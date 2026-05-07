import { useNavigate, useLocation } from 'react-router-dom';
import { LogOut, User } from 'lucide-react';
import './Navbar.css';

const Navbar = () => {
    const navigate = useNavigate();
    const location = useLocation();
    const userName = localStorage.getItem('user_name') || 'Usuario';

    const handleLogout = () => {
        localStorage.clear();
        navigate('/');
    };

    // Mapeo de títulos según la ruta actual
    const titles = {
        '/home': 'Panel Principal',
        '/settings': 'Configuración de API',
        '/tables': 'Explorador de Activos',
        '/charts': 'Análisis Métrico',
        '/evolution': 'Histórico',
        '/critical': 'Alertas Críticas',
        '/logs': 'Bitácora de Eventos'
    };

    return (
        <nav className="global-navbar">
            <div className="nav-left" onClick={() => navigate('/home')}>
                <span className="nav-logo-text">VulnChecker</span>
                <span className="nav-separator">|</span>
                <span className="nav-page-title">{titles[location.pathname] || 'Gestión'}</span>
            </div>

            <div className="nav-right">
                <div className="nav-user-info">
                    <User size={16} color="#007bff" />
                    <span>{userName}</span>
                </div>
                
                <button onClick={handleLogout} className="nav-logout-button">
                    <LogOut size={16} />
                    <span className="logout-text">Cerrar Sesión</span>
                </button>
            </div>
        </nav>
    );
};

export default Navbar;
