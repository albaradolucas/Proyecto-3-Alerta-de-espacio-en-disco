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
max_use=0
max_mnt=""
max_fs=""
frmdate=$(date '+%F %T')


if [ -z "$umbral" ]; then
        echo "Debes ingresar un valor de umbral"
        exit 1
fi


if [[ "$umbral" =~ ^-?[0-9]+$ ]]; then
        if [ "$umbral" -ge 0 ] && [ "$umbral" -le 100 ]; then
                if dffs=$(df -P -T| grep -v -E 'tmpfs|devtmpfs|proc|sysfs|debugfs|overlay|squashfs|9p|rootfs'|awk '$6 !~ "^/mnt/" && $6 !~ "^/usr/lib/wsl" && $6 != "/init" && $7 !~ "^/snap/"'|awk 'NR > 1 {print $1 ":" $6 ":" $7}'|tr -d "%"); then
                        if [ -z "$dffs" ]; then
                                echo "El filtro no muestra filesystems para mostrar"
                                exit 1
                        fi

                        for line in $dffs; do
                                fs=$(echo $line | cut -d: -f1)
                                use=$(echo $line | cut -d: -f2)
                                mnt=$(echo $line | cut -d: -f3)

                                if [ "$use" -le "$umbral" ]; then
                                        if [ "$use" -gt "$max_use" ]; then
                                                max_use=$use
                                                max_mnt=$mnt
                                                max_fs=$fs
                                        fi
                                elif [ "$use" -gt "$umbral" ]; then
                                        if [ "$use" -gt "$max_use" ]; then
                                                max_use=$use
                                                max_mnt=$mnt
                                                max_fs=$fs
                                        fi
                                        echo "$frmdate | $mnt | $use% | $fs | ESTADO: ALERTADO" >> $logdir
                                        exit_code=2
                                fi
                        done

                        if [ "$exit_code" -eq 0 ]; then
                                echo "$frmdate | $max_mnt | $max_use% | $max_fs | ESTADO: OK" >> $logdir
                        fi

                        tail -n 6 $logdir
                        exit $exit_code
                else
                        echo "No hay filesystems para mostrar"
                        exit 1
                fi
        else
                echo "Debes ingresar un valor entre 0 y 100"
                exit 1
        fi
else
        echo "Debes ingresar un valor número entero"
        exit 1
fi
