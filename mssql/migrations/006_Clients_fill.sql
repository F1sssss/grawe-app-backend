USE [GRAWE_DEV]
GO

SET QUOTED_IDENTIFIER ON
GO


DROP TABLE IF EXISTS gr_clients_all;

CREATE TABLE gr_clients_all (
    id INT IDENTITY(1,1) PRIMARY KEY,
    klijent NVARCHAR(255),
    [embg/pib] VARCHAR(50),
    polisa INT,
    datum_rodjenja DATE NULL,
    adresa NVARCHAR(255),
    mjesto NVARCHAR(100),
    telefon1 VARCHAR(50),
    telefon2 VARCHAR(50),
    email VARCHAR(100),
    -- Additional fields for faster client retrieval
    pocetak_osiguranja DATE NULL,
    istek_osiguranja DATE NULL,
    datum_storna DATE NULL,
    bransa INT,
    storno_tip NVARCHAR(50),
    status_polise NVARCHAR(50),
	vkto INT,
    -- Timestamps for maintenance
    last_updated DATETIME DEFAULT GETDATE()
);


-- Populate the gr_clients_all table with an optimized insert
INSERT INTO gr_clients_all (klijent, [embg/pib], polisa, datum_rodjenja, adresa, mjesto, telefon1, telefon2, email, pocetak_osiguranja, istek_osiguranja, datum_storna, bransa, storno_tip, status_polise, VKTO)
SELECT DISTINCT
    kun_zuname + ' ' + ISNULL(kun_vorname,'') AS klijent,
    CASE 
        WHEN kun_steuer_nr IS NOT NULL AND kun_steuer_nr <> '' THEN CAST(kun_steuer_nr AS VARCHAR)
        ELSE CASE 
            WHEN LEN(FORMAT(kun_yu_persnr, '0')) = 12 THEN '0' + FORMAT(kun_yu_persnr, '0')
            ELSE FORMAT(kun_yu_persnr, '0') 
        END
    END AS [embg/pib],
    b.bra_obnr AS polisa,
    kun_geburtsdatum AS datum_rodjenja,
    ISNULL(v.vtg_grund_adresse,'') AS adresa,
    ISNULL(v.vtg_grund_postort,'') AS mjesto,
    ISNULL(k.kun_telefon_1,'') AS telefon1,
    ISNULL(ISNULL(k.kun_tele_mobil_1, k.kun_tele_mobil_2),'') AS telefon2,
    ISNULL(kun_e_mail,'') AS email,
    CONVERT(DATE, bra_vers_beginn) AS pocetak_osiguranja,
    CONVERT(DATE, bra_vers_ablauf) AS istek_osiguranja,
    CONVERT(DATE, bra_storno_ab) AS datum_storna,
    bra_bran AS bransa,
    bra_storno_grund AS storno_tip,
    CASE 
        WHEN ISNULL(bra_storno_ab, '9999-12-31') > GETDATE() AND ISNULL(bra_vers_ablauf, '9999-12-31') > GETDATE() THEN 'Aktivna'
        WHEN ISNULL(bra_storno_ab,'') = ISNULL(bra_vers_beginn,'') THEN 'Stornirana od pocetka'
        WHEN ISNULL(bra_storno_ab,'') > ISNULL(bra_vers_beginn,'') AND ISNULL(bra_storno_ab,'') < ISNULL(bra_vers_ablauf,'') THEN 'Prekid'
        ELSE 'Istekla'
    END AS status_polise,
	vtg_pol_vkto VKTO
FROM kunde k (NOLOCK)
LEFT JOIN vertrag v (NOLOCK) ON k.kun_kundenkz = v.vtg_kundenkz_1
LEFT JOIN branche b (NOLOCK) ON b.bra_vertragid = v.vtg_vertragid
WHERE b.bra_obnr IS NOT NULL
AND EXISTS (SELECT 1 FROM vertrag v2 WHERE v2.vtg_pol_bran = b.bra_bran AND v2.vtg_vertragid = b.bra_vertragid);


-- Create efficient indexes for gr_clients_all table
CREATE UNIQUE NONCLUSTERED INDEX IX_gr_clients_all_embg_pib_polisa
    ON gr_clients_all ([embg/pib], polisa)
    WHERE polisa IS NOT NULL;

CREATE NONCLUSTERED INDEX IX_gr_clients_all_embg_pib_include
    ON gr_clients_all ([embg/pib])
    INCLUDE (klijent, datum_rodjenja, adresa, mjesto, telefon1, telefon2, email);

CREATE NONCLUSTERED INDEX IX_gr_clients_all_polisa
    ON gr_clients_all (polisa)
    INCLUDE (klijent, [embg/pib], status_polise);