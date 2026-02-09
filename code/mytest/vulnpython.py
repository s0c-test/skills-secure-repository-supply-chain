import sqlite3
import subprocess
from flask import Flask, request

app = Flask(__name__)

@app.route('/scan-network')
def scan():
    # VULNERABILITY: OS Command Injection
    # User can input: "google.com; rm -rf /"
    ip_address = request.args.get('ip')
    output = subprocess.check_output(f"ping -c 1 {ip_address}", shell=True)
    return output

@app.route('/login')
def login():
    # VULNERABILITY: SQL Injection
    # User can input: "' OR '1'='1"
    username = request.args.get('username')
    db = sqlite3.connect('users.db')
    cursor = db.cursor()
    query = f"SELECT * FROM users WHERE username = '{username}'"
    cursor.execute(query)
    return "Logged in"

if __name__ == '__main__':
    app.run()
