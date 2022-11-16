#!/usr/bin/python3
"""
Simple Flast web app, localhost port:5000
"""

from flask import Flask
app = Flask(__name__)


@app.route('/', strict_slashes=False)
def index():
    """prints Hello HBNB!"""
    return 'Hello HBNB!'


@app.route('/hbnb', strict_slashes=False)
def hbnb():
    """prints HBNB"""
    return 'HBNB'


@app.route('/c/<text>', strict_slashes=False)
def cisfun(text):
    """
    Display 'C' followed by the value of the `text` variable.
    Underscores are replaced with whitespaces.
    """
    return 'C ' + text.replace('_', ' ')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5000')
