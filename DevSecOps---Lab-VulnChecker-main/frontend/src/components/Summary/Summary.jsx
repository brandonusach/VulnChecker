import React, { useEffect, useMemo, useState, useCallback } from 'react';
import { AlertCircle, RefreshCcw, Search, Download } from 'lucide-react';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import { buildApiUrl } from '../../config/api';
import './Summary.css';

const API_BASE_URL = import.meta.env.VITE_API_URL;
const API_URL = `${API_BASE_URL}/api/vulnerabilities`;
const FILTERS_URL = `${API_BASE_URL}/api/vulnerabilities/filters`;
const PAGE_SIZE = 12;

// --- Funciones de utilidad ---
const formatDate = (dateValue) => {
    if (!dateValue) return '-';
    const parsedDate = new Date(dateValue);
    if (Number.isNaN(parsedDate.getTime())) return dateValue;
    return parsedDate.toLocaleString('es-CL');
};

const truncateText = (value, max = 120) => {
    if (!value) return '-';
    return value.length > max ? `${value.slice(0, max)}...` : value;
};

const severityOrder = { critical: 4, high: 3, medium: 2, low: 1 };

const Summary = ({
    title = 'Resumen de Vulnerabilidades',
    subtitle = 'Vista y resumen de las vulnerabilidades activas.',
    defaultHighPriorityOnly = false,
    lockHighPriority = false,
    hideSeverityFilter = false,
}) => {
    const [rows, setRows] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [search, setSearch] = useState('');
    const [severityFilter, setSeverityFilter] = useState('all');
    const [agentFilter, setAgentFilter] = useState('all');
    const [highPriorityOnly, setHighPriorityOnly] = useState(defaultHighPriorityOnly);
    const [currentPage, setCurrentPage] = useState(1);
    const [sortConfig, setSortConfig] = useState({ key: 'detectionTime', direction: 'desc' });
    const [totalPages, setTotalPages] = useState(1);
    const [totalRecords, setTotalRecords] = useState(0);
    const [pageInput, setPageInput] = useState('');
    const [severityOptions, setSeverityOptions] = useState([]);
    const [agentOptions, setAgentOptions] = useState([]);

    const effectiveHighPriorityOnly = lockHighPriority || highPriorityOnly;

    // 1. Cargar filtros desde el backend (Lógica de Tables)
    useEffect(() => {
        const loadFilters = async () => {
            try {
                const res = await fetch(FILTERS_URL);
                if (!res.ok) return;
                const json = await res.json();
                setSeverityOptions(Array.isArray(json?.severities) ? json.severities : []);
                setAgentOptions(Array.isArray(json?.agentIds) ? json.agentIds : []);
            } catch { /* keep defaults */ }
        };
        loadFilters();
    }, []);

    // 2. Fetch dinámico (Lógica de Tables)
    const fetchVulnerabilities = useCallback(async () => {
        setLoading(true);
        setError('');
        try {
            const params = new URLSearchParams();
            params.set('page', String(currentPage - 1));
            params.set('size', String(PAGE_SIZE));
            params.set('sortKey', sortConfig.key);
            params.set('sortDir', sortConfig.direction);

            if (severityFilter !== 'all') params.set('severity', severityFilter);
            if (agentFilter !== 'all') params.set('agentId', agentFilter);
            if (search.trim()) params.set('search', search.trim());
            if (effectiveHighPriorityOnly) params.set('highPriorityOnly', 'true');

            const response = await fetch(`${API_URL}?${params.toString()}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);

            const data = await response.json();
            const content = data.content || (Array.isArray(data) ? data : []);

            setRows(content);
            setTotalPages(data.totalPages || 1);
            setTotalRecords(data.totalElements || content.length);
        } catch (err) {
            setError('No se pudo cargar la tabla desde el backend.');
        } finally {
            setLoading(false);
        }
    }, [currentPage, severityFilter, agentFilter, search, effectiveHighPriorityOnly, sortConfig]);

    useEffect(() => { fetchVulnerabilities(); }, [fetchVulnerabilities]);

    useEffect(() => { setCurrentPage(1); }, [search, severityFilter, agentFilter, effectiveHighPriorityOnly]);

    // 3. Lógica de Ordenamiento y UI
    const handleSort = (key) => {
        setSortConfig((prev) => ({
            key,
            direction: prev.key === key && prev.direction === 'asc' ? 'desc' : 'asc'
        }));
        setCurrentPage(1);
    };

    const getSortIndicator = (key) => {
        if (sortConfig.key !== key) return '↕';
        return sortConfig.direction === 'asc' ? '↑' : '↓';
    };

    // 4. Lógica de Seguridad y PDF (RESTAURADA)
    const calculateSHA256 = async (arrayBuffer) => {
        const hashBuffer = await crypto.subtle.digest('SHA-256', arrayBuffer);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    };

    const generateSecurePDF = async () => {
        const doc = new jsPDF();
        doc.setFontSize(16);
        doc.text('Reporte de Vulnerabilidades - VulnChecker', 14, 20);
        
        const tableData = rows.map(row => [
            row.cve || '-',
            row.agentName || '-',
            row.severity || '-',
            row.description || '-',
            formatDate(row.detectionTime)
        ]);

        autoTable(doc, {
            startY: 45,
            head: [['CVE ID', 'Agente', 'Severidad', 'Descripción', 'Detectado el']],
            body: tableData,
            headStyles: { fillColor: [32, 32, 32] },
            styles: { fontSize: 8 },
            columnStyles: { 3: { cellWidth: 80 } }
        });

        const pdfBuffer = doc.output('arraybuffer');
        const pdfHash = await calculateSHA256(pdfBuffer);
        
        try {
            const response = await fetch(`${API_BASE_URL}/api/reports/sign`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    reportName: `vuln_report_${Date.now()}.pdf`,
                    sha256Hash: pdfHash
                })
            });

            if (response.ok) {
                doc.save(`vuln_report_${Date.now()}.pdf`);
                alert("Reporte generado y firmado con éxito.");
            } else {
                alert("Error al firmar el documento.");
            }
        } catch (error) {
            console.error("Error conectando al backend:", error);
        }
    };

    return (
        <div className="tables-container">
            <main className="tables-content">
                <header className="tables-header">
                    <div>
                        <h1>{title}</h1>
                        <p>{subtitle}</p>
                    </div>
                    <div className="tables-header-actions">
                        <button className="refresh-button" onClick={generateSecurePDF} disabled={rows.length === 0}>
                            <Download size={16} /> Exportar PDF
                        </button>
                        {!lockHighPriority && (
                            <button
                                className={`priority-toggle ${effectiveHighPriorityOnly ? 'active' : ''}`}
                                onClick={() => setHighPriorityOnly((prev) => !prev)}
                            >
                                Alta prioridad {effectiveHighPriorityOnly ? 'ON' : 'OFF'}
                            </button>
                        )}
                        <button className="refresh-button" onClick={fetchVulnerabilities} disabled={loading}>
                            <RefreshCcw size={16} className={loading ? 'animate-spin' : ''} />
                            {loading ? 'Actualizando...' : 'Actualizar'}
                        </button>
                    </div>
                </header>

                <section className={`tables-filters ${hideSeverityFilter ? 'compact' : ''}`}>
                    <label className="search-input-wrapper">
                        <Search size={16} />
                        <input
                            type="text"
                            placeholder="Buscar por CVE, agente, descripción..."
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                        />
                    </label>
                    {!hideSeverityFilter && (
                        <select value={severityFilter} onChange={(e) => setSeverityFilter(e.target.value)}>
                            <option value="all">Todas las severidades</option>
                            {severityOptions.map((s) => <option key={s} value={s}>{s}</option>)}
                        </select>
                    )}
                    <select value={agentFilter} onChange={(e) => setAgentFilter(e.target.value)}>
                        <option value="all">Todos los agentes</option>
                        {agentOptions.map((a) => <option key={a} value={a}>{a}</option>)}
                    </select>
                </section>

                {error && (
                    <div className="tables-error">
                        <AlertCircle size={18} /> <span>{error}</span>
                    </div>
                )}

                <section className="tables-card">
                    {loading ? (
                        <div className="tables-state">Sincronizando con base de datos...</div>
                    ) : rows.length === 0 ? (
                        <div className="tables-state">No hay registros.</div>
                    ) : (
                        <div className="tables-wrapper">
                            <table className="assets-table">
                                <thead>
                                    <tr>
                                        <th className="sortable">
                                            <button type="button" className="sort-header-btn" onClick={() => handleSort('cve')}>
                                                <span>CVE ID</span> {getSortIndicator('cve')}
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button type="button" className="sort-header-btn" onClick={() => handleSort('agentId')}>
                                                <span>Agente</span> {getSortIndicator('agentId')}
                                            </button>
                                        </th>
                                        <th>Severidad</th>
                                        <th>Descripción</th>
                                        <th className="sortable">
                                            <button type="button" className="sort-header-btn" onClick={() => handleSort('detectionTime')}>
                                                <span>Detectada</span> {getSortIndicator('detectionTime')}
                                            </button>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {rows.map((row) => (
                                        <tr key={row.id}>
                                            <td>{row.cve || '-'}</td>
                                            <td>{row.agentName || '-'}</td>
                                            <td>{row.severity || '-'}</td>
                                            <td title={row.description}>{truncateText(row.description)}</td>
                                            <td>{formatDate(row.detectionTime)}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}

                    <footer className="tables-footer">
                        <span>Mostrando {rows.length} de {totalRecords}</span>
                        <div className="pagination-controls">
                            <button onClick={() => setCurrentPage(p => Math.max(p - 1, 1))} disabled={currentPage === 1}>Anterior</button>
                            <span>Página {currentPage} de {totalPages}</span>
                            <button onClick={() => setCurrentPage(p => Math.min(p + 1, totalPages))} disabled={currentPage === totalPages}>Siguiente</button>
                            
                            <label className="pagination-go">
                                <span>Ir a</span>
                                <input
                                    type="number"
                                    value={pageInput}
                                    onChange={(e) => setPageInput(e.target.value)}
                                    onKeyDown={(e) => {
                                        if (e.key === 'Enter') {
                                            const n = parseInt(pageInput, 10);
                                            if (!isNaN(n)) setCurrentPage(Math.max(1, Math.min(n, totalPages)));
                                            setPageInput('');
                                        }
                                    }}
                                />
                                <button
                                    type="button"
                                    onClick={() => {
                                        const n = parseInt(pageInput, 10);
                                        if (!Number.isNaN(n)) setCurrentPage(Math.max(1, Math.min(n, totalPages)));
                                        setPageInput('');
                                    }}
                                >
                                    Ir
                                </button>
                            </label>
                        </div>
                    </footer>
                </section>
            </main>
        </div>
    );
};

export default Summary;
