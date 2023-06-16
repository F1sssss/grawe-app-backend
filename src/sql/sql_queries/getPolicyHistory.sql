select
convert(varchar,convert(date,pko_wertedatum,104),102) datum_dokumenta,
pko_praemienkontoid			broj_dokumenta,
pko_obnr					broj_ponude,
pko_b_art					vid,
pko_g_fall                  opis_knjizenja,
cast(replace(pko_betraghaben,',','.') as decimal(18,2))				    duguje,
cast(replace(pko_betragsoll,',','.') as decimal(18,2))				    potrazuje,
cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))		        saldo
from
praemienkonto (nolock)
where pko_obnr=@policy
and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,102) and convert(date,@dateTo,102)
order by convert(date,pko_wertedatum,104) asc