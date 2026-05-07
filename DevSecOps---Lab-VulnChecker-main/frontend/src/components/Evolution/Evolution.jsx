import { useCallback, useEffect, useMemo, useState } from 'react';
import { AlertCircle, RefreshCcw, Search } from 'lucide-react';
import { buildApiUrl } from '../../config/api';
import './Evolution.css';

const API_BASE_URL = import.meta.env.VITE_API_URL;
const FILTERS_URL = `${API_BASE_URL}/api/snapshots/evolution/filters`;
const EVOLUTION_URL = `${API_BASE_URL}/api/snapshots/evolution`;
const PAGE_SIZE = 10;

const metricLabels = {
    critical: 'Vulnerabilidades críticas',
    high: 'Vulnerabilidades altas',
    highCritical: 'Altas + críticas',
    total: 'Total de vulnerabilidades',
};

const Evolution = () => {
    const [rows, setRows] = useState([]);
    const [columns, setColumns] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [search, setSearch] = useState('');
    const [agentFilter, setAgentFilter] = useState('all');
    const [metric, setMetric] = useState('critical');
    const [columnCount, setColumnCount] = useState(4);
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [totalRecords, setTotalRecords] = useState(0);
    const [pageInput, setPageInput] = useState('');
    const [agentOptions, setAgentOptions] = useState([]);
    const [metricOptions, setMetricOptions] = useState(['critical', 'high', 'highCritical', 'total']);
    const [columnOptions, setColumnOptions] = useState([4, 6, 8]);
    const [sortConfig, setSortConfig] = useState({ key: 'latestValue', direction: 'desc' });

    useEffect(() => {
        const loadFilters = async () => {
            try {
                const response = await fetch(FILTERS_URL);
                if (!response.ok) {
                    return;
                }

                const data = await response.json();
                setAgentOptions(Array.isArray(data?.agentIds) ? data.agentIds : []);
                setMetricOptions(Array.isArray(data?.metrics) ? data.metrics : ['critical', 'high', 'highCritical', 'total']);

                const nextColumnOptions = Array.isArray(data?.columnOptions) && data.columnOptions.length > 0
                    ? data.columnOptions
                    : [4, 6, 8];
                setColumnOptions(nextColumnOptions);
                if (!nextColumnOptions.includes(columnCount)) {
                    setColumnCount(nextColumnOptions[0]);
                }
            } catch {
                // Mantener defaults cuando no se puede cargar filtros
            }
        };

        loadFilters();
    }, [columnCount]);

    const fetchEvolution = useCallback(async () => {
        setLoading(true);
        setError('');

        try {
            const params = new URLSearchParams();
            params.set('page', String(currentPage - 1));
            params.set('size', String(PAGE_SIZE));
            params.set('metric', metric);
            params.set('columns', String(columnCount));
            params.set('sortKey', sortConfig.key);
            params.set('sortDir', sortConfig.direction);

            if (agentFilter !== 'all') {
                params.set('agentId', agentFilter);
            }

            if (search.trim()) {
                params.set('search', search.trim());
            }

            const response = await fetch(`${EVOLUTION_URL}?${params.toString()}`);
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }

            const data = await response.json();
            setRows(Array.isArray(data?.content) ? data.content : []);
            setColumns(Array.isArray(data?.columns) ? data.columns : []);
            setTotalPages(typeof data?.totalPages === 'number' && data.totalPages > 0 ? data.totalPages : 1);
            setTotalRecords(typeof data?.totalElements === 'number' ? data.totalElements : 0);
        } catch (fetchError) {
            console.error('Error al obtener evolución:', fetchError);
            setError('No se pudo cargar la matriz de evolución desde el backend.');
            setRows([]);
            setColumns([]);
            setTotalPages(1);
            setTotalRecords(0);
        } finally {
            setLoading(false);
        }
    }, [agentFilter, columnCount, currentPage, metric, search, sortConfig.direction, sortConfig.key]);

    useEffect(() => {
        fetchEvolution();
    }, [fetchEvolution]);

    useEffect(() => {
        setCurrentPage(1);
    }, [agentFilter, search, metric, columnCount]);

    const metricTitle = useMemo(() => metricLabels[metric] || metricLabels.critical, [metric]);

    const handleSort = (key) => {
        const defaultDirection = key === 'latestValue' ? 'desc' : 'asc';
        setSortConfig((previousSort) => {
            if (previousSort.key === key) {
                return { key, direction: previousSort.direction === 'asc' ? 'desc' : 'asc' };
            }
            return { key, direction: defaultDirection };
        });
        setCurrentPage(1);
    };

    const getSortIndicator = (key) => {
        if (sortConfig.key !== key) {
            return '↕';
        }
        return sortConfig.direction === 'asc' ? '↑' : '↓';
    };

    return (
        <div className="evolution-container">
            <main className="evolution-content">
                <header className="evolution-header">
                    <div>
                        <h1>Evolución</h1>
                        <p>
                            Matriz histórica por agente usando snapshots ya consolidados en backend.
                        </p>
                    </div>
                    <button className="evolution-refresh-button" onClick={fetchEvolution} disabled={loading}>
                        <RefreshCcw size={16} className={loading ? 'spin' : ''} />
                        {loading ? 'Actualizando...' : 'Actualizar'}
                    </button>
                </header>

                <section className="evolution-filters">
                    <label className="evolution-search-input">
                        <Search size={16} />
                        <input
                            type="text"
                            placeholder="Buscar por agente o nombre..."
                            value={search}
                            onChange={(event) => setSearch(event.target.value)}
                        />
                    </label>

                    <select value={agentFilter} onChange={(event) => setAgentFilter(event.target.value)}>
                        <option value="all">Todos los agentes</option>
                        {agentOptions.map((agent) => (
                            <option key={agent} value={agent}>
                                {agent}
                            </option>
                        ))}
                    </select>

                    <select value={metric} onChange={(event) => setMetric(event.target.value)}>
                        {metricOptions.map((option) => (
                            <option key={option} value={option}>
                                {metricLabels[option] || option}
                            </option>
                        ))}
                    </select>

                    <select value={columnCount} onChange={(event) => setColumnCount(Number(event.target.value))}>
                        {columnOptions.map((option) => (
                            <option key={option} value={option}>
                                Últimos {option} snapshots
                            </option>
                        ))}
                    </select>
                </section>

                {error && (
                    <div className="evolution-error">
                        <AlertCircle size={18} />
                        <span>{error}</span>
                    </div>
                )}

                <section className="evolution-summary-strip">
                    <div className="evolution-summary-card">
                        <span>Métrica</span>
                        <strong>{metricTitle}</strong>
                    </div>
                    <div className="evolution-summary-card">
                        <span>Agentes en página</span>
                        <strong>{rows.length}</strong>
                    </div>
                    <div className="evolution-summary-card">
                        <span>Snapshots visibles</span>
                        <strong>{columns.length}</strong>
                    </div>
                    <div className="evolution-summary-card">
                        <span>Total agentes</span>
                        <strong>{totalRecords}</strong>
                    </div>
                </section>

                <section className="evolution-card">
                    {loading ? (
                        <div className="evolution-state">Cargando matriz de evolución...</div>
                    ) : rows.length === 0 || columns.length === 0 ? (
                        <div className="evolution-state">No hay snapshots disponibles para esos filtros.</div>
                    ) : (
                        <div className="evolution-table-wrapper">
                            <table className="evolution-table">
                                <thead>
                                    <tr>
                                        <th className="sortable sticky-col sticky-col-first">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'agentId' ? 'active' : ''}`}
                                                onClick={() => handleSort('agentId')}
                                            >
                                                <span>Agente</span>
                                                <span className="sort-indicator">{getSortIndicator('agentId')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable sticky-col sticky-col-second">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'agentName' ? 'active' : ''}`}
                                                onClick={() => handleSort('agentName')}
                                            >
                                                <span>Nombre</span>
                                                <span className="sort-indicator">{getSortIndicator('agentName')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable sticky-col sticky-col-third">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'latestValue' ? 'active' : ''}`}
                                                onClick={() => handleSort('latestValue')}
                                            >
                                                <span>Último</span>
                                                <span className="sort-indicator">{getSortIndicator('latestValue')}</span>
                                            </button>
                                        </th>
                                        {columns.map((column) => (
                                            <th key={column.key}>{column.label}</th>
                                        ))}
                                    </tr>
                                </thead>
                                <tbody>
                                    {rows.map((row) => (
                                        <tr key={row.agentId}>
                                            <td className="sticky-col sticky-col-first cell-emphasis">{row.agentId || '-'}</td>
                                            <td className="sticky-col sticky-col-second">{row.agentName || '-'}</td>
                                            <td className="sticky-col sticky-col-third cell-highlight">{row.latestValue ?? 0}</td>
                                            {columns.map((column) => (
                                                <td key={`${row.agentId}-${column.key}`}>
                                                    {row.values?.[column.key] ?? 0}
                                                </td>
                                            ))}
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}

                    <footer className="evolution-footer">
                        <span>
                            Mostrando {rows.length} de {totalRecords} agentes
                        </span>
                        <div className="pagination-controls">
                            <button onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))} disabled={currentPage === 1}>
                                Anterior
                            </button>
                            <span>
                                Página {currentPage} de {totalPages}
                            </span>
                            <button
                                onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
                                disabled={currentPage === totalPages}
                            >
                                Siguiente
                            </button>
                            <label className="pagination-go">
                                <span>Ir a</span>
                                <input
                                    type="number"
                                    min={1}
                                    max={totalPages}
                                    placeholder={String(currentPage)}
                                    value={pageInput}
                                    onChange={(event) => setPageInput(event.target.value)}
                                    onKeyDown={(event) => {
                                        if (event.key === 'Enter') {
                                            event.preventDefault();
                                            const value = Number.parseInt(pageInput, 10);
                                            if (!Number.isNaN(value)) {
                                                setCurrentPage(Math.max(1, Math.min(value, totalPages)));
                                            }
                                            setPageInput('');
                                        }
                                    }}
                                />
                                <button
                                    type="button"
                                    onClick={() => {
                                        const value = Number.parseInt(pageInput, 10);
                                        if (!Number.isNaN(value)) {
                                            setCurrentPage(Math.max(1, Math.min(value, totalPages)));
                                        }
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

export default Evolution;
