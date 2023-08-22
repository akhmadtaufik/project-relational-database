CREATE TABLE body_types (
    body_type_id SERIAL PRIMARY KEY,
    body_type_name VARCHAR(25) UNIQUE NOT NULL
);

CREATE TABLE car_manufactures (
    manufacture_id SERIAL PRIMARY KEY,
    manufacture_name VARCHAR(25) UNIQUE NOT NULL
);

CREATE TABLE car_models (
    model_id SERIAL PRIMARY KEY,
    manufacture_id INT NOT NULL,
    model_name VARCHAR(255) UNIQUE NOT null,
    CONSTRAINT fk_car_model_manufacture
    	FOREIGN KEY(manufacture_id)
    	REFERENCES car_manufactures(manufacture_id)
);

CREATE TABLE cars (
    car_id SERIAL PRIMARY KEY,
    manufacture_id INT NOT NULL,
    model_id INT NOT NULL,
    body_type_id INT NOT NULL,
    year_manufactured INT NOT NULL CHECK (year_manufactured > 1990 AND year_manufactured <= EXTRACT(YEAR FROM CURRENT_DATE)),
    engine_capacity DECIMAL NOT NULL CHECK (engine_capacity > 0),
    passenger_capacity INT NOT NULL CHECK (passenger_capacity > 0),
    transmission_type VARCHAR(10) NOT NULL CHECK (transmission_type IN ('manual', 'automatic')),
    fuel_type VARCHAR(10) NOT NULL CHECK (fuel_type IN ('gasoline', 'diesel', 'hybrid', 'electric')),
    drive_system VARCHAR(5) NOT NULL CHECK (drive_system IN ('FWD', 'RWD', 'AWD')),
    odometer DECIMAL,
    additional_details TEXT,
    CONSTRAINT fk_car_manufacture
    	FOREIGN KEY(manufacture_id)
    	REFERENCES car_manufactures(manufacture_id),
    CONSTRAINT fk_car_model
    	FOREIGN KEY(model_id)
    	REFERENCES car_models(model_id),
    CONSTRAINT fk_car_body_type
    	FOREIGN KEY(body_type_id)
    	REFERENCES body_types(body_type_id)
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL,
    latitude DECIMAL NOT NULL,
    longitude DECIMAL NOT NULL
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    contact VARCHAR(20) UNIQUE NOT NULL,
    location_id INT NOT NULL,
    CONSTRAINT fk_user_location
    	FOREIGN KEY(location_id)
    	REFERENCES locations(location_id)
    
);

CREATE TABLE advertisements (
    ad_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    price DECIMAL NOT NULL,
    description TEXT NOT NULL,
    car_id INT REFERENCES Cars(car_id),
    date_posted DATE NOT NULL,
    image BYTEA,
    CONSTRAINT fk_ads_user
    	FOREIGN KEY(user_id)
    	REFERENCES Users(user_id)
);

CREATE TABLE bids (
    bid_id SERIAL PRIMARY KEY,
    ad_id INT NOT NULL,
    user_id INT NOT NULL,
    bid_price DECIMAL NOT NULL CHECK (bid_price > 0),
    bid_status VARCHAR(255) NOT NULL CHECK (bid_status IN ('approved', 'rejected')),
    datetime_bid TIMESTAMP NOT NULL,
    CONSTRAINT fk_bid_ads
    	FOREIGN KEY(ad_id)
    	REFERENCES advertisements(ad_id),
    CONSTRAINT fk_bid_user
    	FOREIGN KEY(user_id)
    	REFERENCES Users(user_id)
);