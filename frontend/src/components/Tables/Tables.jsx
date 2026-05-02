import { useCallback, useEffect, useState } from 'react';
import { AlertCircle, RefreshCcw, Search } from 'lucide-react';
import { buildApiUrl } from '../../config/api';
import './Tables.css';
const API_BASE_URL = import.meta.env.VITE_API_URL;
const API_URL = `${API_BASE_URL}/api/vulnerabilities`;
const FILTERS_URL = `${API_BASE_URL}/api/vulnerabilities/filters`;
const PAGE_SIZE = 12;

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

const Tables = ({
    title = 'Explorador de Activos',
    subtitle = 'Visualización en crudo de vulnerabilidades y paquetes detectados.',
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

    useEffect(() => {
        const loadFilters = async () => {
            try {
                const res = await fetch(FILTERS_URL);
                if (!res.ok) return;
                const json = await res.json();
                setSeverityOptions(Array.isArray(json?.severities) ? json.severities : []);
                setAgentOptions(Array.isArray(json?.agentIds) ? json.agentIds : []);
            } catch {
                // keep default empty options
            }
        };
        loadFilters();
    }, []);

    const fetchVulnerabilities = useCallback(async () => {
        setLoading(true);
        setError('');

        try {
            const params = new URLSearchParams();
            params.set('page', String(currentPage - 1));
            params.set('size', String(PAGE_SIZE));

            if (severityFilter !== 'all') {
                params.set('severity', severityFilter);
            }
            if (agentFilter !== 'all') {
                params.set('agentId', agentFilter);
            }
            if (search.trim()) {
                params.set('search', search.trim());
            }
            if (effectiveHighPriorityOnly) {
                params.set('highPriorityOnly', 'true');
            }

            params.set('sortKey', sortConfig.key);
            params.set('sortDir', sortConfig.direction);

            const response = await fetch(`${API_URL}?${params.toString()}`);
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }

            const data = await response.json();
            const content = Array.isArray(data)
                ? data
                : (data && Array.isArray(data.content) ? data.content : []);

            setRows(Array.isArray(content) ? content : []);
            setTotalPages(typeof data?.totalPages === 'number' ? data.totalPages : 1);
            setTotalRecords(typeof data?.totalElements === 'number' ? data.totalElements : (Array.isArray(content) ? content.length : 0));
        } catch (fetchError) {
            console.error('Error al obtener vulnerabilidades:', fetchError);
            setError('No se pudo cargar la tabla de activos desde el backend.');
        } finally {
            setLoading(false);
        }
    }, [agentFilter, currentPage, effectiveHighPriorityOnly, search, severityFilter, sortConfig.direction, sortConfig.key]);

    useEffect(() => {
        fetchVulnerabilities();
    }, [fetchVulnerabilities]);

    useEffect(() => {
        setCurrentPage(1);
    }, [search, severityFilter, agentFilter, effectiveHighPriorityOnly]);

    const handleSort = (key) => {
        const defaultDirection = key === 'id' || key === 'cvss3Score' || key === 'detectionTime' ? 'desc' : 'asc';

        setSortConfig((previousSort) => {
            if (previousSort.key === key) {
                return { key, direction: previousSort.direction === 'asc' ? 'desc' : 'asc' };
            }
            return { key, direction: defaultDirection };
        });
        setCurrentPage(1);
    };

    const getSortIndicator = (key) => {
        if (sortConfig.key !== key) return '↕';
        return sortConfig.direction === 'asc' ? '↑' : '↓';
    };

    const paginatedRows = rows;

    return (
        <div className="tables-container">
            <main className="tables-content">
                <header className="tables-header">
                    <div>
                        <h1>{title}</h1>
                        <p>{subtitle}</p>
                    </div>
                    <div className="tables-header-actions">
                        {!lockHighPriority && (
                            <button
                                className={`priority-toggle ${effectiveHighPriorityOnly ? 'active' : ''}`}
                                onClick={() => setHighPriorityOnly((previousValue) => !previousValue)}
                            >
                                Alta prioridad {effectiveHighPriorityOnly ? 'ON' : 'OFF'}
                            </button>
                        )}
                        <button className="refresh-button" onClick={fetchVulnerabilities} disabled={loading}>
                            <RefreshCcw size={16} />
                            {loading ? 'Actualizando...' : 'Actualizar'}
                        </button>
                    </div>
                </header>

                <section className={`tables-filters ${hideSeverityFilter ? 'compact' : ''}`}>
                    <label className="search-input-wrapper">
                        <Search size={16} />
                        <input
                            type="text"
                            placeholder="Buscar por CVE, agente, paquete, estado..."
                            value={search}
                            onChange={(event) => setSearch(event.target.value)}
                        />
                    </label>

                    {!hideSeverityFilter && (
                        <select value={severityFilter} onChange={(event) => setSeverityFilter(event.target.value)}>
                            <option value="all">Todas las severidades</option>
                            {severityOptions.map((severity) => (
                                <option key={severity} value={severity}>
                                    {severity}
                                </option>
                            ))}
                        </select>
                    )}

                    <select value={agentFilter} onChange={(event) => setAgentFilter(event.target.value)}>
                        <option value="all">Todos los agentes</option>
                        {agentOptions.map((agent) => (
                            <option key={agent} value={agent}>
                                {agent}
                            </option>
                        ))}
                    </select>
                </section>

                {error && (
                    <div className="tables-error">
                        <AlertCircle size={18} />
                        <span>{error}</span>
                    </div>
                )}

                <section className="tables-card">
                    {loading ? (
                        <div className="tables-state">Cargando datos...</div>
                    ) : paginatedRows.length === 0 ? (
                        <div className="tables-state">No se encontraron registros con esos filtros.</div>
                    ) : (
                        <div className="tables-wrapper">
                            <table className="assets-table">
                                <thead>
                                    <tr>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'id' ? 'active' : ''}`}
                                                onClick={() => handleSort('id')}
                                            >
                                                <span>ID</span>
                                                <span className="sort-indicator">{getSortIndicator('id')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'agentId' ? 'active' : ''}`}
                                                onClick={() => handleSort('agentId')}
                                            >
                                                <span>Agente</span>
                                                <span className="sort-indicator">{getSortIndicator('agentId')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'cve' ? 'active' : ''}`}
                                                onClick={() => handleSort('cve')}
                                            >
                                                <span>CVE</span>
                                                <span className="sort-indicator">{getSortIndicator('cve')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'severity' ? 'active' : ''}`}
                                                onClick={() => handleSort('severity')}
                                            >
                                                <span>Severidad</span>
                                                <span className="sort-indicator">{getSortIndicator('severity')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'cvss3Score' ? 'active' : ''}`}
                                                onClick={() => handleSort('cvss3Score')}
                                            >
                                                <span>CVSS</span>
                                                <span className="sort-indicator">{getSortIndicator('cvss3Score')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'package' ? 'active' : ''}`}
                                                onClick={() => handleSort('package')}
                                            >
                                                <span>Paquete</span>
                                                <span className="sort-indicator">{getSortIndicator('package')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'status' ? 'active' : ''}`}
                                                onClick={() => handleSort('status')}
                                            >
                                                <span>Estado</span>
                                                <span className="sort-indicator">{getSortIndicator('status')}</span>
                                            </button>
                                        </th>
                                        <th className="sortable">
                                            <button
                                                type="button"
                                                className={`sort-header-btn ${sortConfig.key === 'detectionTime' ? 'active' : ''}`}
                                                onClick={() => handleSort('detectionTime')}
                                            >
                                                <span>Detectada</span>
                                                <span className="sort-indicator">{getSortIndicator('detectionTime')}</span>
                                            </button>
                                        </th>
                                        <th>Descripción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {paginatedRows.map((row) => (
                                        <tr key={row.id}>
                                            <td>{row.id}</td>
                                            <td>{row.agentName || '-'}</td>
                                            <td>{row.cve || '-'}</td>
                                            <td>{row.severity || '-'}</td>
                                            <td>{row.cvss3Score ?? '-'}</td>
                                            <td>{`${row.packageName || '-'} ${row.packageVersion ? `(${row.packageVersion})` : ''}`.trim()}</td>
                                            <td>{row.status || '-'}</td>
                                            <td>{formatDate(row.detectionTime)}</td>
                                            <td title={row.description || ''}>{truncateText(row.description)}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}

                    <footer className="tables-footer">
                        <span>
                            Mostrando {paginatedRows.length} de {totalRecords} registros
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
                                    onChange={(e) => setPageInput(e.target.value)}
                                    onKeyDown={(e) => {
                                        if (e.key === 'Enter') {
                                            e.preventDefault();
                                            const n = parseInt(pageInput, 10);
                                            if (!Number.isNaN(n)) setCurrentPage(Math.max(1, Math.min(n, totalPages)));
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

export default Tables;
