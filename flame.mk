$(call inherit-product, device/qcom/msm8610/msm8610.mk)

TARGET_GCC_VERSION_EXP := 4.8
TARGET_GLOBAL_CPPFLAGS += -Wno-unused-parameter -Wno-sizeof-pointer-memaccess
COMMON_GLOBAL_CFLAGS += -Wno-unused-parameter

PRODUCT_COPY_FILES := \
    device/qcom/msm8610/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msm8610/media/media_codecs_8610.xml:system/etc/media_codecs.xml \
    device/qcom/msm8610/media/media_profiles_8610.xml:system/etc/media_profiles.xml \
    device/qcom/msm8610/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat \
    device/qcom/msm8610/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8610/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin \
    device/t2m/flame/nfc/libnfc-brcm.conf:system/etc/libnfc-brcm.conf \
    device/t2m/flame/nfc/libnfc-nxp.conf:system/etc/libnfc-nxp.conf \
    system/bluetooth/data/main.conf:system/etc/bluetooth/main.conf \
    system/bluetooth/data/input.conf:system/etc/bluetooth/input.conf \
    system/bluetooth/data/blacklist.conf:system/etc/bluetooth/blacklist.conf \
    system/bluetooth/data/network.conf:system/etc/bluetooth/network.conf \
    system/bluetooth/data/audio.conf:system/etc/bluetooth/audio.conf \
    system/bluetooth/data/auto_pairing.conf:system/etc/bluetooth/auto_pairing.conf \
    device/t2m/flame/fstab.qcom:root/fstab.qcom \
    device/t2m/flame/init.target.rc:root/init.target.rc \

TARGET_DEVICE_BLOBS := vendor/t2m/flame/flame-vendor-blobs.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
$(call inherit-product-if-exists, $(TARGET_DEVICE_BLOBS))

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
  libaudioroute \
  libnfc-pn547 \
  librecovery

GAIA_DEV_PIXELS_PER_PX := 1.5
BOOTANIMATION_ASSET_SIZE := qHD

PRODUCT_NAME := flame
PRODUCT_DEVICE := flame
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := t2m
PRODUCT_MODEL := flame
