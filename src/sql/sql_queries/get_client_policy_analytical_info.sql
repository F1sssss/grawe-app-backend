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
	b.bra_obnr					                                        [broj_polise],
	vtg_antrag_obnr				                                        [broj_ponude],
	vtg_pol_kreis				                                        [pol_kreis],
	bra_bran					                                        [bransa],
	bra_vv_ueb					                                        [naziv_branse],
	convert(varchar,bra_vers_beginn,102)   								[pocetak_osiguranja],
	convert(varchar,bra_vers_ablauf,102)    							[istek_osiguranja],
	convert(varchar,bra_storno_ab,102)  								[datum_storna],
	bra_storno_grund			                                        [storno_tip],
	cast('' as vaRCHAR(400))							                [status_polise],
	np.sifra			                                                [nacin_placanja_sifra],
	np.opis			                                                    [nacin_placanja],
	dbo.Bruto_polisirana_premija_polisa(b.bra_obnr,@dateTo)			    [bruto_polisirana_premija],
	dbo.Neto_polisirana_premija_polisa(b.bra_obnr,@dateTo)				[neto_polisirana_premija],
	vtg_pol_vkto				                                        [sifra_zastupnika],
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'')                   [naziv_zastupnika],
	ma_unterst_og				                                        [kanal_prodaje],
	cast(0 as int)				                                        [dani_kasnjenja],
	--vtg_kundenkz_1,
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [osiguranik]
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
and bra_obnr=@id


create clustered index #tempIndx1
on #temp([Broj_Polise])



create nonclustered index #tempIndx2
on #temp([Broj_Polise],Pocetak_osiguranja asc)
INCLUDE ([Datum_storna],[Istek_osiguranja])



update t
set [status_polise]=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@dateTo  then 'Aktivna'
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 -- when @dateTo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem.
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #temp t




if OBJECT_ID('tempdb..#Kasnjenja') is not null
drop table #Kasnjenja

create table #Kasnjenja
(
polisa int,
DaniKasnjenja int
)

declare @policy2 int


DECLARE polise CURSOR FOR

select  [Broj_Polise] from #temp group by [Broj_Polise]


OPEN polise
FETCH NEXT FROM polise INTO @policy2


WHILE @@FETCH_STATUS = 0
BEGIN


	insert into #Kasnjenja
	exec Dani_kasnjenja_polisa @dateTo,@id

	FETCH NEXT FROM polise INTO @policy2
END

CLOSE polise
DEALLOCATE polise

update f
set [Dani_Kasnjenja]=isnull((select DaniKasnjenja from #Kasnjenja where #Kasnjenja.polisa=f.[Broj_Polise]),0)
from #temp f

update #temp
set
[Pocetak_osiguranja]=convert(varchar,convert(date,[Pocetak_osiguranja],102),104),
[Istek_osiguranja]=convert(varchar,convert(date,[Istek_osiguranja],102),104),
[Datum_storna]=convert(varchar,convert(date,[Datum_storna],102),104)


select * from #temp