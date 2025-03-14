
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
    kun_zuname + ' ' + isnull(kun_vorname,'')							[klijent],
    kun_geburtsdatum													[datum_rodjenja],
    case when kun_steuer_nr is not null and  kun_steuer_nr<>'' then cast(kun_steuer_nr as varchar)
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
    convert(varchar,bra_vers_beginn,104) 			                    [pocetak_osiguranja],
    convert(varchar,bra_vers_ablauf,104)   			                    [istek_osiguranja],
    convert(varchar,bra_storno_ab,104) 				                    [datum_storna],
    cast(0 as decimal(18,2))											[premija],
    np.opis																[nacin_placanja],
    bra_vv_ueb															[naziv_branse],
    dbo.Bruto_polisirana_premija_polisa(@policy,@dateto)				[bruto_polisirana_premija],
    dbo.Neto_polisirana_premija_polisa(@policy,@dateto)					[neto_polisirana_premija],
    (select sum(pko_betragsoll) from praemienkonto p2
     where p2.pko_obnr=b.bra_obnr and pko_wertedatum<=@dateto)			[ukupno_zaduzeno],
    (select sum(pko_betraghaben) from praemienkonto p2
     where p2.pko_obnr=b.bra_obnr and pko_wertedatum<=@dateto)			[ukupno_placeno],
    cast(0 as integer)													[dani_kasnjenja],
    cast(0 as decimal(18,2))											[ukupna_potrazivanja],
    (select top 1 pko_wertedatumsaldo*-1 from
        praemienkonto p2 where p2.pko_obnr=b.bra_obnr
                           and pko_wertedatum<=@dateto
     order by pko_wertedatum desc, pko_buch_nr desc)						[dospjela_potrazivanja],
    cast('' as vaRCHAR(400))											[status_polise],
    bra_bran															[bransa],
    bra_storno_grund													[storno_tip],
    cast(0 as decimal(18,2))											[uplacena_premija]
into #temp
from kunde k(nolock)
         left join vertrag v (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
         left join branche b (nolock) on b.bra_vertragid=v.vtg_vertragid
         left join #NaciniPlacanja np on np.sifra=vtg_zahlungsweise
where bra_obnr=@policy
  and v.vtg_pol_bran=bra_bran
--and gc.vkto in (SELECT cast(vkto as int) FROM [dbo].[fn_get_user_accessible_vktos](@userID))

if OBJECT_ID('tempdb..#praemienkonto') is not null
    drop table #praemienkonto


select * into #praemienkonto from praemienkonto p (nolock)
where p.pko_obnr in (select distinct polisa from #temp)
  and convert(date,p.pko_wertedatum,104)<=convert(date,@dateTo,102)





select t.*,
       convert(varchar,pko_wertedatum,104)																datum_dokumenta,
       pko_betraghaben																					potrazuje,
       pko_betragsoll																					duguje,
       pko_wertedatumsaldo * -1																		saldo,
       case when [bruto_polisirana_premija] - ukupno_placeno<0 or dospjela_potrazivanja<0 then 0
            else dospjela_potrazivanja end															ukupno_dospjelo,
       bruto_polisirana_premija- ukupno_placeno														ukupno_duguje,
       case when [bruto_polisirana_premija] - ukupno_placeno - dospjela_potrazivanja <0 or [bruto_polisirana_premija] - ukupno_placeno<0 then 0
            else [bruto_polisirana_premija] - ukupno_placeno - case when dospjela_potrazivanja<0 then 0 else dospjela_potrazivanja end
           END AS																					ukupno_nedospjelo,
       ISNULL((select SUM(bruto_polisirana_premija) from (select polisa,max(bruto_polisirana_premija) bruto_polisirana_premija  from #temp group by polisa)a),0) klijent_bruto_polisirana_premija,
       ISNULL((select SUM(neto_polisirana_premija) from (select polisa,max(neto_polisirana_premija) neto_polisirana_premija  from #temp group by polisa)a),0) klijent_neto_polisirana_premija,
       ISNULL((select sum(cast(pko_betraghaben as decimal(18,2))-cast(pko_betragsoll as decimal(18,2))) from #praemienkonto p2),0) klijent_dospjela_potrazivanja,
       ISNULL((select SUM(ukupna_potrazivanja) from (select polisa,max(ukupna_potrazivanja) ukupna_potrazivanja  from #temp group by polisa)a),0) klijent_ukupna_potrazivanja
from #praemienkonto p(nolock)
         right join #temp t on p.pko_obnr=t.polisa
order by polisa,pko_wertedatum asc,pko_buch_nr asc

