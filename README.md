# Kali + Proxmark3 Docker

Imagen Docker de Kali Linux con el cliente Proxmark3 (Iceman fork) precompilado.

## Requisitos

- Docker instalado (Docker Desktop con integración WSL2, o Docker nativo en Linux)
- Si usas WSL2 en Windows: [usbipd-win](https://github.com/dorssel/usbipd-win) para pasar el USB del Proxmark3 al contenedor

## Construir la imagen

```bash
docker build -t kali-pm3 .
```

## Pasar el Proxmark3 desde Windows a WSL2 (solo si usas WSL2)

En PowerShell, como Administrador:

```powershell
usbipd list
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```

Reemplaza `<BUSID>` por el que te muestre `usbipd list` para el Proxmark3.

## Levantar el contenedor

```bash
docker run -it --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    --name kali-pm3 \
    kali-pm3
```

Si el contenedor ya existe y solo quieres volver a entrar:

```bash
docker start -ai kali-pm3
```

## Dentro del contenedor

```bash
lsusb
ls /dev/ttyACM*
proxmark3 /dev/ttyACM0
```

## Clonar y correr en otro equipo

```bash
git clone git@github.com:dvilmar/pm3-docker.git
cd pm3-docker
docker build -t kali-pm3 .
docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb --name kali-pm3 kali-pm3
```
