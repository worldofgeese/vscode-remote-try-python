from flask import Flask
app = Flask(__name__)

app.config['DEBUG'] = True

@app.route("/")
def hello_world():
    return "Hello, World!"

if __name__ == "__main__":
    # use 0.0.0.0 to make our application externally accessible (from outside the container)
    app.run(host='0.0.0.0')