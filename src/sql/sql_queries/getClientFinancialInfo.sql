set @dateFrom = case when substring(@dateFrom,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@dateFrom,102),104) else @dateFrom end
set @dateTo = case when substring(@dateTo,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@dateTo,102),104) else @dateTo end



if OBJECT_ID('tempdb..#temp') is not null
drop table #temp


select
case when kun_vorname is null then cast(kun_steuer_nr as varchar)
else
case when len(kun_yu_persnr)=12
	then '0' + FORMAT(kun_yu_persnr, '0')
else FORMAT(kun_yu_persnr, '0') end
end																	[embg/pib],
bra_obnr															polisa,
convert(varchar,convert(date,bra_vers_beginn,104),102)   			[pocetak_osiguranja],
convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[istek_osiguranja],
convert(varchar,convert(date,bra_storno_ab,104),102)   				[datum_storna],
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,104) and p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0)										[dospjela_potrazivanja],
dbo.Bruto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [premija],
cast('' as vaRCHAR(40))												[status_polise],
bra_storno_grund													[storno_tip],
bra_bran															[bransa],
(select sum(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from praemienkonto p2 where p2.pko_obnr=b.bra_obnr) ukupno_zaduzeno,
(select top 1 cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))*-1 from praemienkonto p2 where p2.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc) ukupno_dospjelo,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))) from praemienkonto p2 where p2.pko_obnr=b.bra_obnr)  ukupno_placeno,
bra_vertragid
into #temp
from kunde k(nolock)
join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
      else
      case when STR(kun_yu_persnr,12,0)<>'************'
      	then '0' + STR(kun_yu_persnr,12,0)
      else STR(kun_yu_persnr,13,0) end
      end		=@id
and
(exists (select 1 from praemienkonto pk where pk.pko_obnr=b.bra_obnr  and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,104) and convert(date,@dateTo,104)) or
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,104) and p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
OPTION(MAXDOP 1)



delete from #temp
where not exists (select 1 from vertrag v where v.vtg_pol_bran=#temp.bransa and v.vtg_vertragid=#temp.bra_vertragid);




;WITH CTE AS(
select polisa, premija,dospjela_potrazivanja dospjela_potrazivanja from #temp
)
select
case when sum(premija) - (select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr in (select polisa from #temp) and convert(date,pk.pko_wertedatum,104)<=convert(date,@dateTo,104)) <0 then 0
else sum(premija) - (select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr in (select polisa from #temp) and convert(date,pk.pko_wertedatum,104)<=convert(date,@dateTo,104)) end ukupno_nedospjelo,
ABS(sum(dospjela_potrazivanja)) ukupno_dospjelo  from CTE
