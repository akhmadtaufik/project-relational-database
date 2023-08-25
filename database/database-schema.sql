CREATE TABLE body_types (
    body_type_id VARCHAR(6) PRIMARY KEY,
    body_type_name VARCHAR(25) UNIQUE NOT NULL
);

CREATE TABLE manufactures (
    manufacture_id VARCHAR(4) PRIMARY KEY,
    manufacture_name VARCHAR(25) UNIQUE NOT NULL
);

CREATE TABLE models (
    model_id VARCHAR(6) PRIMARY KEY,
    manufacture_id VARCHAR(4) NOT NULL,
    model_name VARCHAR(100) UNIQUE NOT null,
    CONSTRAINT fk_car_model_manufacture
    	FOREIGN KEY(manufacture_id)
    	REFERENCES manufactures(manufacture_id)
);

CREATE TABLE cars (
    car_id INT PRIMARY KEY,
    manufacture_id VARCHAR(4) NOT NULL,
    model_id VARCHAR(6) NOT NULL,
    body_type_id VARCHAR(6) NOT NULL,
    year_manufactured INT NOT NULL CHECK (year_manufactured > 2000 AND year_manufactured <= EXTRACT(YEAR FROM CURRENT_DATE)),
    engine_capacity DECIMAL NOT NULL CHECK (engine_capacity >= 0 AND engine_capacity < 10),
    passenger_capacity INT NOT NULL CHECK (passenger_capacity > 0 AND passenger_capacity <= 12),
    transmission_type VARCHAR(10) NOT NULL CHECK (transmission_type IN ('manual', 'automatic')),
    fuel_type VARCHAR(10) NOT NULL CHECK (fuel_type IN ('gasoline', 'diesel', 'hybrid', 'electric')),
    drive_system VARCHAR(5) NOT NULL CHECK (drive_system IN ('FWD', 'RWD', 'AWD')),
    odometer INT CHECK(odometer > 0),
    additional_details TEXT,
    CONSTRAINT fk_car_manufacture
    	FOREIGN KEY(manufacture_id)
    	REFERENCES manufactures(manufacture_id),
    CONSTRAINT fk_car_model
    	FOREIGN KEY(model_id)
    	REFERENCES models(model_id),
    CONSTRAINT fk_car_body_type
    	FOREIGN KEY(body_type_id)
    	REFERENCES body_types(body_type_id)
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    city_name VARCHAR(25) NOT NULL,
    location POINT
);

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    email VARCHAR(75) UNIQUE NOT NULL,
    contact VARCHAR(15) NOT NULL,
    location_id INT NOT NULL,
    UNIQUE(first_name, last_name),
    CONSTRAINT fk_user_location
    	FOREIGN KEY(location_id)
    	REFERENCES locations(location_id)

);

CREATE TABLE advertisements (
    ad_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    price DECIMAL NOT NULL,
    description TEXT NOT NULL,
    car_id INT NOT NULL,
    date_posted TIMESTAMP NOT NULL,
    CONSTRAINT fk_ads_user
    	FOREIGN KEY(user_id)
    	REFERENCES users(user_id),
    CONSTRAINT fk_ads_car
    	FOREIGN KEY(car_id)
    	REFERENCES cars(car_id)
);

CREATE TABLE bids (
    bid_id SERIAL PRIMARY KEY,
    ad_id INT NOT NULL,
    user_id INT NOT NULL,
    bid_price DECIMAL NOT NULL CHECK (bid_price > 0),
    bid_status VARCHAR(10) NOT NULL CHECK (bid_status IN ('approved', 'rejected')),
    datetime_bid TIMESTAMP NOT NULL,
    CONSTRAINT fk_bid_ads
    	FOREIGN KEY(ad_id)
    	REFERENCES advertisements(ad_id),
    CONSTRAINT fk_bid_user
    	FOREIGN KEY(user_id)
    	REFERENCES users(user_id)
);