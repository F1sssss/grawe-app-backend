
select distinct bra_obnr
into #client_policies
from branche b (nolock)
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
      else
      case when len(kun_yu_persnr)=12
      	then '0' + FORMAT(kun_yu_persnr, '0')
      else FORMAT(kun_yu_persnr, '0') end
      end		=@id



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
where pko_obnr in ( select * from #client_policies )
and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,102) and convert(date,@dateTo,102)
order by pko_obnr,convert(date,pko_wertedatum,104) asc,pko_buch_nr asc

