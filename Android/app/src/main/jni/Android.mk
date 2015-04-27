LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

#opencv
#change this to your Android OpenCV root folder
OPENCVROOT := ~/Downloads/OpenCV-2.4.10-android-sdk
#OPENCVROOT := C:/ocvAndroid
OPENCV_INSTALL_MODULES := on
OPENCV_CAMERA_MODULES := off
OPENCV_LIB_TYPE := STATIC
include ${OPENCVROOT}/sdk/native/jni/OpenCV.mk

LOCAL_SRC_FILES := detector.cpp   \
                   identified.cpp \
                   img_helper.cpp \
                   detect_silene.cpp
LOCAL_LDLIBS += -llog
LOCAL_MODULE := detect_silene
LOCAL_C_INCLUDES := includes

include $(BUILD_SHARED_LIBRARY)

