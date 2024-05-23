
;WITH CTE AS(
select
cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))		[Bruto_polisirana_premija],
cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))		[Neto_polisirana_premija],
cast(0 as int)													[Dani_Kasnjenja],
isnull(cast((
(select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))
from praemienkonto p (nolock)
where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,102) and
p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104)
desc,pko_buch_nr desc )) as decimal(18,2)),0)					[dospjelo_potrazivanje]
from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when k.kun_vorname is null then cast(k.kun_steuer_nr as varchar)
else
case when STR(k.kun_yu_persnr,12,0)<>'************'
	then '0' + STR(k.kun_yu_persnr,12,0)
else STR(k.kun_yu_persnr,13,0) end
end			=@id
and convert(varchar,convert(date,bra_vers_beginn,104),102) between @dateFrom and @dateTo
)
select
sum(Bruto_polisirana_premija)	bruto_polisirana_premija,
sum(neto_polisirana_premija)	neto_polisirana_premija,
max(Dani_Kasnjenja)				dani_Kasnjenja,
sum([dospjelo_potrazivanje])	dospjelo_potrazivanje,
'-'								status_polise
from CTE t
