select distinct 
kun_zuname + ' ' + isnull(kun_vorname,'') [klijent],
kun_geburtsdatum [datum_rodjenja],
case when kun_vorname is null then cast(kun_steuer_nr as varchar) else case when len(kun_yu_persnr)=12 then '0' + FORMAT(kun_yu_persnr, '0') else FORMAT(kun_yu_persnr, '0') end end [embg/pib],
isnull(v.vtg_grund_adresse,'') [adresa],
isnull(v.vtg_grund_postort,'') [mjesto],
ISNULL(k.kun_telefon_1,'') [telefon1],
ISNULL(ISNULL(k.kun_tele_mobil_1,k.kun_tele_mobil_1),'') [telefon1],
ISNULL(kun_e_mail,'') [email]

from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
where case when len(kun_yu_persnr)=12 then '0'+kun_yu_persnr else kun_yu_persnr end=@id

