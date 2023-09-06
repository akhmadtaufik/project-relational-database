-- body_types table;
CREATE TABLE public.body_types (
	body_type_id varchar(6) NOT NULL,
	body_type_name varchar(25) NOT NULL,
	CONSTRAINT body_types_body_type_name_key UNIQUE (body_type_name),
	CONSTRAINT body_types_pkey PRIMARY KEY (body_type_id)
);

-- manufactures table;
CREATE TABLE public.manufactures (
	manufacture_id varchar(4) NOT NULL,
	manufacture_name varchar(25) NOT NULL,
	CONSTRAINT manufactures_manufacture_name_key UNIQUE (manufacture_name),
	CONSTRAINT manufactures_pkey PRIMARY KEY (manufacture_id)
);

-- models table definition
CREATE TABLE public.models (
	model_id varchar(6) NOT NULL,
	manufacture_id varchar(4) NOT NULL,
	model_name varchar(100) NOT NULL,
	CONSTRAINT models_model_name_key UNIQUE (model_name),
	CONSTRAINT models_pkey PRIMARY KEY (model_id)
);


-- public.models foreign keys
ALTER TABLE public.models ADD CONSTRAINT fk_car_model_manufacture FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(manufacture_id);


-- cars table;
CREATE TABLE public.cars (
	car_id int4 NOT NULL,
	manufacture_id varchar(4) NOT NULL,
	model_id varchar(6) NOT NULL,
	body_type_id varchar(6) NOT NULL,
	year_manufactured int4 NOT NULL,
	engine_capacity numeric NOT NULL,
	passenger_capacity int4 NOT NULL,
	transmission_type varchar(10) NOT NULL,
	fuel_type varchar(10) NOT NULL,
	drive_system varchar(5) NOT NULL,
	odometer int4 NULL,
	additional_details text NULL,
	CONSTRAINT cars_drive_system_check CHECK (((drive_system)::text = ANY (ARRAY[('FWD'::character varying)::text, ('RWD'::character varying)::text, ('AWD'::character varying)::text]))),
	CONSTRAINT cars_engine_capacity_check CHECK (((engine_capacity >= (0)::numeric) AND (engine_capacity < (10)::numeric))),
	CONSTRAINT cars_fuel_type_check CHECK (((fuel_type)::text = ANY (ARRAY[('gasoline'::character varying)::text, ('diesel'::character varying)::text, ('hybrid'::character varying)::text, ('electric'::character varying)::text]))),
	CONSTRAINT cars_odometer_check CHECK ((odometer > 0)),
	CONSTRAINT cars_passenger_capacity_check CHECK (((passenger_capacity > 0) AND (passenger_capacity <= 12))),
	CONSTRAINT cars_pkey PRIMARY KEY (car_id),
	CONSTRAINT cars_transmission_type_check CHECK (((transmission_type)::text = ANY (ARRAY[('manual'::character varying)::text, ('automatic'::character varying)::text]))),
	CONSTRAINT cars_year_manufactured_check CHECK (((year_manufactured > 2000) AND ((year_manufactured)::numeric <= EXTRACT(year FROM CURRENT_DATE))))
);

-- Index
CREATE INDEX idx_cars_body_type ON public.cars USING btree (body_type_id);
CREATE INDEX idx_cars_manufacture_model ON public.cars USING btree (manufacture_id, model_id);

-- cars foreign keys
ALTER TABLE public.cars ADD CONSTRAINT fk_car_body_type FOREIGN KEY (body_type_id) REFERENCES public.body_types(body_type_id);
ALTER TABLE public.cars ADD CONSTRAINT fk_car_manufacture FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(manufacture_id);
ALTER TABLE public.cars ADD CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES public.models(model_id);

-- locations table;
CREATE TABLE public.locations (
	location_id int4 NOT NULL,
	city_name varchar(25) NOT NULL,
	"location" point NULL,
	CONSTRAINT locations_pkey PRIMARY KEY (location_id)
);

-- Create an index on the "location" column
CREATE INDEX idx_locations_location ON public.locations USING gist("location");


-- users table
CREATE TABLE public.users (
	user_id int4 NOT NULL,
	first_name varchar(25) NOT NULL,
	last_name varchar(25) NOT NULL,
	email varchar(75) NOT NULL,
	contact varchar(25) NOT NULL,
	location_id int4 NOT NULL,
	CONSTRAINT users_email_key UNIQUE (email),
	CONSTRAINT users_first_name_last_name_key UNIQUE (first_name, last_name),
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
);


-- public.users foreign keys
ALTER TABLE public.users ADD CONSTRAINT fk_user_location FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


-- advertisements definition
CREATE TABLE public.advertisements (
	ad_id int4 NOT NULL,
	user_id int4 NOT NULL,
	title varchar(100) NOT NULL,
	price numeric NOT NULL,
	description text NOT NULL,
	car_id int4 NOT NULL,
	date_posted timestamp NOT NULL,
	CONSTRAINT advertisements_pkey PRIMARY KEY (ad_id)
);

-- Index
CREATE INDEX idx_ads_car ON public.advertisements USING btree (car_id);
CREATE INDEX idx_ads_user ON public.advertisements USING btree (user_id);


-- public.advertisements foreign keys
ALTER TABLE public.advertisements ADD CONSTRAINT fk_ads_car FOREIGN KEY (car_id) REFERENCES public.cars(car_id);
ALTER TABLE public.advertisements ADD CONSTRAINT fk_ads_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- bids table definition
CREATE TABLE public.bids (
	bid_id serial4 NOT NULL,
	ad_id int4 NOT NULL,
	user_id int4 NOT NULL,
	bid_price numeric NOT NULL,
	bid_status varchar(10) NOT NULL,
	datetime_bid timestamp NOT NULL,
	CONSTRAINT bids_bid_price_check CHECK ((bid_price > (0)::numeric)),
	CONSTRAINT bids_bid_status_check CHECK (((bid_status)::text = ANY (ARRAY[('approved'::character varying)::text, ('rejected'::character varying)::text, ('sent'::character varying)::text]))),
	CONSTRAINT bids_pkey PRIMARY KEY (bid_id)
);


-- public.bids foreign keys
ALTER TABLE public.bids ADD CONSTRAINT fk_bid_ads FOREIGN KEY (ad_id) REFERENCES public.advertisements(ad_id);
ALTER TABLE public.bids ADD CONSTRAINT fk_bid_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;
