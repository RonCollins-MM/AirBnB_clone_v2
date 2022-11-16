#!/usr/bin/python3
"""
Simple Flask web app, localhost port:5000
"""

from flask import Flask
app = Flask(__name__)


@app.route('/', strict_slashes=False)
def index():
    """Prints Hello HBNB!"""
    return 'Hello HBNB!'


@app.route('/hbnb', strict_slashes=False)
def hbnb():
    """Prints HBNB"""
    return 'HBNB'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
