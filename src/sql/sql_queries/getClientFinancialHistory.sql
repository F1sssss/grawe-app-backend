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
dbo.gr_num_convert(bra_bruttopraemie) zaduzeno,
0 uplaceno,
convert(varchar,convert(date,bra_vers_beginn,104),102)   			[pocetak_osiguranja],
convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[istek_osiguranja],
convert(varchar,convert(date,bra_storno_ab,104),102)   				[datum_storna],
cast('' as vaRCHAR(400))											[status_polise],
cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))			[neto_polisirana_premija],
bra_storno_grund													[storno_tip],
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

update t
set [status_polise]=
case when isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla'
end
from #branche t




update t
set zaduzeno=
case
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then zaduzeno
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(zaduzeno) from #branche t2 where t2.polisa=t.polisa)-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.polisa=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #branche t


update t
set zaduzeno=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr=t.polisa and pko_g_fall<>'SVOR')
from #branche t
where status_polise='Prekid' --and Nacin_Placanja not in (0,1)


update t

set zaduzeno=Neto_polisirana_premija
from #branche t
where storno_tip=2 and Bransa=11 -- and Nacin_Placanja in (0,1)


update t

set zaduzeno=zaduzeno * cast(CEILING(cast(DATEDIFF(day,convert(date,[Pocetak_osiguranja],102),convert(date,@dateTo,104)) as decimal(18,2))/365) as int)
from #branche t
where Bransa in (78,79)



;WITH CTE AS(
select
datum_dokumenta,
broj_dokumenta,
broj_ponude,
zaduzeno,
uplaceno
from #branche
where convert(date,datum_dokumenta,104)<convert(date,@dateFrom,104)
UNION
select pko_wertedatum, pko_obnr,0, 0 zaduzeno, dbo.gr_num_convert(pko_betraghaben) --bra_bruttopraemie - SUM(pko_betraghaben) OVER (PARTITION BY pko_obnr)
from praemienkonto (nolock)
JOIN gr_clients_all c on c.polisa=praemienkonto.pko_obnr
where c.[embg/pib]=@id and dbo.gr_num_convert(pko_betraghaben)>0
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
UNION
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
UNION
select pko_wertedatum, pko_obnr,0, 0 zaduzeno, dbo.gr_num_convert(pko_betraghaben) --bra_bruttopraemie - SUM(pko_betraghaben) OVER (PARTITION BY pko_obnr)
from praemienkonto (nolock)
JOIN gr_clients_all c on c.polisa=praemienkonto.pko_obnr
where c.[embg/pib]=@id and dbo.gr_num_convert(pko_betraghaben)>0
and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,104) and convert(date,@dateTo,104)
and exists (select 1 from #branche b where b.broj_dokumenta=praemienkonto.pko_obnr and  convert(date,datum_dokumenta,104)>=convert(date,@dateFrom,104))
)
,CTE_5 AS (
select * from CTE_3
UNION
select * from CTE_4
)
select ROW_NUMBER() OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta, zaduzeno desc) row_num,*,SUM(zaduzeno-uplaceno) OVER ( ORDER BY convert(date,datum_dokumenta,104) asc,broj_dokumenta) saldo,
 @dateFrom datum_od,
 @dateTo  datum_do
 from CTE_5