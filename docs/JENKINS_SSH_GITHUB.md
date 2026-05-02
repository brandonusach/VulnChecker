# Guía: Jenkins + GitHub con SSH

Pasos para que Jenkins clone tu repositorio de GitHub usando una clave SSH.

---

## 1. Generar la clave SSH (en tu PC)

Abre **PowerShell** o **Git Bash** y ejecuta (sustituye la ruta si quieres guardarla en otro sitio):

```powershell
# Crear carpeta si no existe
mkdir -Force $env:USERPROFILE\.ssh | Out-Null
cd $env:USERPROFILE\.ssh

# Generar clave (sin passphrase para que Jenkins no pida contraseña)
ssh-keygen -t ed25519 -C "jenkins-github" -f jenkins_github -N ""
```

Se crearán dos archivos en `C:\Users\TU_USUARIO\.ssh\`:

- **jenkins_github** → clave **privada** (esta va a Jenkins)
- **jenkins_github.pub** → clave **pública** (esta va a GitHub)

---

## 2. Añadir la clave pública en GitHub

1. Abre el archivo **.pub** y copia todo su contenido (una línea):
   ```powershell
   Get-Content $env:USERPROFILE\.ssh\jenkins_github.pub
   ```
2. Entra en **GitHub** → tu foto (arriba derecha) → **Settings**.
3. En el menú izquierdo: **SSH and GPG keys**.
4. Pulsa **New SSH key**.
5. **Title:** por ejemplo `Jenkins`.
6. **Key type:** Authentication Key.
7. **Key:** pega el contenido de `jenkins_github.pub` (empieza por `ssh-ed25519` o `ssh-rsa`).
8. **Add SSH key**.

Para comprobar desde tu PC (opcional):

```powershell
ssh -T git@github.com
```

Deberías ver algo como: `Hi usuario! You've successfully authenticated...`

---

## 3. Crear la credencial en Jenkins

1. Abre Jenkins (ej. http://localhost:8081).
2. **Manage Jenkins** → **Credentials**.
3. Pulsa **(global)** (o el dominio que uses).
4. **Add Credentials**.
5. Rellena:
   - **Kind:** `SSH Username with private key`
   - **Scope:** `Global`
   - **ID:** `github-ssh` (o el nombre que quieras; lo usarás en el job)
   - **Description:** opcional, ej. `Clave SSH para GitHub`
   - **Username:** `git` (siempre `git` para GitHub)
   - **Private Key:** marca **Enter directly**
   - En el cuadro de texto pega la clave **privada** completa (la que **no** es .pub).

Para copiar la clave privada en PowerShell:

```powershell
Get-Content $env:USERPROFILE\.ssh\jenkins_github
```

Copia **todo** lo que salga, desde `-----BEGIN OPENSSH PRIVATE KEY-----` hasta `-----END OPENSSH PRIVATE KEY-----` (incluidas esas líneas).

6. **Passphrase:** déjalo vacío (salvo que hayas puesto passphrase al crear la clave).
7. **Create**.

---

## 4. Configurar el job para usar el repo por SSH

1. En Jenkins, entra en tu **job** (p. ej. DevSecOps).
2. **Configure**.
3. En **Pipeline**:
   - **Definition:** `Pipeline script from SCM`
   - **SCM:** `Git`
   - **Repository URL:** la URL **SSH** del repo, por ejemplo:
     ```
     git@github.com:TU_USUARIO/vulnchecker.git
     ```
     (no uses la URL HTTPS `https://github.com/...`)
   - **Credentials:** elige la credencial que creaste (ej. `github-ssh`).
   - **Branch:** `*/main` o `*/master` según tu rama por defecto.
   - **Script Path:** `Jenkinsfile`
4. **Save**.

---

## 5. Probar

1. **Build Now** en el job.
2. Revisa la consola del build. Si el checkout funciona, verás algo como:
   ```
   Cloning the remote Git repository
   Cloning with git ...
   ```

---

## 6. Si sigue fallando (errores frecuentes)

### "Permission denied (publickey)" o "Host key verification failed"

- **Causa:** Jenkins no está usando bien la clave o GitHub no tiene la pública.
- **Comprueba:**
  1. En GitHub → Settings → SSH and GPG keys: que la clave que añadiste sea la del archivo `.pub` (no la privada).
  2. En Jenkins → Credentials: que hayas pegado la clave **privada** (sin .pub) completa, con las líneas BEGIN/END.
  3. En el job, que la URL del repo sea **SSH** (`git@github.com:...`) y que hayas elegido la credencial correcta en **Credentials**.

### "Could not find host 'github.com'"

- **Causa:** El contenedor de Jenkins no resuelve `github.com` o no tiene salida a internet.
- **Comprueba:** Que el contenedor tenga red (por ejemplo que esté en la red del docker-compose y que el host tenga internet). Puedes probar: `docker exec vuln-jenkins ping -c 2 github.com` (si `ping` está instalado).

### "Unknown host key" o "Host key verification failed"

- Jenkins no tiene en su `known_hosts` la clave de GitHub.
- **Solución:** Añadir la host key de GitHub en Jenkins:
  1. En tu PC: `ssh-keyscan github.com` y copia la línea que empiece por `github.com ssh-rsa` (o ssh-ed25519).
  2. En Jenkins no suele editarse `known_hosts` a mano; asegúrate de usar una versión reciente del plugin **Git** (Manage Jenkins → Plugins). Si el contenedor tiene `ssh-keyscan`, puedes ejecutar desde el host:
     ```bash
     docker exec vuln-jenkins sh -c "ssh-keyscan github.com >> /var/jenkins_home/.ssh/known_hosts 2>/dev/null"
     ```
     (solo si el usuario con el que corre Jenkins tiene `/var/jenkins_home/.ssh`).

### La credencial no sale en el desplegable del job

- Que el **Scope** de la credencial sea **Global**.
- Que el **Kind** sea exactamente **SSH Username with private key**.

### Usar HTTPS en lugar de SSH (alternativa)

Si SSH te da muchos problemas, puedes usar **HTTPS** y un **Personal Access Token** de GitHub:

1. GitHub → Settings → Developer settings → Personal access tokens → Generate new token (classic). Marca al menos `repo`.
2. En Jenkins → Credentials → Add → **Username and password**:
   - Username: tu usuario de GitHub
   - Password: el token (no tu contraseña)
   - ID: ej. `github-htpass`
3. En el job, **Repository URL:** `https://github.com/TU_USUARIO/vulnchecker.git` y **Credentials** la que acabas de crear.

---

## Resumen rápido

| Dónde   | Qué hace |
|--------|----------|
| Tu PC  | `ssh-keygen` → generas `jenkins_github` (privada) y `jenkins_github.pub` (pública). |
| GitHub | Añades el contenido de **jenkins_github.pub** en Settings → SSH and GPG keys. |
| Jenkins| Creas credencial "SSH Username with private key" con **Username:** `git` y **Private Key:** contenido de **jenkins_github** (privada). |
| Job    | Repo URL: `git@github.com:usuario/repo.git`, Credentials: la credencial creada, Script Path: `Jenkinsfile`. |
