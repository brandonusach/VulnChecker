import { useCallback, useEffect, useMemo, useState } from 'react';
import { AlertCircle, RefreshCcw } from 'lucide-react';
import {
    Cell,
    Pie,
    PieChart,
    ResponsiveContainer,
    Tooltip,
} from 'recharts';
import { buildApiUrl } from '../../config/api';
import './Charts.css';

const CHART_COLORS = [
    '#5B8CFF',
    '#34D399',
    '#F59E0B',
    '#F97316',
    '#A78BFA',
    '#22D3EE',
    '#F472B6',
    '#2DD4BF',
    '#FB7185',
];

const EMPTY_STATS = {
    total: 0,
    category: [],
    severity: [],
    cve: [],
    package: [],
    agent: [],
};

const normalizeText = (value, fallback = 'Sin dato') => {
    if (value === null || value === undefined) return fallback;
    const normalized = String(value).trim();
    return normalized.length > 0 ? normalized : fallback;
};

const sanitizeChartItems = (items) => {
    if (!Array.isArray(items)) {
        return [];
    }

    return items
        .map((item) => {
            const name = normalizeText(item?.name);
            const parsedValue = Number(item?.value);
            const value = Number.isFinite(parsedValue) && parsedValue > 0 ? parsedValue : 0;

            return { name, value };
        })
        .filter((item) => item.value > 0);
};

const sanitizeStatsPayload = (payload) => {
    const parsedTotal = Number(payload?.total);

    return {
        total: Number.isFinite(parsedTotal) && parsedTotal > 0 ? parsedTotal : 0,
        category: sanitizeChartItems(payload?.category),
        severity: sanitizeChartItems(payload?.severity),
        cve: sanitizeChartItems(payload?.cve),
        package: sanitizeChartItems(payload?.package),
        agent: sanitizeChartItems(payload?.agent),
    };
};

const PieTooltip = ({ active, payload, total }) => {
    if (!active || !Array.isArray(payload) || payload.length === 0) return null;

    const item = payload[0];
    const label = normalizeText(item?.name);
    const value = Number(item?.value) || 0;
    const percentage = total === 0 ? 0 : (value / total) * 100;

    return (
        <div className="pie-tooltip-box">
            <div className="pie-tooltip-label">{label}</div>
            <div className="pie-tooltip-value">
                Cantidad: <strong>{value}</strong> ({percentage.toFixed(1)}%)
            </div>
        </div>
    );
};

const PieCard = ({ title, data, wide = false }) => {
    const total = useMemo(() => data.reduce((sum, entry) => sum + entry.value, 0), [data]);
    const [activeIndex, setActiveIndex] = useState(-1);

    return (
        <article className={`pie-card ${wide ? 'wide' : ''}`}>
            <header className="pie-card-header">
                <h2>{title}</h2>
                <span>Total: {total}</span>
            </header>

            {data.length === 0 ? (
                <div className="pie-empty">No hay datos para mostrar.</div>
            ) : (
                <div className="pie-plot">
                    <div className="pie-canvas">
                        <ResponsiveContainer width="100%" height="100%">
                            <PieChart margin={{ top: 0, right: 0, bottom: 0, left: 0 }}>
                                <Pie
                                    data={data}
                                    dataKey="value"
                                    nameKey="name"
                                    cx="50%"
                                    cy="50%"
                                    outerRadius={95}
                                    innerRadius={55}
                                    onMouseEnter={(_, index) => setActiveIndex(index)}
                                    onMouseLeave={() => setActiveIndex(-1)}
                                >
                                    {data.map((entry, index) => (
                                        <Cell
                                            key={`${title}-${entry.name}`}
                                            fill={CHART_COLORS[index % CHART_COLORS.length]}
                                            stroke={index === activeIndex ? '#f8fafc' : '#1f2937'}
                                            strokeWidth={index === activeIndex ? 2.2 : 1}
                                            opacity={activeIndex === -1 || index === activeIndex ? 1 : 0.65}
                                        />
                                    ))}
                                </Pie>
                                <Tooltip
                                    content={<PieTooltip total={total} />}
                                    offset={24}
                                    wrapperStyle={{ zIndex: 50 }}
                                />
                            </PieChart>
                        </ResponsiveContainer>
                        <div className="pie-center-metric">
                            <span>Total</span>
                            <strong>{total}</strong>
                        </div>
                    </div>
                    <ul className="pie-legend-list">
                        {data.map((entry, index) => (
                            <li key={`${title}-legend-${entry.name}`} className="pie-legend-item">
                                <span
                                    className="pie-legend-dot"
                                    style={{ backgroundColor: CHART_COLORS[index % CHART_COLORS.length] }}
                                />
                                <span className="pie-legend-label">{entry.name}</span>
                            </li>
                        ))}
                    </ul>
                </div>
            )}
        </article>
    );
};
const API_BASE_URL = import.meta.env.VITE_API_URL;
const Charts = () => {
    const [stats, setStats] = useState(EMPTY_STATS);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    const fetchChartStatistics = useCallback(async () => {
        setLoading(true);
        setError('');

        try {
            const response = await fetch(`${API_BASE_URL}/api/vulnerabilities/charts`);
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }

            const payload = await response.json();
            setStats(sanitizeStatsPayload(payload));
        } catch (fetchError) {
            console.error('Error al obtener estadisticas para graficos:', fetchError);
            setError('No se pudo cargar la informacion para los graficos.');
            setStats(EMPTY_STATS);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchChartStatistics();
    }, [fetchChartStatistics]);

    return (
        <div className="charts-container">
            <main className="charts-content">
                <header className="charts-header">
                    <div>
                        <h1>Analisis de Graficos</h1>
                        <p>Vista consolidada de vulnerabilidades en formato de torta.</p>
                    </div>
                    <button className="charts-refresh-button" onClick={fetchChartStatistics} disabled={loading}>
                        <RefreshCcw size={16} className={loading ? 'spin' : ''} />
                        {loading ? 'Actualizando...' : 'Actualizar'}
                    </button>
                </header>

                {error && (
                    <div className="charts-error">
                        <AlertCircle size={18} />
                        <span>{error}</span>
                    </div>
                )}

                {loading ? (
                    <section className="charts-state">Cargando graficos...</section>
                ) : stats.total === 0 ? (
                    <section className="charts-state">No hay datos para construir graficos.</section>
                ) : (
                    <section className="charts-grid">
                        <PieCard title="Por categoria (prioridad)" data={stats.category} />
                        <PieCard title="Por severidad" data={stats.severity} />
                        <PieCard title="Por codigo CVE" data={stats.cve} />
                        <PieCard title="Por paquete" data={stats.package} />
                        <PieCard title="Por agente" data={stats.agent} wide />
                    </section>
                )}
            </main>
        </div>
    );
};

export default Charts;
