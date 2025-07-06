USE TRANSPORTASIINDO;

--- Query untuk Menampilkan Jadwal Perjalanan Lengkap dengan Rute
SELECT 
    k.NamaKendaraan,
    j.IdJadwal,
    p_asal.JenisPemberhentian AS Asal,
    p_tujuan.JenisPemberhentian AS Tujuan,
    j.TanggalKeberangkatan,
    j.JamKeberangkatan,
    j.TanggalTiba,
    j.JamKedatangan,
    r.JarakTempuhKM,
    r.EstimasiDurasi
FROM 
    JADWAL j
JOIN 
    KENDARAAN1 k ON j.IdKendaraan = k.IdKendaraan
JOIN 
    PEMBERHENTIAN p_asal ON j.IdAsal = p_asal.IdPemberhentian
JOIN 
    PEMBERHENTIAN p_tujuan ON j.IdTujuan = p_tujuan.IdPemberhentian
JOIN 
    RUTE r ON j.IdKendaraan = r.IdKendaraan 
    AND j.IdAsal = r.IdAsal 
    AND j.IdTujuan = r.IdTujuan;

----Query untuk Analisis Kinerja Penyedia Transportasi
SELECT 
    pt.NamaPenyedia,
    COUNT(DISTINCT k.IdKendaraan) AS JumlahKendaraan,
    COUNT(j.IdJadwal) AS JumlahPerjalanan,
    SUM(r.JarakTempuhKM) AS TotalJarakTempuh,
    AVG(r.JarakTempuhKM) AS RataRataJarakPerjalanan
FROM 
    PENYEDIA_TRANSPORTASI pt
LEFT JOIN 
    KENDARAAN1 k ON pt.IdPenyedia = k.IdPenyedia
LEFT JOIN 
    JADWAL j ON k.IdKendaraan = j.IdKendaraan
LEFT JOIN 
    RUTE r ON j.IdKendaraan = r.IdKendaraan 
    AND j.IdAsal = r.IdAsal 
    AND j.IdTujuan = r.IdTujuan
GROUP BY 
    pt.NamaPenyedia
ORDER BY 
    JumlahPerjalanan DESC;

--- Query untuk Pelacakan Transaksi Pelanggan
SELECT 
    pg.NamaPelanggan,
    pg.KontakPelanggan,
    t.IdTransaksi,
    t.TanggalTransaksi,
    t.Booking,
    COUNT(*) OVER (PARTITION BY pg.IdPelanggan) AS TotalTransaksi
FROM 
    TRANSAKSI t
JOIN 
    PELANGGAN pg ON t.IdPelanggan = pg.IdPelanggan
ORDER BY 
    t.TanggalTransaksi DESC;

---- Query untuk Manajemen Asuransi Kendaraan
SELECT 
    k.NamaKendaraan,
    k.StatusOperasional,
    pt.NamaPenyedia,
    pa.NamaPerusahaan AS PerusahaanAsuransi,
    pa.JenisAsuransi
FROM 
    KENDARAAN1 k
JOIN 
    PENYEDIA_TRANSPORTASI pt ON k.IdPenyedia = pt.IdPenyedia
JOIN 
    ASURANSI_KENDARAAN ak ON k.IdKendaraan = ak.IdKendaraan
JOIN 
    PERUSAHAAN_ASURANSI pa ON ak.IdPerusahaan = pa.IdPerusahaan
ORDER BY 
    pt.NamaPenyedia, k.NamaKendaraan;

---- Query untuk Analisis Rute dan Pemberhentian
SELECT 
    r.IdRute,
    p_asal.JenisPemberhentian AS TitikAsal,
    p_tujuan.JenisPemberhentian AS TitikTujuan,
    COUNT(rj.IdJadwal) AS FrekuensiPerjalanan,
    GROUP_CONCAT(DISTINCT rp.IdPemberhentian ORDER BY rp.IdPemberhentian SEPARATOR ', ') AS TitikPemberhentian
FROM 
    RUTE r
JOIN 
    PEMBERHENTIAN p_asal ON r.IdAsal = p_asal.IdPemberhentian
JOIN 
    PEMBERHENTIAN p_tujuan ON r.IdTujuan = p_tujuan.IdPemberhentian
LEFT JOIN 
    RUTE_JADWAL rj ON r.IdRute = rj.IdRute
LEFT JOIN 
    RUTE_PEMBERHENTIAN rp ON r.IdKendaraan = rp.IdKendaraan
GROUP BY 
    r.IdRute, p_asal.JenisPemberhentian, p_tujuan.JenisPemberhentian
ORDER BY 
    FrekuensiPerjalanan DESC;

--- Query untuk Laporan Penggunaan Kendaraan
SELECT 
    k.NamaKendaraan,
    k.StatusOperasional,
    COUNT(j.IdJadwal) AS JumlahPerjalanan,
    MIN(j.TanggalKeberangkatan) AS PerjalananPertama,
    MAX(j.TanggalKeberangkatan) AS PerjalananTerakhir,
    SUM(r.JarakTempuhKM) AS TotalJarakTempuh
FROM 
    KENDARAAN k
LEFT JOIN 
    JADWAL j ON k.IdKendaraan = j.IdKendaraan
LEFT JOIN 
    RUTE r ON j.IdKendaraan = r.IdKendaraan 
    AND j.IdAsal = r.IdAsal 
    AND j.IdTujuan = r.IdTujuan
GROUP BY 
    k.NamaKendaraan, k.StatusOperasional
ORDER BY 
    TotalJarakTempuh DESC;

	-- Menampilkan informasi pelanggan beserta detail person mereka
SELECT
    P.NamaPerson,
    P.KontakPerson,
    P.AlamatPerson,
    PL.NamaPelanggan,
    PL.KontakPelanggan
FROM
    PERSON AS P
JOIN
    PELANGGAN AS PL ON P.NIKPerson = PL.NIKPerson;

-- Menampilkan kendaraan beserta penyedia transportasinya
SELECT
    K.NamaKendaraan,
    K.StatusOperasional,
    PT.NamaPenyedia,
    PT.JenisPenyedia
FROM
    KENDARAAN AS K
JOIN
    PENYEDIA_TRANSPORTASI AS PT ON K.IdPenyedia = PT.IdPenyedia;

-- Menampilkan jadwal perjalanan dengan informasi asal dan tujuan pemberhentian
SELECT
    J.IdJadwal,
    K.NamaKendaraan,
    PA.AlamatPemberhentian AS Asal,
    PT.AlamatPemberhentian AS Tujuan,
    J.TanggalKeberangkatan,
    J.JamKeberangkatan,
    J.JamKedatangan
FROM
    JADWAL AS J
JOIN
    KENDARAAN AS K ON J.IdKendaraan = K.IdKendaraan
JOIN
    PEMBERHENTIAN AS PA ON J.IdAsal = PA.IdPemberhentian
JOIN
    PEMBERHENTIAN AS PT ON J.IdTujuan = PT.IdPemberhentian;

-- Menampilkan rute perjalanan beserta detail asal dan tujuan
SELECT
    R.IdRute,
    KA.NamaKendaraan,
    PA.AlamatPemberhentian AS AsalRute,
    PT.AlamatPemberhentian AS TujuanRute,
    R.JarakTempuhKM,
    R.EstimasiDurasi
FROM
    RUTE AS R
JOIN
    KENDARAAN AS KA ON R.IdKendaraan = KA.IdKendaraan
JOIN
    PEMBERHENTIAN AS PA ON R.IdAsal = PA.IdPemberhentian
JOIN
    PEMBERHENTIAN AS PT ON R.IdTujuan = PT.IdPemberhentian;

-- Menampilkan pengelola beserta penyedia transportasi dan detail person mereka
SELECT
    PGL.NamaPengelola,
    PGL.PosisiPengelola,
    PT.NamaPenyedia,
    PS.NamaPerson,
    PS.KontakPerson
FROM
    PENGELOLA3 AS PGL
JOIN
    PENYEDIA_TRANSPORTASI AS PT ON PGL.IdPenyedia = PT.IdPenyedia
JOIN
    PERSON AS PS ON PGL.NIKPerson = PS.NIKPerson;

-- Menampilkan sarana beserta informasi pengelola dan pelanggannya
SELECT
    S.NamaSarana,
    S.JenisSarana,
    S.WilayahSarana,
    PGL.NamaPengelola,
    PL.NamaPelanggan
FROM
    SARANA AS S
JOIN
    PENGELOLA3 AS PGL ON S.IdPengelola = PGL.IdPengelola
JOIN
    PELANGGAN AS PL ON S.IdPelanggan = PL.IdPelanggan;

-- Menampilkan informasi asuransi kendaraan: nama perusahaan asuransi dan kendaraan yang diasuransikan
SELECT
    PA.NamaPerusahaan,
    K.NamaKendaraan
FROM
    ASURANSI_KENDARAAN AS AK
JOIN
    PERUSAHAAN_ASURANSI AS PA ON AK.IdPerusahaan = PA.IdPerusahaan
JOIN
    KENDARAAN AS K ON AK.IdKendaraan = K.IdKendaraan;

-- Menampilkan rute jadwal dengan detail rute dan jadwal
SELECT
    RJ.JalurRute,
    RJ.JarakTempuhKM,
    RJ.EstimasiDurasi,
    J.TanggalKeberangkatan,
    J.JamKeberangkatan,
    R.EstimasiDurasi AS DurasiRuteUtama
FROM
    RUTE_JADWAL AS RJ
JOIN
    JADWAL AS J ON RJ.IdJadwal = J.IdJadwal AND RJ.IdKendaraan = J.IdKendaraan
JOIN
    RUTE AS R ON RJ.IdRute = R.IdRute;

