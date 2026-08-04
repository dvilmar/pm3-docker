# Kali + Proxmark3 Docker

Imagen Docker de Kali Linux con el cliente Proxmark3 (Iceman fork) precompilado.

## Requisitos

- Docker instalado (Docker Desktop con integración WSL2, o Docker nativo en Linux)
- Si usas WSL2 en Windows: [usbipd-win](https://github.com/dorssel/usbipd-win) para pasar el USB del Proxmark3 al contenedor

## ¿Por qué hace falta usbipd en WSL2?

Docker no puede ver dispositivos USB físicos por sí solo en ningún sistema — necesita acceso al bus USB del host. En Linux nativo esto es directo (`-v /dev/bus/usb:/dev/bus/usb --privileged` basta).

En Windows + WSL2, WSL2 es una VM ligera de Hyper-V que **no tiene acceso directo al hardware USB** — el USB lo controla Windows. Por eso hace falta un paso intermedio: `usbipd` comparte el dispositivo USB desde Windows hacia WSL2 mediante USB/IP. El flujo completo es:

Proxmark3 (USB físico)
→ Windows
→ usbipd (comparte el USB)
→ WSL2 (ahora lo ve en /dev/ttyACM0)
→ Docker con -v /dev/bus/usb (el contenedor lo ve)


Este paso solo es necesario si usas Windows + WSL2. En Linux nativo se puede saltar directo a "Levantar el contenedor".

## Construir la imagen

docker build -t kali-pm3 .

## Pasar el Proxmark3 desde Windows a WSL2 (solo si usas WSL2)

**1. Instalar usbipd en Windows** (PowerShell como Administrador, una sola vez):

winget install usbipd

Reinicia PowerShell después de instalarlo.

**2. Conectar el Proxmark3 por USB al PC**, luego listar dispositivos:

usbipd list

Busca la línea del Proxmark3 y anota su `BUSID` (ej: `1-4`).

**3. Compartir y adjuntar el dispositivo a WSL2:**

usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>

Repite el `usbipd attach` cada vez que reconectes el dispositivo o reinicies WSL2.

**4. Verificar en WSL/Kali (fuera del contenedor):**

lsusb

## Levantar el contenedor

docker run -it --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    --name kali-pm3 \
    kali-pm3

Si el contenedor ya existe y solo quieres volver a entrar:

docker start -ai kali-pm3

## Dentro del contenedor

lsusb
ls /dev/ttyACM*
proxmark3 /dev/ttyACM0

Dentro del prompt del cliente, prueba:

hw version


## Clonar y correr en otro equipo

git clone git@github.com:dvilmar/pm3-docker.git
cd pm3-docker
docker build -t kali-pm3 .
docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb --name kali-pm3 kali-pm3
