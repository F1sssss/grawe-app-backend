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
convert(varchar,convert(date,pko_wertedatum,104),102) datum_dokumenta,
pko_obnr                    polisa,
pko_praemienkontoid			broj_dokumenta,
pko_obnr					broj_ponude,
pko_b_art					vid,
pko_g_fall                  opis_knjizenja,
cast(replace(pko_betraghaben,',','.') as decimal(18,2))				    duguje,
cast(replace(pko_betragsoll,',','.') as decimal(18,2))				    potrazuje,
cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))		        saldo
from
praemienkonto (nolock)
join CTE c on c.bra_obnr=praemienkonto.pko_obnr
WHERE convert(date,pko_wertedatum,104) between convert(date,@dateFrom,102) and convert(date,@dateTo,102)
order by pko_obnr,convert(date,pko_wertedatum,104) asc,pko_buch_nr asc
