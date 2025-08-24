# Proyecto 3 – Monitoreo de Uso de Disco

## 🎯 Objetivo
Crear un script que verifique el uso de espacio en disco de los filesystems montados en el sistema, ignorando pseudo-filesystems y particiones especiales, y que registre alertas cuando se supere un umbral definido.

## 📌 Requisitos mínimos
- El script debe recibir **un parámetro**:
  1) Umbral de uso de disco en porcentaje (%).
- Validar que el parámetro esté presente, sea numérico y se encuentre en el rango 0–100.
- Recorrer todos los filesystems montados, ignorando pseudo FS (`tmpfs`, `proc`, `sysfs`, `debugfs`, `snap`, etc.).
- Si algún FS supera el umbral, registrar en `/var/log/disk_alerts.log` una línea con:
  `fecha | mountpoint | %uso | filesystem | ESTADO: ALERTADO`
- Si todos los FS están por debajo del umbral, registrar en el log una línea resumen con el mayor uso encontrado:
  `fecha | mountpoint | %max_use | filesystem | ESTADO: OK`
- Código de salida:
  - `0` → todos los filesystems por debajo del umbral.
  - `2` → al menos un filesystem supera el umbral.

## ✨ Extra (opcional)
- Mostrar en la salida de terminal las últimas líneas registradas en el log para facilitar la revisión rápida.
- Permitir definir múltiples umbrales (por ejemplo: warning y critical).
- Enviar notificaciones externas (correo, Telegram, etc.) cuando se detecten alertas.

## 🚀 Entregables
- Script funcional: `check_disk.sh`.
- Ejemplos de ejecución:
  - Umbral alto (todos OK).
  - Umbral bajo (al menos un FS ALERTADO).
- Archivo de log: `/var/log/disk_alerts.log` con registros de prueba.
