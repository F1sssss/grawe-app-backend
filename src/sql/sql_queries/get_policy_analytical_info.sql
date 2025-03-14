DECLARE @NaciniPlacanja TABLE (
                                  sifra TINYINT PRIMARY KEY,
                                  opis NVARCHAR(50)
                              );

INSERT INTO @NaciniPlacanja VALUES
                                (0, N'plaćanje odjednom'),
                                (1, N'godišnje plaćanje'),
                                (2, N'polugodisnje plaćanje'),
                                (4, N'kvartalno plaćanje'),
                                (6, N'mjesecno plaćanje');


select distinct
    gc.polisa                                [Broj_Polise],
    vtg_antrag_obnr                          [Broj_Ponude],
    vtg_pol_kreis                            [Pol_kreis],
    gc.bransa                                [Bransa],
    bra_vv_ueb                               [Naziv_Branse],
    CONVERT(varchar, [Pocetak_osiguranja],104)	[Pocetak_osiguranja],
    CONVERT(varchar, [Istek_osiguranja],104)	[Istek_osiguranja],
    CONVERT(varchar, [Datum_storna],104)		[Datum_storna],
    bra_storno_grund                         [Storno_tip],
    [Status_Polise],
    np.opis									 [Nacin_Placanja],
    dbo.Bruto_polisirana_premija_polisa(polisa,@dateTo)			[Bruto_polisirana_premija],
    dbo.Neto_polisirana_premija_polisa(polisa,@dateTo)          [Neto_polisirana_premija],
    gc.vkto												[Sifra_zastupnika],
    isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'')   [Naziv_zastupnika],
    ma_unterst_og										[Kanal_prodaje],
    cast(0 as int)										[Dani_Kasnjenja],
    CASE WHEN bra_bran not in (10,11,56,8)
             THEN (SELECT isnull(kun_zuname,'') + ' ' + isnull(kun_vorname,'') FROM kunde WHERE kun_kundenkz = v.vtg_kundenkz_2)
         ELSE (SELECT isnull(kun_zuname,'') + ' ' + isnull(kun_vorname,'') FROM kunde WHERE kun_kundenkz = v.vtg_kundenkz_1)
        END [Ugovarac],
    CASE WHEN bra_bran not in (10,11,56,8)
             THEN (SELECT isnull(kun_zuname,'') + ' ' + isnull(kun_vorname,'') FROM kunde WHERE kun_kundenkz = v.vtg_kundenkz_1)
         ELSE (SELECT isnull(kun_zuname,'') + ' ' + isnull(kun_vorname,'') FROM kunde WHERE kun_kundenkz = v.vtg_kundenkz_2)
        END [Osiguranik]
INTO #TEMP
from branche b(nolock)
         left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
         left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
         left join @NaciniPlacanja np on np.sifra=vtg_zahlungsweise
         join gr_clients_all gc (nolock) on gc.polisa = @policy and gc.polisa = b.bra_obnr
where bra_vers_beginn between @dateFrom and @dateTo
  and polisa = @policy
 --and gc.vkto in (SELECT cast(vkto as int) FROM [dbo].[fn_get_user_accessible_vktos](@userID))


DECLARE @Kasnjenja TABLE (
                             polisa int,
                             DaniKasnjenja int
                         );



insert into @Kasnjenja
    exec Dani_kasnjenja_polisa @dateTo,@policy


update f
set
    [Dani_Kasnjenja]=isnull((select DaniKasnjenja from @Kasnjenja where polisa=f.[Broj_Polise]),0),
    [Ugovarac] = ISNULL(Ugovarac, Osiguranik),
    [Osiguranik] = ISNULL(Osiguranik , Ugovarac)
from #temp f


select distinct *
from #temp