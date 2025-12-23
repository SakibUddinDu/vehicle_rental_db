-- USERS TABLE
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('admin', 'customer')) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- VEHICLES TABLE
CREATE TABLE vehicles (
    vehicle_id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) CHECK (type IN ('car', 'bike', 'truck')) NOT NULL,
    model INT,
    registration_number VARCHAR(100) UNIQUE NOT NULL,
    rental_price INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('available', 'rented', 'maintenance')) NOT NULL
);

-- BOOKINGS TABLE
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(user_id),
    vehicle_id UUID REFERENCES vehicles(vehicle_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')) NOT NULL
);

-- QUERY 1: INNER JOIN
SELECT
    u.name AS customer_name,
    v.name AS vehicle_name
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN vehicles v ON b.vehicle_id = v.vehicle_id;

-- QUERY 2: NOT EXISTS
SELECT *
FROM vehicles v
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.vehicle_id = v.vehicle_id
);

-- QUERY 3: WHERE
SELECT *
FROM vehicles
WHERE type = 'car'
AND status = 'available';


-- QUERY 4: GROUP BY & HAVING
SELECT
    v.vehicle_id,
    v.name,
    COUNT(b.booking_id) AS total_bookings
FROM vehicles v
JOIN bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(b.booking_id) > 2;


