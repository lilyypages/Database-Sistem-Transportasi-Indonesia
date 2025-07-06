
-- Detail perjalanan dari titik rute a ke b, beda pulau, beda, berikan rute perjalanan dan Rute dan jadwal dan Ada perjalanan a ke b, berikan rute dan jadwal, total biaya yang di perlukan

WITH PerjalananGabungan AS (
    SELECT
        rj.IdKendaraan,
        k.NamaKendaraan AS JenisTransportasi,
        rj.IdJadwal,
        j.TanggalKeberangkatan,
        j.JamKeberangkatan,
        j.TanggalTiba,
        j.JamKedatangan,
        rj.IdRute,
        p_asal.AlamatPemberhentian AS LokasiAsal,
        p_tujuan.AlamatPemberhentian AS LokasiTujuan,
        rj.JarakTempuhKM,
        rj.EstimasiDurasi,
        rj.TarifPerjalanan,
        CAST(SUBSTRING(rj.EstimasiDurasi, 1, 2) AS INT) * 60 +
        CAST(SUBSTRING(rj.EstimasiDurasi, 4, 2) AS INT) AS DurasiMenit
    FROM
        RUTE_JADWAL rj
    JOIN
        KENDARAAN k ON rj.IdKendaraan = k.IdKendaraan
    JOIN
        JADWAL j ON rj.IdJadwal = j.IdJadwal AND rj.IdKendaraan = j.IdKendaraan
    JOIN
        RUTE r ON rj.IdRute = r.IdRute 
	JOIN 
	PEMBERHENTIAN p_asal ON r.IdAsal = p_asal.IdPemberhentian
	JOIN 
	PEMBERHENTIAN p_tujuan ON r.IdTujuan = p_tujuan.IdPemberhentian

    WHERE
        
        (rj.IdKendaraan = 'K07' AND rj.IdJadwal = 'J016') 
        OR
        (rj.IdKendaraan = 'K32' AND rj.IdJadwal = 'J035') 
        OR
        (rj.IdKendaraan = 'K33' AND rj.IdJadwal = 'J036') 
)
SELECT
    'Detail Segmen Perjalanan' AS TipeOutput,
    pg.IdKendaraan,
    pg.JenisTransportasi,
    pg.IdJadwal,
    pg.TanggalKeberangkatan,
    pg.JamKeberangkatan,
    pg.TanggalTiba,
    pg.JamKedatangan,
    pg.IdRute,
    pg.LokasiAsal,
    pg.LokasiTujuan,
    pg.JarakTempuhKM,
    pg.EstimasiDurasi,
    pg.TarifPerjalanan
FROM
    PerjalananGabungan pg

UNION ALL

SELECT
    'Total Perjalanan Keseluruhan' AS TipeOutput,
    NULL AS IdKendaraan,
    'Kombinasi Transportasi' AS JenisTransportasi,
    NULL AS IdJadwal,
    NULL AS TanggalKeberangkatan,
    NULL AS JamKeberangkatan,
    NULL AS TanggalTiba,
    NULL AS JamKedatangan,
    NULL AS IdRute,
    'Total Jarak & Durasi' AS LokasiAsal,
    'Total Biaya' AS LokasiTujuan,
    SUM(pg.JarakTempuhKM) AS TotalJarakKM,
    -- Konversi total menit kembali ke format HH:MM
    RIGHT('0' + CAST(SUM(pg.DurasiMenit) / 60 AS VARCHAR(2)), 2) + ':' +
    RIGHT('0' + CAST(SUM(pg.DurasiMenit) % 60 AS VARCHAR(2)), 2) AS TotalEstimasiDurasi,
    SUM(pg.TarifPerjalanan) AS TotalBiayaPerjalanan
FROM
    PerjalananGabungan pg;