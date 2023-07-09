select distinct
b.bra_obnr
from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when len(kun_yu_persnr)=12 then '0'+kun_yu_persnr else kun_yu_persnr end=@id

