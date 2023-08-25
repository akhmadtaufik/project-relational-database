-- Define table for different types of car body styles
CREATE TABLE body_types (
    body_type_id VARCHAR(6) PRIMARY KEY, -- Unique ID for each body type
    body_type_name VARCHAR(25) UNIQUE NOT NULL -- Name of the body type, cannot be NULL
);

-- Define table for car manufacturers
CREATE TABLE manufactures (
    manufacture_id VARCHAR(4) PRIMARY KEY, -- Unique ID for each manufacturer
    manufacture_name VARCHAR(25) UNIQUE NOT NULL -- Name of the manufacturer, cannot be NULL
);

-- Define table for car models, linking to manufacturers
CREATE TABLE models (
    model_id VARCHAR(6) PRIMARY KEY, -- Unique ID for each car model
    manufacture_id VARCHAR(4) NOT NULL, -- Manufacturer ID associated with the model
    model_name VARCHAR(100) UNIQUE NOT NULL, -- Name of the car model, cannot be NULL
    CONSTRAINT fk_car_model_manufacture -- Foreign key constraint linking model to manufacturer
        FOREIGN KEY(manufacture_id)
        REFERENCES manufactures(manufacture_id)
);

-- Define table for cars, linking to manufacturers, models, and body types
CREATE TABLE cars (
    car_id INT PRIMARY KEY, -- Unique ID for each car
    manufacture_id VARCHAR(4) NOT NULL, -- Manufacturer ID associated with the car
    model_id VARCHAR(6) NOT NULL, -- Model ID associated with the car
    body_type_id VARCHAR(6) NOT NULL, -- Body type ID associated with the car
    year_manufactured INT NOT NULL CHECK (year_manufactured > 2000 AND year_manufactured <= EXTRACT(YEAR FROM CURRENT_DATE)), -- Year of manufacture within valid range
    engine_capacity DECIMAL NOT NULL CHECK (engine_capacity >= 0 AND engine_capacity < 10), -- Valid engine capacity range
    passenger_capacity INT NOT NULL CHECK (passenger_capacity > 0 AND passenger_capacity <= 12), -- Valid passenger capacity range
    transmission_type VARCHAR(10) NOT NULL CHECK (transmission_type IN ('manual', 'automatic')), -- Valid transmission types
    fuel_type VARCHAR(10) NOT NULL CHECK (fuel_type IN ('gasoline', 'diesel', 'hybrid', 'electric')), -- Valid fuel types
    drive_system VARCHAR(5) NOT NULL CHECK (drive_system IN ('FWD', 'RWD', 'AWD')), -- Valid drive systems
    odometer INT CHECK(odometer > 0), -- Odometer reading (if available)
    additional_details TEXT, -- Additional details about the car
    CONSTRAINT fk_car_manufacture -- Foreign key constraint linking car to manufacturer
        FOREIGN KEY(manufacture_id)
        REFERENCES manufactures(manufacture_id),
    CONSTRAINT fk_car_model -- Foreign key constraint linking car to model
        FOREIGN KEY(model_id)
        REFERENCES models(model_id),
    CONSTRAINT fk_car_body_type -- Foreign key constraint linking car to body type
        FOREIGN KEY(body_type_id)
        REFERENCES body_types(body_type_id)
);

-- Define table for geographical locations
CREATE TABLE locations (
    location_id INT PRIMARY KEY, -- Unique ID for each location
    city_name VARCHAR(25) NOT NULL, -- Name of the city, cannot be NULL
    location POINT -- Geographic coordinates of the location
);

-- Define table for users
CREATE TABLE users (
    user_id INT PRIMARY KEY, -- Unique ID for each user
    first_name VARCHAR(25) NOT NULL, -- First name of the user, cannot be NULL
    last_name VARCHAR(25) NOT NULL, -- Last name of the user, cannot be NULL
    email VARCHAR(75) UNIQUE NOT NULL, -- Unique email address for the user, cannot be NULL
    contact VARCHAR(15) NOT NULL, -- Contact information for the user, cannot be NULL
    location_id INT NOT NULL, -- Location ID associated with the user
    UNIQUE(first_name, last_name), -- Combination of first and last names must be unique
    CONSTRAINT fk_user_location -- Foreign key constraint linking user to location
        FOREIGN KEY(location_id)
        REFERENCES locations(location_id)
);

-- Define table for advertisements
CREATE TABLE advertisements (
    ad_id INT PRIMARY KEY, -- Unique ID for each advertisement
    user_id INT NOT NULL, -- User ID associated with the advertisement
    title VARCHAR(100) NOT NULL, -- Title of the advertisement, cannot be NULL
    price DECIMAL NOT NULL, -- Price of the advertised item, cannot be NULL
    description TEXT NOT NULL, -- Description of the advertisement, cannot be NULL
    car_id INT NOT NULL, -- Car ID associated with the advertisement
    date_posted TIMESTAMP NOT NULL, -- Date and time when the ad was posted, cannot be NULL
    CONSTRAINT fk_ads_user -- Foreign key constraint linking ad to user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id),
    CONSTRAINT fk_ads_car -- Foreign key constraint linking ad to car
        FOREIGN KEY(car_id)
        REFERENCES cars(car_id)
);

-- Define table for bids on advertisements
CREATE TABLE bids (
    bid_id SERIAL PRIMARY KEY, -- Auto-incrementing ID for each bid
    ad_id INT NOT NULL, -- Advertisement ID associated with the bid
    user_id INT NOT NULL, -- User ID associated with the bid
    bid_price DECIMAL NOT NULL CHECK (bid_price > 0), -- Bid price must be positive
    bid_status VARCHAR(10) NOT NULL CHECK (bid_status IN ('approved', 'rejected')), -- Valid bid statuses
    datetime_bid TIMESTAMP NOT NULL, -- Date and time of the bid, cannot be NULL
    CONSTRAINT fk_bid_ads -- Foreign key constraint linking bid to advertisement
        FOREIGN KEY(ad_id)
        REFERENCES advertisements(ad_id),
    CONSTRAINT fk_bid_user -- Foreign key constraint linking bid to user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
);
