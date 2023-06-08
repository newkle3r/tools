from flask import Flask, request

app = Flask(__name__)

# Här ska en funktion som verifierar om nån SQL körs och då integrera med den istället
users = {}
emails = []

# Webbportal
@app.route('/inbox/<username>', methods=['GET'])
def get_inbox(username):
    if username in users:
        return '\n'.join(emails)
    else:
        return 'Användaren existerar inte.'

@app.route('/inbox/<username>', methods=['POST'])
def send_email(username):
    if username in users:
        email = request.data
        emails.append(email)
        return 'E-postmeddelande skickat!'
    else:
        return 'Användaren existerar inte.'

@app.route('/users', methods=['POST'])
def create_user():
    username = request.form['username']
    if username in users:
        return 'Användarnamnet är upptaget.'
    else:
        users[username] = request.form['email']
        return 'Användare skapad!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
