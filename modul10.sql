DROP DATABASE IF EXISTS praktikum_modul10;
CREATE DATABASE praktikum_modul10 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE praktikum_modul10;

SELECT VERSION() AS versi_dbms, @@version_comment AS distribusi, @@version_compile_os AS os, @@default_storage_engine AS default_engine, @@port AS port;
SELECT ENGINE, SUPPORT, TRANSACTIONS, XA, SAVEPOINTS FROM information_schema.ENGINES WHERE ENGINE IN ('InnoDB', 'MyISAM', 'MEMORY', 'CSV');

CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama_pelanggan VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    no_hp VARCHAR(20),
    kota VARCHAR(50) NOT NULL,
    tanggal_daftar DATE NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT PRIMARY KEY,
    nama_produk VARCHAR(100) NOT NULL,
    kategori VARCHAR(50) NOT NULL,
    harga DECIMAL(12,2) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_produk_harga CHECK (harga >= 0),
    CONSTRAINT chk_produk_stok CHECK (stok >= 0)
) ENGINE=InnoDB;

CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT PRIMARY KEY,
    id_pelanggan INT NOT NULL,
    tanggal_pesanan DATETIME NOT NULL,
    status ENUM('baru', 'dibayar', 'dikirim', 'selesai', 'batal') NOT NULL DEFAULT 'baru',
    total_harga DECIMAL(14,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan)
        REFERENCES pelanggan (id_pelanggan)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101;

CREATE TABLE detail_pesanan (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    jumlah INT NOT NULL,
    harga_saat_transaksi DECIMAL(12,2) NOT NULL,
    CONSTRAINT uq_detail_pesanan_produk UNIQUE (id_pesanan, id_produk),
    CONSTRAINT chk_detail_jumlah CHECK (jumlah > 0),
    CONSTRAINT chk_detail_harga CHECK (harga_saat_transaksi >= 0),
    CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan)
        REFERENCES pesanan (id_pesanan)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk)
        REFERENCES produk (id_produk)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

SELECT TABLE_NAME, ENGINE, TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'praktikum_modul10';

SHOW CREATE TABLE pesanan;
DESCRIBE detail_pesanan;

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'praktikum_modul10'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

SELECT k.TABLE_NAME, k.COLUMN_NAME, k.CONSTRAINT_NAME, k.REFERENCED_TABLE_NAME, k.REFERENCED_COLUMN_NAME, r.UPDATE_RULE, r.DELETE_RULE
FROM information_schema.KEY_COLUMN_USAGE k
JOIN information_schema.REFERENTIAL_CONSTRAINTS r
    ON r.CONSTRAINT_SCHEMA = k.TABLE_SCHEMA AND r.CONSTRAINT_NAME = k.CONSTRAINT_NAME
WHERE k.TABLE_SCHEMA = 'praktikum_modul10';

INSERT INTO pelanggan (nama_pelanggan, email, no_hp, kota) VALUES
('Andi Pratama', 'andi@mail.test', '081200000001', 'Surabaya'),
('Budi Santoso', 'budi@mail.test', '081200000002', 'Malang'),
('Citra Lestari', 'citra@mail.test', '081200000003', 'Sidoarjo'),
('Dewi Anggraini', 'dewi@mail.test', '081200000004', 'Surabaya'),
('Eka Saputra', 'eka@mail.test', '081200000005', 'Gresik');

INSERT INTO produk (nama_produk, kategori, harga, stok) VALUES
('Beras Premium 5 kg', 'Sembako', 75000, 50),
('Minyak Goreng 2 L', 'Sembako', 38000, 40),
('Gula Pasir 1 kg', 'Sembako', 17500, 60),
('Kopi Bubuk 200 g', 'Minuman', 25000, 30),
('Teh Celup isi 25', 'Minuman', 8500, 80),
('Sabun Mandi', 'Perlengkapan', 4500, 100);

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal_pesanan, status, total_harga) VALUES
(101, 1, '2026-10-01 10:15:00', 'selesai', 110000),
(102, 2, '2026-10-02 14:40:00', 'dibayar', 55000);

INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi) VALUES
(101, 1, 1, 75000),
(101, 3, 2, 17500),
(102, 2, 1, 38000),
(102, 5, 2, 8500);

INSERT INTO pelanggan (nama_pelanggan, email, no_hp, kota)
VALUES ('Fajar Nugroho', 'fajar@mail.test', '081200000006', 'Malang');
INSERT INTO produk (nama_produk, kategori, harga, stok)
VALUES ('Mi Instan Goreng', 'Makanan', 3500, 200);
SELECT * FROM pelanggan;

SELECT * FROM produk;
SELECT id_pelanggan, nama_pelanggan, kota FROM pelanggan WHERE kota = 'Surabaya';
SELECT ps.id_pesanan, pl.nama_pelanggan, pr.nama_produk, dp.jumlah, dp.harga_saat_transaksi,
       dp.jumlah * dp.harga_saat_transaksi AS subtotal
FROM pesanan ps
JOIN pelanggan pl ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = ps.id_pesanan
JOIN produk pr ON pr.id_produk = dp.id_produk
ORDER BY ps.id_pesanan, pr.nama_produk;

UPDATE produk SET harga = 80000 WHERE id_produk = 1;
UPDATE pelanggan SET no_hp = '081299999993' WHERE id_pelanggan = 3;
SELECT id_produk, nama_produk, harga FROM produk WHERE id_produk = 1;
SELECT id_pesanan, id_produk, harga_saat_transaksi FROM detail_pesanan WHERE id_produk = 1;
SELECT id_pelanggan, nama_pelanggan, no_hp FROM pelanggan WHERE id_pelanggan = 3;

DELETE FROM pelanggan WHERE id_pelanggan = 6;
SELECT id_pelanggan, nama_pelanggan FROM pelanggan;

INSERT INTO pesanan (id_pelanggan, tanggal_pesanan, status) VALUES (999, NOW(), 'baru');
DELETE FROM pelanggan WHERE id_pelanggan = 1;
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi) VALUES (101, 9999, 1, 1000);
INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, email, kota) VALUES (1, 'Andi Kembar', 'andi2@mail.test', 'Surabaya');
INSERT INTO pelanggan (nama_pelanggan, email, kota) VALUES ('Andi Duplikat', 'andi@mail.test', 'Surabaya');
INSERT INTO pelanggan (nama_pelanggan, email, kota) VALUES (NULL, 'kosong@mail.test', 'Malang');
INSERT INTO produk (nama_produk, kategori, harga, stok) VALUES ('Produk Error', 'Sembako', -1000, 10);
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi) VALUES (101, 3, 1, 17500);
SELECT COUNT(*) AS jumlah_pesanan_pelanggan_1 FROM pesanan WHERE id_pelanggan = 1;

START TRANSACTION;
INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal_pesanan, status) VALUES (103, 3, '2026-10-03 09:30:00', 'dibayar');
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi) VALUES
(103, 4, 2, 25000),
(103, 6, 3, 4500);
UPDATE produk SET stok = stok - 2 WHERE id_produk = 4;
UPDATE produk SET stok = stok - 3 WHERE id_produk = 6;
UPDATE pesanan
SET total_harga = (SELECT SUM(jumlah * harga_saat_transaksi) FROM detail_pesanan WHERE id_pesanan = 103)
WHERE id_pesanan = 103;
COMMIT;

SELECT * FROM pesanan WHERE id_pesanan = 103;
SELECT * FROM detail_pesanan WHERE id_pesanan = 103;
SELECT id_produk, nama_produk, stok FROM produk WHERE id_produk IN (4, 6);

START TRANSACTION;
INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal_pesanan, status, total_harga) VALUES (104, 4, '2026-10-04 11:00:00', 'baru', 80000);
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi) VALUES (104, 1, 1, 80000);
UPDATE produk SET stok = stok - 1 WHERE id_produk = 1;
SELECT * FROM pesanan WHERE id_pesanan = 104;
ROLLBACK;

SELECT * FROM pesanan WHERE id_pesanan = 104;
SELECT * FROM detail_pesanan WHERE id_pesanan = 104;
SELECT id_produk, nama_produk, stok FROM produk WHERE id_produk = 1;

CREATE TABLE angka (n TINYINT PRIMARY KEY);
INSERT INTO angka VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, email, no_hp, kota, tanggal_daftar)
SELECT 1000 + s.seq,
       CONCAT('Pelanggan Sim ', s.seq),
       CONCAT('sim', s.seq, '@mail.test'),
       CONCAT('08', LPAD(s.seq, 10, '0')),
       ELT(1 + s.seq % 8, 'Surabaya', 'Malang', 'Sidoarjo', 'Gresik', 'Mojokerto', 'Pasuruan', 'Jember', 'Kediri'),
       DATE('2024-01-01') + INTERVAL (s.seq % 730) DAY
FROM (SELECT a.n + b.n * 10 + c.n * 100 + d.n * 1000 + e.n * 10000 + 1 AS seq
      FROM angka a CROSS JOIN angka b CROSS JOIN angka c CROSS JOIN angka d CROSS JOIN angka e) s;

INSERT INTO produk (id_produk, nama_produk, kategori, harga, stok)
SELECT 1000 + s.seq,
       CONCAT('Produk Sim ', s.seq),
       ELT(1 + s.seq % 5, 'Sembako', 'Minuman', 'Perlengkapan', 'Makanan', 'Kesehatan'),
       1000 + (s.seq * 137 % 990) * 100,
       1000
FROM (SELECT a.n + b.n * 10 + c.n * 100 + 1 AS seq
      FROM angka a CROSS JOIN angka b CROSS JOIN angka c) s;

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal_pesanan, status)
SELECT 1000 + s.seq,
       1001 + (s.seq * 7919) % 100000,
       TIMESTAMP('2024-01-01') + INTERVAL ((s.seq * 104729) % 63072000) SECOND,
       ELT(1 + s.seq % 5, 'baru', 'dibayar', 'dikirim', 'selesai', 'batal')
FROM (SELECT a.n + b.n * 10 + c.n * 100 + d.n * 1000 + e.n * 10000 + f.n * 100000 + 1 AS seq
      FROM angka a CROSS JOIN angka b CROSS JOIN angka c CROSS JOIN angka d CROSS JOIN angka e CROSS JOIN angka f) s;

INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi)
SELECT p.id_pesanan, pr.id_produk, 1 + (p.id_pesanan + k.k) % 5, pr.harga
FROM pesanan p
CROSS JOIN (SELECT 1 AS k UNION ALL SELECT 2) k
JOIN produk pr ON pr.id_produk = 1001 + (p.id_pesanan * 7 + k.k * 13) % 1000
WHERE p.id_pesanan > 1000;

UPDATE pesanan p
JOIN (SELECT id_pesanan, SUM(jumlah * harga_saat_transaksi) AS total
      FROM detail_pesanan
      WHERE id_pesanan > 1000
      GROUP BY id_pesanan) t ON t.id_pesanan = p.id_pesanan
SET p.total_harga = t.total;

ANALYZE TABLE pelanggan, produk, pesanan, detail_pesanan;

SELECT 'pelanggan' AS tabel, COUNT(*) AS jumlah_baris FROM pelanggan
UNION ALL SELECT 'produk', COUNT(*) FROM produk
UNION ALL SELECT 'pesanan', COUNT(*) FROM pesanan
UNION ALL SELECT 'detail_pesanan', COUNT(*) FROM detail_pesanan;

EXPLAIN SELECT id_pesanan, id_pelanggan, tanggal_pesanan, total_harga
FROM pesanan
WHERE tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59';
EXPLAIN ANALYZE SELECT id_pesanan, id_pelanggan, tanggal_pesanan, total_harga
FROM pesanan
WHERE tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59';

EXPLAIN SELECT id_pelanggan, nama_pelanggan, email, kota
FROM pelanggan
WHERE nama_pelanggan = 'Pelanggan Sim 77777';
EXPLAIN ANALYZE SELECT id_pelanggan, nama_pelanggan, email, kota
FROM pelanggan
WHERE nama_pelanggan = 'Pelanggan Sim 77777';

EXPLAIN SELECT pl.kota, COUNT(DISTINCT ps.id_pesanan) AS jumlah_pesanan, SUM(dp.jumlah * dp.harga_saat_transaksi) AS omzet
FROM pesanan ps
JOIN pelanggan pl ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = ps.id_pesanan
WHERE ps.tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59'
GROUP BY pl.kota
ORDER BY omzet DESC;
EXPLAIN ANALYZE SELECT pl.kota, COUNT(DISTINCT ps.id_pesanan) AS jumlah_pesanan, SUM(dp.jumlah * dp.harga_saat_transaksi) AS omzet
FROM pesanan ps
JOIN pelanggan pl ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = ps.id_pesanan
WHERE ps.tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59'
GROUP BY pl.kota
ORDER BY omzet DESC;

CREATE INDEX idx_pesanan_tanggal ON pesanan (tanggal_pesanan);
CREATE INDEX idx_pelanggan_nama ON pelanggan (nama_pelanggan);
SHOW INDEX FROM pesanan;
SHOW INDEX FROM pelanggan;

EXPLAIN SELECT id_pesanan, id_pelanggan, tanggal_pesanan, total_harga
FROM pesanan
WHERE tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59';
EXPLAIN ANALYZE SELECT id_pesanan, id_pelanggan, tanggal_pesanan, total_harga
FROM pesanan
WHERE tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59';

EXPLAIN SELECT id_pelanggan, nama_pelanggan, email, kota
FROM pelanggan
WHERE nama_pelanggan = 'Pelanggan Sim 77777';
EXPLAIN ANALYZE SELECT id_pelanggan, nama_pelanggan, email, kota
FROM pelanggan
WHERE nama_pelanggan = 'Pelanggan Sim 77777';

EXPLAIN SELECT pl.kota, COUNT(DISTINCT ps.id_pesanan) AS jumlah_pesanan, SUM(dp.jumlah * dp.harga_saat_transaksi) AS omzet
FROM pesanan ps
JOIN pelanggan pl ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = ps.id_pesanan
WHERE ps.tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59'
GROUP BY pl.kota
ORDER BY omzet DESC;
EXPLAIN ANALYZE SELECT pl.kota, COUNT(DISTINCT ps.id_pesanan) AS jumlah_pesanan, SUM(dp.jumlah * dp.harga_saat_transaksi) AS omzet
FROM pesanan ps
JOIN pelanggan pl ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = ps.id_pesanan
WHERE ps.tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59'
GROUP BY pl.kota
ORDER BY omzet DESC;

SELECT pl.kota, COUNT(DISTINCT ps.id_pesanan) AS jumlah_pesanan, SUM(dp.jumlah * dp.harga_saat_transaksi) AS omzet
FROM pesanan ps
JOIN pelanggan pl ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON dp.id_pesanan = ps.id_pesanan
WHERE ps.tanggal_pesanan BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59'
GROUP BY pl.kota
ORDER BY omzet DESC;

EXPLAIN SELECT id_pesanan, tanggal_pesanan, total_harga
FROM pesanan
WHERE YEAR(tanggal_pesanan) = 2025 AND MONTH(tanggal_pesanan) = 3;

EXPLAIN SELECT id_pesanan, tanggal_pesanan, total_harga
FROM pesanan
WHERE tanggal_pesanan >= '2024-01-01';

DROP TABLE angka;
DELETE FROM pesanan WHERE id_pesanan > 1000;
DELETE FROM produk WHERE id_produk > 1000;
DELETE FROM pelanggan WHERE id_pelanggan > 1000;
ANALYZE TABLE pelanggan, produk, pesanan, detail_pesanan;

SELECT 'pelanggan' AS tabel, COUNT(*) AS jumlah_baris FROM pelanggan
UNION ALL SELECT 'produk', COUNT(*) FROM produk
UNION ALL SELECT 'pesanan', COUNT(*) FROM pesanan
UNION ALL SELECT 'detail_pesanan', COUNT(*) FROM detail_pesanan;
