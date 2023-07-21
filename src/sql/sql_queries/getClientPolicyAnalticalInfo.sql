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
	(select sum(cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))) from branche b2 (nolock) where b2.bra_obnr=b.bra_obnr)		[Bruto_polisirana_premija],
	(select sum(cast(replace(bra_nettopraemie1,',','.')as decimal(18,2)))  from branche b2 (nolock) where b2.bra_obnr=b.bra_obnr)			[Neto_polisirana_premija],
	cast(0 as decimal(18,2))							[Premija],
	vtg_pol_vkto				[Sifra_zastupnika],
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'') [Naziv_zastupnika],
	ma_unterst_og				[Kanal_prodaje],
	cast(0 as int)				[Dani_Kasnjenja],
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
where convert(varchar,convert(date,bra_vers_beginn,104),102) between @dateFrom and @dateTo
and bra_obnr=@id
and v.vtg_pol_bran=bra_bran


if OBJECT_ID('tempdb..#praemienkonto') is not null
drop table #praemienkonto


select * into #praemienkonto from praemienkonto p (nolock)
where p.pko_obnr in (select distinct [Broj_Polise] from #temp)
and convert(date,p.pko_wertedatum,104)<=convert(date,@dateTo,102)



update t
set Premija=
case  -- 1. Istekla or Aktivna; 2. Stornirana od pocetka; 3. Prekid; 4. OStalo
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') or isnull([Datum_storna],'')>@dateTo then [Neto_polisirana_premija]
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj_Polise]=t.[Broj_Polise])-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[Broj_Polise]=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #temp t



update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@dateTo  then 'Aktivna'
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 -- when @dateTo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem.
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #temp t



update t
set Premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj_Polise])
from #temp t
where StatusPolise='Prekid' and Nacin_Placanja not in (0,1)




---Porez

update t

set Premija=Premija / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #temp t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@dateTo -- da se ne bi ponovo umanjila za porez
and Bransa<>19


-- Totalna steta kod kasko osiguranja2
update t

set Premija=Neto_polisirana_premija
from #temp t
where [Storno_tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)



if OBJECT_ID('tempdb..#Kasnjenja') is not null
drop table #Kasnjenja

create table #Kasnjenja
(
polisa int,
DaniKasnjenja int
)




select
broj_polise,
[Naziv_Branse],
[Nacin_Placanja],
Bruto_polisirana_premija,
Neto_polisirana_premija,
Dani_Kasnjenja,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))) from #praemienkonto p2) ukupna_potrazivanja,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))-cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from #praemienkonto p2) dospjela_potrazivanja

from #temp t