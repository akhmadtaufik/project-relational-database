-- Tabel body_types: Jenis-Jenis Bentuk Bodi Kendaraan
CREATE TABLE public.body_types (
	body_type_id varchar(6) NOT NULL,  -- Identifier unik untuk jenis tubuh
	body_type_name varchar(25) NOT NULL,  -- Nama deskriptif untuk jenis tubuh
	CONSTRAINT body_types_body_type_name_key UNIQUE (body_type_name),  -- Constraint: Nama harus unik
	CONSTRAINT body_types_pkey PRIMARY KEY (body_type_id)  -- Constraint: body_type_id adalah primary key
);

-- Tabel manufactures: Merek Kendaraan
CREATE TABLE public.manufactures (
	manufacture_id varchar(4) NOT NULL,  -- Identifier unik untuk merek
	manufacture_name varchar(25) NOT NULL,  -- Nama merek kendaraan
	CONSTRAINT manufactures_manufacture_name_key UNIQUE (manufacture_name),  -- Constraint: Nama merek harus unik
	CONSTRAINT manufactures_pkey PRIMARY KEY (manufacture_id)  -- Constraint: manufacture_id adalah primary key
);

-- Tabel models: Model Kendaraan untuk Setiap Merek
CREATE TABLE public.models (
	model_id varchar(6) NOT NULL,  -- Identifier unik untuk model
	manufacture_id varchar(4) NOT NULL,  -- Identifier merek yang terkait
	model_name varchar(100) NOT NULL,  -- Nama model kendaraan
	CONSTRAINT models_model_name_key UNIQUE (model_name),  -- Constraint: Nama model harus unik
	CONSTRAINT models_pkey PRIMARY KEY (model_id)  -- Constraint: model_id adalah primary key
);


-- Tambahkan foreign key constraint ke tabel 'models' untuk menghubungkannya dengan tabel 'manufactures'
ALTER TABLE public.models ADD CONSTRAINT fk_car_model_manufacture FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(manufacture_id);


-- Tabel cars: Detail Lengkap tentang Setiap Kendaraan
CREATE TABLE public.cars (
	car_id int4 NOT NULL,  -- Identifier unik untuk kendaraan
	manufacture_id varchar(4) NOT NULL,  -- Identifier merek kendaraan
	model_id varchar(6) NOT NULL,  -- Identifier model kendaraan
	body_type_id varchar(6) NOT NULL,  -- Identifier jenis tubuh kendaraan
	year_manufactured int4 NOT NULL,  -- Tahun pembuatan kendaraan
	engine_capacity numeric NOT NULL,  -- Kapasitas mesin kendaraan
	passenger_capacity int4 NOT NULL,  -- Kapasitas penumpang kendaraan
	transmission_type varchar(10) NOT NULL,  -- Jenis transmisi kendaraan
	fuel_type varchar(10) NOT NULL,  -- Jenis bahan bakar kendaraan
	drive_system varchar(5) NOT NULL,  -- Sistem penggerak kendaraan
	odometer int4 NULL,  -- Nilai odometer kendaraan (opsional)
	additional_details text NULL,  -- Detail tambahan kendaraan (opsional)
	CONSTRAINT cars_drive_system_check CHECK (((drive_system)::text = ANY (ARRAY[('FWD'::character varying)::text, ('RWD'::character varying)::text, ('AWD'::character varying)::text]))),  -- Constraint: Memastikan drive_system adalah salah satu nilai yang valid
	CONSTRAINT cars_engine_capacity_check CHECK (((engine_capacity >= (0)::numeric) AND (engine_capacity < (10)::numeric))),  -- Constraint: Memastikan kapasitas mesin berada dalam rentang yang valid
	CONSTRAINT cars_fuel_type_check CHECK (((fuel_type)::text = ANY (ARRAY[('gasoline'::character varying)::text, ('diesel'::character varying)::text, ('hybrid'::character varying)::text, ('electric'::character varying)::text]))),  -- Constraint: Memastikan jenis bahan bakar adalah salah satu nilai yang valid
	CONSTRAINT cars_odometer_check CHECK ((odometer > 0)),  -- Constraint: Memastikan odometer bernilai positif
	CONSTRAINT cars_passenger_capacity_check CHECK (((passenger_capacity > 0) AND (passenger_capacity <= 12))),  -- Constraint: Memastikan kapasitas penumpang dalam rentang yang valid
	CONSTRAINT cars_pkey PRIMARY KEY (car_id),  -- Constraint: car_id adalah primary key
	CONSTRAINT cars_transmission_type_check CHECK (((transmission_type)::text = ANY (ARRAY[('manual'::character varying)::text, ('automatic'::character varying)::text]))),  -- Constraint: Memastikan jenis transmisi adalah salah satu nilai yang valid
	CONSTRAINT cars_year_manufactured_check CHECK (((year_manufactured > 2000) AND ((year_manufactured)::numeric <= EXTRACT(year FROM CURRENT_DATE))))  -- Constraint: Memastikan tahun pembuatan berada dalam rentang yang valid
);

-- Buat indeks pada kolom 'body_type_id' di tabel 'cars' untuk meningkatkan pencarian berdasarkan jenis tubuh kendaraan
CREATE INDEX idx_cars_body_type ON public.cars USING btree (body_type_id);

-- Buat indeks gabungan pada kolom 'manufacture_id' dan 'model_id' di tabel 'cars' untuk meningkatkan pencarian berdasarkan merek dan model kendaraan
CREATE INDEX idx_cars_manufacture_model ON public.cars USING btree (manufacture_id, model_id);

-- Tambahkan foreign key constraint ke tabel 'cars' untuk menghubungkannya dengan tabel 'body_types' berdasarkan jenis tubuh kendaraan
ALTER TABLE public.cars ADD CONSTRAINT fk_car_body_type FOREIGN KEY (body_type_id) REFERENCES public.body_types(body_type_id);

-- Tambahkan foreign key constraint ke tabel 'cars' untuk menghubungkannya dengan tabel 'manufactures' berdasarkan merek kendaraan
ALTER TABLE public.cars ADD CONSTRAINT fk_car_manufacture FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(manufacture_id);

-- Tambahkan foreign key constraint ke tabel 'cars' untuk menghubungkannya dengan tabel 'models' berdasarkan model kendaraan
ALTER TABLE public.cars ADD CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES public.models(model_id);


-- Tabel 'locations': Informasi tentang Lokasi Geografis
CREATE TABLE public.locations (
	location_id int4 NOT NULL,  -- Identifier unik untuk lokasi
	city_name varchar(25) NOT NULL,  -- Nama kota
	"location" point NOT NULL,  -- Koordinat lokasi
	CONSTRAINT locations_pkey PRIMARY KEY (location_id)  -- Constraint: location_id adalah primary key
);

-- Buat indeks pada kolom "location" untuk meningkatkan pencarian berdasarkan data geografis
CREATE INDEX idx_locations_location ON public.locations USING gist("location");


-- Tabel 'users': Data Pengguna Platform Kendaraan
CREATE TABLE public.users (
	user_id int4 NOT NULL,  -- Identifier unik untuk pengguna
	first_name varchar(25) NOT NULL,  -- Nama depan pengguna
	last_name varchar(25) NOT NULL,  -- Nama belakang pengguna
	email varchar(75) NOT NULL,  -- Alamat email pengguna
	contact varchar(25) NOT NULL,  -- Informasi kontak pengguna
	location_id int4 NOT NULL,  -- Identifier lokasi fisik pengguna
	CONSTRAINT users_email_key UNIQUE (email),  -- Constraint: Alamat email harus unik
	CONSTRAINT users_first_name_last_name_key UNIQUE (first_name, last_name),  -- Constraint: Nama depan dan belakang harus unik bersama-sama
	CONSTRAINT users_pkey PRIMARY KEY (user_id)  -- Constraint: user_id adalah primary key
);

-- Foreign key constraint untuk menghubungkan dengan tabel 'locations' berdasarkan lokasi fisik pengguna
ALTER TABLE public.users ADD CONSTRAINT fk_user_location FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


-- Tabel 'advertisements': Informasi Iklan Kendaraan
CREATE TABLE public.advertisements (
	ad_id int4 NOT NULL,  -- Identifier unik untuk iklan
	user_id int4 NOT NULL,  -- Identifier pengguna yang memposting iklan
	title varchar(100) NOT NULL,  -- Judul iklan
	price numeric NOT NULL,  -- Harga iklan
	description text NOT NULL,  -- Deskripsi iklan
	car_id int4 NOT NULL,  -- Identifier kendaraan terkait dengan iklan
	date_posted timestamp NOT NULL,  -- Tanggal dan waktu iklan diposting
	CONSTRAINT advertisements_pkey PRIMARY KEY (ad_id)  -- Constraint: ad_id adalah primary key
);

-- Buat indeks pada kolom 'car_id' untuk meningkatkan pencarian berdasarkan kendaraan terkait
CREATE INDEX idx_ads_car ON public.advertisements USING btree (car_id);

-- Buat indeks pada kolom 'user_id' untuk meningkatkan pencarian berdasarkan pengguna yang memposting iklan
CREATE INDEX idx_ads_user ON public.advertisements USING btree (user_id);

-- Foreign key constraints untuk menghubungkan dengan tabel 'cars' dan 'users'
ALTER TABLE public.advertisements ADD CONSTRAINT fk_ads_car FOREIGN KEY (car_id) REFERENCES public.cars(car_id);
ALTER TABLE public.advertisements ADD CONSTRAINT fk_ads_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Tabel bids: Penawaran untuk Kendaraan
CREATE TABLE public.bids (
	bid_id serial4 NOT NULL,  -- Identifier unik untuk penawaran
	ad_id int4 NOT NULL,  -- Identifier iklan yang ditawar
	user_id int4 NOT NULL,  -- Identifier pengguna yang membuat penawaran
	bid_price numeric NOT NULL,  -- Harga penawaran
	bid_status varchar(10) NOT NULL,  -- Status penawaran
	datetime_bid timestamp NOT NULL,  -- Waktu penawaran dibuat
	CONSTRAINT bids_bid_price_check CHECK ((bid_price > (0)::numeric)),  -- Constraint: Harga penawaran harus positif
	CONSTRAINT bids_bid_status_check CHECK (((bid_status)::text = ANY (ARRAY[('approved'::character varying)::text, ('rejected'::character varying)::text, ('sent'::character varying)::text]))),  -- Constraint: Status penawaran harus salah satu dari opsi yang valid
	CONSTRAINT bids_pkey PRIMARY KEY (bid_id)  -- Constraint: bid_id adalah primary key
);

-- Foreign key constraints untuk menghubungkan dengan tabel advertisements dan users
ALTER TABLE public.bids ADD CONSTRAINT fk_bid_ads FOREIGN KEY (ad_id) REFERENCES public.advertisements(ad_id);
ALTER TABLE public.bids ADD CONSTRAINT fk_bid_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;