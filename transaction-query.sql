-- Nomor 1
-- Mencari mobil keluaran 2015 ke atas
select 
	c.car_id ,
	m.manufacture_id  as merek,
	m2.model_name ,
	year_manufactured,
	a.price 
from cars c 
inner join manufactures m 
	using(manufacture_id)
inner join models m2 
	using(model_id)
inner join advertisements a 
	using(car_id)
where 
	year_manufactured > 2015
;

-- Nomor 2
-- Menambahkan satu data bid produk baru
-- Ganti nilai-nilai berikut sesuai dengan data bid yang ingin Anda tambahkan
INSERT INTO bids (ad_id, user_id, bid_price, bid_status, datetime_bid)
VALUES (123, 269, 150000000, 'sent', '2023-09-05 14:30:00');

-- Sebelum menambahkan data baru
SELECT *
FROM bids
WHERE datetime_bid >= '2023-08-11 00:00:00' AND datetime_bid < '2023-09-05 00:00:00'
ORDER BY datetime_bid ;

-- Setelah menambahkan data baru
SELECT *
FROM bids
WHERE datetime_bid >= '2023-08-11 00:00:00'
ORDER BY datetime_bid ;

-- Nomor 3
-- Melihat semua mobil yg dijual 1 akun dari yg paling baru
-- Mobil yang dijual oleh akun Gambira Saptono
select 
	c.car_id ,
	m.manufacture_name as merk,
	m2.model_name as model,
	c.year_manufactured as year,
	a.price,
	a.date_posted 
from 
	cars c 
inner join manufactures m 
	using(manufacture_id)
inner join models m2 
	using(model_id)
inner join advertisements a 
	using(car_id)
where 
	a.user_id in (
		select 
			u.user_id
		from 
			users u 
		where 
			u.first_name = 'Gambira' and 
			u.last_name = 'Saptono'
	)
;

-- Nomor 4
-- Mencari mobil bekas yang termurah berdasarkan keyword
select 
	distinct c.car_id ,
	m.manufacture_name as merk,
	m2.model_name as model,
	c.year_manufactured as year,
	a.price
from 
	cars c 
inner join manufactures m 
	using(manufacture_id)
inner join models m2 
	using(model_id)
inner join advertisements a 
	using(car_id)
where
	m2.model_name ilike '%camry%'
order by a.price 
;

-- Nomor 5 
-- Mencari mobil bekas yang terdekat berdasarkan sebuah id kota, jarak terdekat dihitung berdasarkan latitude longitude. Perhitungan jarak dapat dihitung menggunakan rumus jarak euclidean berdasarkan latitude dan longitude
select 
    c.car_id,
    m.manufacture_name  as merk,
    m2.model_name AS model,
    c.year_manufactured as year,
    a.price,
    SQRT(POW(l."location"[0] - user_location."location"[0], 2) + POW(l."location"[1] - user_location."location"[1], 2)) AS distance
from 
    cars c
join manufactures m 
	using(manufacture_id)
join models m2 
	using(model_id)
join advertisements a 
	using(car_id)
join users u 
	using(user_id)
join locations l 
	using(location_id)
cross join 
  	locations user_location
where 
    user_location.location_id = 3173
ORDER by 
    distance
;

-- Menggunakan formula Vincenty
with  LocationCoords as (
    select 
        l.location_id,
        RADIANS(l."location"[0]) as lat_radians,
        RADIANS(l."location"[1]) as lng_radians
    from 
        locations l
    where 
        l.location_id = 3173
),
CarCoords as (
    select 
        c.car_id,
        RADIANS(l."location"[0]) AS car_lat_radians,
        RADIANS(l."location"[1]) AS car_lng_radians
    from cars c
    join advertisements a using(car_id)
    join users u using(user_id) 
    join locations l using(location_id)
)
select
    cc.car_id,
    c.manufacture_id,
    c.model_id,
    c.year_manufactured,
    a.price,
    6371 * ATAN2(
        SQRT(
            POWER(COS(cc.car_lat_radians) * SIN(cc.car_lng_radians - lc.lng_radians), 2) +
            POWER(
                COS(lc.lat_radians) * SIN(cc.car_lat_radians) - SIN(lc.lat_radians) * COS(cc.car_lat_radians) *
                COS(cc.car_lng_radians - lc.lng_radians), 2
            )
        ),
        SIN(lc.lat_radians) * SIN(cc.car_lat_radians) + COS(lc.lat_radians) * COS(cc.car_lat_radians) * COS(cc.car_lng_radians - lc.lng_radians)
    ) AS distance
from
    CarCoords cc
join cars c using(car_id)
join advertisements a using(car_id)
join LocationCoords lc ON lc.location_id = 3173
ORDER BY
    distance
;