if OBJECT_ID('tempdb..#temp') is not null
drop table #temp


select distinct
	b.bra_obnr					[Broj_Polise],
	vtg_antrag_obnr				[Broj_Ponude],
	vtg_pol_kreis				[Pol_kreis],
	bra_bran					[Bransa],
	bra_vv_ueb					[Naziv_Branse],
	convert(varchar,convert(date,bra_vers_beginn,104),102)   			[Pocetak_osiguranja],
	convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[Istek_osiguranja],
	convert(varchar,convert(date,bra_storno_ab,104),102)   			[Datum_storna],
	bra_storno_grund			[Storno_tip],
	cast('' as vaRCHAR(400))							[StatusPolise],
	vtg_zahlungsweise			[Nacin_Placanja],
	cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))		[Bruto_polisirana_premija],
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))			[Neto_polisirana_premija],
	cast(0 as decimal(18,2))							[Premija],
	vtg_pol_vkto				[Sifra_zastupnika],
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'') [Naziv_zastupnika],
	ma_unterst_og				[Kanal_prodaje],
	cast(0 as int)				[Dani_Kasnjenja],
	isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,102) and p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0) [dospjelo_potrazivanje],
	--vtg_kundenkz_1,
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [Osiguranik]
	into #temp
from branche b(nolock)
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
else
case when STR(kun_yu_persnr,12,0)<>'************'
	then '0' + STR(kun_yu_persnr,12,0)
else STR(kun_yu_persnr,13,0) end
end			=@id
and convert(varchar,convert(date,bra_vers_beginn,104),102) between @dateFrom and @dateTo




if OBJECT_ID('tempdb..#Kasnjenja') is not null
drop table #Kasnjenja

create table #Kasnjenja
(
polisa int,
DaniKasnjenja int
)



select
sum(Bruto_polisirana_premija)	bruto_polisirana_premija,
sum(neto_polisirana_premija)	neto_polisirana_premija,
max(Dani_Kasnjenja)				dani_Kasnjenja,
sum([dospjelo_potrazivanje])	dospjelo_potrazivanje,
'-'								status_polise
from #temp t
group by Ugovarac


