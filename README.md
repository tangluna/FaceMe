# FaceMe

HackMIT 2022! 

Video demo here: https://www.youtube.com/watch?v=JSGzNlfhmo4

Slides here: https://docs.google.com/presentation/d/1dSdeSKypn4yZ2iMHKZ9NpZEi64CvbaMAkBb0hX8scmc/edit?usp=sharing

Our project on Spectacle: https://spectacle.hackmit.org/project/84

Both as a diagnosed condition (prosopagnosia) and just as a day-to-day issue, many people can struggle with putting names to faces that they have seen before. Our app, coded using Flutter to be cross-platform, uses face recognition technology along with OpenCV to recognize people in real time.

Users can log in to our app and snap a frame of a camera feed containing the face of the person they cannot recognize. The app sends a request to a server hosting our Python face recognition code; the server then processes the image in the request, detects the contained face, and compares it against the "known" faces that are already entered into the database. If the requested face is identified, the server returns the associated name (or "Unknown") to the app, which then displays it on the screen.

In the backend, we use an image encoded function trained using triple-loss. The server compares the encodings of faces in the user DB to the requested face to determine if there is a match to return.
