
DECLARE @ClientPolicies TABLE (
                                  polisa int PRIMARY KEY,
                                  status_polise VARCHAR(50),
                                  dani_kasnjenja INT
                              );

INSERT INTO @ClientPolicies
SELECT
    gc.polisa,
    gc.status_polise,
    0 AS dani_kasnjenja
FROM gr_clients_all gc WITH (NOLOCK)
JOIN vertrag v WITH (NOLOCK) ON gc.polisa = v.vtg_obnr
WHERE gc.[embg/pib] = @id
--AND gc.vkto IN (SELECT vkto FROM dbo.fn_get_user_accessible_vktos(@currentUserID))



DECLARE @LastBalance TABLE (
                               polisa int,
                               dospjela_potrazivanja DECIMAL(18,2),
                               ukupno_zaduzeno DECIMAL(18,2),
                               ukupno_placeno DECIMAL(18,2),
                               dani_kasnjenja INT,
                               status_polise VARCHAR(50)
                           );

INSERT INTO @LastBalance
SELECT
    p.pko_obnr AS polisa,
    p.pko_wertedatumsaldo * -1 AS dospjela_potrazivanja,
    SUM(p.pko_betragsoll) AS ukupno_zaduzeno,
    SUM(p.pko_betraghaben) AS ukupno_placeno,
    MAX(cp.dani_kasnjenja) AS dani_kasnjenja,
    MAX(cp.status_polise) AS status_polise
FROM praemienkonto p WITH (NOLOCK)
         JOIN @ClientPolicies cp ON p.pko_obnr = cp.polisa
WHERE p.pko_wertedatum <= @dateTo
  -- Join to get only the latest date for each policy
  AND p.pko_wertedatum = (
    SELECT MAX(p2.pko_wertedatum)
    FROM praemienkonto p2 WITH (NOLOCK)
    WHERE p2.pko_obnr = p.pko_obnr
      AND p2.pko_wertedatum <= @dateTo
)
GROUP BY p.pko_obnr, p.pko_wertedatumsaldo;


-- Final query
IF EXISTS (SELECT 1 FROM @LastBalance)
    BEGIN
        SELECT
            SUM(dbo.Bruto_polisirana_premija_polisa(polisa, @dateTo)) AS klijent_bruto_polisirana_premija,
            SUM(dbo.Neto_polisirana_premija_polisa(polisa, @dateTo)) AS klijent_neto_polisirana_premija,
            SUM(dospjela_potrazivanja) AS klijent_dospjela_potrazivanja,
            SUM(0) AS klijent_ukupna_potrazivanja,
            MAX(dani_kasnjenja) dani_kasnjenja,
            MAX(status_polise) status_polise
        FROM @LastBalance;
    END
ELSE
    BEGIN
        -- Return empty result with correct structure
        SELECT
            CAST(NULL AS DECIMAL(18,2)) AS klijent_bruto_polisirana_premija,
            CAST(NULL AS DECIMAL(18,2)) AS klijent_neto_polisirana_premija,
            CAST(NULL AS DECIMAL(18,2)) AS klijent_dospjela_potrazivanja,
            CAST(NULL AS DECIMAL(18,2)) AS klijent_ukupna_potrazivanja,
            CAST(NULL AS INT) AS dani_kasnjenja,
            CAST(NULL AS VARCHAR(50)) AS status_polise
        WHERE 1 = 0;
    END