;WITH CTE AS(
select  bra_obnr
from branche b (nolock)
join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
else
case when STR(kun_yu_persnr,12,0)<>'************'
	then '0' + STR(kun_yu_persnr,12,0)
else STR(kun_yu_persnr,13,0) end
end		=@id
group by bra_obnr
)
select
convert(varchar,pko_wertedatum,104)				datum_dokumenta,
pko_obnr										polisa,
pko_praemienkontoid								broj_dokumenta,
pko_obnr										broj_ponude,
pko_b_art										vid,
pko_g_fall										opis_knjizenja,
pko_betragsoll									duguje,
pko_betraghaben									potrazuje,
pko_wertedatumsaldo								saldo
from
praemienkonto (nolock)
join CTE c on c.bra_obnr=praemienkonto.pko_obnr
WHERE pko_wertedatum between @dateFrom and @dateTo
order by pko_obnr,pko_wertedatum asc,pko_buch_nr asc
