select distinct
kun_zuname + ' ' + isnull(kun_vorname,'') [klijent],
case when kun_vorname is null then cast(kun_steuer_nr as varchar) else case when len(FORMAT(kun_yu_persnr, '0'))=12 then '0' + FORMAT(kun_yu_persnr, '0') else FORMAT(kun_yu_persnr, '0') end end [embg/pib],
isnull(bra_obnr,'') [polisa]

from branche b (nolock)
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
right join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
where case when len(FORMAT(kun_yu_persnr, '0'))=12 then '0'+kun_yu_persnr else kun_yu_persnr end like '%' + @search +'%'
or  kun_zuname like '%' + @search + '%'
or  kun_vorname like '%' + @search + '%'
or  cast(b.bra_obnr as varchar) like '%' + @search + '%'

