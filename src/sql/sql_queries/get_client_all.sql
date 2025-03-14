DECLARE @NaciniPlacanja TABLE (
                                  sifra TINYINT PRIMARY KEY,
                                  opis NVARCHAR(50)
                              );

INSERT INTO @NaciniPlacanja VALUES
                                (0, N'plaćanje odjednom'),
                                (1, N'godišnje plaćanje'),
                                (2, N'polugodisnje plaćanje'),
                                (4, N'kvartalno plaćanje'),
                                (6, N'mjesecno plaćanje');


DECLARE @ClientPolicies TABLE (
                                  polisa INT PRIMARY KEY
                              );

INSERT INTO @ClientPolicies
SELECT gc.polisa
FROM gr_clients_all gc WITH (NOLOCK)
WHERE gc.[embg/pib] = @id
--AND gc.vkto IN (SELECT vkto FROM dbo.fn_get_user_accessible_vktos(@currentuserID));


DECLARE @PolicyTransactions TABLE (
                                      polisa INT,
                                      pko_wertedatum DATETIME,
                                      pko_betragsoll DECIMAL(18,2),
                                      pko_betraghaben DECIMAL(18,2),
                                      pko_wertedatumsaldo DECIMAL(18,2),
                                      pko_buch_nr INT,
                                      pko_b_art VARCHAR(10),
                                      pko_g_fall VARCHAR(10),
                                      wertedatum DATE,
                                      datum_dokumenta VARCHAR(10),
                                      in_period BIT,
                                      rn INT,
                                      INDEX IX_PolicyTransactions_polisa_rn CLUSTERED (polisa, rn)
                                  );

INSERT INTO @PolicyTransactions
SELECT
    pk.pko_obnr AS polisa,
    pk.pko_wertedatum,
    pk.pko_betragsoll,
    pk.pko_betraghaben,
    pk.pko_wertedatumsaldo,
    pk.pko_buch_nr,
    pk.pko_b_art,
    pk.pko_g_fall,
    CONVERT(DATE, pk.pko_wertedatum, 104) AS wertedatum,
    CONVERT(VARCHAR(10), pk.pko_wertedatum, 104) AS datum_dokumenta,
    CASE WHEN pk.pko_wertedatum BETWEEN @dateFrom AND @dateTo THEN 1 ELSE 0 END AS in_period,
    ROW_NUMBER() OVER (PARTITION BY pk.pko_obnr ORDER BY pk.pko_wertedatum DESC, pk.pko_buch_nr DESC) AS rn
FROM praemienkonto pk WITH (NOLOCK)
INNER JOIN @ClientPolicies cp ON pk.pko_obnr = cp.polisa
WHERE pk.pko_wertedatum <= @dateTo;


DECLARE @LastBalance TABLE (
                               polisa INT PRIMARY KEY,
                               dospjela_potrazivanja DECIMAL(18,2)
                           );

INSERT INTO @LastBalance
SELECT
    polisa,
    pko_wertedatumsaldo * -1 AS dospjela_potrazivanja
FROM @PolicyTransactions
WHERE rn = 1;


DECLARE @PolicyFinancials TABLE (
                                    polisa INT PRIMARY KEY,
                                    ukupno_zaduzeno DECIMAL(18,2),
                                    ukupno_placeno DECIMAL(18,2)
                                );

INSERT INTO @PolicyFinancials
SELECT
    polisa,
    SUM(pko_betragsoll) AS ukupno_zaduzeno,
    SUM(pko_betraghaben) AS ukupno_placeno
FROM @PolicyTransactions
GROUP BY polisa;


DECLARE @ClientInfo TABLE (
                              polisa INT ,
                              klijent NVARCHAR(100),
                              datum_rodjenja DATE,
                              [embg/pib] VARCHAR(20),
                              adresa NVARCHAR(100),
                              mjesto NVARCHAR(50),
                              telefon1 VARCHAR(20),
                              telefon2 VARCHAR(20),
                              email VARCHAR(100),
                              pocetak_osiguranja DATE,
                              istek_osiguranja DATE,
                              datum_storna DATE,
                              bruto_polisirana_premija DECIMAL(18,2),
                              neto_polisirana_premija DECIMAL(18,2),
                              nacin_placanja NVARCHAR(50),
                              nacin_placanja_sifra TINYINT,
                              naziv_branse VARCHAR(100),
                              bransa INT,
                              storno_tip VARCHAR(10),
                              status_polise VARCHAR(50),
                              broj_ponude INT
                          );


DECLARE @klijent_bruto_polisirana_premija DECIMAL(18,2) = 0;
DECLARE @klijent_neto_polisirana_premija DECIMAL(18,2) = 0;
DECLARE @klijent_dospjela_potrazivanja DECIMAL(18,2) = 0;

INSERT INTO @ClientInfo
SELECT DISTINCT
    gc.polisa,
    gc.klijent,
    gc.datum_rodjenja,
    gc.[embg/pib],
    gc.adresa,
    gc.mjesto,
    gc.telefon1,
    gc.telefon2,
    gc.email,
    gc.pocetak_osiguranja,
    gc.istek_osiguranja,
    gc.datum_storna,
    CAST(dbo.Bruto_polisirana_premija_polisa(gc.polisa, @dateTo) AS DECIMAL(18,2)) AS bruto_polisirana_premija,
    CAST(dbo.Neto_polisirana_premija_polisa(gc.polisa, @dateTo) AS DECIMAL(18,2)) AS neto_polisirana_premija,
    np.opis AS nacin_placanja,
    np.sifra AS nacin_placanja_sifra,
    b.bra_vv_ueb AS naziv_branse,
    gc.bransa AS bransa,
    b.bra_storno_grund AS storno_tip,
    gc.status_polise,
    CASE
        WHEN b.bra_bran IN (10,19,56) OR (b.bra_bran=9 AND b.bra_statistik_nr=11040)
            THEN v.vtg_antrag_obnr
        ELSE 0
        END AS broj_ponude
FROM gr_clients_all gc WITH (NOLOCK)
         JOIN branche b WITH (NOLOCK) ON b.bra_obnr = gc.polisa
         JOIN vertrag v WITH (NOLOCK) ON b.bra_vertragid = v.vtg_vertragid
         JOIN @NaciniPlacanja np ON np.sifra = v.vtg_zahlungsweise
WHERE gc.[embg/pib] = @id
  AND EXISTS (
    SELECT 1 FROM @PolicyTransactions pt
    WHERE pt.polisa = b.bra_obnr
      AND (pt.in_period = 1 OR pt.pko_wertedatumsaldo <> 0)
);


SELECT
    @klijent_bruto_polisirana_premija = SUM(bruto_polisirana_premija),
    @klijent_neto_polisirana_premija = SUM(neto_polisirana_premija)
FROM @ClientInfo;

SELECT
    @klijent_dospjela_potrazivanja = SUM(
            CASE
                WHEN ci.bruto_polisirana_premija - ISNULL(pf.ukupno_placeno, 0) < 0
                    OR ISNULL(lb.dospjela_potrazivanja, 0) < 0
                    THEN 0
                ELSE ISNULL(lb.dospjela_potrazivanja, 0)
                END
                                     )
FROM @ClientInfo ci
         LEFT JOIN @LastBalance lb ON ci.polisa = lb.polisa
         LEFT JOIN @PolicyFinancials pf ON ci.polisa = pf.polisa;


SELECT
    ci.*,
    CAST(0 AS INT) AS dani_kasnjenja,
    CASE
        WHEN ci.bruto_polisirana_premija - ISNULL(pf.ukupno_placeno, 0) < 0
            THEN 0
        ELSE ci.bruto_polisirana_premija - ISNULL(pf.ukupno_placeno, 0)
        END AS ukupna_potrazivanja,
    ISNULL(lb.dospjela_potrazivanja, 0) AS dospjela_potrazivanja,
    ISNULL(pf.ukupno_placeno, 0) AS uplacena_premija,
    @klijent_bruto_polisirana_premija AS klijent_bruto_polisirana_premija,
    @klijent_neto_polisirana_premija AS klijent_neto_polisirana_premija,
    0 AS klijent_dani_kasnjenja,
    @klijent_dospjela_potrazivanja AS klijent_dospjela_potrazivanja,
    '-' AS klijent_status_polise,
    pt.pko_buch_nr,
    pt.datum_dokumenta,
    pt.pko_betragsoll AS duguje,
    pt.pko_betraghaben AS potrazuje,
    pt.pko_wertedatumsaldo * -1 AS saldo,
    pt.pko_b_art AS trangrupa1,
    pt.pko_g_fall AS trangrupa2
FROM @ClientInfo ci
         LEFT JOIN @LastBalance lb ON ci.polisa = lb.polisa
         LEFT JOIN @PolicyFinancials pf ON ci.polisa = pf.polisa
         LEFT JOIN @PolicyTransactions pt ON ci.polisa = pt.polisa AND pt.in_period = 1
ORDER BY ci.polisa, pt.datum_dokumenta, pt.pko_buch_nr;