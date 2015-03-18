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
//    const char *image_str = env->GetStringUTFChars(image_path, JNI_FALSE);
    if (NULL == flower_str || NULL == vocab_str || NULL == silene_str) return NULL;
    __android_log_print(ANDROID_LOG_VERBOSE, "JNI", "%s", "before detector load");
    __android_log_print(ANDROID_LOG_VERBOSE, "JNI", "%s", flower_str);
    __android_log_print(ANDROID_LOG_VERBOSE, "JNI", "%s", vocab_str);
    __android_log_print(ANDROID_LOG_VERBOSE, "JNI", "%s", silene_str);
    detector sileneDetector (flower_str, vocab_str, silene_str);
//    detector* sileneDetector = new detector(String(flower_str), String(vocab_str), String(silene_str));
//    jint* _img_array = env->GetIntArrayElements(img_array, 0);
    __android_log_print(ANDROID_LOG_VERBOSE, "JNI", "%d", img_array[512]);
    jbyte * img_data = env->GetByteArrayElements(img_array, NULL);
    __android_log_print(ANDROID_LOG_VERBOSE, "JNI", "%d", img_data[512]);
    Mat mat_image(height, width, CV_8UC4, (unsigned char*)img_data);
    Mat tmp_mat = imdecode(mat_image, 1);
//    ctvColor(tmp_mat, mat_image, CV_RGB2RGBA);
//    Mat reshaped_mat = mat_image.reshape(0, height);
//    Mat mat_image = imdecode(img_data, CV_LOAD_IMAGE_COLOR);
//    Mat image(height, width, CV_8UC4, (unsigned char *)_img_array);
//    bool is_silene = sileneDetector.isThisSilene(reshaped_mat);
//    bool is_silene = sileneDetector.isThisSilene(tmp_mat);
    Mat thumbnail = img_helper::resizeSetWidth(tmp_mat, 200);
    float prediction = sileneDetector.predict(thumbnail);
    if (prediction < 0.967) {
    env->ReleaseByteArrayElements(img_array, img_data, JNI_ABORT);
        return true;}
    Mat pink = sileneDetector.isolatePink(tmp_mat);
    vector<identified> flowers = sileneDetector.findFlowers(pink);
    env->ReleaseByteArrayElements(img_array, img_data, JNI_ABORT);
    return flowers.size() >= 1;
//    return is_silene;
}



// Taken from trashkalmar's anser at http://stackoverflow.com/questions/8322208
void GetJStringContent(JNIEnv *AEnv, jstring AStr, std::string &ARes) {
  if (!AStr) {
    ARes.clear();
    return;
  }

  const char *s = AEnv->GetStringUTFChars(AStr,NULL);
  ARes=s;
  AEnv->ReleaseStringUTFChars(AStr,s);
}