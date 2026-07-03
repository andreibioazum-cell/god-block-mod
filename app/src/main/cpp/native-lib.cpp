#include <jni.h>
#include <string>
#include <Eigen/Dense>

using namespace Eigen;

extern "C" JNIEXPORT jstring JNICALL
Java_com_tasksai_neural_MainActivity_processWithAI(JNIEnv* env, jobject, jfloat val) {
    // Реальный матричный расчет нейроном
    MatrixXf weights = MatrixXf::Random(1, 1);
    MatrixXf input(1, 1);
    input(0, 0) = val;
    MatrixXf output = input * weights;
    
    std::string res = "AI Output: " + std::to_string(output(0,0));
    return env->NewStringUTF(res.c_str());
}
