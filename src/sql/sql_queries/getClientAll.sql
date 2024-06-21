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


select 
kun_zuname + ' ' + isnull(kun_vorname,'')							[klijent],
kun_geburtsdatum													[datum_rodjenja],
case when kun_vorname is null then cast(kun_steuer_nr as varchar)
else
case when len(kun_yu_persnr)=12
	then '0' + FORMAT(kun_yu_persnr, '0')
else FORMAT(kun_yu_persnr, '0') end
end																	[embg/pib],
isnull(v.vtg_grund_adresse,'')										[adresa],
isnull(v.vtg_grund_postort,'')										[mjesto],
ISNULL(k.kun_telefon_1,'')											[telefon1],
ISNULL(ISNULL(k.kun_tele_mobil_1,k.kun_tele_mobil_1),'')			[telefon2],
ISNULL(kun_e_mail,'')												[email],
b.bra_obnr															[polisa],
convert(varchar,convert(date,bra_vers_beginn,104),102)   			[pocetak_osiguranja],
convert(varchar,convert(date,bra_vers_ablauf,104),102)   			[istek_osiguranja],
convert(varchar,convert(date,bra_storno_ab,104),102)   				[datum_storna],
cast(0 as decimal(18,2))											[premija],
np.opis																[nacin_placanja],
np.sifra															[nacin_placanja_sifra],
bra_vv_ueb															[naziv_branse],
cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))			[bruto_polisirana_premija],
cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))			[neto_polisirana_premija],
cast(0 as integer)													[dani_kasnjenja],
cast(0 as decimal(18,2))											[ukupna_potrazivanja],
cast(0 as decimal(18,2))											[dospjela_potrazivanja],
cast('' as vaRCHAR(400))											[status_polise],
bra_bran															[bransa],
bra_storno_grund													[storno_tip],
cast(0 as decimal(18,2))											[uplacena_premija],
kun_kundenkz,
bra_vertragid
into #temp
from kunde k(nolock)
join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
join #NaciniPlacanja np on np.sifra=vtg_zahlungsweise
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
      else
      case when STR(kun_yu_persnr,12,0)<>'************'
      	then '0' + STR(kun_yu_persnr,12,0)
      else STR(kun_yu_persnr,13,0) end
      end		=@id
OPTION(MAXDOP 1)


create clustered index #tempIndx1
on #temp(polisa)



create nonclustered index #tempIndx2
on #temp(polisa,Pocetak_osiguranja asc)
INCLUDE ([Datum_storna],[Istek_osiguranja])


if OBJECT_ID('tempdb..#praemienkonto') is not null
drop table #praemienkonto


select *,convert(date,p.pko_wertedatum,104) wertedatum into #praemienkonto from praemienkonto p (nolock)
where p.pko_obnr in (select distinct polisa from #temp)
and convert(date,p.pko_wertedatum,104)<=convert(date,@dateTo,102)



CREATE NONCLUSTERED INDEX #indx1
ON #praemienkonto (pko_obnr,wertedatum asc,pko_buch_nr desc)
INCLUDE (
pko_betragsoll,
pko_betraghaben,
pko_wertedatumsaldo
)

CREATE CLUSTERED INDEX #pko_clustered_inx_obnr
ON #praemienkonto (pko_obnr)



update t
set [status_polise]=
case when isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla'
end
from #temp t

--
--
-- update t
-- set Bruto_polisirana_premija=
-- case
-- 	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Neto_polisirana_premija
-- 	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
-- 	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.[polisa]=t.[polisa])-
-- 	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from #praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[polisa]=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
-- 	 else 0
-- end
-- from #temp t
--
-- update t
-- set Bruto_polisirana_premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from #praemienkonto pk(nolock) where pk.pko_obnr=t.polisa and pko_g_fall<>'SVOR')
-- from #temp t
-- where [status_polise]='Prekid' and Nacin_Placanja_Sifra not in (0,1)
--
--
--
-- update t
--
-- set Bruto_polisirana_premija=Bruto_polisirana_premija / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
-- from #temp t
-- where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@dateto -- da se ne bi ponovo umanjila za porez
-- and Bransa<>19
--
--
-- update t
--
-- set Bruto_polisirana_premija=Neto_polisirana_premija
-- from #temp t
-- where storno_tip=2 and Bransa=11
--

update t
set bruto_polisirana_premija= (select sum(cast(replace(bra_bruttopraemie,',','.')  as decimal(18,2)))from branche b2 where t.polisa=b2.bra_obnr)
from #temp t

update t
set [ukupna_potrazivanja]=Bruto_polisirana_premija-(select sum(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=t.polisa)
from #temp t

--
-- update t
-- set Bruto_polisirana_premija=(select sum(Bruto_polisirana_premija) from #temp t2 where t2.polisa=t.polisa)
-- from #temp t

delete from #temp
where not exists (select 1 from vertrag v where v.vtg_pol_bran=#temp.bransa and v.vtg_vertragid=#temp.bra_vertragid);

update t
set Premija=
case
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Bruto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.polisa=t.polisa)-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.polisa=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #temp t


update t
set Premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr=t.polisa and pko_g_fall<>'SVOR')
from #temp t
where status_polise='Prekid' --and Nacin_Placanja not in (0,1)


update t

set Premija=Neto_polisirana_premija
from #temp t
where storno_tip=2 and Bransa=11 -- and Nacin_Placanja in (0,1)


update t

set Premija=Premija * cast(CEILING(cast(DATEDIFF(day,convert(date,[Pocetak_osiguranja],102),convert(date,@dateTo,102)) as decimal(18,2))/365) as int)
from #temp t
where Bransa in (78,79)

update #temp
set [Pocetak_osiguranja]=convert(varchar,convert(date,[Pocetak_osiguranja],102),104),
[Istek_osiguranja]=convert(varchar,convert(date,[Istek_osiguranja],102),104),
[Datum_storna]=convert(varchar,convert(date,[Datum_storna],102),104)

;WITH CTE_Praemienkonto AS (
select t.*,
--convert(varchar,convert(date,pko_wertedatum,104),102)                   datum_dokumenta,
pko_wertedatum                                                          datum_dokumenta,
cast(replace(pko_betragsoll,',','.') as decimal(18,2))				    duguje,
cast(replace(pko_betraghaben,',','.') as decimal(18,2))				    potrazuje,
cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))*-1	        saldo,
(select sum(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=p.pko_obnr) ukupno_dospjelo,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=p.pko_obnr)  ukupno_placeno,
(select SUM(bruto_polisirana_premija)from #temp)                        klijent_bruto_polisirana_premija,
(select SUM(neto_polisirana_premija) from #temp)                        klijent_neto_polisirana_premija,
(select sum(cast(replace(pko_betragsoll,',','.')as decimal(18,2))-cast(replace(pko_betraghaben,',','.') as decimal(18,2))) from #praemienkonto p2) klijent_dospjela_potrazivanja,
(select SUM(ukupna_potrazivanja) from #temp)                            klijent_ukupna_potrazivanja
from #praemienkonto p(nolock)
right join #temp t on p.pko_obnr=t.polisa
),
CTE_Final AS (
    SELECT 
        CTE_Praemienkonto.*,
 --       CASE
 --           WHEN ukupno_dospjelo - ukupno_placeno < 0 THEN 0.0
 --           ELSE ukupno_dospjelo - ukupno_placeno
 --       END AS ukupno_duguje,
        case when premija - ukupno_dospjelo <0 then 0
        else premija - ukupno_dospjelo
        END AS ukupno_nedospjelo,
        case when premija - ukupno_placeno < 0 then 0
        else premija - ukupno_placeno
        END AS ukupno_duguje

    FROM CTE_Praemienkonto
)
SELECT *
FROM CTE_Final
order by polisa,convert(date,datum_dokumenta,104) asc
