set @dateFrom = case when substring(@dateFrom,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@dateFrom,102),104) else @dateFrom end
set @dateTo = case when substring(@dateTo,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@dateTo,102),104) else @dateTo end



if OBJECT_ID('tempdb..#temp') is not null
drop table #temp


select
[embg/pib],
polisa,
convert(varchar,convert(date,bra_vers_beginn,104),102)   			[pocetak_osiguranja],
convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[istek_osiguranja],
convert(varchar,convert(date,bra_storno_ab,104),102)   				[datum_storna],
ABS(isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,104) and p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0))											[dospjela_potrazivanja],
cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))			[bruto_polisirana_premija],
cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))			[Neto_polisirana_premija],
cast('' as vaRCHAR(40))												[status_polise],
bra_storno_grund													[storno_tip],
bra_bran															[bransa]
into #temp
from gr_clients_all a
left join branche b on b.bra_obnr=a.polisa
where a.[embg/pib]=@id
OPTION(MAXDOP 1)


update t
set [status_polise]=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>convert(varchar,convert(date,@dateTo,104),102) then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna'
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>convert(varchar,convert(date,@dateTo,104),102) then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 -- when @datumdo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem.
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #temp t




----------Bruto Polisirana premija-----------------

update t
set Bruto_polisirana_premija=
case
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Bruto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.polisa=t.polisa)-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.polisa=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #temp t


update t
set Bruto_polisirana_premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr=t.polisa and pko_g_fall<>'SVOR')
from #temp t
where [status_polise]='Prekid' --and Nacin_Placanja not in (0,1)


update t

set Bruto_polisirana_premija=Neto_polisirana_premija
from #temp t
where [storno_tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)




update t

set Bruto_polisirana_premija=Bruto_polisirana_premija * cast(CEILING(cast(DATEDIFF(day,convert(date,[Pocetak_osiguranja],102),convert(date,@dateTo,104)) as decimal(18,2))/365) as int)
from #temp t
where Bransa in (78,79)


select
sum(bruto_polisirana_premija)   ukupno_dospjelo,
sum(dospjela_potrazivanja)      ukupno_nedospjelo
from #temp



