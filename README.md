# tools
Some of my tools. Makes life easier. And faster.

# pyMailer

# pyMailer skapar en enkel Flask-webbapplikation som har två API-rutter: /inbox/<username> och /users. /inbox/<username> accepterar GET och POST-anrop för att läsa och skicka e-postmeddelanden. /users accepterar POST-anrop för att skapa en ny användare med användarnamn och e-postadress.
# För att nå mailservern via http://localhost:5000 och använda API-rutterna för att skicka och ta emot e-postmeddelanden samt skapa nya användare.

1. docker build -t mailserver .
2. docker run -p 5000:5000 mailserver