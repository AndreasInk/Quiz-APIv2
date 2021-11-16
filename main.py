import os
import sentencepiece
from flask import Flask, request
from pipelines import pipeline 
app = Flask(__name__)

@app.route("/Quizify")
def Quizify():
    nlp = pipeline("question-generation")
    text = request.args.get('text')
    
    return str(nlp(text))

@app.route("/")
def hello_world():
    name = os.environ.get("NAME", "World")
    return "Hello {}!".format(name)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))