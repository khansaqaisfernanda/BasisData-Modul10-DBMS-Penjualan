DROP DATABASE IF EXISTS praktikum_modul10;
CREATE DATABASE praktikum_modul10;
USE praktikum_modul10;

SELECT VERSION();
SELECT @@version_comment;
SHOW ENGINES;
SHOW DATABASES;

CREATE TABLE pelanggan (
   id_pelanggan INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   nama_pelanggan VARCHAR(100) NOT NULL,
   email VARCHAR(120) NOT NULL UNIQUE,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE produk (
   id_produk INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   nama_produk VARCHAR(100) NOT NULL,
   harga_produk DECIMAL(12,2) NOT NULL,
   stok INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE pesanan (
   id_pesanan INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   id_pelanggan INT UNSIGNED NOT NULL,
   tanggal DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   status_pesanan ENUM('baru', 'diproses', 'selesai', 'batal') NOT NULL DEFAULT 'baru',
   CONSTRAINT fk_pesanan_pelanggan
       FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
       ON UPDATE CASCADE
       ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detail_pesanan (
   id_pesanan INT UNSIGNED NOT NULL,
   id_produk INT UNSIGNED NOT NULL,
   jumlah INT UNSIGNED NOT NULL,
   harga_saat_transaksi DECIMAL(12,2) NOT NULL,
   PRIMARY KEY (id_pesanan, id_produk),
   CONSTRAINT fk_detail_pesanan
       FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
       ON UPDATE CASCADE
       ON DELETE RESTRICT,
   CONSTRAINT fk_detail_produk
       FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
       ON UPDATE CASCADE
       ON DELETE RESTRICT
) ENGINE=InnoDB;

SHOW TABLES;
SHOW TABLE STATUS;
SHOW CREATE TABLE pelanggan;
SHOW CREATE TABLE pesanan;
SHOW CREATE TABLE detail_pesanan;

INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, email) VALUES
(1, 'Budi', 'budi@example.test'),
(2, 'Siti', 'siti@example.test');

INSERT INTO produk (id_produk, nama_produk, harga_produk, stok) VALUES
(10, 'Keyboard', 200000, 15),
(11, 'Mouse', 100000, 30),
(12, 'Monitor', 1500000, 5);

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal, status_pesanan) VALUES
(101, 1, '2026-10-01 09:00:00', 'selesai'),
(102, 2, '2026-10-02 10:00:00', 'diproses');

INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi) VALUES
(101, 10, 1, 200000),
(101, 11, 2, 100000),
(102, 12, 1, 1500000);

INSERT INTO pelanggan (nama_pelanggan, email)
VALUES ('Andi', 'andi@example.test');

SELECT * FROM pelanggan;

SELECT id_pelanggan, nama_pelanggan, email FROM pelanggan;

SELECT * FROM produk WHERE harga_produk > 100000;

UPDATE produk
SET harga_produk = 220000
WHERE id_produk = 10;

SELECT * FROM produk WHERE id_produk = 10;

DELETE FROM pelanggan
WHERE email = 'andi@example.test';

SELECT * FROM pelanggan;

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal)
VALUES (105, 999, '2026-10-05 10:00:00');

DELETE FROM pelanggan WHERE id_pelanggan = 1;

START TRANSACTION;

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal, status_pesanan)
VALUES (103, 1, '2026-10-05 09:00:00', 'baru');

INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi)
VALUES (103, 11, 2, 100000);

COMMIT;

SELECT * FROM pesanan WHERE id_pesanan = 103;
SELECT * FROM detail_pesanan WHERE id_pesanan = 103;

START TRANSACTION;

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal, status_pesanan)
VALUES (104, 2, '2026-10-06 10:00:00', 'baru');

INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_saat_transaksi)
VALUES (104, 10, 1, 200000);

ROLLBACK;

SELECT * FROM pesanan WHERE id_pesanan = 104;

EXPLAIN SELECT id_pesanan, id_pelanggan, tanggal, status_pesanan
FROM pesanan
WHERE tanggal >= '2026-10-01' AND tanggal < '2026-11-01';

CREATE TABLE seq_angka (n TINYINT UNSIGNED PRIMARY KEY);
INSERT INTO seq_angka VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

INSERT INTO pesanan (id_pesanan, id_pelanggan, tanggal, status_pesanan)
SELECT 1000 + s.seq,
       1 + (s.seq % 2),
       TIMESTAMP('2024-01-01 00:00:00') + INTERVAL ((s.seq * 83) % 94608000) SECOND,
       ELT(1 + (s.seq % 4), 'baru', 'diproses', 'selesai', 'batal')
FROM (
    SELECT a.n + b.n*10 + c.n*100 + d.n*1000 + e.n*10000 + f.n*100000 + 1 AS seq
    FROM seq_angka a
    CROSS JOIN seq_angka b
    CROSS JOIN seq_angka c
    CROSS JOIN seq_angka d
    CROSS JOIN seq_angka e
    CROSS JOIN seq_angka f
) s;

DROP TABLE seq_angka;
ANALYZE TABLE pelanggan, produk, pesanan, detail_pesanan;

SELECT COUNT(*) AS total_baris_pesanan FROM pesanan;

EXPLAIN SELECT id_pesanan, id_pelanggan, tanggal, status_pesanan
FROM pesanan
WHERE tanggal >= '2026-10-01' AND tanggal < '2026-11-01';

EXPLAIN ANALYZE SELECT id_pesanan, id_pelanggan, tanggal, status_pesanan
FROM pesanan
WHERE tanggal >= '2026-10-01' AND tanggal < '2026-11-01';

EXPLAIN SELECT p.id_pesanan, pl.nama_pelanggan, p.tanggal, p.status_pesanan
FROM pesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
WHERE p.tanggal >= '2026-10-01' AND p.tanggal < '2026-11-01';

CREATE INDEX idx_pesanan_tanggal ON pesanan(tanggal);

SHOW INDEX FROM pesanan;

EXPLAIN SELECT id_pesanan, id_pelanggan, tanggal, status_pesanan
FROM pesanan
WHERE tanggal >= '2026-10-01' AND tanggal < '2026-11-01';

EXPLAIN ANALYZE SELECT id_pesanan, id_pelanggan, tanggal, status_pesanan
FROM pesanan
WHERE tanggal >= '2026-10-01' AND tanggal < '2026-11-01';

EXPLAIN SELECT p.id_pesanan, pl.nama_pelanggan, p.tanggal, p.status_pesanan
FROM pesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
WHERE p.tanggal >= '2026-10-01' AND p.tanggal < '2026-11-01';

DELETE FROM pesanan WHERE id_pesanan > 1000;
ANALYZE TABLE pesanan;

USE praktikum_modul10;
SHOW TABLES;
SELECT COUNT(*) FROM pelanggan;
SELECT COUNT(*) FROM produk;
SELECT COUNT(*) FROM pesanan;
SELECT COUNT(*) FROM detail_pesanan;
