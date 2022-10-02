import face_recognition
import numpy as np

def who_is_this(mapping, identify_this):

    # Load in provided mapping and learn to recognize
    encodings = []
    names = []
 
    for person in mapping:
        encodings.append(person[0])
        names.append(person[1])
        
    # find face in passed in image
    face_locations = face_recognition.face_locations(identify_this)
    face_encodings = face_recognition.face_encodings(identify_this, face_locations)

    name = "Unknown"

    if face_encodings:
        # only use the face that is the most prominent (closest/biggest)
        closest_face = face_encodings[0]

        match = face_recognition.compare_faces(encodings, closest_face)

        # Use the known face with the smallest distance to the new face
        face_distances = face_recognition.face_distance(encodings, closest_face)
        best_match_index = np.argmin(face_distances)
        if match[best_match_index]:
            name = names[best_match_index]
    # return recognized name
    return name

