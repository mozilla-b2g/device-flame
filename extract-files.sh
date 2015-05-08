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

echo Pulling files from ${ANDROIDFS_DIR}

BASE_PROPRIETARY_DEVICE_DIR=vendor/$MANUFACTURER/$DEVICE/proprietary
PROPRIETARY_DEVICE_DIR=../../../vendor/$MANUFACTURER/$DEVICE/proprietary

mkdir -p $PROPRIETARY_DEVICE_DIR

for NAME in audio etc etc/acdbdata/MTP etc/acdbdata/QRD etc/firmware egl hw nfc wifi
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
	libbt-vendor.so
	libcnefeatureconfig.so
	libgps.utils.so
	libloc_api_v02.so
	libloc_core.so
	libloc_ds_api.so
	libloc_eng.so
	libmdmdetect.so
	libmmcamera_interface.so
	libmmjpeg_interface.so
	libqomx_core.so
	libsigchain.so
	libxml2.so
	"

copy_files "$COMMON_LIBS" "system/lib" ""

copy_files_glob "lib*.so" "system/vendor/lib" ""

COMMON_BINS="
	adsprpcd
	audiod
	charger_monitor
	fm_qsoc_patches
	fmconfig
	hci_qcomm_init
	location-mq
	lowi-server
	mm-qcamera-daemon
	mpdecision
	netmgrd
	ptt_socket_app
	qcom-system-daemon
	qmuxd
	qseecomd
	radish
	rfs_access
	rmt_storage
	thermal-engine
	time_daemon
	trace_util
	vold
	xtwifi-client
	xtwifi-inet-agent
	"

copy_files "$COMMON_BINS" "system/bin" ""

COMMON_HW="
	audio.primary.msm8610.so
	camera.msm8610.so
	gps.default.so
	sensors.msm8610.so
	"
copy_files "$COMMON_HW" "system/lib/hw" "hw"

COMMON_ETC="
	lowi.conf
	mixer_paths.xml
	xtwifi.conf
	"
copy_files "$COMMON_ETC" "system/etc" "etc"

COMMON_ETC_ACDBDATA_MTP="
	MTP_Bluetooth_cal.acdb
	MTP_General_cal.acdb
	MTP_Global_cal.acdb
	MTP_Handset_cal.acdb
	MTP_Hdmi_cal.acdb
	MTP_Headset_cal.acdb
	MTP_Speaker_cal.acdb
	"
copy_files "$COMMON_ETC_ACDBDATA_MTP" "system/etc/acdbdata/MTP" "etc/acdbdata/MTP"

COMMON_ETC_ACDBDATA_QRD="
	QRD_Bluetooth_cal.acdb
	QRD_General_cal.acdb
	QRD_Global_cal.acdb
	QRD_Handset_cal.acdb
	QRD_Hdmi_cal.acdb
	QRD_Headset_cal.acdb
	QRD_Speaker_cal.acdb
	"
copy_files "$COMMON_ETC_ACDBDATA_QRD" "system/etc/acdbdata/QRD" "etc/acdbdata/QRD"

COMMON_AUDIO="
	"
#copy_files "$COMMON_AUDIO" "system/lib" "audio"

COMMON_EGL="
	egl.cfg
	"
#copy_files "$COMMON_EGL" "system/lib/egl" "egl"

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

COMMON_VENDOR_HW="
	flp.default.so
        "
copy_files "$COMMON_VENDOR_HW" "system/vendor/lib/hw" "hw"


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

B2G_TIME_BUNDLE="
        chrome.manifest
        timeservice.js
        "
#copy_files "$B2G_TIME_BUNDLE" "system/b2g/distribution/bundles/b2g_time" ""

#echo $BASE_PROPRIETARY_DEVICE_DIR/libcnefeatureconfig.so:obj/lib/libcnefeatureconfig.so \\ >> $BLOBS_LIST

