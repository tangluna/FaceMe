# Tests identify.py by repeatedly pulling frames from camera and returning the person in each frame

import face_recognition
import identify
import cv2

# Get a reference to webcam #0 (the default one)
video_capture = cv2.VideoCapture(0)

# Creates mapping of faces to names.
obama_image = face_recognition.face_encodings((face_recognition.load_image_file("obama.jpg")))[0]
biden_image = face_recognition.face_encodings((face_recognition.load_image_file("biden.jpg")))[0]
john_image = face_recognition.face_encodings((face_recognition.load_image_file("john_ref.jpg")))[0]
luna_image = face_recognition.face_encodings((face_recognition.load_image_file("luna_ref.jpg")))[0]
soop_image = face_recognition.face_encodings((face_recognition.load_image_file("soop_ref.jpg")))[0]
deep_image = face_recognition.face_encodings((face_recognition.load_image_file("deep_ref.jpg")))[0]
fatema_image = face_recognition.face_encodings((face_recognition.load_image_file("fatema_ref.jpg")))[0]
rumaisa_image = face_recognition.face_encodings((face_recognition.load_image_file("rumaisa_ref.jpg")))[0]

friend_map = [
    [obama_image, "Barack Obama"],
    [biden_image, "Joe Biden"],
    [john_image, "John"],
    [luna_image, "Tarang"],
    [soop_image, "Supriya"],
    [deep_image, "Deepta"],
    [fatema_image, "Fatema"],
    [rumaisa_image, "Rumaisa"]
]

# while True:
#     # Print out who's face is biggest for each frame
#     ret, frame = video_capture.read()
#     print(identify.who_is_this(friend_map, frame))
