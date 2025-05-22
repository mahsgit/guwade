# import tensorflow as tf

# tflite_path = "C:/Users/MS/Desktop/final_year/guawade/assets/emotion_model.tflite"

# try:
#     interpreter = tf.lite.Interpreter(model_path=tflite_path)
#     interpreter.allocate_tensors()
#     input_details = interpreter.get_input_details()
#     output_details = interpreter.get_output_details()
#     print("Model loaded successfully!")
#     print("Input details:", input_details)
#     print("Output details:", output_details)
# except Exception as e:
#     print("Error loading model:", e)