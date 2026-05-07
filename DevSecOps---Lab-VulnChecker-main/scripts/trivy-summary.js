#!/usr/bin/env node
/**
 * Lee uno o más JSON de Trivy y muestra un resumen legible (por consola y/o archivo).
 * Uso: node scripts/trivy-summary.js [--out archivo.md] trivy-backend.json [trivy-frontend.json ...]
 * Ejemplo: node scripts/trivy-summary.js jenkins-reports/latest/trivy/trivy-backend.json
 */

const fs = require('fs');
const path = require('path');

const args = process.argv.slice(2);
let outFile = null;
const files = [];
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--out' || args[i] === '-o') {
    outFile = args[i + 1] || null;
    i++;
  } else if (args[i].endsWith('.json')) {
    files.push(args[i]);
  }
}
if (files.length === 0) {
  console.error('Uso: node scripts/trivy-summary.js [--out resumen.md] <trivy-backend.json> [trivy-frontend.json ...]');
  process.exit(1);
}

function load(path) {
  const raw = fs.readFileSync(path, 'utf8');
  return JSON.parse(raw);
}

function severityOrder(s) {
  const o = { CRITICAL: 0, HIGH: 1, MEDIUM: 2, LOW: 3, UNKNOWN: 4 };
  return o[s] ?? 5;
}

function reportOne(data) {
  const artifact = data.ArtifactName || data.Metadata?.ImageID || 'unknown';
  const lines = [];
  lines.push(`## ${artifact}`);
  lines.push('');

  const counts = { CRITICAL: 0, HIGH: 0, MEDIUM: 0, LOW: 0, UNKNOWN: 0 };
  const vulns = [];
  const results = data.Results || [];
  for (const r of results) {
    const target = r.Target || '';
    for (const v of r.Vulnerabilities || []) {
      counts[v.Severity] = (counts[v.Severity] || 0) + 1;
      vulns.push({
        id: v.VulnerabilityID,
        severity: v.Severity,
        pkg: v.PkgName || v.PkgID || '',
        installed: v.InstalledVersion || '',
        fixed: v.FixedVersion || '-',
        title: (v.Title || v.Description || '').slice(0, 80),
        url: v.PrimaryURL || '',
        target,
      });
    }
  }

  const total = Object.values(counts).reduce((a, b) => a + b, 0);
  lines.push('| Severity | Count |');
  lines.push('|----------|-------|');
  for (const s of ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW', 'UNKNOWN']) {
    if (counts[s] != null && counts[s] > 0) lines.push(`| ${s} | ${counts[s]} |`);
  }
  lines.push(`| **Total** | **${total}** |`);
  lines.push('');

  if (vulns.length > 0) {
    vulns.sort((a, b) => severityOrder(a.severity) - severityOrder(b.severity));
    lines.push('### Vulnerabilities');
    lines.push('');
    lines.push('| Severity | CVE/ID | Package | Installed | Fixed | Title |');
    lines.push('|----------|--------|---------|-----------|-------|-------|');
    for (const v of vulns) {
      const title = (v.title || '').replace(/\|/g, ' ').replace(/\n/g, ' ');
      const link = v.url ? `[${v.id}](${v.url})` : v.id;
      lines.push(`| ${v.severity} | ${link} | ${v.pkg} | ${v.installed} | ${v.fixed} | ${title} |`);
    }
  }

  return { artifact, total, lines: lines.join('\n') };
}

const allLines = ['# Resumen Trivy', '', `Generado: ${new Date().toISOString()}`, ''];

for (const f of files) {
  if (!fs.existsSync(f)) {
    allLines.push(`## ${f}`);
    allLines.push('*(archivo no encontrado)*');
    allLines.push('');
    continue;
  }
  try {
    const data = load(f);
    const { lines } = reportOne(data);
    allLines.push(lines);
    allLines.push('');
  } catch (e) {
    allLines.push(`## ${f}`);
    allLines.push('*(error leyendo JSON: ' + e.message + ')*');
    allLines.push('');
  }
}

const out = allLines.join('\n');
console.log(out);

if (outFile) {
  fs.writeFileSync(outFile, out, 'utf8');
  console.error('Resumen escrito en:', path.resolve(outFile));
}
