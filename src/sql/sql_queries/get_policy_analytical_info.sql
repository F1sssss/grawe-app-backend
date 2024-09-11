if OBJECT_ID('tempdb..#NaciniPlacanja') is not null
drop table #NaciniPlacanja


CREATE TABLE #NaciniPlacanja (
sifra int,
opis varchar (50)
)

insert into #NaciniPlacanja
values
(0 , 'plaćanje odjednom'),
(1 , 'godišnje plaćanje'),
(2 , 'polugodisnje plaćanje'),
(4 , 'kvartalno plaćanje'),
(6 , 'mjesecno plaćanje')


if OBJECT_ID('tempdb..#temp') is not null
drop table #temp



select distinct
	b.bra_obnr											[Broj_Polise],
	vtg_antrag_obnr										[Broj_Ponude],
	vtg_pol_kreis										[Pol_kreis],
	bra_bran											[Bransa],
	bra_vv_ueb											[Naziv_Branse],
	bra_vers_beginn   									[Pocetak_osiguranja],
	bra_vers_ablauf   									[Istek_osiguranja],
	bra_storno_ab 										[Datum_storna],
	bra_storno_grund									[Storno_tip],
	cast('' as vaRCHAR(400))							[Status_Polise],
	np.opis			[Nacin_Placanja],
	dbo.Bruto_polisirana_premija_polisa(@policy,@dateTo)		[Bruto_polisirana_premija],
	dbo.Neto_polisirana_premija_polisa(@policy,@dateTo)			[Neto_polisirana_premija],
	cast(0 as decimal(18,2))							[Premija],
	vtg_pol_vkto										[Sifra_zastupnika],
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'')	[Naziv_zastupnika],
	ma_unterst_og										[Kanal_prodaje],
	cast(0 as int)										[Dani_Kasnjenja],
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
left join #NaciniPlacanja np on np.sifra=vtg_zahlungsweise
where bra_vers_beginn between @dateFrom and @dateTo
and bra_obnr=@policy




update t
set Status_Polise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@dateTo  then 'Aktivna'
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 -- when @dateTo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem.
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #temp t


update #temp
set Premija=Bruto_polisirana_premija



if OBJECT_ID('tempdb..#Kasnjenja') is not null
drop table #Kasnjenja

create table #Kasnjenja
(
polisa int,
DaniKasnjenja int
)

declare @policy2 int


DECLARE polise CURSOR FOR

select distinct [Broj_Polise] from #temp


OPEN polise
FETCH NEXT FROM polise INTO @policy2


WHILE @@FETCH_STATUS = 0
BEGIN


	insert into #Kasnjenja
	exec Dani_kasnjenja_polisa @dateTo,@policy

	FETCH NEXT FROM polise INTO @policy2
END

CLOSE polise
DEALLOCATE polise

update f
set [Dani_Kasnjenja]=isnull((select DaniKasnjenja from #Kasnjenja where #Kasnjenja.polisa=f.[Broj_Polise]),0)
from #temp f



select distinct * from #temp