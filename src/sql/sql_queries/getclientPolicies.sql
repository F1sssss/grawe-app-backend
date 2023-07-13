select distinct
b.bra_obnr
from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
      else
      case when len(kun_yu_persnr)=12
      	then '0' + FORMAT(kun_yu_persnr, '0')
      else FORMAT(kun_yu_persnr, '0') end
      end		=@id

