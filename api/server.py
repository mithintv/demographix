"""Server for demographix app."""

from flask import (Flask, render_template, request,
                   flash, jsonify, session, redirect)
from model import connect_to_db, db

app = Flask(__name__)
app.secret_key = "demographix_dev"


@app.route('/')
def homepage():
    """View homepage."""

    return render_template('page.html')


if __name__ == "__main__":
    connect_to_db(app)
    app.run(host="0.0.0.0", debug=True)
