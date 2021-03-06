#!/bin/bash
#
# qemu/patch.sh -- Apply the available qemu patchs
#

BOARD=$1
QEMU=$2
QEMU_SRC=$3
QEMU_OUTPUT=$4

TOP_DIR=$(cd $(dirname $0)/../../ && pwd)

QEMU_BASE=${QEMU%.*}

QPD_BOARD_BASE=${TOP_DIR}/boards/${BOARD}/patch/qemu/${QEMU_BASE}/
QPD_BOARD=${TOP_DIR}/boards/${BOARD}/patch/qemu/${QEMU}/

QPD_BASE=${TOP_DIR}/patch/qemu/${QEMU_BASE}/
QPD=${TOP_DIR}/patch/qemu/${QEMU}/

for d in $QPD_BOARD_BASE $QPD_BOARD $QPD_BASE $QPD
do
    echo $d
    [ ! -d $d ] && continue

    for p in `ls $d`
    do
        # Ignore some buggy patch via renaming it with suffix .ignore
        echo $p | grep -q .ignore$
        [ $? -eq 0 ] && continue

        [ -f "$d/$p" ] && patch -r- -N -l -d ${QEMU_SRC} -p1 < $d/$p
    done
done
