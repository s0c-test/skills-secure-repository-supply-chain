import os
import sqlite3
import subprocess
from flask import Flask, request, render_template_string

app = Flask(__name__)

# Using f-strings to build queries allows an attacker to bypass authentication.
@app.route('/login')
def login():
    username = request.args.get('username')
    db = sqlite3.connect('users.db')
    cursor = db.cursor()
    # Snyk will flag the line below:
    query = f"SELECT * FROM users WHERE username = '{username}'"
    cursor.execute(query)
    return "Logged in"

# Passing unsanitized input to a shell command allows arbitrary code execution.
@app.route('/ping')
def ping():
    hostname = request.args.get('hostname')
    # Snyk will flag 'shell=True' combined with the variable:
    command = f"ping -c 1 {hostname}"
    output = subprocess.check_output(command, shell=True)
    return output

# Directly rendering user input in a template string.
@app.route('/greet')
def greet():
    name = request.args.get('name', 'Guest')
    # An attacker could provide {{config}} to see secret keys
    template = f"<h1>Hello {name}!</h1>"
    return render_template_string(template)

# Snyk will detect this as a "High" severity credential leak.
API_KEY = "sk_live_51MzXj0L9uWqR1v7p8N2m4Q6k8L"

if __name__ == '__main__':
    app.run(debug=True)