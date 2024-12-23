create schema fin;

-- 1

CREATE TABLE fin.users(
user_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(50) UNIQUE NOT NULL,
password VARCHAR(20) NOT NULL,
phone VARCHAR(20) NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE user_role AS ENUM('customer', 'admin');

ALTER TABLE fin.users
ADD COLUMN "role" user_role NOT NULL DEFAULT 'customer';

-- 2

CREATE TABLE fin.movies(
movie_id INT PRIMARY KEY,
--
title VARCHAR(50) UNIQUE NOT NULL,
description VARCHAR(50) NULL,
--
duration_minutes INT NOT NULL,
release_date TIMESTAMP NOT NULL,
rating FLOAT CHECK(rating >= 0 and rating <= 10),
poster_url VARCHAR(300) NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE fin.movies
ADD COLUMN genre VARCHAR(30) NOT NULL;

ALTER TABLE fin.movies
ADD COLUMN title  VARCHAR(100) UNIQUE NOT NULL;
ALTER TABLE fin.movies
ADD COLUMN description VARCHAR(100) UNIQUE NOT NULL;

-- 3 

CREATE TABLE fin.cinemas(
cinema_id INT PRIMARY KEY,
name VARCHAR(50) UNIQUE NOT NULL,
location VARCHAR(100) UNIQUE NOT NULL, 
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4 

CREATE TABLE fin.screens(
screen_id INT PRIMARY KEY,
cinema_id INT,
name VARCHAR(50) NOT NULL,
capacity DECIMAL NOT NULL,
FOREIGN KEY (cinema_id) REFERENCES fin.cinemas(cinema_id)
);


-- 5 

CREATE TABLE fin.seats(
seat_id INT PRIMARY KEY,
screen_id INT,
seat_number VARCHAR(5) NOT NULL,
FOREIGN KEY (screen_id) REFERENCES fin.screens(screen_id)
);

CREATE TYPE seat_type AS ENUM('VIP', 'Regular');

ALTER TABLE fin.seats
ADD COLUMN seat_type seat_type;

-- 6 

CREATE TABLE fin.showtimes(
showtime_id INT PRIMARY KEY,
screen_id INT,
movie_id INT,
start_time TIMESTAMP NOT NULL,
end_time TIMESTAMP NOT NULL,
price DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (screen_id) REFERENCES fin.screens(screen_id),
FOREIGN KEY (movie_id) REFERENCES fin.movies(movie_id)
);


-- 7 

CREATE TABLE fin.bookings(
booking_id INT PRIMARY KEY,
user_id INT,
showtime_id INT,
booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
total_price DECIMAL NOT NULL,
FOREIGN KEY (user_id) REFERENCES fin.users(user_id),
FOREIGN KEY (showtime_id) REFERENCES fin.showtimes(showtime_id)
);

CREATE TYPE status_of_books AS ENUM('pending', 'confirmed', 'canceled');

ALTER TABLE fin.bookings
ADD COLUMN status status_of_books DEFAULT 'pending';

-- 8 

CREATE TABLE fin.booking_details(
booking_detail_id INT PRIMARY KEY,
booking_id INT,
seat_id INT,
price DECIMAL NOT NULL,
FOREIGN KEY (booking_id) REFERENCES fin.bookings(booking_id),
FOREIGN KEY (seat_id) REFERENCES fin.seats(seat_id)
);

-- 9 

CREATE TABLE fin.payments(
payment_id INT PRIMARY KEY,
booking_id INT,
payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
amount DECIMAL NOT NULL,
payment_method VARCHAR(20) NOT NULL,
FOREIGN KEY (booking_id) REFERENCES fin.bookings(booking_id)
);

ALTER TABLE fin.payments
ADD COLUMN status VARCHAR(20) DEFAULT 'pending';



INSERT INTO fin.users (user_id, name, email, password, role, phone, created_at) VALUES
(1, 'Alice Smith', 'alice@gmail.com', 'hashed_password1', 'customer', '1234567890', '2024-01-01 10:00:00'),
(2, 'Bob Johnson', 'bob@gmail.com', 'hashed_password2', 'admin', '0987654321', '2024-01-02 11:00:00'),
(3, 'Charlie Brown', 'charlie@hotmail.com', 'hashed_password3', 'customer', '1122334455', '2024-01-03 12:00:00');


INSERT INTO fin.movies (movie_id, title, description, genre, duration_minutes, release_date, rating, poster_url, created_at) VALUES
(1, 'Inception', 'A mind-bending thriller.', 'Sci-Fi', 148, '2010-07-16', 8.8, 'inception_poster.jpg', '2024-01-01 10:00:00'),
(2, 'The Matrix', 'A computer hacker learns about the true nature of reality.', 'Action', 136, '1999-03-31', 8.7, 'matrix_poster.jpg', '2024-01-02 11:00:00'),
(3, 'Titanic', 'A romantic drama on the ill-fated ship.', 'Drama', 195, '1997-12-19', 7.9, 'titanic_poster.jpg', '2024-01-03 12:00:00');

INSERT INTO fin.cinemas (cinema_id, name, location, created_at) VALUES
(1, 'Downtown Cinema', '123 Main Street, City Center', '2024-01-01 10:00:00'),
(2, 'Uptown Theater', '456 Uptown Avenue, Suburbs', '2024-01-02 11:00:00'),
(3, 'Parkside Cineplex', '789 Park Lane, Riverside', '2024-01-03 12:00:00');


INSERT INTO fin.screens (screen_id, cinema_id, name, capacity) VALUES
(1, 1, 'Screen 1', 100),
(2, 1, 'Screen 2', 120),
(3, 2, 'Screen A', 150);


INSERT INTO fin.seats (seat_id, screen_id, seat_number, seat_type) VALUES
(1, 1, 'A1', 'VIP'),
(2, 1, 'A2', 'Regular'),
(3, 2, 'B1', 'Regular');

INSERT INTO fin.showtimes (showtime_id, screen_id, movie_id, start_time, end_time, price) VALUES
(1, 1, 1, '2024-01-10 14:00:00', '2024-01-10 16:30:00', 10.00),
(2, 2, 2, '2024-01-11 18:00:00', '2024-01-11 20:30:00', 12.50),
(3, 3, 3, '2024-01-12 20:00:00', '2024-01-12 23:15:00', 15.00);


INSERT INTO fin.bookings (booking_id, user_id, showtime_id, booking_date, total_price, status) VALUES
(1, 1, 1, '2024-01-05 10:00:00', 10.00, 'confirmed'),
(2, 2, 2, '2024-01-06 11:30:00', 25.00, 'pending'),
(3, 3, 3, '2024-01-07 15:45:00', 15.00, 'canceled');


INSERT INTO fin.booking_details (booking_detail_id, booking_id, seat_id, price) VALUES
(1, 1, 1, 10.00),
(2, 2, 2, 12.50),
(3, 3, 3, 15.00);

INSERT INTO fin.payments (payment_id, booking_id, payment_date, amount, payment_method, status) VALUES
(1, 1, '2024-01-05 10:15:00', 10.00, 'Credit Card', 'completed'),
(2, 2, '2024-01-06 11:45:00', 25.00, 'PayPal', 'completed'),
(3, 3, '2024-01-07 16:00:00', 15.00, 'Cash', 'failed');

-- 1 
SELECT *FROM FIN.USERS
WHERE (user_id < 5) AND ("role" = 'admin' OR "role" = 'customer');

SELECT * FROM FIN.MOVIES
WHERE (rating BETWEEN 7 AND 9) AND (duration_minutes > 90);

SELECT *FROM FIN.BOOKINGS
WHERE total_price < 50 AND status != 'canceled';

SELECT * FROM FIN.PAYMENTS
WHERE amount > 100 OR payment_method = 'Credit Card';

-- 2 

SELECT * FROM FIN.USERS
WHERE email like '%gmail.com';

SELECT * FROM FIN.MOVIES 
WHERE rating >= 8;

SELECT * FROM FIN.BOOKINGS
WHERE user_id = 3;

SELECT * FROM FIN.SHOWTIMES
WHERE movie_id = 2 AND start_time > '2024-01-01 18:00:00';

-- 3 

SELECT DISTINCT genre FROM FIN.MOVIES;

SELECT DISTINCT location FROM fin.cinemas;

SELECT DISTINCT status FROM fin.bookings;

SELECT DISTINCT start_time FROM fin.showtimes;

-- 4

SELECT * FROM fin.users
ORDER BY created_at DESC;

SELECT * FROM fin.movies
ORDER BY release_date ASC;

SELECT * FROM fin.bookings
ORDER BY total_price DESC;

SELECT * FROM fin.payments
ORDER BY payment_date DESC;

-- 5 

SELECT * FROM fin.users
WHERE name LIKE 'A%';

SELECT * FROM fin.movies
WHERE title ILIKE '%The%';

SELECT  * FROM fin.bookings
WHERE booking_date LIKE '2024-%'; -- ?

SELECT * FROM fin.cinemas
WHERE name LIKE '%Theater';

-- 6
 
SELECT user_id AS USER_ID, name AS Full_Name, email AS Email_Addres FROM fin.users;

SELECT title AS movie_title, release_date AS Release_Date, rating AS Viewer_rating FROM f in.movies;

SELECT booking_date AS Booking_Date, status AS Booking_status, total_price AS Amount_Paid FROM fin.bookings;

SELECT start_time AS Show_Start_Time, price AS Ticket_price , screen_id AS Screen_ID FROM fin.showtimes;















