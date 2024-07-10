
if OBJECT_ID('tempdb..#temp') is not null
drop table #temp


select
b.bra_obnr															[polisa],
dbo.Bruto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [bruto_polisirana_premija],
dbo.Neto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [neto_polisirana_premija],
cast(0 as integer)													[dani_kasnjenja],
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))
from praemienkonto p (nolock)
where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,102) and
p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104)
desc,pko_buch_nr desc )) as decimal(18,2)),0)						[dospjelo_potrazivanje],
bra_bran															[bransa],
kun_kundenkz,
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
(exists (select 1 from praemienkonto pk where pk.pko_obnr=b.bra_obnr  and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,102) and convert(date,@dateTo,102)) or
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,102) and p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
OPTION(MAXDOP 1)




create clustered index #tempIndx1
on #temp(polisa)




if OBJECT_ID('tempdb..#praemienkonto') is not null
drop table #praemienkonto


select *,convert(date,p.pko_wertedatum,104) wertedatum into #praemienkonto from praemienkonto p (nolock)
where p.pko_obnr in (select distinct polisa from #temp)
and convert(date,p.pko_wertedatum,104)<=convert(date,@dateTo,102)



CREATE NONCLUSTERED INDEX #indx1
ON #praemienkonto (pko_obnr,wertedatum asc,pko_buch_nr desc)
INCLUDE (
pko_betragsoll,
pko_betraghaben,
pko_wertedatumsaldo
)

CREATE CLUSTERED INDEX #pko_clustered_inx_obnr
ON #praemienkonto (pko_obnr)



delete from #temp
where not exists (select 1 from vertrag v where v.vtg_pol_bran=#temp.bransa and v.vtg_vertragid=#temp.bra_vertragid);



select
sum(bruto_polisirana_premija)	bruto_polisirana_premija,
sum(neto_polisirana_premija)	neto_polisirana_premija,
max(Dani_Kasnjenja)				dani_Kasnjenja,
sum([dospjelo_potrazivanje]*-1)	dospjelo_potrazivanje,
'-'								status_polise
from #temp t


