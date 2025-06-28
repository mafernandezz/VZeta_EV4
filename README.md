# Despliegue Continuo con Nginx, Docker y GitHub Actions en AWS

Este proyecto es una demostración de un pipeline de **CI/CD (Integración Continua y Despliegue Continuo)** completamente automatizado. El objetivo es desplegar una página web estática servida por **Nginx** dentro de un contenedor **Docker** en una instancia **AWS EC2**. El proceso se activa automáticamente con cada `push` a la rama `main` del repositorio mediante **GitHub Actions**.

## Tabla de Contenidos

- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [¿Cómo Funciona?](#cómo-funciona)
  - [Flujo de CI/CD](#flujo-de-cicd)
  - [Persistencia de Datos](#persistencia-de-datos)
- [Cómo Probar en Local](#cómo-probar-en-local)
- [Configuración para Despliegue](#configuración-para-despliegue)
  - [Prerrequisitos en AWS](#prerrequisitos-en-aws)
  - [Secrets de GitHub](#secrets-de-github)
- [Autor](#autor)

---

## Tecnologías Utilizadas

- **Servidor Web:** [Nginx](https://www.nginx.com/)
- **Contenerización:** [Docker](https://www.docker.com/)
- **Plataforma en la Nube:** [AWS EC2](https://aws.amazon.com/ec2/)
- **CI/CD:** [GitHub Actions](https://github.com/features/actions)
- **Registro de Imágenes:** [Docker Hub](https://hub.docker.com/)

---

## Estructura del Proyecto
Use code with caution.
Markdown
.
├── .github/
│ └── workflows/
│ └── ci-cd.yml # Define el pipeline de CI/CD
├── Dockerfile # Instrucciones para construir la imagen de Nginx
├── nginx.conf # Configuración personalizada de Nginx
├── app/ # Código fuente de la página web
│ ├── css/style.css
│ ├── js/main.js
│ └── index.html
└── app-data/
└── persistent.html # Archivo de prueba para volúmenes persistentes
Generated code
- **`app/`**: Contiene la aplicación web estática (HTML, CSS, JS).
- **`app-data/`**: Contiene datos que deben ser persistentes y no forman parte de la imagen de Docker. En este caso, se usa para demostrar el uso de volúmenes.
- **`Dockerfile`**: Construye una imagen de Nginx con la configuración y el contenido de la aplicación web.
- **`nginx.conf`**: Configuración optimizada de Nginx que escucha en el puerto 8080.
- **`.github/workflows/ci-cd.yml`**: Orquesta todo el proceso: construye la imagen de Docker, la sube a Docker Hub y se conecta a la instancia EC2 para desplegar el nuevo contenedor.

---

## ¿Cómo Funciona?

### Flujo de CI/CD

1.  **Activación (`push`)**: Cuando se realiza un `push` a la rama `main`, el workflow de GitHub Actions se activa.
2.  **Construcción y Publicación (CI)**:
    -   Se construye una nueva imagen de Docker usando el `Dockerfile`.
    -   La imagen se etiqueta con `latest` y con el hash del commit de Git para un versionado preciso.
    -   La imagen se sube al registro de Docker Hub.
3.  **Despliegue (CD)**:
    -   GitHub Actions se conecta de forma segura a la instancia EC2 mediante SSH.
    -   Detiene y elimina el contenedor que se estaba ejecutando previamente.
    -   Descarga (`pull`) la nueva versión de la imagen desde Docker Hub.
    -   Inicia un nuevo contenedor con la imagen actualizada, mapeando el puerto 80 del host al 8080 del contenedor y montando un volumen para los datos persistentes.

### Persistencia de Datos

Para demostrar la separación entre el contenedor (efímero) y los datos (persistentes), se utiliza un **volumen de Docker**. La página principal (`index.html`) incluye un enlace a `/persistent.html`. Este archivo no se copia en la imagen de Docker, sino que se monta desde el sistema de archivos del host (la instancia EC2) en el directorio web del contenedor.

Esto asegura que si el contenedor es destruido y recreado, el contenido de `persistent.html` no se pierde.

---

## Cómo Probar en Local

Para construir y ejecutar el proyecto en tu máquina local antes de desplegarlo:

1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/mafernandezz/VZeta_EV4.git
    cd VZeta_EV4
    ```

2.  **Construye la imagen de Docker:**
    ```bash
    docker build -t nginx-local-test .
    ```

3.  **Ejecuta el contenedor con un volumen local:**
    ```bash
    docker run -d -p 8080:8080 --name local-test \
      -v "$(pwd)/app-data/persistent.html:/usr/share/nginx/html/persistent.html" \
      nginx-local-test
    ```

4.  **Verifica en tu navegador:**
    -   **Página Principal:** [http://localhost:8080](http://localhost:8080)
    -   **Archivo Persistente:** [http://localhost:8080/persistent.html](http://localhost:8080/persistent.html)

5.  **Para detener y limpiar:**
    ```bash
    docker stop local-test
    docker rm local-test
    ```

---

## Configuración para Despliegue

### Prerrequisitos en AWS

1.  Una instancia **EC2** con Docker instalado.
2.  Un **Grupo de Seguridad** que permita tráfico entrante en el **puerto 80 (HTTP)**.
3.  Un par de claves SSH para el acceso remoto.

### Secrets de GitHub

El pipeline de GitHub Actions requiere los siguientes `secrets` configurados en `Settings > Secrets and variables > Actions`:

-   `DOCKERHUB_USERNAME`: Tu nombre de usuario de Docker Hub.
-   `DOCKERHUB_TOKEN`: Un token de acceso de Docker Hub.
-   `EC2_HOST`: La dirección IP pública o DNS de tu instancia EC2.
-   `EC2_USERNAME`: El nombre de usuario para la conexión SSH (ej. `ec2-user`).
-   `EC2_SSH_KEY`: La clave SSH privada para acceder a la instancia.

---

## Autor

- **Matías Fernández**
- GitHub: [@mafernandezz](https://github.com/mafernandezz)