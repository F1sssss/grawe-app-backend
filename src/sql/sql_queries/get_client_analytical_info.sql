if OBJECT_ID('tempdb..#temp') is not null
drop table #temp


select
b.bra_obnr															[polisa],
dbo.Bruto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [bruto_polisirana_premija],
dbo.Neto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [neto_polisirana_premija],
cast(0 as integer)													[dani_kasnjenja],
isnull(cast(((select top 1  p.pko_wertedatumsaldo
from praemienkonto p (nolock)
where pko_wertedatum <= @dateTo and
p.pko_obnr=b.bra_obnr 
order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0)	[dospjelo_potrazivanje],
bra_bran																[bransa],
kun_kundenkz,
bra_vertragid
into #temp
from kunde k(nolock)
join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when kun_steuer_nr is not null and  kun_steuer_nr<>'' then cast(kun_steuer_nr as varchar)
      else
      case when STR(kun_yu_persnr,12,0)<>'************'
      	then '0' + STR(kun_yu_persnr,12,0)
      else STR(kun_yu_persnr,13,0) end
      end		=@id
and
(exists (select 1 from praemienkonto pk where pk.pko_obnr=b.bra_obnr  and pko_wertedatum between @dateFrom and @dateTo) or
isnull(cast(((select top 1 p.pko_wertedatumsaldo from praemienkonto p (nolock) where pko_wertedatum <= @dateTo and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
OPTION(MAXDOP 8)




create clustered index #tempIndx1
on #temp(polisa)




if OBJECT_ID('tempdb..#praemienkonto') is not null
drop table #praemienkonto


select *,convert(date,p.pko_wertedatum,104) wertedatum into #praemienkonto from praemienkonto p (nolock)
where p.pko_obnr in (select distinct polisa from #temp)
and p.pko_wertedatum <= @dateTo



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
sum(bruto_polisirana_premija)	klijent_bruto_polisirana_premija,
sum(neto_polisirana_premija)	klijent_neto_polisirana_premija,
max(Dani_Kasnjenja)				klijent_dani_Kasnjenja,
sum([dospjelo_potrazivanje]*-1)	klijent_dospjelo_potrazivanje,
'-'								klijent_status_polise
from #temp t