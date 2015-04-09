from ConnectionHandler import ConnectionHandler
import socket
import os
from flask import Flask, request, redirect, url_for, Response
from werkzeug import secure_filename
from flask import send_from_directory
from flask import jsonify
import json

UPLOAD_FOLDER = 'images/'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])
EXAMPLE_IMAGE_FOLDER = 'example_images/'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['EXAMPLE_IMAGE_FOLDER'] = EXAMPLE_IMAGE_FOLDER


# Replace with /upload
@app.route('/')
def Index():
    return('Hello World')

# Remove
@app.route('/<num>')
def AddHundred(num):
    # Connect to the matlab backend.
    blub = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    blub.connect(('localhost', 60000))

    # Send query.
    ch = ConnectionHandler(blub)
    ch.send(num)

    # Display the result.
    json_list = ch.recv()
    print json_list
    return json.dumps(json_list, separators=(',',':'))

#todo fix variable names
@app.route('/androidupload', methods = ['GET', 'POST'])
def Upload():
    if request.method == 'POST':
        print request.headers
        filename = request.headers['Uploaded-File']
        file = request.files[filename]
        if file and allowed_file(filename):
            secure_name = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], secure_name))
            resp = call_backend(secure_name)
            print resp
            return resp

# make nicer
@app.route('/upload', methods=['GET', 'POST'])
def upload_new():
    if request.method == 'POST':
        print request.files
        file = request.files['file']
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            #print filename
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return call_backend(filename)
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form action="" method=post enctype=multipart/form-data>
      <p><input type=file name=file>
         <input type=submit value=Upload>
    </form>
    '''

@app.route('/img/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['EXAMPLE_IMAGE_FOLDER'],
                               filename)

def call_backend(filename):
    # Connect to the matlab backend.
    blub = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    blub.connect(('localhost', 60000))
    # Send query.
    ch = ConnectionHandler(blub)
    ch.send(filename)
    return ch.recv()

def allowed_file(filename):
    return '.' in filename and \
        filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


if __name__ == "__main__":
    app.debug = True
    app.run(host = '0.0.0.0')
