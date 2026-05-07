import { useCallback, useEffect, useState } from 'react';
import { 
    ShieldCheck, Lock, User, Server, Database, Edit2, X, 
    Users, Check, Trash2, UserCheck 
} from 'lucide-react';
import { buildApiUrl } from '../../config/api';
import './Settings.css';

const API_BASE_URL = import.meta.env.VITE_API_URL;

const Settings = () => {
    // Estados Infraestructura
    const [infraName, setInfraName] = useState('');
    const [sshUser, setSshUser] = useState('');
    const [sshPass, setSshPass] = useState('');
    const [wazuhUser, setWazuhUser] = useState('');
    const [wazuhPass, setWazuhPass] = useState('');
    const [infraCredentials, setInfraCredentials] = useState([]);
    
    // Estados Admin (Gestión de Usuarios)
    const [pendingUsers, setPendingUsers] = useState([]);
    const userRole = localStorage.getItem('user_role'); // USER o ADMIN

    // Estados de Control
    const [loading, setLoading] = useState(false);
    const [editingId, setEditingId] = useState(null);
    const [showVerifyModal, setShowVerifyModal] = useState(false);
    const [userPasswordVerify, setUserPasswordVerify] = useState('');
    const userId = localStorage.getItem('user_id');

    const fetchData = useCallback(async () => {
        if (!userId) return;

        try {
            // 1. Cargar credenciales de infraestructura
            const resInfra = await fetch(`${API_BASE_URL}/api/infra-credentials/user/${userId}`);
            if (resInfra.ok) setInfraCredentials(await resInfra.json());

            // 2. Si es ADMIN, cargar usuarios pendientes (active = false)
            if (userRole === 'ADMIN') {
                const resUsers = await fetch(`${API_BASE_URL}/api/users/pending`);
                if (resUsers.ok) setPendingUsers(await resUsers.json());
            }
        } catch (error) { 
            console.error('Error al cargar datos:', error); 
        }
    }, [userId, userRole]);

    useEffect(() => { fetchData(); }, [fetchData]);

    // --- LÓGICA DE ADMINISTRACIÓN ---
    const handleActivateUser = async (id) => {
        if (!window.confirm("¿Confirmas la activación de este usuario?")) return;
        try {
            const res = await fetch(`${API_BASE_URL}/api/users/${id}/activate`, { method: 'PATCH' });
            if (res.ok) fetchData();
        } catch (error) { console.error('Error:', error); }
    };

    const handleDeleteUser = async (id) => {
        if (!window.confirm("¿Estás seguro de rechazar/eliminar esta solicitud?")) return;
        try {
            const res = await fetch(`${API_BASE_URL}/api/users/${id}`, { method: 'DELETE' });
            if (res.ok) fetchData();
        } catch (error) { console.error('Error:', error); }
    };

    // --- LÓGICA DE INFRAESTRUCTURA ---
    const startEdit = (cred) => {
        setEditingId(cred.id);
        setInfraName(cred.name);
        setSshUser(cred.sshUser);
        setSshPass(''); 
        setWazuhUser(cred.wazuhUser);
        setWazuhPass('');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const cancelEdit = () => {
        setEditingId(null);
        setInfraName(''); setSshUser(''); setSshPass(''); setWazuhUser(''); setWazuhPass('');
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        setShowVerifyModal(true);
    };

    const handleVerifyAndSave = async () => {
        setLoading(true);
        // Aquí iría tu fetch real de validación de password contra el backend
        const isPasswordCorrect = true; 

        if (!isPasswordCorrect) {
            alert("Contraseña incorrecta");
            setLoading(false);
            return;
        }

        const payload = {
            userId,
            name: infraName,
            sshUser,
            sshPassword: sshPass,
            wazuhUser,
            wazuhPassword: wazuhPass
        };

        try {
            const url = editingId 
                ? `${API_BASE_URL}/api/infra-credentials/${editingId}`
                : `${API_BASE_URL}/api/infra-credentials`;
            const appAuth = localStorage.getItem('auth_basic');
            const response = await fetch(url, {
                method: editingId ? 'PUT' : 'POST',
                headers: { 
                    'Content-Type': 'application/json',
                    'Authorization': appAuth
                },
                body: JSON.stringify(payload)
            });

            if (response.ok) {
                cancelEdit();
                fetchData();
                setShowVerifyModal(false);
                setUserPasswordVerify('');
            }
        } catch (error) { console.error(error); }
        finally { setLoading(false); }
    };

    return (
        <div className="settings-container">
            {/* MODAL DE VERIFICACIÓN */}
            {showVerifyModal && (
                <div className="modal-overlay">
                    <form className="modal-content" onSubmit={(e) => { e.preventDefault(); handleVerifyAndSave(); }}>
                        <div className="modal-header">
                            <div className="modal-icon-wrapper"><ShieldCheck size={28} color="#007bff" /></div>
                            <h3>Verificación de Seguridad</h3>
                            <button type="button" className="close-modal-x" onClick={() => setShowVerifyModal(false)}><X size={20} /></button>
                        </div>
                        <p className="modal-description">
                            Ingresa tu contraseña para confirmar los cambios en <strong>{infraName}</strong>.
                        </p>
                        <div className="form-group">
                            <label><Lock size={14}/> Contraseña de acceso</label>
                            <input 
                                type="password" 
                                value={userPasswordVerify} 
                                onChange={(e) => setUserPasswordVerify(e.target.value)}
                                placeholder="Escribe tu contraseña"
                                autoFocus required className="modal-input"
                            />
                        </div>
                        <div className="modal-actions">
                            <button type="button" className="cancel-button" onClick={() => setShowVerifyModal(false)}>Cancelar</button>
                            <button type="submit" className="confirm-button" disabled={loading || !userPasswordVerify}>
                                {loading ? 'Procesando...' : 'Confirmar'}
                            </button>
                        </div>
                    </form>
                </div>
            )}

            <main className="settings-content">
                
                {/* --- SECCIÓN ADMINISTRADOR: USUARIOS PENDIENTES --- */}
                {userRole === 'ADMIN' && (
                    <section className="settings-section admin-box">
                        <div className="section-header">
                            <Users className="section-icon admin-icon" />
                            <div>
                                <h2>Aprobación de Usuarios</h2>
                                <p>Solicitudes de acceso pendientes de revisión.</p>
                            </div>
                        </div>

                        <div className="pending-list">
                            {pendingUsers.length === 0 ? (
                                <p className="empty-msg">No hay usuarios esperando aprobación.</p>
                            ) : (
                                <table className="creds-table">
                                    <thead>
                                        <tr>
                                            <th>Nombre Completo</th>
                                            <th>Email</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {pendingUsers.map(u => (
                                            <tr key={u.id}>
                                                <td>{`${u.firstName} ${u.paternalLastName} ${u.maternalLastName}`}</td>
                                                <td style={{color: '#888'}}>{u.email}</td>
                                                <td>
                                                    <div className="admin-actions">
                                                        <button 
                                                            className="approve-btn"
                                                            onClick={() => handleActivateUser(u.id)}
                                                            title="Activar Usuario"
                                                        >
                                                            <UserCheck size={16} />
                                                        </button>
                                                        <button 
                                                            className="delete-btn"
                                                            onClick={() => handleDeleteUser(u.id)}
                                                            title="Rechazar"
                                                        >
                                                            <Trash2 size={16} />
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            )}
                        </div>
                    </section>
                )}

                {/* --- SECCIÓN INFRAESTRUCTURA --- */}
                <section className={`settings-section ${editingId ? 'editing-mode' : ''}`}>
                    <div className="section-header">
                        <Server className="section-icon" />
                        <div>
                            <h2 className={editingId ? 'editing-title' : ''}>
                                {editingId ? 'Editando Perfil' : 'Llavero de Credenciales'}
                            </h2>
                            <p>{editingId ? `Modificando: ${infraName}` : 'Configura accesos SSH y Wazuh.'}</p>
                        </div>
                        {editingId && (
                            <button onClick={cancelEdit} className="cancel-edit-btn" style={{marginLeft: 'auto'}}>
                                <X size={16}/> Cancelar Edición
                            </button>
                        )}
                    </div>
                    
                    <form className="credential-form" onSubmit={handleSubmit}>
                        <div className="form-grid">
                            <div className="form-group full-width">
                                <label><Database size={16} /> Nombre del Perfil</label>
                                <input type="text" value={infraName} onChange={(e) => setInfraName(e.target.value)} required />
                            </div>
                            <div className="form-group">
                                <label><User size={14} /> Usuario SSH</label>
                                <input type="text" value={sshUser} onChange={(e) => setSshUser(e.target.value)} required />
                            </div>
                            <div className="form-group">
                                <label><Lock size={14} /> Pass SSH {editingId && '(Nueva)'}</label>
                                <input type="password" value={sshPass} onChange={(e) => setSshPass(e.target.value)} placeholder="••••" required={!editingId} />
                            </div>
                            <div className="form-group">
                                <label><User size={14} /> Usuario Wazuh</label>
                                <input type="text" value={wazuhUser} onChange={(e) => setWazuhUser(e.target.value)} required />
                            </div>
                            <div className="form-group">
                                <label><Lock size={14} /> Pass Wazuh {editingId && '(Nueva)'}</label>
                                <input type="password" value={wazuhPass} onChange={(e) => setWazuhPass(e.target.value)} placeholder="••••" required={!editingId} />
                            </div>
                        </div>
                        <button type="submit" className="save-button infra-btn" disabled={loading}>
                            {editingId ? 'Actualizar Datos del Perfil' : 'Guardar Perfil'}
                        </button>
                    </form>

                    <div className="credentials-list">
                        <h3>Perfiles Registrados</h3>
                        <table className="creds-table">
                            <thead>
                                <tr>
                                    <th>Perfil</th>
                                    <th>SSH / Wazuh</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                {infraCredentials.map((cred) => (
                                    <tr key={cred.id} style={editingId === cred.id ? {backgroundColor: 'rgba(0, 123, 255, 0.05)'} : {}}>
                                        <td style={{ fontWeight: 'bold' }}>{cred.name}</td>
                                        <td>{cred.sshUser} / {cred.wazuhUser}</td>
                                        <td>
                                            <button className="edit-btn" onClick={() => startEdit(cred)}>
                                                <Edit2 size={12} /> Editar
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </section>
            </main>
        </div>
    );
};

export default Settings;