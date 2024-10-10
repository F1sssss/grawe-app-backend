select
convert(varchar,pko_wertedatum,102) datum_dokumenta,
pko_praemienkontoid					broj_dokumenta,
pko_obnr							broj_ponude,
pko_b_art							vid,
pko_g_fall							opis_knjizenja,
pko_betragsoll						duguje,
pko_betraghaben						potrazuje,
pko_wertedatumsaldo					saldo
from
praemienkonto (nolock)
where pko_obnr=@policy
and pko_wertedatum between @dateFrom and @dateTo
order by pko_wertedatum asc