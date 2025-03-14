IF OBJECT_ID('tempdb..#relevant_policies') IS NOT NULL DROP TABLE #relevant_policies;

SELECT DISTINCT
	bra_obnr															polisa,
	isnull(cast(((select top 1 p.pko_wertedatumsaldo*-1  from praemienkonto p (nolock) where pko_wertedatum <= @dateTo and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0)	[dospjela_potrazivanja],
	dbo.Bruto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [bruto_polisirana_premija],
	cast('' as vaRCHAR(40))												[status_polise],
	bra_storno_grund													[storno_tip],
	bra_bran															[bransa],
	(select sum(pko_betragsoll) from praemienkonto p2 where p2.pko_obnr=b.bra_obnr and pko_wertedatum<=@dateTo) ukupno_zaduzeno,
	(select sum(pko_betraghaben) from praemienkonto p2 where p2.pko_obnr=b.bra_obnr and pko_wertedatum<=@dateTo)  ukupno_placeno,
bra_vertragid
INTO #relevant_policies
FROM gr_clients_all gc WITH (NOLOCK)
JOIN branche b WITH (NOLOCK) ON b.bra_obnr = gc.polisa
JOIN vertrag v WITH (NOLOCK) ON b.bra_vertragid = v.vtg_vertragid
WHERE gc.[embg/pib] = @id
AND EXISTS (
    SELECT 1
    FROM vertrag v2 WITH (NOLOCK)
    WHERE v2.vtg_pol_bran = b.bra_bran
    AND v2.vtg_vertragid = b.bra_vertragid
)
and
(exists (select 1 from praemienkonto pk where pk.pko_obnr=b.bra_obnr  and pko_wertedatum between @dateFrom and @dateTo) or
isnull(cast(((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @dateTo and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
and 1= case when @ZK = 1 then 1 else case when bra_bran=19 then 0 else 1 end end
and 1= case when @AO = 1 then 1 else case when bra_bran=10 and vtg_pol_kreis<>97 then 0 else 1 end end




;WITH CTE AS(
select
polisa,
bruto_polisirana_premija,
dospjela_potrazivanja,
case when bruto_polisirana_premija-ukupno_placeno-dospjela_potrazivanja <0 or bruto_polisirana_premija- ukupno_placeno<0 then 0 else [bruto_polisirana_premija] - ukupno_placeno - case when dospjela_potrazivanja<0 then 0 else dospjela_potrazivanja end end ukupno_nedospjelo,
case when [bruto_polisirana_premija] - ukupno_placeno<0 or dospjela_potrazivanja<0 then 0
else dospjela_potrazivanja end ukupno_dospjelo
from #relevant_policies
)
select
cast(sum(ukupno_nedospjelo)as decimal(18,2)) ukupno_nedospjelo,
cast(sum(ukupno_dospjelo)as decimal(18,2)) ukupno_dospjelo
from CTE