#!/bin/bash

# el script recibe un umbral (%) como primer parametro
# si falta el parametro o no es valido -> mostrar uso y exit 1
# recorrer fs montados , ignorando pseudo fs
# si algun fs supera > el umbral
        # registrar en /var/log/disk_alerts.log en formato
        # fecha | mountpoint | %uso | filesystem
        # exit 2
# si todo esta bajo < el umbral
        # registrar en el log /var/log/disk_alerts.log en formato
        # fecha | mountpoint | %max_use | filesystem
        # exit 0

umbral=$1
logdir=/var/log/disk_alerts.log
exit_code=0

if [ -z "$umbral" ]; then
        echo "Debes ingresar un valor de umbral"
        exit 2
fi


if [[ "$umbral" =~ ^-?[0-9]+$ ]]; then
        if [ "$umbral" -gt 0 ] && [ "$umbral" -lt 100 ]; then
                dffs=$(df -P -T| grep -v -E 'tmpfs|devtmpfs|proc|sysfs|debugfs|overlay|squashfs|9p|rootfs'|awk '$6 !~ "^/mnt/" && $6 !~ "^/usr/lib/wsl" && $6 != "/init" && $7 !~ "^/snap/"'|awk 'NR > 1 {print $1 ":" $6 ":" $7}'|tr -d "%")
                for line in $dffs; do
                        fs=$(echo $line | cut -d: -f1)
                        use=$(echo $line | cut -d: -f2)
                        mnt=$(echo $line | cut -d: -f3)
                        frmdate=$(date '+%F %T')

                        if [ "$use" -le "$umbral" ]; then
                                echo "$frmdate | $mnt | $use% | $fs | ESTADO: OK"
                        else
                                echo "$frmdate | $mnt | $use% | $fs | ESTADO: ALERTADO"
                        fi
                done
        else
                echo "Debes ingresar un valor entre 0 y 100"
                exit 2
        fi
else
        echo "Debes ingresar un valor número entero"
        exit 2
fi
