if OBJECT_ID('tempdb..#branche') is not null
drop table #branche


SELECT
(select TOP 1 pko_wertedatum from praemienkonto where praemienkonto.pko_obnr=branche.bra_obnr and pko_betragsoll>0 order by pko_wertedatum asc) datum_dokumenta,
polisa,
bra_obnr broj_dokumenta,
dbo.Bruto_polisirana_premija_polisa(bra_obnr,@dateTo)				zaduzeno,
0																	uplaceno,
bra_bran															[bransa],
cast(0 as integer)													[broj_ponude],
bra_statistik_nr,
bra_vertragid
into #branche  from branche (nolock)
JOIN gr_clients_all c on c.polisa=branche.bra_obnr
join vertrag v on bra_vertragid=v.vtg_vertragid
where c.[embg/pib]=@id and
(exists (select 1 from praemienkonto pk where pk.pko_obnr=branche.bra_obnr  and pko_wertedatum between @dateFrom and @dateTo) or
isnull(cast(((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @dateTo and p.pko_obnr=branche.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
and 1= case when @ZK = 1 then 1 else case when bra_bran=19 then 0 else 1 end end
and 1= case when @AO = 1 then 1 else case when bra_bran=10 and vtg_pol_kreis<>97 then 0 else 1 end end



update #branche
set [broj_ponude]=(select case when bransa in (10,19,56) or (bransa=9 and bra_statistik_nr=11040)
then vtg_antrag_obnr
else 0 end   from vertrag where vertrag.vtg_vertragid=bra_vertragid)


delete from #branche
where not exists (select 1 from vertrag v where v.vtg_pol_bran=#branche.bransa and v.vtg_vertragid=#branche.bra_vertragid);


;WITH CTE AS(
select
0 id,
datum_dokumenta,
broj_dokumenta,
broj_ponude,
zaduzeno,
uplaceno
from #branche
where datum_dokumenta < @dateFrom

UNION ALL

select pko_praemienkontoid, pko_wertedatum, pko_obnr,0,  0 zaduzeno, pko_betraghaben --bra_bruttopraemie - SUM(pko_betraghaben) OVER (PARTITION BY pko_obnr)
from praemienkonto (nolock)
JOIN gr_clients_all c on c.polisa=praemienkonto.pko_obnr
where c.[embg/pib]=@id and pko_betraghaben <> 0
and pko_wertedatum <= @dateTo
and exists (select 1 from #branche b where b.broj_dokumenta=praemienkonto.pko_obnr and datum_dokumenta < @dateFrom)
),

CTE_2 AS (
select id, '01.01.' + SUBSTRING(convert(varchar,@dateFrom,102),1,4) datum_dokumenta, broj_dokumenta,broj_ponude, sum(zaduzeno) zaduzeno, sum (uplaceno) uplaceno
FROM CTE
where datum_dokumenta <= convert(date,'01.01.' + SUBSTRING(convert(varchar,@dateFrom,102),1,4),104)
group by broj_dokumenta,broj_ponude,id
having sum(zaduzeno-uplaceno)<>0
),
CTE_3 AS (
select * from CTE_2
UNION ALL
select * from CTE
where convert(date,datum_dokumenta,104)>convert(date,'01.01.' + SUBSTRING(convert(varchar,@dateFrom,102),1,4),104)
)
,CTE_4 AS(
select
0 id,
datum_dokumenta,
broj_dokumenta,
broj_ponude,
zaduzeno,
uplaceno
from #branche
where convert(date,datum_dokumenta,104)>= @dateFrom

UNION ALL

select pko_praemienkontoid, pko_wertedatum, pko_obnr,b.broj_ponude,  0 zaduzeno, pko_betraghaben --bra_bruttopraemie - SUM(pko_betraghaben) OVER (PARTITION BY pko_obnr)
from praemienkonto (nolock)
JOIN gr_clients_all c on c.polisa=praemienkonto.pko_obnr
left join #branche b on b.polisa=c.polisa
where c.[embg/pib]=@id and pko_betraghaben <>0
and pko_wertedatum between @dateFrom and @dateTo
and exists (select 1 from #branche b where b.broj_dokumenta=praemienkonto.pko_obnr and  convert(date,datum_dokumenta,104)>=@dateFrom)
)
,CTE_5 AS (
select DISTINCT * from CTE_3
UNION ALL
select DISTINCT * from CTE_4
)
select ROW_NUMBER() OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta, zaduzeno desc) row_num,
convert(varchar,datum_dokumenta,104)datum_dokumenta,
broj_dokumenta,
broj_ponude,
zaduzeno,
uplaceno,
SUM(cast(zaduzeno-uplaceno as decimal(18,2))) OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta,uplaceno) saldo,
convert(varchar,@dateFrom,104) datum_od,
convert(varchar,@dateTo,104)  datum_do
from CTE_5