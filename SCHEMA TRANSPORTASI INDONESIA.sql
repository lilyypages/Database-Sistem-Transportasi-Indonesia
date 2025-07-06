CREATE DATABASE TRANSPORTASIINDO
USE TRANSPORTASIINDO

DROP TABLE IF EXISTS SARANA_TRANSAKSI;
DROP TABLE IF EXISTS RUTE_JADWAL;
DROP TABLE IF EXISTS RUTE_PEMBERHENTIAN;
DROP TABLE IF EXISTS KENDARAAN_SARANA;
DROP TABLE IF EXISTS ASURANSI_PERSON;
DROP TABLE IF EXISTS ASURANSI_KENDARAAN;
DROP TABLE IF EXISTS PENYEDIA_ASURANSI;
DROP TABLE IF EXISTS PELANGGAN_KENDARAAN;
DROP TABLE IF EXISTS JADWAL;
DROP TABLE IF EXISTS RUTE;
DROP TABLE IF EXISTS KENDARAAN;
DROP TABLE IF EXISTS SARANA;
DROP TABLE IF EXISTS TRANSAKSI;
DROP TABLE IF EXISTS PENGELOLA;
DROP TABLE IF EXISTS PELANGGAN;
DROP TABLE IF EXISTS PENYEDIA_TRANSPORTASI;
DROP TABLE IF EXISTS PERUSAHAAN_ASURANSI;
DROP TABLE IF EXISTS PEMBERHENTIAN;
DROP TABLE IF EXISTS PERSON;


CREATE TABLE PERSON (
    NIKPerson VARCHAR(20) PRIMARY KEY,
    NamaPerson VARCHAR(100),
    KontakPerson VARCHAR(50),
    JenisKelaminPerson CHAR(1) CHECK (JenisKelaminPerson IN ('M', 'F')),
    StatusPerson VARCHAR(50),
    AlamatPerson TEXT,
    UsiaPerson INT
);


CREATE TABLE PELANGGAN (
    IdPelanggan VARCHAR(20) PRIMARY KEY,
    NamaPelanggan VARCHAR(100),
    KontakPelanggan VARCHAR(50),
    JenisKelamin CHAR(1) CHECK (JenisKelamin IN ('M', 'F')),
    NIKPerson VARCHAR(20),
    FOREIGN KEY (NIKPerson) REFERENCES PERSON(NIKPerson)
);

CREATE TABLE PENYEDIA_TRANSPORTASI (
    IdPenyedia VARCHAR(20) PRIMARY KEY,
    NamaPenyedia VARCHAR(100),
    KontakPenyedia VARCHAR(50),
    JenisPenyedia VARCHAR(50),
    NIKPerson VARCHAR(20),
    FOREIGN KEY (NIKPerson) REFERENCES PERSON(NIKPerson)
);


CREATE TABLE PENGELOLA (
    IdPengelola VARCHAR(20),
    NamaPengelola VARCHAR(100),
    KontakPengelola VARCHAR(50),
	PosisiPengelola VARCHAR (75), 
	IdPenyedia VARCHAR(20),
    NIKPerson VARCHAR(20),
	PRIMARY KEY (IdPengelola, IdPenyedia), 
    FOREIGN KEY (NIKPerson) REFERENCES PERSON(NIKPerson), 
	FOREIGN KEY (IdPenyedia) REFERENCES PENYEDIA_TRANSPORTASI (IdPenyedia), 
);


CREATE TABLE PERUSAHAAN_ASURANSI (
    IdPerusahaan VARCHAR(20) PRIMARY KEY,
    NamaPerusahaan VARCHAR(100),
    JenisAsuransi VARCHAR(255)
);


CREATE TABLE KENDARAAN (
    IdKendaraan VARCHAR(20) PRIMARY KEY,
    NamaKendaraan VARCHAR(100),
    StatusOperasional VARCHAR(50),
    IdPenyedia VARCHAR(20),
    IdPengelola VARCHAR(20), 
    FOREIGN KEY (IdPenyedia) REFERENCES PENYEDIA_TRANSPORTASI(IdPenyedia),
    FOREIGN KEY (IdPengelola, IdPenyedia) REFERENCES PENGELOLA (IdPengelola, IdPenyedia)
);

CREATE TABLE SARANA (
    IdSarana VARCHAR(20),
    NamaSarana VARCHAR(100),
    KontakSarana VARCHAR(255),
    AlamatSarana TEXT,
    JenisSarana VARCHAR(255),
    WilayahSarana VARCHAR(100),
    FasilitasSarana TEXT,
    IdPengelola VARCHAR(20),
    IdPenyedia VARCHAR(20),
    IdPelanggan VARCHAR(20),
    PRIMARY KEY (IdSarana, IdPengelola, IdPelanggan),
    FOREIGN KEY (IdPengelola, IdPenyedia) REFERENCES PENGELOLA (IdPengelola, IdPenyedia),
    FOREIGN KEY (IdPelanggan) REFERENCES PELANGGAN(IdPelanggan)
);

CREATE TABLE PEMBERHENTIAN (
    IdPemberhentian VARCHAR(75) PRIMARY KEY,
    AlamatPemberhentian TEXT,
    JenisPemberhentian VARCHAR(50)
);

CREATE TABLE TRANSAKSI (
    IdTransaksi VARCHAR(20) PRIMARY KEY,
    TanggalTransaksi DATE,
    Booking VARCHAR(50),
    IdPelanggan VARCHAR(20),
    FOREIGN KEY (IdPelanggan) REFERENCES PELANGGAN(IdPelanggan)
);

CREATE TABLE JADWAL (
    IdJadwal VARCHAR(20),
    IdKendaraan VARCHAR(20),
    IdAsal VARCHAR(75), 
    IdTujuan VARCHAR(75),
    TanggalKeberangkatan DATE,
    TanggalTiba DATE,
    JamKeberangkatan TIME,
    JamKedatangan TIME,
    PRIMARY KEY (IdJadwal, IdKendaraan),
    FOREIGN KEY (IdKendaraan) REFERENCES KENDARAAN(IdKendaraan),
    FOREIGN KEY (IdAsal) REFERENCES PEMBERHENTIAN(IdPemberhentian),
    FOREIGN KEY (IdTujuan) REFERENCES PEMBERHENTIAN(IdPemberhentian)
);

CREATE TABLE RUTE (
    IdRute VARCHAR(20) PRIMARY KEY,
    IdAsal VARCHAR(75) ,
    IdTujuan VARCHAR(75),
    IdKendaraan VARCHAR(20),
    JarakTempuhKM DECIMAL(10, 2),
    EstimasiDurasi VARCHAR(50),   
    FOREIGN KEY (IdAsal) REFERENCES PEMBERHENTIAN(IdPemberhentian),
    FOREIGN KEY (IdTujuan) REFERENCES PEMBERHENTIAN(IdPemberhentian),
    FOREIGN KEY (IdKendaraan) REFERENCES KENDARAAN(IdKendaraan)
);

CREATE TABLE PENYEDIA_ASURANSI (
    IdPenyedia VARCHAR(20),
    IdPerusahaan VARCHAR(20),
    PRIMARY KEY (IdPenyedia, IdPerusahaan),
    FOREIGN KEY (IdPenyedia) REFERENCES PENYEDIA_TRANSPORTASI(IdPenyedia),
    FOREIGN KEY (IdPerusahaan) REFERENCES PERUSAHAAN_ASURANSI(IdPerusahaan)
);

CREATE TABLE ASURANSI_KENDARAAN (
    IdPerusahaan VARCHAR(20),
    IdKendaraan VARCHAR(20),
    PRIMARY KEY (IdPerusahaan, IdKendaraan),
    FOREIGN KEY (IdPerusahaan) REFERENCES PERUSAHAAN_ASURANSI(IdPerusahaan),
    FOREIGN KEY (IdKendaraan) REFERENCES KENDARAAN(IdKendaraan)
);

CREATE TABLE RUTE_PEMBERHENTIAN (
    IdKendaraan VARCHAR(20),
    IdPemberhentian VARCHAR(75),
    PRIMARY KEY (IdKendaraan, IdPemberhentian),
    FOREIGN KEY (IdKendaraan) REFERENCES KENDARAAN(IdKendaraan),
    FOREIGN KEY (IdPemberhentian) REFERENCES PEMBERHENTIAN(IdPemberhentian)
);

CREATE TABLE RUTE_JADWAL (
    IdKendaraan VARCHAR(20),
    IdJadwal VARCHAR(20),
    JalurRute VARCHAR(100),
    IdRute VARCHAR(20),
    IdAsal VARCHAR(75) NOT NULL,
    JarakTempuhKM DECIMAL(10, 2),
    TujuanRute VARCHAR(100),
    EstimasiDurasi VARCHAR(50),
	TarifPerjalanan DECIMAL(10, 2), 
    PRIMARY KEY (IdKendaraan, IdJadwal, IdRute),
    FOREIGN KEY (IdKendaraan) REFERENCES KENDARAAN(IdKendaraan),
    FOREIGN KEY (IdJadwal, IdKendaraan) REFERENCES JADWAL(IdJadwal, IdKendaraan), 
	FOREIGN KEY (IdRute) REFERENCES RUTE(IdRute),
	FOREIGN KEY (IdAsal) REFERENCES PEMBERHENTIAN(IdPemberhentian)
);

