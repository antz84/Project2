CREATE DATABASE dearsanta;

\c dearsanta

CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  password_digest VARCHAR(400) NOT NULL,
  age INTEGER,
  location VARCHAR(100)
);

CREATE TABLE items(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price INTEGER,
  pic VARCHAR(1000),
  user_id INTEGER
);
