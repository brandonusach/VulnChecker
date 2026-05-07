import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom'; 
import './Login.css';

const API_BASE_URL = import.meta.env.VITE_API_URL;

const Login = () => {
    const [userPrefix, setUserPrefix] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false); // Estado para feedback visual
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true); // Bloqueamos el botón para evitar múltiples clics
        const fullEmail = `${userPrefix}@usach.cl`;

        try {
            const response = await fetch(`${API_BASE_URL}/api/users/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    email: fullEmail,
                    password: password
                })
            });

            if (response.ok) {
                const user = await response.json();
                localStorage.setItem('user_id', user.id);
                localStorage.setItem('user_role', user.role);
                localStorage.setItem('is_authenticated', 'true');
                localStorage.setItem('user_name', user.firstName); // Para saludarlo en el Home
                
                if (user.role === 'ADMIN') {
                    navigate('/home');
                } else {
                    navigate('/home');
                }
            } else if (response.status === 401) {
                alert('Credenciales incorrectas o cuenta aún no aprobada por el administrador.');
            } else {
                alert('Error en el servidor. Intente más tarde.');
            }
        } catch (error) {
            console.error('Error de conexión:', error);
            alert('No se pudo conectar con el servidor. Revise su conexión.');
        } finally {
            setLoading(false); // Liberamos el botón
        }
    };

    return (
        <div className="login-container">
            <form className="login-form" onSubmit={handleSubmit}>
                <h1 className="login-title">VulnChecker</h1>
                <p className="login-subtitle">Gestión de Vulnerabilidades Wazuh</p>

                <div className="input-group">
                    <label htmlFor="userPrefix">Correo electrónico institucional</label>
                    <div className="email-input-wrapper">
                        <input
                            type="text"
                            id="userPrefix"
                            value={userPrefix}
                            onChange={(e) => setUserPrefix(e.target.value)}
                            placeholder="nombre.apellido"
                            required
                        />
                        <span className="email-domain">@usach.cl</span>
                    </div>
                </div>

                <div className="input-group">
                    <label htmlFor="password">Contraseña</label>
                    <input
                        type="password"
                        id="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        placeholder="••••••••"
                        required
                    />
                </div>

                <button type="submit" className="login-button" disabled={loading}>
                    {loading ? 'Verificando...' : 'Ingresar'}
                </button>

                {/* --- SECCIÓN DE REGISTRO --- */}
                <div className="register-link-container">
                    <p className="login-subtitle">
                        ¿No tienes una cuenta? <br />
                        <Link to="/register" className="register-link">
                            Solicita acceso aquí
                        </Link>
                    </p>
                </div>
            </form>
        </div>
    );
};

export default Login;