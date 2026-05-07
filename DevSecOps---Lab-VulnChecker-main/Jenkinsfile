// Pipeline DevSecOps: Secretos, Build, Test, SAST, SCA, escaneo de imágenes, DAST (ZAP), métricas
pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = 'vulnchecker'
        DOCKER_NETWORK = 'vulnchecker_devsecops'
        APP_BACKEND_URL = 'http://backend:8080'
        APP_FRONTEND_URL = 'http://frontend:5173'
        SONAR_HOST = 'http://sonarqube:9000'
        BACKEND_IMAGE = 'vulnchecker-backend'
        FRONTEND_IMAGE = 'vulnchecker-frontend'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 90, unit: 'MINUTES')
        timestamps()
    }

    parameters {
        choice(name: 'SKIP_SONAR', choices: ['false', 'true'], description: 'Si SonarQube no está configurado o no está levantado, elegir true para omitir el análisis SAST con SonarQube')
        string(name: 'SONAR_SERVER_NAME', defaultValue: 'SonarQube', description: "Nombre exacto de la instalación SonarQube en Jenkins (Manage Jenkins → System → SonarQube servers). Si falla 'does not match any configured installation', pon aquí el nombre que ves en la lista.")
        choice(name: 'SKIP_CHECKOUT', choices: ['false', 'true'], description: "Usar true solo si el job NO es 'Pipeline from SCM' y el workspace ya tiene el repo (p. ej. clonado a mano). En condiciones normales: false y configurar el job como 'Pipeline script from SCM'.")
        choice(name: 'SKIP_JUNIT', choices: ['false', 'true'], description: 'Si eliges true se omite el stage Unit Tests (JUnit)')
        choice(name: 'SKIP_DEPENDENCY_CHECK', choices: ['false', 'true'], description: 'true = omitir OWASP Dependency Check (la primera vez puede tardar 30-60 min por la descarga NVD)')
        choice(name: 'SKIP_ZAP', choices: ['false', 'true'], description: 'true = omitir DAST (OWASP ZAP). La app debe estar ya levantada (docker compose up --build).')
        password(name: 'NVD_API_KEY', description: 'Opcional. API key de NVD (nvd.nist.gov → Request API Key) para evitar rate limit 429.')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    if (params.SKIP_CHECKOUT == 'true') {
                        if (!fileExists('vulncheckerbackend/pom.xml')) {
                            error('SKIP_CHECKOUT=true pero no hay código en el workspace. Configura el job como "Pipeline script from SCM" (Git + Script Path: Jenkinsfile) o clona el repo antes de ejecutar.')
                        }
                        echo 'Checkout omitido; usando código existente en el workspace.'
                    } else {
                        try {
                            checkout scm
                        } catch (Exception e) {
                            error(
                                "Checkout falló: 'checkout scm' solo funciona cuando el job está definido como 'Pipeline script from SCM'. " +
                                "En la configuración del job: Pipeline → Definition → elige 'Pipeline script from SCM', indica el repositorio Git y Script Path 'Jenkinsfile'. " +
                                "Si ya tienes el código en el workspace por otro medio, ejecuta de nuevo con parámetro SKIP_CHECKOUT=true. Original: ${e.message}"
                            )
                        }
                    }
                }
            }
        }

        stage('Prepare reports dirs') {
            steps {
                sh """
                    mkdir -p /jenkins-reports/latest
                    mkdir -p /jenkins-reports/latest/dependency-check-backend /jenkins-reports/latest/dependency-check-frontend /jenkins-reports/latest/trivy /jenkins-reports/latest/zap
                    chmod -R 777 /jenkins-reports/latest 2>/dev/null || true
                    mkdir -p reports reports/zap reports/trivy reports/dependency-check-backend reports/dependency-check-frontend
                    chmod -R 777 reports 2>/dev/null || true
                    chmod +x vulncheckerbackend/mvnw 2>/dev/null || true
                """
            }
        }

        stage('Secret Scanning (Gitleaks)') {
            steps {
                sh """
                    chmod -R 777 reports 2>/dev/null || true
                    docker run --rm \
                        -v "${WORKSPACE}:/repo:rw" \
                        ghcr.io/zricethezav/gitleaks:latest \
                        detect --source /repo --no-git --verbose \
                        --report-path /repo/reports/gitleaks-report.json \
                        || true
                    # Gitleaks no escribe archivo cuando no hay hallazgos; dejar JSON válido con 0 resultados
                    if [ ! -s reports/gitleaks-report.json ]; then
                        echo '{"version":"0","results":[],"message":"No secrets detected (or report not generated)"}' > reports/gitleaks-report.json
                    fi
                """
            }
            post {
                always {
                    archiveArtifacts artifacts: 'reports/gitleaks-report.json', allowEmptyArchive: true
                }
            }
        }

        stage('Build Backend') {
            steps {
                dir('vulncheckerbackend') {
                    sh 'chmod +x mvnw && ./mvnw clean compile -q -DskipTests'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm ci'
                    sh 'npm run build'
                }
            }
        }

        stage('Unit Tests') {
            when { expression { return params.SKIP_JUNIT != 'true' } }
            steps {
                dir('vulncheckerbackend') {
                    sh 'chmod +x mvnw && ./mvnw test -q'
                }
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'vulncheckerbackend/target/surefire-reports/*.xml'
                }
            }
        }

        // Rutas: repo raíz = workspace; backend=${WORKSPACE}/vulncheckerbackend (pom.xml), frontend=${WORKSPACE}/frontend (package.json); salida=/jenkins-reports/latest/... (montaje ./jenkins-reports en compose).
        // El CLI de Dependency Check escanea JARs en disco; no resuelve pom.xml. Por eso copiamos las dependencias Maven a target/dependency antes de escanear el backend.
        stage('OWASP Dependency Check') {
            when { expression { return params.SKIP_DEPENDENCY_CHECK != 'true' } }
            steps {
                dir('vulncheckerbackend') {
                    sh 'chmod +x mvnw && ./mvnw dependency:copy-dependencies -DoutputDirectory=target/dependency -q'
                }
                script {
                    echo 'OWASP Dependency Check: backend descarga NVD (NVD API key en credencial nvd-api-key, parámetro o .env evita 429). Frontend usa caché (--noupdate).'
                    timeout(time: 90, unit: 'MINUTES') {
                    def nvdKey = (params.NVD_API_KEY != null && params.NVD_API_KEY != '') ? params.NVD_API_KEY : ''
                    if (nvdKey == '' && fileExists('.env')) {
                        readFile('.env').split('\n').each { line ->
                            def t = line.trim()
                            if (t.startsWith('NVD_API_KEY=')) {
                                nvdKey = t.substring(12).trim()
                                if (nvdKey.size() >= 2 && ((nvdKey.startsWith('"') && nvdKey.endsWith('"')) || (nvdKey.startsWith("'") && nvdKey.endsWith("'")))) {
                                    nvdKey = nvdKey[1..-2]
                                }
                            }
                        }
                    }
                    if (nvdKey != '') {
                        echo "NVD API key: sí (parámetro o .env)."
                        withEnv(["NVD_API_KEY=${nvdKey}"]) {
                    dir('vulncheckerbackend') {
                        sh """
                            echo ">>> Dependency Check (backend): iniciando. Reportes en ./jenkins-reports/latest/dependency-check-backend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -e NVD_API_KEY=\$NVD_API_KEY -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/vulncheckerbackend --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-backend --project vulnchecker-backend --failOnCVSS 11 \${NVD_API_KEY:+--nvdApiKey \$NVD_API_KEY} || true
                        """
                    }
                    dir('frontend') {
                        sh """
                            echo ">>> Dependency Check (frontend). Reportes en ./jenkins-reports/latest/dependency-check-frontend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/frontend --noupdate --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-frontend --project vulnchecker-frontend --failOnCVSS 11 || true
                        """
                    }
                        }
                    } else {
                        def usedNvdCred = false
                        try {
                            echo "NVD API key: intentando credencial Secret file (nvd-api-key-file); si no existe, Secret text (nvd-api-key)."
                            withCredentials([file(credentialsId: 'nvd-api-key-file', variable: 'NVD_API_KEY_FILE')]) {
                                usedNvdCred = true
                    dir('vulncheckerbackend') {
                        sh """
                            echo ">>> Dependency Check (backend): iniciando (key desde archivo). Reportes en ./jenkins-reports/latest/dependency-check-backend/"
                            NVD_KEY=\$(cat "\$NVD_API_KEY_FILE" | tr -d '\\n\\r')
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -e NVD_API_KEY="\$NVD_KEY" -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/vulncheckerbackend --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-backend --project vulnchecker-backend --failOnCVSS 11 --nvdApiKey "\$NVD_KEY" || true
                        """
                    }
                    dir('frontend') {
                        sh """
                            echo ">>> Dependency Check (frontend). Reportes en ./jenkins-reports/latest/dependency-check-frontend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/frontend --noupdate --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-frontend --project vulnchecker-frontend --failOnCVSS 11 || true
                        """
                    }
                            }
                        } catch (Exception e1) {
                            try {
                                echo "Secret file no encontrado; intentando credencial Secret text (nvd-api-key)..."
                                withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                                    usedNvdCred = true
                    dir('vulncheckerbackend') {
                        sh """
                            echo ">>> Dependency Check (backend): iniciando. Reportes en ./jenkins-reports/latest/dependency-check-backend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -e NVD_API_KEY=\$NVD_API_KEY -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/vulncheckerbackend --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-backend --project vulnchecker-backend --failOnCVSS 11 \${NVD_API_KEY:+--nvdApiKey \$NVD_API_KEY} || true
                        """
                    }
                    dir('frontend') {
                        sh """
                            echo ">>> Dependency Check (frontend). Reportes en ./jenkins-reports/latest/dependency-check-frontend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/frontend --noupdate --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-frontend --project vulnchecker-frontend --failOnCVSS 11 || true
                        """
                    }
                                }
                            } catch (Exception e2) {
                                echo "Credencial 'nvd-api-key' (file o text) no encontrada: ${e2.message}"
                            }
                        }
                        if (!usedNvdCred) {
                            withEnv(['NVD_API_KEY=']) {
                    dir('vulncheckerbackend') {
                        sh """
                            echo ">>> Dependency Check (backend): iniciando (sin API key). Reportes en ./jenkins-reports/latest/dependency-check-backend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -e NVD_API_KEY= -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/vulncheckerbackend --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-backend --project vulnchecker-backend --failOnCVSS 11 || true
                        """
                    }
                    dir('frontend') {
                        sh """
                            echo ">>> Dependency Check (frontend). Reportes en ./jenkins-reports/latest/dependency-check-frontend/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) -v vulnchecker-owasp-data:/usr/share/dependency-check/data:rw owasp/dependency-check:latest --scan ${WORKSPACE}/frontend --noupdate --format HTML --format JSON --out /jenkins-reports/latest/dependency-check-frontend --project vulnchecker-frontend --failOnCVSS 11 || true
                        """
                    }
                            }
                        }
                    }
                    }
                }
            }
            post {
                always {
                    sh """
                        mkdir -p ${WORKSPACE}/reports
                        cp -r /jenkins-reports/latest/dependency-check-backend ${WORKSPACE}/reports/ 2>/dev/null || true
                        cp -r /jenkins-reports/latest/dependency-check-frontend ${WORKSPACE}/reports/ 2>/dev/null || true
                        echo "Reportes escritos en ./jenkins-reports/latest/dependency-check-backend y .../dependency-check-frontend (carpeta del proyecto)."
                        ls -la /jenkins-reports/latest/dependency-check-backend/ 2>/dev/null || echo "Backend report dir vacío o no accesible"
                        ls -la /jenkins-reports/latest/dependency-check-frontend/ 2>/dev/null || echo "Frontend report dir vacío o no accesible"
                    """
                    script {
                        def hasReport = fileExists('reports/dependency-check-backend/dependency-check-report.html') || fileExists('reports/dependency-check-frontend/dependency-check-report.html')
                        if (hasReport) {
                            archiveArtifacts artifacts: 'reports/**/dependency-check-report.html', allowEmptyArchive: true
                        }
                    }
                }
            }
        }

        // SonarQube 9+ requiere token. Credencial id 'sonarqube-token'; System → SonarQube servers → el nombre debe coincidir con el parámetro SONAR_SERVER_NAME.
        stage('SonarQube Analysis') {
            when { expression { return params.SKIP_SONAR != 'true' } }
            steps {
                withSonarQubeEnv(params.SONAR_SERVER_NAME?.trim() ?: 'SonarQube') {
                    dir('vulncheckerbackend') {
                        withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                            sh """
                                chmod +x mvnw
                                ./mvnw sonar:sonar -q \
                                    -Dsonar.host.url=\${SONAR_HOST_URL:-${SONAR_HOST}} \
                                    -Dsonar.token=\${SONAR_TOKEN} \
                                    -Dsonar.projectKey=vulnchecker-backend \
                                    -Dsonar.projectName=vulnchecker-backend \
                                    -Dsonar.java.binaries=target/classes \
                                    -DskipTests
                            """
                        }
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh """
                    cd ${WORKSPACE} && docker compose -f docker-compose.yml -f docker-compose.ci.yml build backend frontend
                """
            }
        }

        stage('Container Image Scan (Trivy)') {
            steps {
                sh """
                    docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        aquasec/trivy:latest image \
                        --severity HIGH,CRITICAL \
                        --ignore-unfixed \
                        --exit-code 0 \
                        --format table \
                        ${BACKEND_IMAGE} || true
                """
                sh """
                    docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        aquasec/trivy:latest image \
                        --severity HIGH,CRITICAL \
                        --ignore-unfixed \
                        --exit-code 0 \
                        --format table \
                        ${FRONTEND_IMAGE} || true
                """
            }
            post {
                always {
                    sh """
                        mkdir -p /jenkins-reports/latest/trivy
                        chmod -R 777 /jenkins-reports/latest/trivy 2>/dev/null || true
                        echo ">>> Trivy (backend). Reportes en ./jenkins-reports/latest/trivy/"
                        docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            aquasec/trivy:latest image \
                            --format json --output /jenkins-reports/latest/trivy/trivy-backend.json ${BACKEND_IMAGE} || true
                        echo ">>> Trivy (frontend). Reportes en ./jenkins-reports/latest/trivy/"
                        docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            aquasec/trivy:latest image \
                            --format json --output /jenkins-reports/latest/trivy/trivy-frontend.json ${FRONTEND_IMAGE} || true
                        mkdir -p ${WORKSPACE}/reports/trivy
                        cp -r /jenkins-reports/latest/trivy/*.json ${WORKSPACE}/reports/trivy/ 2>/dev/null || true
                        echo ">>> Resumen Trivy (trivy-resumen.txt)"
                        docker run --rm -v "${WORKSPACE}:/app" -w /app node:20-alpine node scripts/trivy-summary.js --out reports/trivy/trivy-resumen.txt reports/trivy/trivy-backend.json reports/trivy/trivy-frontend.json 2>/dev/null || echo "Trivy resumen: script falló o no hay JSON (revisar reports/trivy/*.json)." > reports/trivy/trivy-resumen.txt
                        echo "Reportes Trivy en ./jenkins-reports/latest/trivy/ (carpeta del proyecto)."
                        ls -la /jenkins-reports/latest/trivy/ 2>/dev/null || echo "latest/trivy vacío o no accesible"
                        ls -la ${WORKSPACE}/reports/trivy/ 2>/dev/null || echo "reports/trivy vacío"
                    """
                    archiveArtifacts artifacts: 'reports/trivy/*.json, reports/trivy/trivy-resumen.txt', allowEmptyArchive: true
                }
            }
        }

        stage('DAST - OWASP ZAP') {
            when { expression { return params.SKIP_ZAP != 'true' } }
            steps {
                sh '''
                    echo "Comprobando que el backend esté listo (app ya levantada con docker compose up --build)..."
                    for i in $(seq 1 24); do
                        if curl -sf http://backend:8080/actuator/health >/dev/null 2>&1 || curl -sf http://backend:8080 >/dev/null 2>&1; then
                            echo "Backend listo."
                            break
                        fi
                        echo "Esperando backend... ($i/24)"
                        sleep 5
                    done
                '''
                script {
                    timeout(time: 15, unit: 'MINUTES') {
                        sh """
                            mkdir -p /jenkins-reports/latest/zap
                            chmod -R 777 /jenkins-reports/latest/zap 2>/dev/null || true
                            echo ">>> ZAP: escaneo a backend (http://backend:8080). Reportes en ./jenkins-reports/latest/zap/"
                            docker run --rm --volumes-from vuln-jenkins --user \$(id -u):\$(id -g) \
                                --network ${DOCKER_NETWORK} \
                                --entrypoint bash \
                                ghcr.io/zaproxy/zaproxy:latest \
                                -c "rm -rf /zap/wrk && ln -s /jenkins-reports/latest/zap /zap/wrk && exec zap-baseline.py -t http://backend:8080 -r zap-report.html -J zap-report.json -I -s -m 3" || true
                            mkdir -p ${WORKSPACE}/reports/zap
                            cp /jenkins-reports/latest/zap/zap-report.html ${WORKSPACE}/reports/zap/ 2>/dev/null || true
                            cp /jenkins-reports/latest/zap/zap-report.json ${WORKSPACE}/reports/zap/ 2>/dev/null || true
                            touch ${WORKSPACE}/reports/zap/zap-report.html ${WORKSPACE}/reports/zap/zap-report.json 2>/dev/null || true
                            echo "Reportes ZAP en ./jenkins-reports/latest/zap/ (carpeta del proyecto)."
                            ls -la /jenkins-reports/latest/zap/ 2>/dev/null || echo "latest/zap vacío o no accesible"
                            ls -la ${WORKSPACE}/reports/zap/ 2>/dev/null || echo "reports/zap vacío"
                        """
                    }
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'reports/zap/*.html, reports/zap/*.json', allowEmptyArchive: true
                }
            }
        }
    }

    post {
        always {
            // No paramos backend/frontend para que la app quede corriendo al final del pipeline
            sh """
                mkdir -p /jenkins-reports/latest
                if [ -d "${WORKSPACE}/reports" ] && [ "\$(ls -A ${WORKSPACE}/reports 2>/dev/null)" ]; then
                    cp -rv ${WORKSPACE}/reports/* /jenkins-reports/latest/ || echo "Warning: no se pudo copiar reports"
                else
                    echo "No hay reportes en ${WORKSPACE}/reports aún (pipeline incompleto o sin ejecutar esos stages)"
                fi
            """
        }
        success {
            echo 'Pipeline DevSecOps completado. Revisa reportes en Jenkins y en ./jenkins-reports/latest/ (carpeta del proyecto).'
        }
        failure {
            echo 'Pipeline falló. Revisa los logs y reportes de seguridad.'
        }
    }
}
