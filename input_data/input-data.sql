-- Copy CSV Tabel body_types
COPY body_types FROM '\input_data\body_types.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel manufactures
COPY manufactures FROM '\input_data\manufactures.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel models
COPY models FROM '\input_data\car_models.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel cars
COPY cars FROM '\input_data\cars.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel locations
COPY locations FROM '\input_data\locations.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel users
COPY users FROM '\input_data\user.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel advertisements
COPY advertisements FROM '\input_data\ads.csv' DELIMITER ',' CSV HEADER;

-- Copy CSV tabel bids
COPY bids FROM '\input_data\bid.csv' DELIMITER ',' CSV HEADER;

