import base64
from flask import Flask, jsonify, request
import json
from withFriends import friend_map
from identify import who_is_this
import numpy as np
from PIL import Image

app = Flask(__name__)
response = ""

@app.route('/', methods = ["GET", "POST"])
def nameRoute():
    global response
    if (request.method == 'POST'): #code in place to return user name
        request_data = request.data
        request_data = json.loads(request_data, cls=json.JSONDecoder)
        request_data
        if request_data == None:
            response = f'No Image Received'
        else:
            bytes_ = base64.b64decode(request_data)
            with open("yay.png", "wb") as f:
                f.write(bytes_)
            image = Image.open("yay.png")
            image_array = np.array(image)
            print(image_array.dtype)
            response = f'{who_is_this(friend_map, image_array)}'

        return response
    else:
        return jsonify({'label': response})

if __name__ == '__main__':
    app.run()