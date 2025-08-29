CREATE OR REPLACE TABLE `rakamin-kf-analytics-470512.kimia_farma.tabel_analisa` AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,

  -- Persentase gross laba berdasarkan harga (sebelum diskon)
  CASE
    WHEN t.price <= 50000  THEN 0.10
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.20
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Harga setelah diskon
  t.price * (1 - t.discount_percentage / 100.0) AS nett_sales,

  -- Profit = nett_sales * persentase_gross_laba
  (t.price * (1 - t.discount_percentage / 100.0)) *
  CASE
    WHEN t.price <= 50000  THEN 0.10
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.20
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  t.rating AS rating_transaksi
  
FROM 
  `rakamin-kf-analytics-470512.kimia_farma.kf_final_transaction` AS t
JOIN 
  `rakamin-kf-analytics-470512.kimia_farma.kf_kantor_cabang` AS kc
  ON t.branch_id = kc.branch_id
LEFT JOIN 
  `rakamin-kf-analytics-470512.kimia_farma.kf_product` AS p
  ON t.product_id = p.product_id;
