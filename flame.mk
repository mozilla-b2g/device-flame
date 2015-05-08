$(call inherit-product, device/qcom/msm8610/msm8610.mk)

PRODUCT_COPY_FILES := \
    device/qcom/msm8610/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msm8610/media/media_codecs_8610.xml:system/etc/media_codecs.xml \
    device/qcom/msm8610/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat \
    device/qcom/msm8610/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8610/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin \
    device/t2m/flame/nfc/libnfc-brcm.conf:system/etc/libnfc-brcm.conf \
    device/t2m/flame/nfc/libnfc-nxp.conf:system/etc/libnfc-nxp.conf \
    device/t2m/flame/nfc/nfcee_access.xml:system/etc/nfcee_access.xml \
    device/t2m/flame/fstab.qcom:root/fstab.qcom \
    device/t2m/flame/init.target.rc:root/init.target.rc \
    device/t2m/flame/init.qcom.usb.rc:root/init.qcom.usb.rc \
    device/t2m/flame/media_profiles.xml:system/etc/media_profiles.xml \
    device/t2m/flame/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/t2m/flame/volume.cfg:system/etc/volume.cfg \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
$(call inherit-product-if-exists, vendor/t2m/flame/flame-vendor-blobs.mk)

PRODUCT_BOOT_JARS := \

PRODUCT_PROPERTY_OVERRIDES += \
  persist.radio.multisim.config=dsds \
  ro.moz.devinputjack=1 \
  ro.moz.nfc.enabled=true \
  ro.moz.ril.0.network_types=gsm,wcdma \
  ro.moz.ril.1.network_types=gsm \
  ro.moz.ril.emergency_by_default=true \
  ro.moz.ril.numclients=2 \
  ro.moz.ril.subscription_control=true \
  org.bluez.device.conn.type=array \


PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
        persist.sys.usb.config=diag,serial_smd,serial_tty,rmnet_bam,mass_storage

PRODUCT_PACKAGES += \
  nfcd \
  nfc_nci.pn54x.default \
  libaudioroute \
  libnfc-pn547 \
  librecovery \
  bluetooth.default

GAIA_DEV_PIXELS_PER_PX := 1.5

PRODUCT_NAME := flame
PRODUCT_DEVICE := flame
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := t2m
PRODUCT_MODEL := flame
