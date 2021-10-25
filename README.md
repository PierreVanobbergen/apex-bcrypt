# apex-bcrypt

Bcrypt implementation in the Salesforce Apex language, based on the JavaScript library [bcrypt.js](https://github.com/dcodeIO/bcrypt.js)

## Security considerations

Besides incorporating a salt to protect against rainbow table attacks, bcrypt is an adaptive function: over time, the
iteration count can be increased to make it slower, so it remains resistant to brute-force search attacks even with
increasing computation power. ([see](http://en.wikipedia.org/wiki/Bcrypt))

The maximum input length is 72 bytes (note that UTF8 encoded characters use up to 4 bytes) and the length of generated
hashes is 60 characters.

## Usage

To hash a password:

```java
String salt = Bcrypt.genSalt(10);
String hash = Bcrypt.hash('mypassword', salt);
// Store hash in Salesforce.
```

To check a password:

```java
// Load hash from Salesforce.
Bcrypt.compare('mypassword', hash); // true
Bcrypt.compare('not_mypassword', hash); // false
```

Auto-gen a salt and hash:

```java
String hash = Bcrypt.hash('mypassword');
// OR to specify the number of rounds
String hash = Bcrypt.hash('mypassword', 8);
```
