select
b.bra_obnr
from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
else
case when STR(kun_yu_persnr,12,0)<>'************'
	then '0' + STR(kun_yu_persnr,12,0)
else STR(kun_yu_persnr,13,0) end
end			=@id
GROUP BY b.bra_obnr