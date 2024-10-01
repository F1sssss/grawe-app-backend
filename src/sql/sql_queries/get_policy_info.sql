select distinct
	b.bra_obnr					                        [Broj_Polise],
	vtg_antrag_obnr				                        [Broj_Ponude],
	vtg_pol_kreis				                        [Pol_kreis],
	bra_bran					                        [Bransa],
	bra_vv_ueb					                        [Naziv_Branse],
	convert(varchar,bra_vers_beginn,104)  			    [Pocetak_osiguranja],
    convert(varchar,bra_vers_ablauf,104)    			[Istek_osiguranja],
    convert(varchar,bra_storno_ab,104)   			    [Datum_storna],
	--convert(varchar,convert(date,bra_vers_beginn,104),102)   			[Pocetak_osiguranja],
	--convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[Istek_osiguranja],
	--convert(varchar,convert(date,bra_storno_ab,104),102)   			[Datum_storna],
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [Osiguranik]
	from branche b(nolock)
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik
where  bra_obnr=@policy


