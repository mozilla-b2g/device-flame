$(call inherit-product, device/qcom/msm8610/msm8610.mk)

PRODUCT_COPY_FILES := \
    device/qcom/msm8610/audio_policy.conf:system/etc/audio_policy.conf

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
$(call inherit-product-if-exists, vendor/t2m/flame/flame-vendor-blobs.mk)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.moz.devinputjack=1 \
  ro.moz.ril.0.network_types=gsm,wcdma \
  ro.moz.ril.1.network_types=gsm \
  ro.moz.ril.emergency_by_default=true \
  ro.moz.ril.numclients=2 \
  org.bluez.device.conn.type=array \

PRODUCT_NAME := flame
PRODUCT_DEVICE := flame
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := t2m
PRODUCT_MODEL := flame
