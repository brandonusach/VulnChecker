import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
    Table,
    BarChart3,
    History,
    ShieldAlert,
    ClipboardList,
    Settings as SettingsIcon,
    Download // Nuevo icono para el botón de Wazuh
} from 'lucide-react';
import './Home.css';
const API_BASE_URL = import.meta.env.VITE_API_URL;
const Home = () => {
    const [userName] = useState(() => localStorage.getItem('user_name') || 'Usuario');
    const userRole = localStorage.getItem('user_role'); // Obtenemos el rol
    const navigate = useNavigate();

    const menuItems = [
        { id: 1, title: 'Tablas', icon: <Table size={40} />, desc: 'Visualiza datos crudos de activos.', path: '/tables' },
        { id: 2, title: 'Gráficos', icon: <BarChart3 size={40} />, desc: 'Análisis visual de las métricas.', path: '/charts' },
        { id: 3, title: 'Evolución', icon: <History size={40} />, desc: 'Histórico de seguridad en el tiempo.', path: '/evolution' },
        { id: 4, title: 'Críticas', icon: <ShieldAlert size={40} />, desc: 'Vulnerabilidades de alta prioridad.', path: '/critical' },
        { id: 5, title: 'Resumen', icon: <ClipboardList size={40} />, desc: 'Visualizar y descargas vulnerabilidades.', path: '/summary' },
        // Condicional: Solo aparece si es ADMIN
        ...(userRole === 'ADMIN' ? [
            { id: 6, title: 'Ajustes', icon: <SettingsIcon size={40} />, desc: 'Configuración del sistema y perfil.', path: '/settings' }
        ] : []),
    ];

    return (
        <div className="home-container">
            <main className="home-content">
                <header className="welcome-header">
                    <h1 className="welcome-text">¡Bienvenido, {userName}!</h1>
                    <p className="main-subtitle">Panel de Gestión de Vulnerabilidades Institucional USACH</p>
                </header>

                <div className="menu-grid">
                    {menuItems.map((item) => (
                        <button
                            key={item.id}
                            className="menu-card"
                            onClick={() => navigate(item.path)}
                        >
                            <div className="icon-wrapper">{item.icon}</div>
                            <div className="card-info">
                                <h3>{item.title}</h3>
                                <p>{item.desc}</p>
                            </div>
                        </button>
                    ))}

                    {/* Botón de Wazuh: Solo renderizar si es ADMIN */}
                    {userRole === 'ADMIN' && (
                        <button 
                            className="menu-card wazuh-button" 
                            onClick={() => navigate('/consumer')} 
                            style={{ gridColumn: '1 / -1' }} 
                        >
                            <div className="icon-wrapper">
                                <Download size={40} />
                            </div>
                            <div className="card-info">
                                <h3>Obtener datos desde Wazuh</h3>
                                <p>Consume la API de uno o más Wazuh</p>
                            </div>
                        </button>
                    )}
                </div>
            </main>
        </div>
    );
};

export default Home;
