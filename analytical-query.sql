-- Analytical Query

-- Nomor 1
-- Rangking popularitas mobil berdasarkan jumlah bid
SELECT
    m.model_name,
    COUNT(DISTINCT c.car_id) AS count_car_id,
    COUNT(b.bid_id) AS count_bid,
    RANK() OVER (ORDER BY COUNT(b.bid_id) DESC) AS popularity_rank
FROM
    models m
JOIN cars c USING(model_id)
JOIN advertisements a USING(car_id)
LEFT JOIN bids b USING(ad_id)
GROUP BY
    m.model_name
ORDER BY
    popularity_rank
;

-- Nomor 2
-- Membandingkan harga mobil berdasarkan harga rata-rata per kota
SELECT
    l.city_name as nama_kota,
    m.manufacture_name as merek,
    mo.model_name as model,
    c.year_manufactured as "year",
    a.price,
    ROUND(AVG(a.price) OVER (PARTITION BY l.city_name), 0) AS avg_car_city
FROM
    cars c
JOIN
    models mo ON c.model_id = mo.model_id
JOIN
    manufactures m ON c.manufacture_id = m.manufacture_id
JOIN
    advertisements a ON c.car_id = a.car_id
JOIN
    users u ON a.user_id = u.user_id
JOIN
    locations l ON u.location_id = l.location_id
ORDER BY
    l.city_name, m.manufacture_name, mo.model_name, c.year_manufactured
;

-- Nomor 3
-- Dari penawaran suatu model mobil, cari perbandingan tanggal user melakukan bid dengan bid selanjutnya beserta harga tawar yang diberikan. Ambil contoh untuk penawaran mobil Honda Brio
WITH ModelBids AS (
    SELECT
        mo.model_name,
        ad.user_id,
        b.datetime_bid AS bid_date,
        b.bid_price,
        LEAD(b.datetime_bid) OVER (PARTITION BY ad.ad_id ORDER BY b.datetime_bid) AS next_bid_date,
        LEAD(b.bid_price) OVER (PARTITION BY ad.ad_id ORDER BY b.datetime_bid) AS next_bid_price,
        ROW_NUMBER() OVER (PARTITION BY ad.ad_id ORDER BY b.datetime_bid) AS bid_rank
    FROM
        models mo
    JOIN
        cars c ON mo.model_id = c.model_id
    JOIN
        advertisements ad ON c.car_id = ad.car_id
    JOIN
        bids b ON ad.ad_id = b.ad_id
    JOIN
        users u ON b.user_id = u.user_id
    WHERE
        mo.model_name = 'Honda Brio'
)
SELECT
    model_name,
    user_id,
    bid_date AS first_bid_date,
    next_bid_date,
    bid_price AS first_bid_price,
    next_bid_price
FROM
    ModelBids
WHERE
    bid_rank = 1
ORDER BY
    first_bid_date
;

-- Nomor 4
-- Membandingkan persentase perbedaan rata-rata harga mobil berdasarkan modelnya dan rata-rata harga bid yang ditawarkan oleh customer pada 6 bulan terakhir
-- Difference adalah selisih antara rata-rata harga model mobil(avg_price) dengan rata-rata harga bid yang ditawarkan terhadap model tersebut(avg_bid_6month)
-- Difference dapat bernilai negatif atau positif
-- Difference_percent adalah persentase dari selisih yang telah dihitung, yaitu dengan cara difference dibagi rata-rata harga model mobil(avg_price) dikali 100%
-- Difference_percent dapat bernilai negatif atau positif
WITH ModelAvgPrices AS (
    SELECT
        mo.model_name,
        AVG(a.price) AS avg_price
    FROM
        models mo
    JOIN
        cars c ON mo.model_id = c.model_id
    JOIN
        advertisements a ON c.car_id = a.car_id
    GROUP BY
        mo.model_name
),
ModelAvgBids AS (
    SELECT
        mo.model_name,
        AVG(b.bid_price) AS avg_bid_6month
    FROM
        models mo
    JOIN
        cars c ON mo.model_id = c.model_id
    JOIN
        advertisements a ON c.car_id = a.car_id
    JOIN
        bids b ON a.ad_id = b.ad_id
    WHERE
        b.datetime_bid >= NOW() - INTERVAL '6 months'
    GROUP BY
        mo.model_name
)
SELECT
    m.model_name,
    COALESCE(ROUND(mp.avg_price, 0), 0) AS avg_price,
    COALESCE(ROUND(mab.avg_bid_6month, 0), 0) AS avg_bid_6month,
    COALESCE(ROUND(mp.avg_price, 0), 0) - COALESCE(ROUND(mab.avg_bid_6month, 0), 0) AS difference,
    CASE
        WHEN COALESCE(ROUND(mp.avg_price, 0), 0) = 0 THEN NULL
        ELSE (COALESCE(ROUND(mp.avg_price, 0), 0) - COALESCE(ROUND(mab.avg_bid_6month, 0), 0)) / COALESCE(ROUND(mp.avg_price, 0), 0) * 100
    END AS difference_percent
FROM
    public.models m
LEFT JOIN
    ModelAvgPrices mp ON m.model_name = mp.model_name
LEFT JOIN
    ModelAvgBids mab ON m.model_name = mab.model_name
;

-- Nomor 5
-- Membuat window function rata-rata harga bid sebuah merk dan model mobil selama 6 bulan terakhir
-- Contoh: Mobil Honda Brio selama 6 bulan terakhir
WITH ModelBidAverages AS (
    SELECT
        m.manufacture_name,
        mo.model_name,
        a.price AS bid_price,
        AVG(a.price) OVER (
            PARTITION BY m.manufacture_name, mo.model_name
            ORDER BY a.date_posted
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ) AS m_min_6,
        AVG(a.price) OVER (
            PARTITION BY m.manufacture_name, mo.model_name
            ORDER BY a.date_posted
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ) AS m_min_5,
        AVG(a.price) OVER (
            PARTITION BY m.manufacture_name, mo.model_name
            ORDER BY a.date_posted
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) AS m_min_4,
        AVG(a.price) OVER (
            PARTITION BY m.manufacture_name, mo.model_name
            ORDER BY a.date_posted
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS m_min_3,
        AVG(a.price) OVER (
            PARTITION BY m.manufacture_name, mo.model_name
            ORDER BY a.date_posted
            ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
        ) AS m_min_2,
        AVG(a.price) OVER (
            PARTITION BY m.manufacture_name, mo.model_name
            ORDER BY a.date_posted
            ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
        ) AS m_min_1
    FROM
        models mo
    JOIN
        cars c ON mo.model_id = c.model_id
    JOIN
        manufactures m ON c.manufacture_id = m.manufacture_id
    JOIN
        advertisements a ON c.car_id = a.car_id
    WHERE
        mo.model_name = 'Honda Brio' AND
        a.date_posted >= NOW() - INTERVAL '6 months'
)
SELECT
    manufacture_name,
    model_name,
    ROUND(AVG(m_min_6), 0) AS avg_m_min_6,
    ROUND(AVG(m_min_5), 0) AS avg_m_min_5,
    ROUND(AVG(m_min_4), 0) AS avg_m_min_4,
    ROUND(AVG(m_min_3), 0) AS avg_m_min_3,
    ROUND(AVG(m_min_2), 0) AS avg_m_min_2,
    ROUND(AVG(m_min_1), 0) AS avg_m_min_1
FROM
    ModelBidAverages
GROUP BY
    manufacture_name, model_name
ORDER BY
    manufacture_name, model_name
;
