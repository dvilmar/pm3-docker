# Kali + Proxmark3 Docker

Imagen Docker de Kali Linux con el cliente Proxmark3 (Iceman fork) precompilado.

## Construir la imagen

```bash
docker build -t kali-pm3 .
```

## Ejecutar el contenedor

Con acceso al bus USB (para detectar el Proxmark3):

```bash
docker run -it --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    --name kali-pm3 \
    kali-pm3
```

## Dentro del contenedor

```bash
lsusb
proxmark3 /dev/ttyACM0
```

## Requisitos en el host (Windows/WSL2)

Para pasar el Proxmark3 desde Windows a WSL2, usa `usbipd-win`:

```powershell
usbipd list
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```
