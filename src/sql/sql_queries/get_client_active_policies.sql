SELECT DISTINCT a.polisa
FROM gr_clients_all a WITH (NOLOCK)
INNER JOIN praemienkonto pk WITH (NOLOCK) ON pk.pko_obnr = a.polisa
WHERE a.[embg/pib] = @id
AND (
    (pk.pko_wertedatum BETWEEN @dateFrom AND @dateTo) 
    OR EXISTS (
        SELECT 1 
        FROM praemienkonto p WITH (NOLOCK)
        WHERE p.pko_obnr = a.polisa
        AND p.pko_wertedatum <= @dateTo
        AND p.pko_wertedatumsaldo <> 0
    )
)
--AND a.vkto IN (SELECT vkto FROM dbo.fn_get_user_accessible_vktos(@currentuserID))