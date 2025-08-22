# Proyecto 3 – Alerta de espacio en disco
🎯 Objetivo
Detectar cuando un filesystem supera un umbral de uso y dejar evidencia en un log.

📌 Requisitos mínimos

El script recibe un umbral (%) como primer parámetro (./check_disk.sh 80).

Si falta el parámetro o no es válido → mostrar uso y salir con código 1.

Recorre los sistemas de archivos montados, ignorando pseudo-FS (tmpfs, devtmpfs, etc.).

Si algún uso ≥ umbral:

Registrar en /var/log/disk_alerts.log con: fecha | mountpoint | %uso | filesystem.

Salir con código 2.

Si todo está bajo el umbral:

Registrar en el log una línea “OK” (con fecha y máximo % detectado).

Salir con código 0.
