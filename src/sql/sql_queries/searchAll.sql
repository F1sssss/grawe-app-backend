/*
select distinct
kun_zuname + ' ' + isnull(kun_vorname,'') [klijent],
case when kun_vorname is null then cast(kun_steuer_nr as varchar) else case when len(FORMAT(kun_yu_persnr, '0'))=12 then '0' + FORMAT(kun_yu_persnr, '0') else FORMAT(kun_yu_persnr, '0') end end [embg/pib],
isnull(bra_obnr,'') [polisa]
from branche b (nolock)
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
right join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1

*/

/*
WITH CTE_Kunde AS (
    SELECT
        k.kun_kundenkz,
        k.kun_zuname,
        k.kun_vorname,
        k.kun_steuer_nr,
        k.kun_yu_persnr,
		CASE
        WHEN k.kun_vorname IS NULL THEN CAST(k.kun_steuer_nr AS VARCHAR)
        ELSE CASE
            WHEN LEN(FORMAT(k.kun_yu_persnr, '0')) = 12 THEN '0' + FORMAT(k.kun_yu_persnr, '0')
            ELSE FORMAT(k.kun_yu_persnr, '0')
        END     END AS [embg/pib]
    FROM
        kunde k (NOLOCK)
    GROUP BY
        k.kun_kundenkz,
        k.kun_zuname,
        k.kun_vorname,
        k.kun_steuer_nr,
        k.kun_yu_persnr
),
CTE_Vertrag AS (
    SELECT
        v.vtg_vertragid,
        v.vtg_kundenkz_1
    FROM
        vertrag v (NOLOCK)
    GROUP BY
        v.vtg_vertragid,
        v.vtg_kundenkz_1
),
CTE_Branche AS (
    SELECT
        b.bra_vertragid,
        b.bra_obnr
    FROM
        branche b (NOLOCK)
    GROUP BY
        b.bra_vertragid,
        b.bra_obnr
)
SELECT
    k.kun_zuname + ' ' + ISNULL(k.kun_vorname, '') AS [klijent],
    [embg/pib],
    ISNULL(b.bra_obnr, '') AS [polisa]
FROM
    CTE_Kunde k
JOIN
    CTE_Vertrag v ON k.kun_kundenkz = v.vtg_kundenkz_1
LEFT JOIN
    CTE_Branche b ON b.bra_vertragid = v.vtg_vertragid
*/

select * from gr_clients_all

--	select * from gr_v_clients_all
