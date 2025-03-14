
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


SELECT
    convert(varchar,pko_wertedatum,104) as datum_dokumenta,
    pko_obnr as polisa,
    pko_praemienkontoid as broj_dokumenta,
    pko_obnr as broj_ponude,
    pko_b_art as vid,
    pko_g_fall as opis_knjizenja,
    pko_betragsoll as duguje,
    pko_betraghaben as potrazuje,
    pko_wertedatumsaldo as saldo
FROM praemienkonto (nolock)
         JOIN @ClientPolicies ca ON ca.polisa = praemienkonto.pko_obnr
WHERE pko_wertedatum BETWEEN @dateFrom AND @dateTo
ORDER BY pko_obnr, pko_wertedatum ASC, pko_buch_nr ASC
