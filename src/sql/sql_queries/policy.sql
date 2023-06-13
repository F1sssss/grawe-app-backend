declare
		@datumod varchar(10)='2022.01.01',
		@datumdo varchar(10)='2022.09.30'


select distinct
	b.bra_obnr					[Broj Polise],
	vtg_antrag_obnr				[Broj Ponude],
	vtg_pol_kreis				[Pol_kreis],
	bra_bran					[Bransa],
	bra_vv_ueb					[Naziv_Branse],
	bra_statistik_nr			[Statisticki_broj],
	convert(varchar,convert(date,bra_vers_beginn,104),102)   			[Pocetak_osiguranja],
	convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[Istek_osiguranja],
	convert(varchar,convert(date,bra_storno_ab,104),102)   			[Datum_storna],
	bra_storno_grund			[Storno tip],
	cast('' as vaRCHAR(400))							[StatusPolise],
	vtg_zahlungsweise			[Nacin_Placanja],
	cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))		[Bruto_polisirana_premija],
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))			[Neto_polisirana_premija],
	cast(0 as decimal(18,2))							[Premija],
	vtg_pol_vkto				[Sifra zastupnika],
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'') [Naziv zastupnika],
	ma_unterst_og				[Kanal_prodaje],
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
where vtg_pol_kreis<>98
and bra_obnr=@policy


-----------------------------------------------------------------------------------------

update t
set Premija=
case  -- 1. Istekla or Aktivna; 2. Stornirana od pocetka; 3. Prekid; 4. OStalo
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') or isnull([Datum_storna],'')>@datumdo then [Neto_polisirana_premija]
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[Broj Polise]=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #temp t


update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo then 'Aktivna'
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla'
end
from #temp t



update t
set Premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise])
from #temp t
where StatusPolise='Prekid' and Nacin_Placanja not in (0,1)


update t

set Premija=case when (select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj Polise]=t.[Broj Polise])=0 then 0 else  isnull((Premija*Bruto_polisirana_premija) /(select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj Polise]=t.[Broj Polise]),0) end
from #temp t
where StatusPolise='Prekid' -- isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo -- prekid
and statuspolise<>'Stornirana od pocetka'


update t

set Premija=Premija / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #temp t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datumdo -- da se ne bi ponovo umanjila za porez
and Bransa<>19



update t

set Premija=Neto_polisirana_premija
from #temp t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)



select * from #temp