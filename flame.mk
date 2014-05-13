$(call inherit-product, device/qcom/msm8610/msm8610.mk)

PRODUCT_COPY_FILES := \
    device/qcom/msm8610/audio_policy.conf:system/etc/audio_policy.conf \
    device/t2m/flame/nfc/libnfc-brcm.conf:system/etc/libnfc-brcm.conf \
    device/t2m/flame/nfc/libnfc-nxp.conf:system/etc/libnfc-nxp.conf

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
$(call inherit-product-if-exists, vendor/t2m/flame/flame-vendor-blobs.mk)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.moz.devinputjack=1 \
  ro.moz.nfc.enabled=true \
  ro.moz.ril.emergency_by_default=true \
  org.bluez.device.conn.type=array \

PRODUCT_PACKAGES += \
  nfcd

PRODUCT_NAME := flame
PRODUCT_DEVICE := flame
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := t2m
PRODUCT_MODEL := flame
