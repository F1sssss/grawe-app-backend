/*
declare @policy int=9000664,
@embg varchar(13)='02015366',
@dateFrom varchar(10)='01.01.2022',
@dateTo varchar (10)='31.12.2023'
*/

set @dateFrom = case when substring(@dateFrom,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@dateFrom,102),104) else @dateFrom end
set @dateTo = case when substring(@dateTo,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@dateTo,102),104) else @dateTo end



if OBJECT_ID('tempdb..#branche') is not null
drop table #branche


SELECT
(select TOP 1 pko_wertedatum from praemienkonto where praemienkonto.pko_obnr=branche.bra_obnr and dbo.gr_num_convert(pko_betragsoll)>0 order by convert(date,pko_wertedatum,104) asc) datum_dokumenta,
polisa,
bra_obnr broj_dokumenta,
dbo.Bruto_polisirana_premija_polisa(bra_obnr,@dateTo)             zaduzeno,
0 uplaceno,
bra_bran															[bransa],
cast(0 as integer)													[broj_ponude],
bra_statistik_nr,
bra_vertragid
into #branche  from branche (nolock)
JOIN gr_clients_all c on c.polisa=branche.bra_obnr
where c.[embg/pib]=@id and
(exists (select 1 from praemienkonto pk where pk.pko_obnr=branche.bra_obnr  and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,104) and convert(date,@dateTo,104)) or
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,104) and p.pko_obnr=branche.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)



update #branche
set [broj_ponude]=(select case when bransa in (10,19,56) or (bransa=9 and bra_statistik_nr=11040)
then vtg_antrag_obnr
else 0 end   from vertrag where vertrag.vtg_vertragid=bra_vertragid)


delete from #branche
where not exists (select 1 from vertrag v where v.vtg_pol_bran=#branche.bransa and v.vtg_vertragid=#branche.bra_vertragid);


;WITH CTE AS(
select
datum_dokumenta,
broj_dokumenta,
broj_ponude,
zaduzeno,
uplaceno
from #branche
where convert(date,datum_dokumenta,104)<convert(date,@dateFrom,104)
UNION ALL
select pko_wertedatum, pko_obnr,0,  0 zaduzeno, dbo.gr_num_convert(pko_betraghaben) --bra_bruttopraemie - SUM(pko_betraghaben) OVER (PARTITION BY pko_obnr)
from praemienkonto (nolock)
JOIN gr_clients_all c on c.polisa=praemienkonto.pko_obnr
where c.[embg/pib]=@id and dbo.gr_num_convert(pko_betraghaben)<>0
and convert(date,pko_wertedatum,104) <= convert(date,@dateTo,104)
and exists (select 1 from #branche b where b.broj_dokumenta=praemienkonto.pko_obnr and convert(date,datum_dokumenta,104)<convert(date,@dateFrom,104))
),
CTE_2 AS (
select '01.01.' + SUBSTRING(@dateFrom,7,4) datum_dokumenta, broj_dokumenta,broj_ponude, sum(zaduzeno) zaduzeno, sum (uplaceno) uplaceno
FROM CTE
where convert(date,datum_dokumenta,104)<=convert(date,'01.01.' + SUBSTRING(@dateFrom,7,4),104)
group by broj_dokumenta,broj_ponude
having sum(zaduzeno-uplaceno)<>0
),
CTE_3 AS (
select * from CTE_2
UNION ALL
select * from CTE
where convert(date,datum_dokumenta,104)>convert(date,'01.01.' + SUBSTRING(@dateFrom,7,4),104)
)
,CTE_4 AS(
select
datum_dokumenta,
broj_dokumenta,
broj_ponude,
zaduzeno,
uplaceno
from #branche
where convert(date,datum_dokumenta,104)>=convert(date,@dateFrom,104)
UNION ALL
select pko_wertedatum, pko_obnr,b.broj_ponude,  0 zaduzeno, dbo.gr_num_convert(pko_betraghaben) --bra_bruttopraemie - SUM(pko_betraghaben) OVER (PARTITION BY pko_obnr)
from praemienkonto (nolock)
JOIN gr_clients_all c on c.polisa=praemienkonto.pko_obnr
left join #branche b on b.polisa=c.polisa
where c.[embg/pib]=@id and dbo.gr_num_convert(pko_betraghaben)<>0
and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,104) and convert(date,@dateTo,104)
and exists (select 1 from #branche b where b.broj_dokumenta=praemienkonto.pko_obnr and  convert(date,datum_dokumenta,104)>=convert(date,@dateFrom,104))
)
,CTE_5 AS (
select * from CTE_3
UNION ALL
select * from CTE_4
)
select ROW_NUMBER() OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta, zaduzeno desc) row_num,*,SUM(zaduzeno-uplaceno) OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta,uplaceno) saldo,
 @dateFrom datum_od,
 @dateTo  datum_do
 from CTE_5