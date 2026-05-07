import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import './Login.css'; // Reutilizamos los estilos

const API_BASE_URL = import.meta.env.VITE_API_URL;

const Register = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        firstName: '',
        paternalLastName: '',
        maternalLastName: '',
        userPrefix: '',
        password: '',
        confirmPassword: ''
    });
    const [loading, setLoading] = useState(false);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.id]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        
        if (formData.password !== formData.confirmPassword) {
            alert("Las contraseñas no coinciden");
            return;
        }

        setLoading(true);
        const fullEmail = `${formData.userPrefix}@usach.cl`;

        try {
            const response = await fetch(`${API_BASE_URL}/api/users`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    firstName: formData.firstName,
                    paternalLastName: formData.paternalLastName,
                    maternalLastName: formData.maternalLastName,
                    email: fullEmail,
                    password: formData.password
                    // 'active' y 'role' se manejan por defecto en el backend
                })
            });

            if (response.ok) {
                alert('Solicitud enviada con éxito. Un administrador debe aprobar tu cuenta para que puedas ingresar.');
                navigate('/login');
            } else {
                const errorData = await response.json();
                alert(errorData.message || 'Error al registrar usuario. El correo podría estar en uso.');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('No se pudo conectar con el servidor.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-container">
            <form className="login-form register-form-width" onSubmit={handleSubmit}>
                <h1 className="login-title">Registro</h1>
                <p className="login-subtitle">Solicita acceso al sistema VulnChecker</p>

                <div className="input-group">
                    <label htmlFor="firstName">Nombre</label>
                    <input type="text" id="firstName" value={formData.firstName} onChange={handleChange} required placeholder="Juan" />
                </div>

                <div style={{ display: 'flex', gap: '1rem' }}>
                    <div className="input-group" style={{ flex: 1 }}>
                        <label htmlFor="paternalLastName">Apellido Paterno</label>
                        <input type="text" id="paternalLastName" value={formData.paternalLastName} onChange={handleChange} required placeholder="Pérez" />
                    </div>
                    <div className="input-group" style={{ flex: 1 }}>
                        <label htmlFor="maternalLastName">Apellido Materno</label>
                        <input type="text" id="maternalLastName" value={formData.maternalLastName} onChange={handleChange} required placeholder="García" />
                    </div>
                </div>

                <div className="input-group">
                    <label htmlFor="userPrefix">Correo Institucional</label>
                    <div className="email-input-wrapper">
                        <input
                            type="text"
                            id="userPrefix"
                            value={formData.userPrefix}
                            onChange={handleChange}
                            placeholder="nombre.apellido"
                            required
                        />
                        <span className="email-domain">@usach.cl</span>
                    </div>
                </div>

                <div className="input-group">
                    <label htmlFor="password">Contraseña</label>
                    <input type="password" id="password" value={formData.password} onChange={handleChange} required placeholder="••••••••" />
                </div>

                <div className="input-group">
                    <label htmlFor="confirmPassword">Confirmar Contraseña</label>
                    <input type="password" id="confirmPassword" value={formData.confirmPassword} onChange={handleChange} required placeholder="••••••••" />
                </div>

                <button type="submit" className="login-button" disabled={loading}>
                    {loading ? 'Enviando solicitud...' : 'Solicitar Acceso'}
                </button>

                <p className="login-subtitle" style={{ marginTop: '1.5rem', marginBottom: 0 }}>
                    ¿Ya tienes cuenta? <Link to="/login" style={{ color: 'var(--primary-color)', textDecoration: 'none' }}>Inicia sesión</Link>
                </p>
            </form>
        </div>
    );
};

export default Register;