#include "com_luminousmossboss_luminous_Detector.h"
#include "detector.h"
#include "img_helper.h"
#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <android/log.h>

#define byte uint8_t


JNIEXPORT bool JNICALL Java_com_luminousmossboss_luminous_SileneDetector_isSilene
    (JNIEnv * env, jobject obj, jstring flower_xml, jstring vocab_xml, jstring silene_xml, jint height, jint width, jbyteArray img_array)
{
    // create c-style strings from jstring inputs
    const char *flower_str = env->GetStringUTFChars(flower_xml, JNI_FALSE);
    const char *vocab_str = env->GetStringUTFChars(vocab_xml, JNI_FALSE);
    const char *silene_str = env->GetStringUTFChars(silene_xml, JNI_FALSE);
    if (NULL == flower_str || NULL == vocab_str || NULL == silene_str) return NULL;
    // create the detector
    detector sileneDetector (flower_str, vocab_str, silene_str);
    // get the byte array elements from the passed array
    jbyte * img_data = env->GetByteArrayElements(img_array, NULL);
    env->ReleaseByteArrayElements(img_array, img_data, JNI_ABORT);
    // create the mat from the encoded byte array
    Mat mat_image(height, width, CV_8UC3, (unsigned char*)img_data);
    Mat tmp_mat = imdecode(mat_image, 1);
    // detect image
    return sileneDetector.isThisSilene(tmp_mat);
}