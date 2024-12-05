select top 1
kun_zuname + ' ' + isnull(kun_vorname,'')							[klijent],
kun_geburtsdatum													[datum_rodjenja],
case when kun_steuer_nr is not null and  kun_steuer_nr<>'' then cast(kun_steuer_nr as varchar)
else
case when STR(kun_yu_persnr,12,0)<>'************'
	then '0' + STR(kun_yu_persnr,12,0)
else STR(kun_yu_persnr,13,0) end
end																	[jmbg_pib],
isnull(v.vtg_grund_adresse,'')										[adresa],
isnull(v.vtg_grund_postort,'')										[mjesto],
ISNULL(k.kun_telefon_1,'')											[telefon1],
ISNULL(ISNULL(k.kun_tele_mobil_1,k.kun_tele_mobil_2),'')			[telefon2],
ISNULL(kun_e_mail,'')												[email]

from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when kun_steuer_nr is not null and  kun_steuer_nr<>'' then cast(kun_steuer_nr as varchar)
else
case when STR(kun_yu_persnr,12,0)<>'************'
	then '0' + STR(kun_yu_persnr,12,0)
else STR(kun_yu_persnr,13,0) end
end			=@id

