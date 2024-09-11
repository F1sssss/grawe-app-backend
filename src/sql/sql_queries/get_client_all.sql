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
np.opis																[nacin_placanja],
np.sifra															[nacin_placanja_sifra],
bra_vv_ueb															[naziv_branse],
dbo.Bruto_polisirana_premija_polisa(b.bra_obnr,@dateTo)				[bruto_polisirana_premija],
dbo.Neto_polisirana_premija_polisa(b.bra_obnr,@dateTo)				[neto_polisirana_premija],
cast(0 as integer)													[dani_kasnjenja],
cast(0 as decimal(18,2))											[ukupna_potrazivanja],
cast('' as vaRCHAR(400))											[status_polise],
bra_bran															[bransa],
bra_storno_grund													[storno_tip],
cast(0 as decimal(18,2))											[uplacena_premija],
case when bra_bran in (10,19,56) or (bra_bran=9 and bra_statistik_nr=11040)
then v.vtg_antrag_obnr
else 0 end      													[broj_ponude],
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
and
(exists (select 1 from praemienkonto pk where pk.pko_obnr=b.bra_obnr  and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,102) and convert(date,@dateTo,102)) or
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,102) and p.pko_obnr=b.bra_obnr order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
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


delete from #temp
where not exists (select 1 from vertrag v where v.vtg_pol_bran=#temp.bransa and v.vtg_vertragid=#temp.bra_vertragid);



update #temp
set [Pocetak_osiguranja]=convert(varchar,convert(date,[Pocetak_osiguranja],102),104),
[Istek_osiguranja]=convert(varchar,convert(date,[Istek_osiguranja],102),104),
[Datum_storna]=convert(varchar,convert(date,[Datum_storna],102),104)


;WITH CTE_Praemienkonto AS (
select t.*,
pko_buch_nr,
--convert(varchar,convert(date,pko_wertedatum,104),102)                   datum_dokumenta,
pko_wertedatum                                                          datum_dokumenta,
cast(replace(pko_betragsoll,',','.') as decimal(18,2))				    duguje,
cast(replace(pko_betraghaben,',','.') as decimal(18,2))				    potrazuje,
cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))*-1	        saldo,
(select sum(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=p.pko_obnr) ukupno_zaduzeno,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=p.pko_obnr)  ukupno_placeno,
(select SUM(bruto_polisirana_premija)from #temp)                        klijent_bruto_polisirana_premija,
(select SUM(neto_polisirana_premija) from #temp)                        klijent_neto_polisirana_premija,
(select top 1 cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))*-1 from #praemienkonto p2 where p2.pko_obnr=t.polisa order by convert(date,pko_wertedatum,104) desc, pko_buch_nr desc) dospjela_potrazivanja,
pko_b_art                                                               trangrupa1,
pko_g_fall                                                              trangrupa2
from #praemienkonto p(nolock)
right join #temp t on p.pko_obnr=t.polisa
),
CTE_Final AS (
    SELECT
        CTE_Praemienkonto.*,
        case when [bruto_polisirana_premija] - ukupno_placeno<0 or dospjela_potrazivanja<0 then 0
        else dospjela_potrazivanja end ukupno_dospjelo,
        case when [bruto_polisirana_premija] - ukupno_placeno - dospjela_potrazivanja <0 or [bruto_polisirana_premija] - ukupno_placeno<0 then 0
        else [bruto_polisirana_premija] - ukupno_placeno - case when dospjela_potrazivanja<0 then 0 else dospjela_potrazivanja end
        END AS ukupno_nedospjelo,
        [bruto_polisirana_premija] - ukupno_placeno
        AS ukupno_duguje
    FROM CTE_Praemienkonto
)
SELECT *,
(select sum(ukupno_duguje) from (select polisa,ukupno_duguje from CTE_Final group by polisa,ukupno_duguje)a)   klijent_ukupna_potrazivanja,
(select sum(ukupno_dospjelo) from (select polisa,ukupno_dospjelo from CTE_Final group by polisa,ukupno_dospjelo)a) klijent_dospjela_potrazivanja
FROM CTE_Final
order by polisa,convert(date,datum_dokumenta,104) asc,pko_buch_nr asc