/*
DECLARE
@id VARCHAR(20) = '02020220',
    @dateFrom DATE = '2024.01.01',
    @dateTo DATE = '2025.01.01',
    @userID int = 1,
    @ZK int = 1,
    @AO int = 1;
*/


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



DECLARE @YearStartDate DATE = DATEFROMPARTS(YEAR(@dateFrom), 1, 1);
DECLARE @YearStartString VARCHAR(20) = '01.01.' + CAST(YEAR(@dateFrom) AS VARCHAR(4));



if OBJECT_ID('tempdb..#ClientPolicies') is not null
drop table #ClientPolicies

SELECT
    gc.polisa													polisa,
    gc.pocetak_osiguranja										datum_dokumenta,
    dbo.Bruto_polisirana_premija_polisa(bra_obnr,@dateTo)		zaduzeno,
    0															uplaceno,
    gc.bransa													bransa,
    case when bra_bran in (10,19,56) or (bra_bran=9 and bra_statistik_nr=11040)
             then vtg_antrag_obnr
         else 0 end 													[broj_ponude],
bra_statistik_nr											bra_statistik_nr,
bra_vertragid												bra_vertragid
INTO #ClientPolicies
FROM gr_clients_all gc WITH (NOLOCK)
    JOIN vertrag v ON gc.polisa = v.vtg_obnr
    JOIN branche b WITH (NOLOCK) ON b.bra_obnr = gc.polisa
WHERE gc.[embg/pib] = @id
--AND gc.vkto IN (SELECT vkto FROM dbo.fn_get_user_accessible_vktos(@userID))
AND 1= case when @ZK = 1 then 1 else case when bransa=19 then 0 else 1 end end
AND 1= case when @AO = 1 then 1 else case when bransa=10 and vtg_pol_kreis<>97 then 0 else 1 end end


if OBJECT_ID('tempdb..#ClientTransactions') is not null
drop table #ClientTransactions


CREATE TABLE #ClientTransactions  (
                                      polisa INT,
                                      pko_praemienkontoid INT,
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
                                      INDEX IX_PolicyTransactions_polisa_rn CLUSTERED (pko_wertedatum ASC, pko_praemienkontoid ASC)
);


INSERT INTO #ClientTransactions
SELECT
    pk.pko_obnr AS polisa,
    pko_praemienkontoid,
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
    ROW_NUMBER() OVER (PARTITION BY pko_obnr ORDER BY pk.pko_wertedatum ASC, pk.pko_buch_nr ASC) AS rn
FROM praemienkonto pk WITH (NOLOCK)
INNER JOIN #ClientPolicies cp ON pk.pko_obnr = cp.polisa
WHERE pk.pko_wertedatum <= @dateTo;



IF OBJECT_ID('tempdb..#ActivePolicies') IS NOT NULL
DROP TABLE #ActivePolicies;

SELECT
    cp.polisa,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM #ClientTransactions ct
            WHERE ct.polisa = cp.polisa
              AND ct.pko_wertedatum BETWEEN @dateFrom AND @dateTo
        ) THEN 1
        WHEN isnull(cast(((select top 1 p.pko_wertedatumsaldo  from #ClientTransactions p (nolock) where pko_wertedatum <= @dateTo and p.polisa=cp.polisa order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0) <> 0
            THEN 1
        ELSE 0
        END AS is_active
INTO #ActivePolicies
FROM #ClientPolicies cp;





DECLARE @FinalData TABLE (
    id INT,
    datum_dokumenta DATETIME,
    broj_dokumenta INT,
    broj_ponude INT,
    zaduzeno DECIMAL(18,2),
    uplaceno DECIMAL(18,2)
);





SELECT DISTINCT
    ROW_NUMBER() OVER ( ORDER BY datum_dokumenta asc, broj_dokumenta, zaduzeno desc, rn asc) id,
        CONVERT(VARCHAR,datum_dokumenta,104) datum_dokumenta,
    broj_dokumenta,
    broj_ponude,
    zaduzeno,
    uplaceno,
    SUM(cast(zaduzeno-uplaceno as decimal(18,2))) OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta,rn) saldo,
    convert(varchar,@dateFrom,104) datum_od,
    convert(varchar,@dateTo,104)  datum_do
FROM
    (

        SELECT
            0 as pko_praemienkontoid,
            CASE WHEN cp.datum_dokumenta < @dateFrom then @YearStartString else cp.datum_dokumenta end datum_dokumenta,
            cp.polisa AS broj_dokumenta,
            cp.broj_ponude,
            dbo.Bruto_polisirana_premija_polisa(cp.polisa,@dateTo) AS zaduzeno,
            0 AS uplaceno,
            0 as rn
        FROM #ClientPolicies cp
                 JOIN #ActivePolicies ap ON cp.polisa = ap.polisa
        WHERE ap.is_active = 1

        UNION

        SELECT
            ct.pko_praemienkontoid,
            case when ct.pko_wertedatum <= @YearStartDate then @YearStartString else ct.pko_wertedatum end AS datum_dokumenta,
            cp.polisa AS broj_dokumenta,
            cp.broj_ponude,
            0 AS zaduzeno,
            ct.pko_betraghaben AS uplaceno,
            ct.rn
        FROM #ClientPolicies cp
                 JOIN #ActivePolicies ap ON cp.polisa = ap.polisa
                 JOIN #ClientTransactions ct ON ct.polisa = cp.polisa
        WHERE ap.is_active = 1
          AND ct.pko_betraghaben <> 0
          AND cp.datum_dokumenta <= @dateFrom


        UNION


        SELECT
            ct.pko_praemienkontoid,
            ct.pko_wertedatum AS datum_dokumenta,
            cp.polisa AS broj_dokumenta,
            cp.broj_ponude,
            0 AS zaduzeno,
            ct.pko_betraghaben AS uplaceno,
            ct.rn
        FROM #ClientPolicies cp
                 JOIN #ActivePolicies ap ON cp.polisa = ap.polisa
                 JOIN #ClientTransactions ct ON ct.polisa = cp.polisa
        WHERE ap.is_active = 1
          AND ct.pko_wertedatum between @dateFrom and @dateTo
          AND ct.pko_betraghaben <> 0
          AND cp.datum_dokumenta > @dateFrom

    ) AS FinancialHistrory
ORDER BY ID