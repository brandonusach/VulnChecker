import { useState, useEffect } from 'react';
import { Database, Plus, Trash2, ArrowLeft, Send, Loader2 } from 'lucide-react'; // Cambié ShieldCheck por Loader2 para el loading
import { useNavigate } from 'react-router-dom';
import { buildApiUrl } from '../../config/api';
import './Consumer.css';

const API_BASE_URL = import.meta.env.VITE_API_URL;

const Consumer = () => {
    const navigate = useNavigate();
    const userId = localStorage.getItem('user_id');
    
    const [servers, setServers] = useState([{ id: 1, ip: '', port: '', credentialId: '' }]);
    const [availableCredentials, setAvailableCredentials] = useState([]);
    const [nextServerId, setNextServerId] = useState(2);    
    const [loading, setLoading] = useState(false);
    const [progressCount, setProgressCount] = useState(0);
    const [totalTarget, setTotalTarget] = useState(0);

    // Polling de progreso
    useEffect(() => {
        let interval;
        if (loading) {
            interval = setInterval(async () => {
                try {
                    const token = localStorage.getItem('token'); 
                    const res = await fetch(`${API_BASE_URL}/api/vulns/count-local`, {
                        headers: { 'Authorization': token ? `Bearer ${token}` : '' }
                    });

                    if (res.ok) {
                        const data = await res.json();
                        setProgressCount(data.count); 
                        
                        // Si llegamos al objetivo, desactivamos el loading
                        if (data.count >= totalTarget && totalTarget > 0) {
                            setLoading(false);
                        }
                    }
                } catch (err) {
                    console.error("Error en polling:", err);
                }
            }, 2000); // Un poco más rápido para mejor feedback
        }
        return () => clearInterval(interval);
    }, [loading, totalTarget]);

    // Cargar credenciales
    useEffect(() => {
        const fetchCredentials = async () => {
            if (!userId) return;
            try {
                const response = await fetch(`${API_BASE_URL}/api/infra-credentials/user/${userId}`);
                if (response.ok) {
                    const data = await response.json();
                    setAvailableCredentials(data);
                }
            } catch (error) {
                console.error('Error cargando credenciales:', error);
            }
        };
        fetchCredentials();
    }, [userId]);

    const addServer = () => {
        setServers((prev) => [...prev, { id: nextServerId, ip: '', port: '', credentialId: '' }]);
        setNextServerId((id) => id + 1);
    };

    const removeServer = (id) => {
        if (servers.length > 1) {
            setServers((prev) => prev.filter((s) => s.id !== id));
        }
    };

    const handleInputChange = (id, field, value) => {
        setServers((prev) =>
            prev.map((s) => (s.id === id ? { ...s, [field]: value } : s))
        );
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setProgressCount(0); // Reiniciamos contador visual
        
        let totalCule = 0;
        const appAuth = localStorage.getItem('auth_basic');
        
        try {
            for (const server of servers) {
                // 1. Obtener el total dinámico
                const countRes = await fetch(`${API_BASE_URL}/api/vulns/remote-count`, {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Authorization': appAuth
                    },
                    body: JSON.stringify({
                        ip: server.ip,
                        infrastructureCredentialId: parseInt(server.credentialId)
                    })
                });
                const data = await countRes.json();
                totalCule += (data.total || 0);
                setTotalTarget(totalCule);

                // 2. Disparar consumo
                fetch(`${API_BASE_URL}/api/vulns/consume`, {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Authorization': appAuth 
                    },
                    body: JSON.stringify({
                        ip: server.ip,
                        infrastructureCredentialId: parseInt(server.credentialId)
                    })
                });
            }
        } catch (error) {
            console.error("Error iniciando consumo:", error);
            setLoading(false);
        }
    };

    return (
        <div className="consumer-container">
            <main className="consumer-content-wrapper">
                <header className="consumer-header">
                    <button 
                        className="back-button" 
                        onClick={() => navigate(-1)} 
                        disabled={loading} // No dejar volver mientras procesa
                    >
                        <ArrowLeft size={24} />
                    </button>
                    <h1 className="welcome-text">Configuración Wazuh</h1>
                </header>

                <section className="consumer-card">
                    <div className="db-icon-container">
                        <div className={`icon-wrapper ${loading ? 'spinning-slow' : ''}`}>
                            <Database size={60} />
                        </div>
                        <p className="main-subtitle">
                            {loading 
                                ? "Sincronizando vulnerabilidades con la base de datos local..." 
                                : "Asocia tus servidores con los perfiles de credenciales registrados"}
                        </p>
                    </div>

                    <form onSubmit={handleSubmit} className="wazuh-form">
                        <div className="servers-list">
                            {servers.map((server) => (
                                <div key={server.id} className={`server-row ${loading ? 'row-disabled' : ''}`}>
                                    <div className="input-group">
                                        <label>Dirección IP</label>
                                        <input
                                            type="text"
                                            disabled={loading}
                                            placeholder="192.168.1.XX"
                                            value={server.ip}
                                            onChange={(e) => handleInputChange(server.id, 'ip', e.target.value)}
                                            required
                                        />
                                    </div>
                                    {/* 
                                    <div className="input-group">
                                        <label>Puerto</label>
                                        <input
                                            type="number"
                                            disabled={loading}
                                            placeholder="55000"
                                            value={server.port}
                                            onChange={(e) => handleInputChange(server.id, 'port', e.target.value)}
                                            required
                                        />
                                    </div>
                                    */}
                                    <div className="input-group">
                                        <label>Perfil de Credencial</label>
                                        <select
                                            className="cred-select"
                                            disabled={loading}
                                            value={server.credentialId}
                                            onChange={(e) => handleInputChange(server.id, 'credentialId', e.target.value)}
                                            required
                                        >
                                            <option value="">Seleccionar...</option>
                                            {availableCredentials.map(c => (
                                                <option key={c.id} value={c.id}>{c.name}</option>
                                            ))}
                                        </select>
                                    </div>

                                    <div className="actions-group">
                                        {servers.length > 1 && !loading && (
                                            <button 
                                                type="button" 
                                                className="remove-btn" 
                                                onClick={() => removeServer(server.id)}
                                            >
                                                <Trash2 size={20} />
                                            </button>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>

                        {!loading && (
                            <button type="button" className="add-server-row-btn" onClick={addServer}>
                                <Plus size={20} />
                                <span>Añadir otro objetivo</span>
                            </button>
                        )}

                        {/* BOTÓN DINÁMICO */}
                        <button 
                            type="submit" 
                            className={`submit-btn ${loading ? 'loading-active' : ''}`} 
                            disabled={loading}
                        >
                            {loading ? (
                                <>
                                    <Loader2 className="spinner" size={20} />
                                    <span>
                                        Sincronizando: {progressCount} / {totalTarget}
                                    </span>
                                </>
                            ) : (
                                <>
                                    <Send size={20} />
                                    <span>Iniciar Consumo de Datos</span>
                                </>
                            )}
                        </button>
                    </form>
                </section>
            </main>
        </div>
    );
};

export default Consumer;
