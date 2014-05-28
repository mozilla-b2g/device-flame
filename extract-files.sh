#!/bin/bash

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEVICE=flame
MANUFACTURER=t2m

if [[ -z "${ANDROIDFS_DIR}" ]]; then
    ANDROIDFS_DIR=../../../backup-${DEVICE}
fi

if [[ ! -d ../../../backup-${DEVICE}/system ]]; then
    echo Backing up system partition to backup-${DEVICE}
    mkdir -p ../../../backup-${DEVICE} &&
    adb root &&
    sleep 1 &&
    adb wait-for-device &&
    adb pull /system ../../../backup-${DEVICE}/system
fi

if [[ -z "${ANDROIDFS_DIR}" ]]; then
    echo Pulling files from device
    DEVICE_BUILD_ID=`adb shell cat /system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\n\r'`
else
    echo Pulling files from ${ANDROIDFS_DIR}
    DEVICE_BUILD_ID=`cat ${ANDROIDFS_DIR}/system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\n\r'`
fi

BASE_PROPRIETARY_DEVICE_DIR=vendor/$MANUFACTURER/$DEVICE/proprietary
PROPRIETARY_DEVICE_DIR=../../../vendor/$MANUFACTURER/$DEVICE/proprietary

mkdir -p $PROPRIETARY_DEVICE_DIR

for NAME in audio hw wifi etc egl etc/firmware nfc
do
    mkdir -p $PROPRIETARY_DEVICE_DIR/$NAME
done

BLOBS_LIST=../../../vendor/$MANUFACTURER/$DEVICE/$DEVICE-vendor-blobs.mk

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__MANUFACTURER__/$MANUFACTURER/g > ../../../vendor/$MANUFACTURER/$DEVICE/$DEVICE-vendor-blobs.mk
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Prebuilt libraries that are needed to build open-source libraries
PRODUCT_COPY_FILES :=

# All the blobs
PRODUCT_COPY_FILES += \\
EOF

# copy_file
# pull file from the device and adds the file to the list of blobs
#
# $1 = src/dst name
# $2 = directory path on device
# $3 = directory name in $PROPRIETARY_DEVICE_DIR
copy_file()
{
    echo Pulling \"$1\"
    if [[ -z "${ANDROIDFS_DIR}" ]]; then
        NAME=$1
        adb pull /$2/$1 $PROPRIETARY_DEVICE_DIR/$3/$2
    else
        NAME=`basename ${ANDROIDFS_DIR}/$2/$1`
        rm -f $PROPRIETARY_DEVICE_DIR/$3/$NAME
        cp ${ANDROIDFS_DIR}/$2/$NAME $PROPRIETARY_DEVICE_DIR/$3/$NAME
    fi

    if [[ -f $PROPRIETARY_DEVICE_DIR/$3/$NAME ]]; then
        echo   $BASE_PROPRIETARY_DEVICE_DIR/$3/$NAME:$2/$NAME \\ >> $BLOBS_LIST
    else
        echo Failed to pull $1. Giving up.
        exit -1
    fi
}

# copy_files
# pulls a list of files from the device and adds the files to the list of blobs
#
# $1 = list of files
# $2 = directory path on device
# $3 = directory name in $PROPRIETARY_DEVICE_DIR
copy_files()
{
    for NAME in $1
    do
        copy_file "$NAME" "$2" "$3"
    done
}

# copy_files_glob
# pulls a list of files matching a pattern from the device and
# adds the files to the list of blobs
#
# $1 = pattern/glob
# $2 = directory path on device
# $3 = directory name in $PROPRIETARY_DEVICE_DIR
copy_files_glob()
{
    for NAME in "${ANDROIDFS_DIR}/$2/"$1
    do
        copy_file "`basename $NAME`" "$2" "$3"
    done
}

# copy_local_files
# puts files in this directory on the list of blobs to install
#
# $1 = list of files
# $2 = directory path on device
# $3 = local directory path
copy_local_files()
{
    for NAME in $1
    do
        echo Adding \"$NAME\"
        echo device/$MANUFACTURER/$DEVICE/$3/$NAME:$2/$NAME \\ >> $BLOBS_LIST
    done
}

COMMON_LIBS="
	libalsa-intf.so
	libcnefeatureconfig.so
	libgps.utils.so
	libloc_api_v02.so
	libloc_core.so
	libloc_ds_api.so
	libloc_eng.so
	libloc_xtra.so
	libmmcamera_interface.so
	libmmjpeg_interface.so
	libnfc-nci.so
	libqomx_core.so
	"

copy_files "$COMMON_LIBS" "system/lib" ""

copy_files_glob "lib*.so" "system/vendor/lib" ""

COMMON_BINS="
	adsprpcd
	bridgemgrd
	fm_qsoc_patches
	fmconfig
	hci_qcomm_init
	mm-qcamera-daemon
	netmgrd
	port-bridge
	qmiproxy
	qmuxd
	radish
	rmt_storage
	"

copy_files "$COMMON_BINS" "system/bin" ""

COMMON_HW="
	audio_policy.msm8610.so
	audio.primary.msm8610.so
	camera.msm8610.so
	gps.default.so
	lights.msm8610.so
	nfc_nci_pn547.msm8610.so
	sensors.msm8610.so
	"
copy_files "$COMMON_HW" "system/lib/hw" "hw"

COMMON_WLAN="
	WCNSS_cfg.dat
	"
copy_files "$COMMON_WLAN" "system/etc/firmware/wlan/prima" "wifi"

COMMON_ETC="
	gps.conf
	"
copy_files "$COMMON_ETC" "system/etc" "etc"

COMMON_ETC_WIFI="
	WCNSS_qcom_cfg.ini
	"
copy_files "$COMMON_ETC_WIFI" "system/etc/wifi" "wifi"

COMMON_ETC_AUDIO="
	snd_soc_msm_8x10_wcd_skuaa
	"
copy_files "$COMMON_ETC_AUDIO" "system/etc/snd_soc_msm" "audio"

COMMON_AUDIO="
	"
#copy_files "$COMMON_AUDIO" "system/lib" "audio"

COMMON_EGL="
	egl.cfg
	libGLES_android.so
	"
copy_files "$COMMON_EGL" "system/lib/egl" "egl"

COMMON_VENDOR_NFC="
	libpn547_fw.so
	"
copy_files "$COMMON_VENDOR_NFC" "system/vendor/firmware" "nfc"

COMMON_VENDOR_EGL="
	eglsubAndroid.so
	libEGL_adreno.so
	libGLESv1_CM_adreno.so
	libGLESv2_adreno.so
	libq3dtools_adreno.so
	"
copy_files "$COMMON_VENDOR_EGL" "system/vendor/lib/egl" "egl"

COMMON_FIRMWARE="
	a225_pfp.fw
	a225_pm4.fw
	a225p5_pm4.fw
	a300_pfp.fw
	a300_pm4.fw
	a330_pfp.fw
	a330_pm4.fw
	leia_pfp_470.fw
	leia_pm4_470.fw
	"
copy_files "$COMMON_FIRMWARE" "system/etc/firmware" "etc/firmware"

echo $BASE_PROPRIETARY_DEVICE_DIR/libcnefeatureconfig.so:obj/lib/libcnefeatureconfig.so \\ >> $BLOBS_LIST

