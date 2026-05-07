import { BrowserRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import Navbar from './components/Navbar/Navbar';
import Login from './components/Login/Login';
import Register from './components/Login/Register';
import Home from './components/Home/Home';
import Settings from './components/Settings/Settings';
import Consumer from './components/Consumer/Consumer';
import Tables from './components/Tables/Tables';
import Summary from './components/Summary/Summary';
import Charts from './components/Charts/Charts';
import Evolution from './components/Evolution/Evolution';
import './App.css';

// Componente para proteger rutas
const ProtectedRoute = ({ children, adminOnly = false }) => {
    const isAuthenticated = localStorage.getItem('is_authenticated') === 'true';
    const userRole = localStorage.getItem('user_role'); // 'ADMIN' o 'USER'
    
    if (!isAuthenticated) {
        return <Navigate to="/" replace />;
    }

    // Si la ruta es solo para admin y el usuario no lo es
    if (adminOnly && userRole !== 'ADMIN') {
        return <Navigate to="/home" replace />;
    }

    return children;
};

const AppContent = () => {
    const location = useLocation(); // <--- Ahora sí funcionará porque lo importamos arriba
    const isPublicPage = location.pathname === '/' || location.pathname === '/register';

    return (
        <>
            {/* Si NO estamos en una página pública, mostramos la Navbar */}
            {!isPublicPage && <Navbar />}
            
            <Routes>
                <Route path="/" element={<Login />} />
                <Route path="/register" element={<Register />} />
                <Route 
                    path="/home" 
                    element={<ProtectedRoute><Home /></ProtectedRoute>} 
                />
                <Route 
                    path="/settings" 
                    element={<ProtectedRoute adminOnly={true}><Settings /></ProtectedRoute>} 
                />
                <Route 
                    path="/consumer" 
                    element={<ProtectedRoute adminOnly={true}><Consumer /></ProtectedRoute>} 
                />
                <Route
                    path="/tables"
                    element={<ProtectedRoute><Tables /></ProtectedRoute>}
                />
                <Route
                    path="/critical"
                    element={
                        <ProtectedRoute>
                            <Tables
                                title="Vulnerabilidades Críticas"
                                subtitle="Vista priorizada de hallazgos críticos y altos."
                                defaultHighPriorityOnly={true}
                                lockHighPriority={true}
                                hideSeverityFilter={true}
                            />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="/summary"
                    element={<ProtectedRoute><Summary /></ProtectedRoute>}
                />
                <Route
                    path="/charts"
                    element={<ProtectedRoute><Charts /></ProtectedRoute>}
                />
                <Route
                    path="/evolution"
                    element={<ProtectedRoute><Evolution /></ProtectedRoute>}
                />
                <Route path="*" element={<Navigate to="/" replace />} />
            </Routes>
        </>
    );
};

function App() {
    return (
        <Router>
            <AppContent />
        </Router>
    );
}

export default App;
