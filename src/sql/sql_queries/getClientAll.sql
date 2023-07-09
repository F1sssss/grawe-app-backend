if OBJECT_ID('tempdb..#temp') is not null
drop table #temp


select distinct
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
vtg_zahlungsweise													[nacin_placanja],
bra_vv_ueb															[naziv_branse],
cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))			[bruto_polisirana_premija],
cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))			[neto_polisirana_premija],
cast(0 as integer)													[dani_kasnjenja],
cast(0 as decimal(18,2))											[ukupna_potrazivanja],
cast(0 as decimal(18,2))											[dospjela_potrazivanja],
cast('' as vaRCHAR(400))											[status_polise],
bra_bran															[bransa],
bra_storno_grund													[storno_tip],
cast(0 as decimal(18,2))											[uplacena_premija]
into #temp
from kunde k(nolock)
left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
where case when kun_vorname is null then cast(kun_steuer_nr as varchar)
      else
      case when len(kun_yu_persnr)=12
      	then '0' + FORMAT(kun_yu_persnr, '0')
      else FORMAT(kun_yu_persnr, '0') end
      end		=@id



if OBJECT_ID('tempdb..#praemienkonto') is not null
drop table #praemienkonto


select * into #praemienkonto from praemienkonto p (nolock)
where p.pko_obnr in (select distinct polisa from #temp)
and convert(date,p.pko_wertedatum,104)<=convert(date,@dateTo,102)


update t
set [status_polise]=
case when isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@dateTo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka'
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla'
end
from #temp t



update t
set Bruto_polisirana_premija=
case
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Neto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.[polisa]=t.[polisa])-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from #praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[polisa]=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #temp t


update t
set Bruto_polisirana_premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from #praemienkonto pk(nolock) where pk.pko_obnr=t.polisa and pko_g_fall<>'SVOR')
from #temp t
where [status_polise]='Prekid' and Nacin_Placanja not in (0,1)


update t

set Bruto_polisirana_premija=Neto_polisirana_premija
from #temp t
where storno_tip=2 and Bransa=11


update t
set [ukupna_potrazivanja]=Bruto_polisirana_premija-[Uplacena_premija]
from #temp t


update t
set Bruto_polisirana_premija=(select sum(Bruto_polisirana_premija) from #temp t2 where t2.polisa=t.polisa)
from #temp t


select t.*,
convert(varchar,convert(date,pko_wertedatum,104),102) datum_dokumenta,
cast(replace(pko_betraghaben,',','.') as decimal(18,2))				    duguje,
cast(replace(pko_betragsoll,',','.') as decimal(18,2))				    potrazuje,
cast(replace(pko_wertedatumsaldo,',','.')as decimal(18,2))		        saldo,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=p.pko_obnr) ukupno_dospjelo,
(select sum(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from #praemienkonto p2 where p2.pko_obnr=p.pko_obnr) ukupno_placeno,
cast(0 as decimal(18,2))		                                        ukupno_dug,
cast(0 as decimal(18,2))                                                ukupno_nedospjelo,
(select SUM(bruto_polisirana_premija) from (select polisa,max(bruto_polisirana_premija) bruto_polisirana_premija  from #temp group by polisa)a) klijent_bruto_polisirana_premija,
(select SUM(neto_polisirana_premija) from (select polisa,max(neto_polisirana_premija) neto_polisirana_premija  from #temp group by polisa)a) klijent_neto_polisirana_premija,
(select sum(cast(replace(pko_betraghaben,',','.')as decimal(18,2))-cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from #praemienkonto p2) klijent_dospjela_potrazivanja,
(select SUM(ukupna_potrazivanja) from (select polisa,max(ukupna_potrazivanja) ukupna_potrazivanja  from #temp group by polisa)a) klijent_ukupna_potrazivanja
from #praemienkonto p(nolock)
right join #temp t on p.pko_obnr=t.polisa
order by polisa,Pocetak_osiguranja asc,pko_buch_nr asc