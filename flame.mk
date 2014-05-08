$(call inherit-product, device/qcom/msm8610/msm8610.mk)

PRODUCT_COPY_FILES := \
    device/qcom/msm8610/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msm8610/media/media_codecs_8610.xml:system/etc/media_codecs.xml \
    device/qcom/msm8610/media/media_profiles_8610.xml:system/etc/media_profiles.xml

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
$(call inherit-product-if-exists, vendor/t2m/flame/flame-vendor-blobs.mk)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.moz.devinputjack=1 \
  ro.moz.nfc.enabled=true \
  ro.moz.ril.emergency_by_default=true \
  org.bluez.device.conn.type=array \

PRODUCT_PACKAGES += \
  nfcd \
  librecovery

PRODUCT_NAME := flame
PRODUCT_DEVICE := flame
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := t2m
PRODUCT_MODEL := flame
