-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: praktikum_modul10
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `detail_pesanan`
--

DROP TABLE IF EXISTS `detail_pesanan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_pesanan` (
  `id_detail` int NOT NULL AUTO_INCREMENT,
  `id_pesanan` int NOT NULL,
  `id_produk` int NOT NULL,
  `jumlah` int NOT NULL,
  `harga_saat_transaksi` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id_detail`),
  UNIQUE KEY `uq_detail_pesanan_produk` (`id_pesanan`,`id_produk`),
  KEY `fk_detail_produk` (`id_produk`),
  CONSTRAINT `fk_detail_pesanan` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detail_produk` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_detail_harga` CHECK ((`harga_saat_transaksi` >= 0)),
  CONSTRAINT `chk_detail_jumlah` CHECK ((`jumlah` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=2031595 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_pesanan`
--

LOCK TABLES `detail_pesanan` WRITE;
/*!40000 ALTER TABLE `detail_pesanan` DISABLE KEYS */;
INSERT INTO `detail_pesanan` VALUES (1,101,1,1,75000.00),(2,101,3,2,17500.00),(3,102,2,1,38000.00),(4,102,5,2,8500.00),(7,103,4,2,25000.00),(8,103,6,3,4500.00);
/*!40000 ALTER TABLE `detail_pesanan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pelanggan`
--

DROP TABLE IF EXISTS `pelanggan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pelanggan` (
  `id_pelanggan` int NOT NULL AUTO_INCREMENT,
  `nama_pelanggan` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kota` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tanggal_daftar` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id_pelanggan`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_pelanggan_nama` (`nama_pelanggan`)
) ENGINE=InnoDB AUTO_INCREMENT=101001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pelanggan`
--

LOCK TABLES `pelanggan` WRITE;
/*!40000 ALTER TABLE `pelanggan` DISABLE KEYS */;
INSERT INTO `pelanggan` VALUES (1,'Andi Pratama','andi@mail.test','081200000001','Surabaya','2026-11-05'),(2,'Budi Santoso','budi@mail.test','081200000002','Malang','2026-11-05'),(3,'Citra Lestari','citra@mail.test','081299999993','Sidoarjo','2026-11-05'),(4,'Dewi Anggraini','dewi@mail.test','081200000004','Surabaya','2026-11-05'),(5,'Eka Saputra','eka@mail.test','081200000005','Gresik','2026-11-05');
/*!40000 ALTER TABLE `pelanggan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pesanan`
--

DROP TABLE IF EXISTS `pesanan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pesanan` (
  `id_pesanan` int NOT NULL AUTO_INCREMENT,
  `id_pelanggan` int NOT NULL,
  `tanggal_pesanan` datetime NOT NULL,
  `status` enum('baru','dibayar','dikirim','selesai','batal') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'baru',
  `total_harga` decimal(14,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_pesanan`),
  KEY `fk_pesanan_pelanggan` (`id_pelanggan`),
  KEY `idx_pesanan_tanggal` (`tanggal_pesanan`),
  CONSTRAINT `fk_pesanan_pelanggan` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1001001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pesanan`
--

LOCK TABLES `pesanan` WRITE;
/*!40000 ALTER TABLE `pesanan` DISABLE KEYS */;
INSERT INTO `pesanan` VALUES (101,1,'2026-10-01 10:15:00','selesai',110000.00),(102,2,'2026-10-02 14:40:00','dibayar',55000.00),(103,3,'2026-10-03 09:30:00','dibayar',63500.00);
/*!40000 ALTER TABLE `pesanan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produk`
--

DROP TABLE IF EXISTS `produk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produk` (
  `id_produk` int NOT NULL AUTO_INCREMENT,
  `nama_produk` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kategori` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `stok` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_produk`),
  CONSTRAINT `chk_produk_harga` CHECK ((`harga` >= 0)),
  CONSTRAINT `chk_produk_stok` CHECK ((`stok` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produk`
--

LOCK TABLES `produk` WRITE;
/*!40000 ALTER TABLE `produk` DISABLE KEYS */;
INSERT INTO `produk` VALUES (1,'Beras Premium 5 kg','Sembako',80000.00,50),(2,'Minyak Goreng 2 L','Sembako',38000.00,40),(3,'Gula Pasir 1 kg','Sembako',17500.00,60),(4,'Kopi Bubuk 200 g','Minuman',25000.00,28),(5,'Teh Celup isi 25','Minuman',8500.00,80),(6,'Sabun Mandi','Perlengkapan',4500.00,97),(7,'Mi Instan Goreng','Makanan',3500.00,200);
/*!40000 ALTER TABLE `produk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'praktikum_modul10'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-05 14:30:45
