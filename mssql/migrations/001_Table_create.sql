USE master;
GO

-- Check if the database exists, create it if not
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GRAWE_DEV')
    BEGIN
        PRINT 'Creating database GRAWE_DEV...';
        CREATE DATABASE GRAWE_DEV;
        PRINT 'Database GRAWE_DEV created successfully.';
    END
GO


USE GRAWE_DEV;
GO


/****** Object:  Table [dbo].[adresse]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adresse](
	[adr_adressid] [int] NOT NULL,
	[adr_post_nation] [nvarchar](3) NULL,
	[adr_postlz] [nvarchar](10) NULL,
	[adr_postort] [nvarchar](27) NULL,
	[adr_ort] [nvarchar](27) NULL,
	[adr_strasse] [nvarchar](27) NULL,
	[adr_hausnr] [nvarchar](10) NULL,
	[adr_hauserg] [nvarchar](10) NULL,
	[adr_postfach] [nvarchar](30) NULL,
	[adr_ovkey] [nchar](15) NULL,
	[adr_vr_key] [int] NULL,
	[adr_pac] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[adr_adressid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[brache_porezi]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[brache_porezi](
	[branche_id] [int] NULL,
	[porez] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[branche]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[branche](
	[bra_branchenid] [int] NOT NULL,
	[bra_vertragid] [int] NULL,
	[bra_kfzid] [int] NULL,
	[bra_persid] [int] NULL,
	[bra_ortid] [int] NULL,
	[bra_divid] [int] NULL,
	[bra_vr_key] [int] NULL,
	[bra_oart] [nchar](2) NULL,
	[bra_obnr] [int] NULL,
	[bra_hist_nr] [int] NULL,
	[bra_bran] [int] NULL,
	[bra_brnr] [int] NULL,
	[bra_evi_nr] [int] NULL,
	[bra_statistik_nr] [int] NULL,
	[bra_schalterpol] [nchar](1) NULL,
	[bra_vae_datum] [datetime] NULL,
	[bra_vers_beginn] [datetime] NULL,
	[bra_vers_ablauf] [datetime] NULL,
	[bra_storno_ab] [datetime] NULL,
	[bra_storno_grund] [int] NULL,
	[bra_storno_abrechnung] [nchar](2) NULL,
	[bra_storno_kt_prozent] [float] NULL,
	[bra_storno_grund_text] [nvarchar](13) NULL,
	[bra_sistiert_ab] [datetime] NULL,
	[bra_sistiert_bis] [datetime] NULL,
	[bra_sistiert_grund] [nvarchar](30) NULL,
	[bra_tarifpraemie] [float] NULL,
	[bra_bonus_betrag] [float] NULL,
	[bra_malus_betrag] [float] NULL,
	[bra_nettopraemie1] [float] NULL,
	[bra_nettopraemie2] [float] NULL,
	[bra_bruttopraemie] [float] NULL,
	[bra_praemienfrei_wkz] [nchar](1) NULL,
	[bra_uz_prozent] [float] NULL,
	[bra_vst_prozent] [float] NULL,
	[bra_fst_prozent] [float] NULL,
	[bra_vv_kz_feld] [nchar](50) NULL,
	[bra_text_code] [int] NULL,
	[bra_text_wert] [nchar](1) NULL,
	[bra_text_code_z2] [int] NULL,
	[bra_text] [nvarchar](50) NULL,
	[bra_text_klausel] [nchar](1) NULL,
	[bra_kh_variante] [nchar](1) NULL,
	[bra_sondertarif] [nchar](1) NULL,
	[bra_vs_pauschal] [float] NULL,
	[bra_vs_person] [float] NULL,
	[bra_vs_ereignis] [float] NULL,
	[bra_vs_sachschaden] [float] NULL,
	[bra_bm_stufe_vv_lfd] [nchar](2) NULL,
	[bra_bm_stufe_vv_alt] [nchar](2) NULL,
	[bra_bm_bzr_vv] [nvarchar](6) NULL,
	[bra_bm_umreihung_am] [datetime] NULL,
	[bra_hu_datum] [datetime] NULL,
	[bra_hu_grund] [nvarchar](30) NULL,
	[bra_hu_behoerde] [nvarchar](30) NULL,
	[bra_abmelde_datum] [datetime] NULL,
	[bra_abmelde_grund] [nvarchar](30) NULL,
	[bra_vorvr_key_ablauf] [int] NULL,
	[bra_vers_beginn_ablaufk] [datetime] NULL,
	[bra_kaskoart] [int] NULL,
	[bra_kasko_prsatz] [float] NULL,
	[bra_listenpreis] [float] NULL,
	[bra_selbstbehalt] [float] NULL,
	[bra_tagesmaximum] [float] NULL,
	[bra_iu_prsatz] [float] NULL,
	[bra_iu_art] [nchar](2) NULL,
	[bra_iu_krad] [nchar](1) NULL,
	[bra_vs_tod] [float] NULL,
	[bra_vs_invalid] [float] NULL,
	[bra_heilkosten] [float] NULL,
	[bra_bergung] [float] NULL,
	[bra_taggeld] [float] NULL,
	[bra_spitalgeld] [float] NULL,
	[bra_vorsteuer] [nchar](1) NULL,
	[bra_vs_rueckhol] [float] NULL,
	[bra_kasko_wert] [nchar](1) NULL,
	[bra_selbstbehalt_proz] [float] NULL,
	[bra_selbstbehalt_min] [float] NULL,
	[bra_selbstbehalt_max] [float] NULL,
	[bra_index_art] [nchar](2) NULL,
	[bra_index_datum] [datetime] NULL,
	[bra_index_zahl] [float] NULL,
	[bra_index_auf_am] [datetime] NULL,
	[bra_index_auf_um] [float] NULL,
	[bra_index_datum_basis] [datetime] NULL,
	[bra_index_zahl_basis] [float] NULL,
	[bra_waehrung] [nchar](3) NULL,
	[bra_praemienfrei_bis] [datetime] NULL,
	[bra_blitz_betrag] [float] NULL,
	[bra_blitz_beginn] [datetime] NULL,
	[bra_blitz_ablauf] [datetime] NULL,
	[bra_tarif_stichtag] [datetime] NULL,
	[bra_kuend_datum] [datetime] NULL,
	[bra_kuend_grund] [int] NULL,
	[bra_text_code_at] [nchar](2) NULL,
	[bra_pz_ende] [datetime] NULL,
	[bra_laufzeit] [int] NULL,
	[bra_gewinn_modell] [int] NULL,
	[bra_paket_daten] [nvarchar](10) NULL,
	[bra_tarif_alter] [float] NULL,
	[bra_tarif_satz] [float] NULL,
	[bra_tarif_id] [nchar](7) NULL,
	[bra_vsst2] [float] NULL,
	[bra_vsst2_frei] [float] NULL,
	[bra_end_alter] [float] NULL,
	[bra_vvp_textm_ref] [nchar](3) NULL,
	[bra_statistik_nr_zus] [int] NULL,
	[bra_rente] [float] NULL,
	[bra_rente_dauer] [float] NULL,
	[bra_rente_kz] [nchar](1) NULL,
	[bra_statistik_gruppe] [nchar](7) NULL,
	[bra_bm_stufe_gw_alt] [nchar](3) NULL,
	[bra_bm_stufe_gw_lfd] [nchar](3) NULL,
	[bra_as_tab_index] [int] NULL,
	[bra_eh_tarif] [nchar](1) NULL,
	[bra_haft_mit_rs] [nchar](1) NULL,
	[bra_laufzeit_kz] [nchar](1) NULL,
	[bra_lenker] [nchar](1) NULL,
	[bra_rs_mit_sbh] [nchar](1) NULL,
	[bra_umreihung_gw_bm] [nchar](1) NULL,
	[bra_untervers_verzicht] [nchar](1) NULL,
	[bra_variante] [nchar](1) NULL,
	[bra_voraus_bonus] [nchar](1) NULL,
	[bra_voraus_bonus_zusatz] [nchar](1) NULL,
	[bra_vst_frei_grund] [nchar](1) NULL,
	[bra_vs_lv] [float] NULL,
	[bra_vs_lv_prfrei] [float] NULL,
	[bra_vs_lv_rueckk] [float] NULL,
	[bra_vs_lv_rente] [float] NULL,
	[bra_vs_lv_prf_abl] [float] NULL,
	[bra_vv_ueb] [nvarchar](100) NULL,
	[bra_beteiligung_kz] [nvarchar](10) NULL,
	[bra_vs_vermoegen] [float] NULL,
	[bra_vink_alt] [nvarchar](1) NULL,
	[bra_km_stand] [int] NULL,
	[bra_km_std_alt] [int] NULL,
	[bra_vers_beginn_hhmm] [nvarchar](5) NULL,
	[bra_kuehlaufbau_kz] [nvarchar](1) NULL,
	[bra_bm_uebergabe_opid] [nvarchar](5) NULL,
	[bra_bm_uebergabe_am] [date] NULL,
	[bra_bm_uebergabe_polnr] [nvarchar](30) NULL,
	[bra_bm_uebergabe_vrkey] [int] NULL,
	[bra_erster_vers_beginn] [datetime] NULL,
	[bra_erste_bruttopraemie] [float] NULL,
	[bra_ListenpreisPrfg] [nvarchar](1) NULL,
	[bra_sv_traeger] [nvarchar](10) NULL,
	[bra_region] [nvarchar](10) NULL,
	[bra_selbstbehalt_kz] [nvarchar](1) NULL,
	[bra_anpassung_stichtag] [datetime] NULL,
	[bra_praemienabweichung] [nvarchar](20) NULL,
	[bra_praemienabweichung_alter] [int] NULL,
	[bra_praemienabweichung_datum] [datetime] NULL,
	[bra_praemienabweichung_prozent] [float] NULL,
	[bra_anwartschaft] [nvarchar](1) NULL,
	[bra_anwartschaft_bis] [datetime] NULL,
	[bra_cde_recommendation_value] [nvarchar](70) NULL,
	[bra_cde_recommendation_text] [nvarchar](140) NULL,
 CONSTRAINT [PK_branche] PRIMARY KEY CLUSTERED 
(
	[bra_branchenid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_clients_all]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_clients_all](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[klijent] [nvarchar](255) NULL,
	[embg/pib] [varchar](50) NULL,
	[polisa] [int] NULL,
	[datum_rodjenja] [date] NULL,
	[adresa] [nvarchar](255) NULL,
	[mjesto] [nvarchar](100) NULL,
	[telefon1] [varchar](50) NULL,
	[telefon2] [varchar](50) NULL,
	[email] [varchar](100) NULL,
	[pocetak_osiguranja] [date] NULL,
	[istek_osiguranja] [date] NULL,
	[datum_storna] [date] NULL,
	[bransa] [int] NULL,
	[storno_tip] [nvarchar](50) NULL,
	[status_polise] [nvarchar](50) NULL,
	[vkto] [int] NULL,
	[last_updated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_datumi_presjeka]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_datumi_presjeka](
	[datumPresjeka] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_dnevne_greske]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_dnevne_greske](
	[id_greske] [int] NULL,
	[polisa] [int] NULL,
	[opis_greske] [varchar](300) NULL,
	[datum_greske] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_error_exceptions]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_error_exceptions](
	[polisa] [int] NULL,
	[id_greske] [int] NULL,
	[komentar] [varchar](2000) NULL,
	[datum_komentara] [date] NULL,
	[user_exception] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_hierarchy_groups]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_hierarchy_groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[level_type] [int] NOT NULL,
	[parent_id] [int] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_hierarchy_vkto_mapping]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_hierarchy_vkto_mapping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[vkto] [varchar](50) NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_pairing_permission_groups_permission]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_pairing_permission_groups_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_permission_group] [int] NULL,
	[id_permission] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_pairing_permisson_property_list]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_pairing_permisson_property_list](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_permission] [int] NULL,
	[id_permission_property] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_pairing_users_groups_permission]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_pairing_users_groups_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[permission_group_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_permission]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[route] [varchar](200) NULL,
	[visibility] [int] NULL,
	[method] [varchar](10) NULL,
	[name] [varchar](200) NULL,
	[description] [varchar](400) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_permission_groups]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_permission_groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NULL,
	[permission] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_permission_properties]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_permission_properties](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[read_right] [int] NULL,
	[write_right] [int] NULL,
	[group_id] [int] NULL,
	[permission_property_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_polisirane_premije_superset]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_polisirane_premije_superset](
	[Broj Polise] [float] NULL,
	[Broj Ponude] [float] NULL,
	[Pol_kreis] [float] NULL,
	[Bransa] [float] NULL,
	[Naziv_Branse] [nvarchar](255) NULL,
	[Statisticki_broj] [float] NULL,
	[Pocetak_osiguranja] [varchar](30) NULL,
	[Istek_osiguranja] [varchar](30) NULL,
	[Datum_storna] [varchar](30) NULL,
	[Storno tip] [float] NULL,
	[StatusPolise] [varchar](400) NULL,
	[Nacin_Placanja] [float] NULL,
	[Bruto_polisirana_premija] [decimal](18, 2) NULL,
	[Neto_polisirana_premija] [decimal](18, 2) NULL,
	[Premija] [decimal](18, 2) NULL,
	[Sifra zastupnika] [float] NULL,
	[Naziv zastupnika] [nvarchar](511) NOT NULL,
	[Kanal_prodaje] [float] NULL,
	[Ugovarac] [nvarchar](511) NOT NULL,
	[Osiguranik] [nvarchar](511) NOT NULL,
	[pocetak_osiguranja_datetime] [date] NULL,
	[istek_osiguranja_datetime] [date] NULL,
	[datum_storna_datetime] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_prekidi]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_prekidi](
	[datumPrekida] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_property_lists]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_property_lists](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[property_path] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gr_user_hierarchy_groups]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gr_user_hierarchy_groups](
	[user_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kunde]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kunde](
	[kun_kundenkz] [int] NOT NULL,
	[kun_vr_key] [int] NULL,
	[kun_art] [nchar](2) NULL,
	[kun_anrede] [nvarchar](10) NULL,
	[kun_besondere_anrede] [nvarchar](10) NULL,
	[kun_ak_titel] [nvarchar](10) NULL,
	[kun_zuname] [nvarchar](31) NULL,
	[kun_vorname] [nvarchar](31) NULL,
	[kun_nachsatz] [nvarchar](10) NULL,
	[kun_geburtsdatum] [datetime] NULL,
	[kun_vulgoname] [nvarchar](27) NULL,
	[kun_berufsschluessel] [int] NULL,
	[kun_berufsbezeichnung] [nvarchar](22) NULL,
	[kun_sprach_kz] [nchar](10) NULL,
	[kun_ku_nation] [nvarchar](100) NULL,
	[kun_yu_persnr] [bigint] NULL,
	[kun_gk_nr] [int] NULL,
	[kun_cs_modell] [nvarchar](100) NULL,
	[kun_cs_prozent] [int] NULL,
	[kun_cs_stufe] [int] NULL,
	[kun_cs_reserve] [nvarchar](20) NULL,
	[kun_cs_datum] [datetime] NULL,
	[kun_cs_rs1] [nvarchar](2) NULL,
	[kun_cs_rs2] [nvarchar](2) NULL,
	[kun_cs_rs3] [nchar](2) NULL,
	[kun_cs_rs4] [nchar](2) NULL,
	[kun_cs_rs5] [nchar](2) NULL,
	[kun_cs_kf1] [nchar](2) NULL,
	[kun_cs_kf2] [nchar](2) NULL,
	[kun_cs_kf3] [nchar](2) NULL,
	[kun_cs_kf4] [nchar](2) NULL,
	[kun_cs_kf5] [nchar](2) NULL,
	[kun_cs_pv1] [nchar](2) NULL,
	[kun_cs_pv2] [nchar](2) NULL,
	[kun_cs_pv3] [nchar](2) NULL,
	[kun_cs_pv4] [nchar](2) NULL,
	[kun_cs_pv5] [nchar](2) NULL,
	[kun_cs_fn1] [nchar](2) NULL,
	[kun_cs_fn2] [nchar](2) NULL,
	[kun_cs_fn3] [nchar](2) NULL,
	[kun_cs_fn4] [nchar](2) NULL,
	[kun_cs_fn5] [nchar](2) NULL,
	[kun_cs_af1] [nchar](2) NULL,
	[kun_cs_af2] [nchar](2) NULL,
	[kun_cs_af3] [nchar](2) NULL,
	[kun_cs_af4] [nchar](2) NULL,
	[kun_cs_af5] [nchar](2) NULL,
	[kun_schadensatz_gesamt_tk] [int] NULL,
	[kun_schadensatz_anzahl_tk] [int] NULL,
	[kun_berein_datum] [datetime] NULL,
	[kun_berein_kundenkz] [nvarchar](50) NULL,
	[kun_telefon_1] [nvarchar](50) NULL,
	[kun_telefon_2] [nvarchar](50) NULL,
	[kun_telefax_1] [nvarchar](50) NULL,
	[kun_telefax_2] [nvarchar](50) NULL,
	[kun_tele_mobil_1] [nvarchar](50) NULL,
	[kun_tele_mobil_2] [nvarchar](50) NULL,
	[kun_kunde_storno_ab] [datetime] NULL,
	[kun_kunde_storno_grund] [nvarchar](10) NULL,
	[kun_vf_vkto] [int] NULL,
	[kun_vn_vdat] [int] NULL,
	[kun_kz_schadenzahlung] [nvarchar](10) NULL,
	[kun_adr_vae_art] [nchar](10) NULL,
	[kun_sv_nr] [nchar](10) NULL,
	[kun_e_mail] [nvarchar](70) NULL,
	[kun_schadensatz] [int] NULL,
	[kun_dataen] [datetime] NULL,
	[kun_datneu] [datetime] NULL,
	[kun_usraen] [nvarchar](50) NULL,
	[kun_usrneu] [nvarchar](50) NULL,
	[kun_typ] [nvarchar](50) NULL,
	[kun_ersterkunde] [bit] NULL,
	[kun_vertragsanzahl] [int] NULL,
	[kun_sc_satz_proz_fn] [nvarchar](5) NULL,
	[kun_sc_satz_proz_uh] [nvarchar](5) NULL,
	[kun_sc_satz_proz_kf] [nvarchar](5) NULL,
	[kun_sc_satz_proz_eh] [nvarchar](5) NULL,
	[kun_sc_satz_anz_fn] [nvarchar](5) NULL,
	[kun_sc_satz_anz_uh] [nvarchar](5) NULL,
	[kun_sc_satz_anz_kf] [nvarchar](5) NULL,
	[kun_sc_satz_anz_eh] [nvarchar](5) NULL,
	[kun_csv] [nvarchar](max) NULL,
	[kun_gruppe] [nvarchar](20) NULL,
	[kun_schadensatz_anzahl] [int] NULL,
	[kun_aenart] [nvarchar](10) NULL,
	[kun_mpk_vkto] [int] NULL,
	[kun_mpk_jahr] [nchar](4) NULL,
	[kun_kis_rating] [nvarchar](5) NULL,
	[kun_guid] [uniqueidentifier] NULL,
	[kun_steuer_nr] [nvarchar](20) NULL,
	[kun_oib] [nvarchar](15) NULL,
	[kun_bankkundennummer] [bigint] NULL,
	[kun_achtung] [bit] NULL,
	[kun_ital] [nvarchar](27) NULL,
	[kun_ndg] [nvarchar](20) NULL,
	[kun_geburtsort] [nvarchar](27) NULL,
	[kun_geb_nation] [nvarchar](3) NULL,
	[kun_e_komm_info_grawe] [nvarchar](1) NULL,
	[kun_e_komm_zustimmung] [nvarchar](1) NULL,
	[kun_datimport] [datetime] NULL,
	[kun_antragsnr] [nvarchar](19) NULL,
	[kun_portalstatus] [nchar](1) NULL,
	[kun_appstatus] [nchar](1) NULL,
	[kun_staatsbuergerschaft] [nvarchar](3) NULL,
	[kun_steuerpflicht_usa] [nvarchar](1) NULL,
	[kun_alphaschluessel] [int] NULL,
	[kun_inkassoweg] [int] NULL,
	[kun_output_mail] [nvarchar](1) NULL,
	[kun_output_sms] [nvarchar](1) NULL,
	[kun_risiko_geldwaesche] [nvarchar](2) NULL,
	[kun_zsrv3] [int] NULL,
	[kun_unternehmenszweck] [nvarchar](10) NULL,
	[kun_letzter_berechnungsdruck] [datetime] NULL,
	[kun_keineSteuerNr] [bit] NULL,
	[kun_kz_aktion] [nvarchar](10) NULL,
	[kun_bevollmaechtigter_name] [nvarchar](63) NULL,
	[kun_bevollmaechtigter_addresse] [nvarchar](63) NULL,
	[kun_bevollmaechtigter_ort] [nvarchar](63) NULL,
	[kun_EKommInfoEmailStatus] [int] NULL,
	[kun_EKommInfoPhoneNrStatus] [int] NULL,
 CONSTRAINT [pk_kunde] PRIMARY KEY CLUSTERED 
(
	[kun_kundenkz] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mitarbeiter]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mitarbeiter](
	[ma_id] [int] NOT NULL,
	[ma_user_id] [nchar](10) NULL,
	[ma_user_password] [nvarchar](300) NULL,
	[ma_md_opid] [nvarchar](8) NULL,
	[ma_vr_key] [int] NULL,
	[ma_vkto] [int] NOT NULL,
	[ma_vkto_verwendung] [nvarchar](2) NULL,
	[ma_vkto_funktion] [nchar](2) NULL,
	[ma_unterst_ld] [int] NULL,
	[ma_unterst_ob] [int] NULL,
	[ma_unterst_og] [int] NULL,
	[ma_unterst_bb] [int] NULL,
	[ma_unterst_lfb] [int] NULL,
	[ma_unterst_et] [int] NULL,
	[ma_team_a] [int] NULL,
	[ma_team_s] [int] NULL,
	[ma_such_vkto_1] [int] NULL,
	[ma_such_vkto_2] [int] NULL,
	[ma_such_vkto_3] [int] NULL,
	[ma_such_vkto_4] [int] NULL,
	[ma_such_vkto_5] [int] NULL,
	[ma_such_bb] [int] NULL,
	[ma_vae_db] [nvarchar](14) NULL,
	[ma_vae_host] [nvarchar](14) NULL,
	[ma_anr] [nchar](2) NULL,
	[ma_vorname] [nvarchar](31) NULL,
	[ma_zuname] [nvarchar](31) NULL,
	[ma_ak_titel] [nvarchar](8) NULL,
	[ma_ort] [nvarchar](27) NULL,
	[ma_strasse] [nvarchar](27) NULL,
	[ma_hausnr] [int] NULL,
	[ma_hauserg] [nvarchar](9) NULL,
	[ma_post_nation] [nvarchar](3) NULL,
	[ma_postlz] [nvarchar](6) NULL,
	[ma_postort] [nvarchar](27) NULL,
	[ma_dienst_titel] [nvarchar](5) NULL,
	[ma_geburtsdatum] [nvarchar](10) NULL,
	[ma_persnr] [int] NULL,
	[ma_sv_nr] [nvarchar](15) NULL,
	[ma_sprach_kz] [nchar](2) NULL,
	[ma_tel_fest_priv] [nvarchar](50) NULL,
	[ma_tel_fest_dienst] [nvarchar](50) NULL,
	[ma_tel_mobil_priv] [nvarchar](50) NULL,
	[ma_tel_mobil_dienst] [nvarchar](50) NULL,
	[ma_fax_priv] [nvarchar](50) NULL,
	[ma_fax_dienst] [nvarchar](50) NULL,
	[ma_email_priv] [nvarchar](75) NULL,
	[ma_email_dienst] [nvarchar](75) NULL,
	[ma_http_priv] [nvarchar](50) NULL,
	[ma_http_dienst] [nvarchar](50) NULL,
	[ma_sa] [nvarchar](4) NULL,
	[ma_nimmzusatz] [bit] NULL,
	[ma_zusatz1] [nvarchar](50) NULL,
	[ma_zusatz2] [nvarchar](50) NULL,
	[ma_zusatz3] [nvarchar](50) NULL,
	[ma_zusatz4] [nvarchar](50) NULL,
	[ma_zusatz5] [nvarchar](50) NULL,
	[ma_csv] [nvarchar](max) NULL,
	[ma_datneu] [datetime] NULL,
	[ma_kz_scn_pc] [nvarchar](10) NULL,
	[ma_unterst_firma] [int] NULL,
	[ma_unterst_ldir] [int] NULL,
	[ma_such_region] [int] NULL,
	[ma_such_provision] [int] NULL,
	[ma_vkto_status_text] [nvarchar](15) NULL,
	[ma_eintritt] [nvarchar](10) NULL,
	[ma_inaktiv_ab] [nvarchar](10) NULL,
	[ma_prov_sql] [int] NULL,
	[ma_prov_sql_name] [nvarchar](50) NULL,
	[ma_sql_alle] [nchar](1) NULL,
	[ma_sql_vkto] [int] NULL,
	[ma_steuer_nr] [nvarchar](15) NULL,
	[ma_register_nr] [nvarchar](18) NULL,
	[ma_finanzamt_nr] [nvarchar](2) NULL,
	[ma_waehrung] [nvarchar](3) NULL,
	[ma_prov_schema] [nvarchar](2) NULL,
	[ma_vkto_orgbez] [nvarchar](12) NULL,
	[ma_ueberw_stop] [nvarchar](40) NULL,
	[ma_md_abt] [nchar](3) NULL,
	[ma_versand_bb] [int] NULL,
	[ma_kostenstelle] [int] NULL,
	[ma_vkto_kzr_11] [int] NULL,
	[ma_vkto_kzr_12] [int] NULL,
	[ma_vkto_kzr_13] [int] NULL,
	[ma_vkto_kzr_14] [int] NULL,
	[ma_vkto_kzr_15] [int] NULL,
	[ma_vkto_kzr_21] [int] NULL,
	[ma_vkto_kzr_22] [int] NULL,
	[ma_vkto_kzr_23] [int] NULL,
	[ma_vkto_kzr_24] [int] NULL,
	[ma_vkto_kzr_25] [int] NULL,
	[ma_vkto_kzr_31] [int] NULL,
	[ma_vkto_kzr_32] [int] NULL,
	[ma_vkto_kzr_33] [int] NULL,
	[ma_vkto_kzr_34] [int] NULL,
	[ma_vkto_kzr_35] [int] NULL,
	[ma_vkto_kzr_41] [int] NULL,
	[ma_vkto_kzr_42] [int] NULL,
	[ma_vkto_kzr_43] [int] NULL,
	[ma_vkto_kzr_44] [int] NULL,
	[ma_vkto_kzr_45] [int] NULL,
	[ma_zs_kundenkz_1] [int] NULL,
	[ma_zs_bankleitzahl_1] [bigint] NULL,
	[ma_zs_bankkontonummer_1] [nvarchar](30) NULL,
	[ma_zs_kundenkz_2] [int] NULL,
	[ma_zs_bankleitzahl_2] [bigint] NULL,
	[ma_zs_bankkontonummer_2] [nvarchar](30) NULL,
	[ma_zs_kundenkz_3] [int] NULL,
	[ma_zs_bankleitzahl_3] [bigint] NULL,
	[ma_zs_bankkontonummer_3] [nvarchar](30) NULL,
	[ma_zs_kundenkz_4] [int] NULL,
	[ma_zs_bankleitzahl_4] [bigint] NULL,
	[ma_zs_bankkontonummer_4] [nvarchar](30) NULL,
	[ma_sub_vr_key] [int] NULL,
	[ma_fremd_rvd] [nvarchar](22) NULL,
	[ma_fremd_merkur] [nvarchar](22) NULL,
	[ma_fremd_abv] [nvarchar](22) NULL,
	[ma_omds_vkto] [int] NULL,
	[ma_omds_art] [nchar](1) NULL,
	[ma_omds_version] [nvarchar](5) NULL,
	[ma_omds_email] [nvarchar](75) NULL,
	[ma_kz_anzahl_laptops] [int] NULL,
	[ma_kz_anzahl_standgeraete] [int] NULL,
	[ma_kz_pc_nota] [nvarchar](2) NULL,
	[ma_kz_pc_bestand] [bit] NULL,
	[ma_md_sprache] [nvarchar](2) NULL,
	[ma_kz_pol_empf] [bit] NULL,
	[ma_kz_scn_info] [bit] NULL,
	[ma_kz_omds_intervall] [nvarchar](1) NULL,
	[ma_kz_papierantrag] [bit] NULL,
	[ma_kz_fachabt_fn] [bit] NULL,
	[ma_kz_fachabt_uh] [bit] NULL,
	[ma_kz_fachabt_kf] [bit] NULL,
	[ma_kz_fachabt_lv] [bit] NULL,
	[ma_kz_fachabt_kv] [bit] NULL,
	[ma_kz_rabattstufe_fn] [nvarchar](2) NULL,
	[ma_kz_rabattstufe_uh] [nvarchar](2) NULL,
	[ma_kz_rabattstufe_kf] [nvarchar](2) NULL,
	[ma_kz_rabattstufe_lv] [nvarchar](2) NULL,
	[ma_kz_rabattstufe_kv] [nvarchar](2) NULL,
	[ma_kz_unter_mindestpraem_fn] [bit] NULL,
	[ma_kz_unter_mindestpraem_uh] [bit] NULL,
	[ma_kz_unter_mindestpraem_kf] [bit] NULL,
	[ma_kz_unter_mindestpraem_lv] [bit] NULL,
	[ma_kz_unter_mindestpraem_kv] [bit] NULL,
	[ma_kz_drf_erfassung_id_fn] [bit] NULL,
	[ma_kz_drf_erfassung_id_uh] [bit] NULL,
	[ma_kz_drf_erfassung_id_kf] [bit] NULL,
	[ma_kz_drf_erfassung_id_lv] [bit] NULL,
	[ma_kz_drf_erfassung_id_kv] [bit] NULL,
	[ma_kz_tarifvariante_fn] [nvarchar](2) NULL,
	[ma_kz_tarifvariante_uh] [nvarchar](2) NULL,
	[ma_kz_tarifvariante_kf] [nvarchar](2) NULL,
	[ma_kz_tarifvariante_lv] [nvarchar](2) NULL,
	[ma_kz_tarifvariante_kv] [nvarchar](2) NULL,
	[ma_vkto_status] [int] NULL,
	[ma_scn_lim_gesamt] [float] NULL,
	[ma_scn_lim_kasko] [float] NULL,
	[ma_scn_lim_unfall_knochenbruch] [float] NULL,
	[ma_scn_lim] [float] NULL,
	[ma_sc_kosten] [nvarchar](1) NULL,
	[ma_kz_gb_drf] [nvarchar](1) NULL,
	[ma_kz_gb_best] [nvarchar](1) NULL,
	[ma_kz_gb_prov] [nvarchar](1) NULL,
	[ma_dataen] [datetime] NULL,
	[ma_kz_gb_best_ausw] [nvarchar](1) NULL,
	[ma_kz_gb_sub_user] [nvarchar](1) NULL,
	[ma_SperreKuBetrUeb] [nvarchar](1) NULL,
	[ma_SperrePoEinzelAbzg] [nvarchar](1) NULL,
	[ma_datimport] [datetime] NULL,
	[ma_zs_bank_bic_1] [nvarchar](11) NULL,
	[ma_zs_bank_iban_1] [nvarchar](34) NULL,
	[ma_zs_bank_bic_2] [nvarchar](11) NULL,
	[ma_zs_bank_iban_2] [nvarchar](34) NULL,
	[ma_zs_bank_bic_3] [nvarchar](11) NULL,
	[ma_zs_bank_iban_3] [nvarchar](34) NULL,
	[ma_zs_bank_bic_4] [nvarchar](11) NULL,
	[ma_zs_bank_iban_4] [nvarchar](34) NULL,
	[ma_lizenznummer] [nvarchar](50) NULL,
	[ma_mentor] [bit] NULL,
	[ma_lizenzdatum] [datetime] NULL,
	[ma_vermittlername] [nvarchar](150) NULL,
	[ma_vermittleradresse] [nvarchar](250) NULL,
	[ma_berechtLaden] [nvarchar](1) NULL,
	[ma_sessionTimeOutDate] [datetime] NULL,
	[ma_isa_berechtigung] [nvarchar](5) NULL,
	[ma_kfz_prov_534_haft] [float] NULL,
	[ma_kfz_prov_534_kasko] [float] NULL,
	[ma_agenturDaten] [nvarchar](250) NULL,
	[ma_versicherungen] [nvarchar](500) NULL,
	[ma_schemaProz] [int] NULL,
	[ma_drfProz] [int] NULL,
	[ma_izz_versichererauflagen] [nvarchar](2) NULL,
	[ma_izz_versgesetzbelehrung] [nvarchar](2) NULL,
	[ma_lastLoggedInDate] [datetime] NULL,
	[ma_kz_fachabt_sc] [nvarchar](10) NULL,
	[ma_kz_boev] [bit] NULL,
	[ma_scnSchema] [nvarchar](100) NULL,
	[ma_scnSchemaStueck] [int] NULL,
	[ma_scnKulanzProz] [float] NULL,
	[ma_IsFotoDrucken] [bit] NULL,
	[ma_gerechnetFuer] [int] NULL,
	[ma_isIddMandatory] [bit] NOT NULL,
	[ma_VollmachtNummer] [nvarchar](40) NULL,
	[ma_VollmachtDatum] [datetime] NULL,
	[ma_uosUsername] [nvarchar](200) NULL,
	[ma_uosPassword] [nvarchar](200) NULL,
	[ma_uosAgentLizenzNr] [nvarchar](200) NULL,
	[ma_uosAgentLizenzNrDatum] [datetime] NULL,
	[ma_uosAngestellterLizenzNr] [nvarchar](200) NULL,
	[ma_uosAngestellterLizenzNrDatum] [datetime] NULL,
	[ma_uosAngestellterIstTechnischePruefstelle] [bit] NULL,
	[ma_IsBiBMandatory] [bit] NOT NULL,
	[ma_zertifikatNr] [nvarchar](20) NULL,
	[ma_zertifikatNrBis] [int] NULL,
	[ma_hpVersNr] [nvarchar](20) NULL,
	[ma_hpVersNrBis] [int] NULL,
	[ma_personal_nr] [nvarchar](50) NULL,
	[ma_dienst_titel_seit] [int] NULL,
	[ma_eintritt_ehrung] [int] NULL,
	[ma_ApprovalPermission] [bit] NOT NULL,
	[ma_PaymentBlocked] [bit] NOT NULL,
	[ma_PaymentLimit] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ma_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mitarbeiter_kontakt]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mitarbeiter_kontakt](
	[makon_id] [int] NOT NULL,
	[makon_ges] [int] NULL,
	[makon_v_firma] [int] NULL,
	[makon_firma] [nvarchar](12) NULL,
	[makon_v_ld] [int] NULL,
	[makon_ld] [nvarchar](12) NULL,
	[makon_v_ob] [int] NULL,
	[makon_ob] [nvarchar](12) NULL,
	[makon_v_org] [int] NULL,
	[makon_org] [nvarchar](12) NULL,
	[makon_v_bb] [int] NULL,
	[makon_bb] [nvarchar](12) NULL,
	[makon_v_lfb] [int] NULL,
	[makon_lfb] [nvarchar](12) NULL,
	[makon_v_team] [int] NULL,
	[makon_team] [nvarchar](12) NULL,
	[makon_vkto] [int] NULL,
	[makon_persnr] [int] NULL,
	[makon_kost_org] [int] NULL,
	[makon_status] [int] NULL,
	[makon_status_text] [nvarchar](10) NULL,
	[makon_verwendung] [nvarchar](12) NULL,
	[makon_anr] [nvarchar](2) NULL,
	[makon_name] [nvarchar](31) NULL,
	[makon_postlz] [int] NULL,
	[makon_postort] [nvarchar](27) NULL,
	[makon_post_nat] [nvarchar](3) NULL,
	[makon_adresse] [nvarchar](27) NULL,
	[makon_tel_privat] [nvarchar](30) NULL,
	[makon_tel_dienst] [nvarchar](75) NULL,
	[makon_fax] [nvarchar](75) NULL,
	[makon_eintritt] [datetime] NULL,
	[makon_vkto_ab] [datetime] NULL,
	[makon_geb_datum] [datetime] NULL,
	[makon_diensttitel] [nvarchar](5) NULL,
	[makon_diensttitel_seit] [datetime] NULL,
	[makon_opid] [nvarchar](8) NULL,
	[makon_internet] [nvarchar](1) NULL,
	[makon_pc] [nvarchar](1) NULL,
	[makon_best_an_1] [int] NULL,
	[makon_best_an_2] [int] NULL,
	[makon_best_an_3] [int] NULL,
	[makon_best_ma72] [int] NULL,
	[makon_best_ma29] [int] NULL,
	[makon_stichtag] [datetime] NULL,
	[makon_c_team] [int] NULL,
	[makon_c_name] [nvarchar](15) NULL,
	[makon_h_team] [int] NULL,
	[makon_h_name] [nvarchar](15) NULL,
	[makon_s_team] [int] NULL,
	[makon_s_name] [nvarchar](15) NULL,
	[makon_email] [nvarchar](40) NULL,
	[makon_sc_schema] [nvarchar](2) NULL,
	[makon_zuname] [nvarchar](31) NULL,
	[makon_vorname] [nvarchar](31) NULL,
	[makon_gl_vkto] [int] NULL,
	[makon_gl_name] [nvarchar](15) NULL,
	[makon_anz_kunden] [int] NULL,
	[makon_anz_kunvtg] [int] NULL,
	[makon_gemeinde] [int] NULL,
	[makon_gem_name] [nvarchar](15) NULL,
	[makon_edv_dat] [datetime] NULL,
	[makon_verw] [int] NULL,
	[makon_funk] [int] NULL,
	[makon_inaktiv_ab] [datetime] NULL,
	[makon_best_01] [float] NULL,
	[makon_best_02] [float] NULL,
	[makon_best_03] [float] NULL,
	[makon_best_04] [float] NULL,
	[makon_best_05] [float] NULL,
	[makon_stk_01] [float] NULL,
	[makon_stk_02] [float] NULL,
	[makon_stk_03] [float] NULL,
	[makon_stk_04] [float] NULL,
	[makon_stk_05] [float] NULL,
	[makon_pd_06_01] [float] NULL,
	[makon_pd_10_01] [float] NULL,
	[makon_pd_12_01] [float] NULL,
	[makon_pd_14_01] [float] NULL,
	[makon_pd_15_01] [float] NULL,
	[makon_pd_06_02] [float] NULL,
	[makon_pd_10_02] [float] NULL,
	[makon_pd_12_02] [float] NULL,
	[makon_pd_14_02] [float] NULL,
	[makon_pd_15_02] [float] NULL,
	[makon_pd_06_03] [float] NULL,
	[makon_pd_10_03] [float] NULL,
	[makon_pd_12_03] [float] NULL,
	[makon_pd_14_03] [float] NULL,
	[makon_pd_15_03] [float] NULL,
	[makon_pd_06_04] [float] NULL,
	[makon_pd_10_04] [float] NULL,
	[makon_pd_12_04] [float] NULL,
	[makon_pd_14_04] [float] NULL,
	[makon_pd_15_04] [float] NULL,
	[makon_pd_06_05] [float] NULL,
	[makon_pd_10_05] [float] NULL,
	[makon_pd_12_05] [float] NULL,
	[makon_pd_14_05] [float] NULL,
	[makon_pd_15_05] [float] NULL,
	[makon_st_06_01] [float] NULL,
	[makon_st_10_01] [float] NULL,
	[makon_st_12_01] [float] NULL,
	[makon_st_14_01] [float] NULL,
	[makon_st_15_01] [float] NULL,
	[makon_st_06_02] [float] NULL,
	[makon_st_10_02] [float] NULL,
	[makon_st_12_02] [float] NULL,
	[makon_st_14_02] [float] NULL,
	[makon_st_15_02] [float] NULL,
	[makon_st_06_03] [float] NULL,
	[makon_st_10_03] [float] NULL,
	[makon_st_12_03] [float] NULL,
	[makon_st_14_03] [float] NULL,
	[makon_st_15_03] [float] NULL,
	[makon_st_06_04] [float] NULL,
	[makon_st_10_04] [float] NULL,
	[makon_st_12_04] [float] NULL,
	[makon_st_14_04] [float] NULL,
	[makon_st_15_04] [float] NULL,
	[makon_st_06_05] [float] NULL,
	[makon_st_10_05] [float] NULL,
	[makon_st_12_05] [float] NULL,
	[makon_st_14_05] [float] NULL,
	[makon_st_15_05] [float] NULL,
	[makon_prod_01] [float] NULL,
	[makon_prod_02] [float] NULL,
	[makon_prod_03] [float] NULL,
	[makon_prod_04] [float] NULL,
	[makon_prod_05] [float] NULL,
	[makon_prod_stk_01] [float] NULL,
	[makon_prod_stk_02] [float] NULL,
	[makon_prod_stk_03] [float] NULL,
	[makon_prod_stk_04] [float] NULL,
	[makon_prod_stk_05] [float] NULL,
	[makon_v_ldir] [int] NULL,
	[makon_ldir] [nvarchar](12) NULL,
	[makon_telefondienst] [nvarchar](75) NULL,
	[makon_telefonprivat] [nvarchar](75) NULL,
	[makon_faxdienst] [nvarchar](75) NULL,
	[makon_faxprivat] [nvarchar](75) NULL,
	[makon_mobildienst] [nvarchar](75) NULL,
	[makon_mobilprivat] [nvarchar](75) NULL,
	[makon_maildienst] [nvarchar](75) NULL,
	[makon_mailprivat] [nvarchar](75) NULL,
	[makon_telefonbb] [nvarchar](75) NULL,
	[makon_faxbb] [nvarchar](75) NULL,
	[makon_region] [int] NULL,
	[makon_ga] [float] NULL,
	[makon_gf] [float] NULL,
	[makon_gn] [float] NULL,
	[makon_sum_haben] [float] NULL,
	[makon_za_zh_zl] [float] NULL,
	[makon_sum_soll] [float] NULL,
	[makon_csv] [nvarchar](max) NULL,
	[makon_datneu] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[makon_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[praemienkonto]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[praemienkonto](
	[pko_praemienkontoid] [int] NOT NULL,
	[pko_vr_key] [int] NULL,
	[pko_oart] [nvarchar](2) NULL,
	[pko_obnr] [int] NULL,
	[pko_wertedatum] [datetime] NULL,
	[pko_b_art] [nvarchar](15) NULL,
	[pko_g_fall] [nvarchar](5) NULL,
	[pko_wertvondat] [datetime] NULL,
	[pko_wertbisdat] [datetime] NULL,
	[pko_betragsoll] [float] NULL,
	[pko_betraghaben] [float] NULL,
	[pko_wertedatumsaldo] [float] NULL,
	[pko_auszifferstatus] [nvarchar](1) NULL,
	[pko_mahnstufe] [int] NULL,
	[pko_buchungssaldo] [float] NULL,
	[pko_buch_nr] [int] NULL,
	[pko_aufgabeamdatum] [datetime] NULL,
	[pko_waehrung] [nvarchar](3) NULL,
	[pko_gf_key] [int] NULL,
	[pko_csv] [nvarchar](max) NULL,
	[pko_datneu] [datetime] NULL,
	[pko_betragsoll_2] [float] NULL,
	[pko_betraghaben_2] [float] NULL,
	[pko_wertedatumsaldo_2] [float] NULL,
	[pko_buchungssaldo_2] [float] NULL,
	[pko_waehrung_2] [nvarchar](3) NULL,
	[pko_buchungstext] [nvarchar](200) NULL,
 CONSTRAINT [PK_praemiennkonto] PRIMARY KEY CLUSTERED 
(
	[pko_praemienkontoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reports]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reports](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[report_name] [varchar](200) NULL,
	[procedure_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reports_param_options]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reports_param_options](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[procedure_id] [int] NULL,
	[report_id] [int] NULL,
	[order_param] [int] NULL,
	[param_name] [varchar](200) NULL,
	[sql] [varchar](8000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schaden]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schaden](
	[scn_id] [int] NOT NULL,
	[scn_ident_vr_key] [int] NULL,
	[scn_ident_kreis] [nvarchar](50) NULL,
	[scn_ident_bran] [int] NULL,
	[scn_ident_jahr] [int] NULL,
	[scn_ident_pol_filiale] [int] NULL,
	[scn_ident_lfd_nr] [int] NULL,
	[scn_hist_nr] [int] NULL,
	[scn_sprach_kz] [nvarchar](50) NULL,
	[scn_waehrung_scn] [nvarchar](50) NULL,
	[scn_schaden_vn] [nvarchar](50) NULL,
	[scn_referent] [nvarchar](50) NULL,
	[scn_urschl] [int] NULL,
	[scn_stand] [int] NULL,
	[scn_ereignis_dt] [datetime] NULL,
	[scn_gesamt_schaden] [float] NULL,
	[scn_kosten_nodisplay] [float] NULL,
	[scn_zahlungen] [float] NULL,
	[scn_sb_vkto] [int] NULL,
	[scn_statistik_nr] [int] NULL,
	[scn_statistik_nr_zus] [int] NULL,
	[scn_kz_f111_vv_verschkz] [nvarchar](50) NULL,
	[scn_ptr_vte_oart] [nvarchar](50) NULL,
	[scn_ptr_vte_obnr] [int] NULL,
	[scn_ptr_vte_hist] [int] NULL,
	[scn_ptr_vve_evi] [int] NULL,
	[scn_ptr_vve_bran] [int] NULL,
	[scn_ptr_vve_brnr] [int] NULL,
	[scn_anmelde_dt] [datetime] NULL,
	[scn_erledigt_am] [datetime] NULL,
	[scn_bran_ueb] [nvarchar](100) NULL,
	[scn_kundenkz_vn1] [int] NULL,
	[scn_csv] [nvarchar](max) NULL,
	[scn_datneu] [datetime] NULL,
	[scn_pc_schaden_nummer] [nvarchar](20) NULL,
	[scn_dataen] [datetime] NULL,
	[scn_anlageart] [nvarchar](1) NULL,
	[scn_schema] [nvarchar](1) NULL,
	[scn_digsigniert] [nvarchar](1) NULL,
	[scn_fotoanzahl] [int] NULL,
	[scn_kulanzzahlungen] [float] NULL,
	[scn_pendenz] [float] NULL,
	[scn_fremdbezug] [nvarchar](25) NULL,
	[scn_unfallort] [nvarchar](140) NULL,
	[scn_unfall_nation] [nvarchar](3) NULL,
	[scn_unfallhergang] [nvarchar](700) NULL,
 CONSTRAINT [PK_schaden] PRIMARY KEY CLUSTERED 
(
	[scn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schadenperson]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schadenperson](
	[scp_id] [int] NOT NULL,
	[scp_schadenid] [int] NULL,
	[scp_anrede] [nvarchar](10) NULL,
	[scp_zuname] [nvarchar](50) NULL,
	[scp_vorname] [nvarchar](50) NULL,
	[scp_vulgoname] [nvarchar](50) NULL,
	[scp_titel] [nvarchar](10) NULL,
	[scp_post_nation] [nvarchar](10) NULL,
	[scp_postlz] [nvarchar](10) NULL,
	[scp_ort] [nvarchar](50) NULL,
	[scp_strasse] [nvarchar](50) NULL,
	[scp_hausnr] [nchar](4) NULL,
	[scp_hauserg] [nvarchar](20) NULL,
	[scp_bankleitzahl] [nvarchar](20) NULL,
	[scp_bankkontonummer] [nvarchar](30) NULL,
	[scp_ptr_kun_kundenkz] [int] NULL,
	[scp_vtg_ku_rolle] [nchar](4) NULL,
	[scp_vtg_ku_rolle_fnr] [int] NULL,
	[scp_ku_rolle1] [nvarchar](10) NULL,
	[scp_ku_rolle2] [nvarchar](10) NULL,
	[scp_ku_rolle3] [nvarchar](10) NULL,
	[scp_ku_rolle4] [nvarchar](10) NULL,
	[scp_ku_rolle5] [nvarchar](10) NULL,
	[scp_ptr_satzart_vi] [nvarchar](1) NULL,
	[scp_ptr_ident_vi_idc] [int] NULL,
	[scp_bic] [nvarchar](11) NULL,
	[scp_iban] [nvarchar](34) NULL,
	[scp_steuernummer] [nvarchar](20) NULL,
 CONSTRAINT [PK_schadenperson] PRIMARY KEY NONCLUSTERED 
(
	[scp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_berechtigung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE CLUSTERED INDEX [ix_berechtigung] ON [dbo].[schadenperson]
(
	[scp_schadenid] ASC,
	[scp_ku_rolle1] ASC,
	[scp_ku_rolle2] ASC,
	[scp_ku_rolle3] ASC,
	[scp_ku_rolle4] ASC,
	[scp_ku_rolle5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schadenprozess]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schadenprozess](
	[spz_id] [int] NOT NULL,
	[spz_nummer] [int] NULL,
	[spz_beginn] [datetime] NULL,
	[spz_ende] [datetime] NULL,
	[spz_klageziel] [float] NULL,
	[spz_waehrung_scn] [nvarchar](3) NULL,
	[spz_schadenid] [int] NULL,
 CONSTRAINT [PK_schadenprozess] PRIMARY KEY CLUSTERED 
(
	[spz_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schadenvi]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schadenvi](
	[scv_id] [int] NOT NULL,
	[scv_schadenid] [int] NULL,
	[scv_evi_art] [nvarchar](10) NULL,
	[scv_identcounter] [int] NULL,
	[scv_kurzform_vi] [nvarchar](100) NULL,
	[scv_satzart] [nvarchar](10) NULL,
	[scv_kfz_kennzeichen] [nvarchar](30) NULL,
	[scv_kfz_nationenkz] [nvarchar](5) NULL,
	[scv_post_nation] [nvarchar](5) NULL,
	[scv_postlz] [nvarchar](10) NULL,
	[scv_postort] [nvarchar](50) NULL,
	[scv_strasse] [nvarchar](50) NULL,
	[scv_hausnr] [nvarchar](4) NULL,
	[scv_hauserg] [nvarchar](20) NULL,
	[scv_anrede] [nchar](5) NULL,
	[scv_zuname] [nvarchar](50) NULL,
	[scv_vorname] [nvarchar](50) NULL,
	[scv_vatersname] [nvarchar](50) NULL,
	[scv_geburtsdatum] [datetime] NULL,
	[scv_ovkey] [nvarchar](40) NULL,
	[scv_fahrgestell] [nvarchar](21) NULL,
	[scv_fabrikat] [nvarchar](25) NULL,
	[scv_fahrzeugtyp] [nvarchar](10) NULL,
 CONSTRAINT [PK_schadenvi] PRIMARY KEY CLUSTERED 
(
	[scv_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schadenzahlung]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schadenzahlung](
	[scz_id] [int] NOT NULL,
	[scz_schadenid] [int] NULL,
	[scz_waehrung_scn] [nvarchar](10) NULL,
	[scz_betrag] [float] NULL,
	[scz_verbdatum] [datetime] NULL,
	[scz_wertedatum] [datetime] NULL,
	[scz_bu_zweck] [nvarchar](50) NULL,
	[scz_bankleitzahl] [nvarchar](15) NULL,
	[scz_bankkontonummer] [nvarchar](30) NULL,
	[scz_kz_f116_belegart] [nvarchar](50) NULL,
	[scz_kz_f116_belegtyp] [nvarchar](50) NULL,
	[scz_empf_gk_nr] [int] NULL,
	[scz_empf_zuname] [nvarchar](50) NULL,
	[scz_empf_vorname] [nvarchar](50) NULL,
	[scz_empf_vulgoname] [nvarchar](50) NULL,
	[scz_empf_post_nation] [nchar](3) NULL,
	[scz_empf_postlz] [nvarchar](6) NULL,
	[scz_empf_ort] [nvarchar](50) NULL,
	[scz_empf_strasse] [nvarchar](50) NULL,
	[scz_empf_hausnr] [nchar](4) NULL,
	[scz_empf_anrede] [nchar](3) NULL,
	[scz_empf_ak_titel] [nvarchar](8) NULL,
	[scz_empf_bes_anrede] [nvarchar](8) NULL,
	[scz_empf_nachsatz] [nvarchar](8) NULL,
	[scz_kundenkz] [int] NULL,
	[scz_zahlungsartkz] [nvarchar](1) NULL,
	[scz_bankbic] [nvarchar](11) NULL,
	[scz_bankiban] [nvarchar](34) NULL,
	[scz_zahlungsart] [int] NULL,
	[scz_st_bm_grundlage] [float] NULL,
	[scz_st_ant_npfl] [float] NULL,
	[scz_st_nr] [nvarchar](5) NULL,
	[scz_st_code] [nvarchar](1) NULL,
 CONSTRAINT [PK_schadenzahlung] PRIMARY KEY CLUSTERED 
(
	[scz_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](40) NOT NULL,
	[name] [varchar](60) NULL,
	[last_Name] [varchar](60) NULL,
	[date_of_birth] [varchar](20) NULL,
	[role] [int] NULL,
	[password] [varchar](255) NULL,
	[email] [varchar](255) NULL,
	[verified] [int] NULL,
	[time_to_varify] [datetime] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[email_verification_token] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vertrag]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vertrag](
	[vtg_vertragid] [int] NOT NULL,
	[vtg_vr_key] [int] NULL,
	[vtg_oart] [nvarchar](2) NULL,
	[vtg_obnr] [int] NULL,
	[vtg_branchengruppe] [int] NULL,
	[vtg_hist_nr] [int] NULL,
	[vtg_pol_kreis] [int] NULL,
	[vtg_pol_bran] [int] NULL,
	[vtg_zahlungsweise] [int] NULL,
	[vtg_inkassoweg] [int] NULL,
	[vtg_pol_vkto] [int] NULL,
	[vtg_zo_vkto] [int] NULL,
	[vtg_waehrung] [nvarchar](3) NULL,
	[vtg_pol_filiale] [int] NULL,
	[vtg_folgedatum] [datetime] NULL,
	[vtg_hauptfz] [nvarchar](4) NULL,
	[vtg_gk_nr] [int] NULL,
	[vtg_erlagschein_nr] [nvarchar](50) NULL,
	[vtg_vae_ab] [datetime] NULL,
	[vtg_pol_text_1] [nvarchar](70) NULL,
	[vtg_pol_text_2] [nvarchar](70) NULL,
	[vtg_pol_text_3] [nvarchar](70) NULL,
	[vtg_vae_polex] [datetime] NULL,
	[vtg_vae_fil] [int] NULL,
	[vtg_vae_art] [nvarchar](3) NULL,
	[vtg_vae_druck] [nvarchar](4) NULL,
	[vtg_kundenkz_1] [int] NULL,
	[vtg_kundenkz_2] [int] NULL,
	[vtg_kundenkz_3] [int] NULL,
	[vtg_kundenkz_4] [int] NULL,
	[vtg_kundenkz_5] [int] NULL,
	[vtg_kundenrolle_1] [nvarchar](2) NULL,
	[vtg_kundenrolle_2] [nvarchar](2) NULL,
	[vtg_kundenrolle_3] [nvarchar](2) NULL,
	[vtg_kundenrolle_4] [nvarchar](2) NULL,
	[vtg_kundenrolle_5] [nvarchar](2) NULL,
	[vtg_kunden_fnr_1] [nvarchar](3) NULL,
	[vtg_kunden_fnr_2] [nvarchar](3) NULL,
	[vtg_kunden_fnr_3] [nvarchar](3) NULL,
	[vtg_kunden_fnr_4] [nvarchar](3) NULL,
	[vtg_kunden_fnr_5] [nvarchar](3) NULL,
	[vtg_bankleitzahl] [nvarchar](15) NULL,
	[vtg_bankkontonummer] [nvarchar](30) NULL,
	[vtg_bankeinzug_storno] [datetime] NULL,
	[vtg_antrag_obnr] [int] NULL,
	[vtg_pnr_storno_ab] [datetime] NULL,
	[vtg_ersatz_oart] [nvarchar](2) NULL,
	[vtg_ersatz_obnr] [int] NULL,
	[vtg_grund_plz] [int] NULL,
	[vtg_grund_name] [nvarchar](31) NULL,
	[vtg_grund_adresse] [nvarchar](27) NULL,
	[vtg_grund_ergaenzung] [nvarchar](31) NULL,
	[vtg_grund_postnation] [nvarchar](3) NULL,
	[vtg_grund_postort] [nvarchar](27) NULL,
	[vtg_info_extern] [nvarchar](14) NULL,
	[vtg_mstop] [nvarchar](1) NULL,
	[vtg_estop] [nvarchar](1) NULL,
	[vtg_folge_praemie] [float] NULL,
	[vtg_folge_praemie_ab] [datetime] NULL,
	[vtg_erst_praemie] [float] NULL,
	[vtg_ivk_autom] [nvarchar](1) NULL,
	[vtg_text_code] [int] NULL,
	[vtg_text_code_z2] [int] NULL,
	[vtg_text] [nvarchar](47) NULL,
	[vtg_text_code_at] [nvarchar](50) NULL,
	[vtg_kz_feld] [nvarchar](79) NULL,
	[vtg_pol_ueb_erg] [nvarchar](35) NULL,
	[vtg_jahres_brutto_praemie] [float] NULL,
	[vtg_jahres_netto_praemie] [float] NULL,
	[vtg_sprach_kz] [nvarchar](2) NULL,
	[vtg_waehrung_v] [nvarchar](3) NULL,
	[vtg_st_nation] [nvarchar](3) NULL,
	[vtg_waehrung_2] [nvarchar](3) NULL,
	[vtg_tc_stichtag] [datetime] NULL,
	[vtg_sub_vr_key] [int] NULL,
	[vtg_pc_antrag] [nvarchar](30) NULL,
	[vtg_ivk_nr] [int] NULL,
	[vtg_praemienfrei_ab] [datetime] NULL,
	[vtg_datenweitergabe_pkt_19] [nvarchar](50) NULL,
	[vtg_eh_variante] [nvarchar](50) NULL,
	[vtg_fn_voraus_bonus] [nvarchar](50) NULL,
	[vtg_datneu] [datetime] NULL,
	[vtg_pol_kopf] [nvarchar](100) NULL,
	[vtg_vtg_ueb] [nvarchar](100) NULL,
	[vtg_xml] [nvarchar](max) NULL,
	[vtg_csv] [nvarchar](max) NULL,
	[vtg_vae_einl] [datetime] NULL,
	[vtg_vae_filein] [datetime] NULL,
	[vtg_grund_risiko] [nvarchar](27) NULL,
	[vtg_grund_risiko_erg] [nvarchar](20) NULL,
	[vtg_grund_risiko_erg2] [nvarchar](70) NULL,
	[vtg_kurs_datum] [nvarchar](8) NULL,
	[vtg_vae_vlauf] [datetime] NULL,
	[vtg_vsst2_folgepr] [float] NULL,
	[vtg_poldruckdatum] [datetime] NULL,
	[vtg_dataen] [datetime] NULL,
	[vtg_ext_obnr] [nvarchar](14) NULL,
	[vtg_bic] [nvarchar](11) NULL,
	[vtg_iban] [nvarchar](34) NULL,
	[vtg_portal_anzeige] [nvarchar](1) NULL,
	[vtg_fremd_schluessel] [nvarchar](25) NULL,
	[vtg_report_nr] [int] NULL,
	[vtg_erstes_orig_datum] [datetime] NULL,
	[vtg_polizzen_darlehen] [float] NULL,
	[vtg_kommunal_info_direkt] [nvarchar](5) NULL,
	[vtg_bk_ez_termin] [nvarchar](5) NULL,
	[vtg_pflichtvers] [nvarchar](10) NULL,
	[vtg_deckblatt] [nvarchar](10) NULL,
 CONSTRAINT [PK_vertrag] PRIMARY KEY CLUSTERED 
(
	[vtg_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vertrag_kunde]    Script Date: 3/5/2025 2:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vertrag_kunde](
	[vtk_vtkid] [int] NOT NULL,
	[vtk_obnr] [int] NULL,
	[vtk_kundenkz] [int] NULL,
	[vtk_kundenrolle] [nchar](2) NULL,
	[vtk_kunden_fnr] [nchar](3) NULL,
	[vtk_vr_key] [int] NULL,
 CONSTRAINT [PK_vertrag_kunde] PRIMARY KEY NONCLUSTERED 
(
	[vtk_vtkid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [ix_berechtigung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE CLUSTERED INDEX [ix_berechtigung] ON [dbo].[vertrag_kunde]
(
	[vtk_obnr] ASC,
	[vtk_kundenkz] ASC,
	[vtk_vr_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_adresse]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_adresse] ON [dbo].[adresse]
(
	[adr_post_nation] ASC,
	[adr_postlz] ASC,
	[adr_postort] ASC,
	[adr_ort] ASC,
	[adr_strasse] ASC,
	[adr_hausnr] ASC,
	[adr_hauserg] ASC,
	[adr_postfach] ASC,
	[adr_ovkey] ASC,
	[adr_vr_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_adresse2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_adresse2] ON [dbo].[adresse]
(
	[adr_postlz] ASC,
	[adr_adressid] ASC,
	[adr_strasse] ASC,
	[adr_ort] ASC,
	[adr_hausnr] ASC,
	[adr_hauserg] ASC,
	[adr_postfach] ASC,
	[adr_postort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertungen]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen] ON [dbo].[adresse]
(
	[adr_adressid] ASC,
	[adr_strasse] ASC,
	[adr_ort] ASC,
	[adr_hausnr] ASC,
	[adr_hauserg] ASC,
	[adr_postfach] ASC,
	[adr_postort] ASC,
	[adr_postlz] ASC,
	[adr_ovkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertung1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung1] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_branchenid] ASC,
	[bra_bran] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertung2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung2] ON [dbo].[branche]
(
	[bra_bran] ASC,
	[bra_branchenid] ASC,
	[bra_vers_ablauf] ASC,
	[bra_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertung4]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung4] ON [dbo].[branche]
(
	[bra_vs_lv_prfrei] ASC,
	[bra_bran] ASC,
	[bra_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen10]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen10] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_bran] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen11]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen11] ON [dbo].[branche]
(
	[bra_vers_beginn] ASC
)
INCLUDE([bra_vertragid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen12]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen12] ON [dbo].[branche]
(
	[bra_vers_ablauf] ASC
)
INCLUDE([bra_vertragid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen5]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen5] ON [dbo].[branche]
(
	[bra_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen7]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen7] ON [dbo].[branche]
(
	[bra_bran] ASC
)
INCLUDE([bra_obnr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen8]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen8] ON [dbo].[branche]
(
	[bra_bran] ASC,
	[bra_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertungen9]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen9] ON [dbo].[branche]
(
	[bra_bran] ASC,
	[bra_index_art] ASC,
	[bra_vertragid] ASC,
	[bra_branchenid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_branche]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_branche] ON [dbo].[branche]
(
	[bra_vr_key] ASC,
	[bra_obnr] ASC,
	[bra_bran] ASC,
	[bra_brnr] ASC,
	[bra_evi_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_branche_1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_branche_1] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_evi_nr] ASC,
	[bra_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_branche_2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_branche_2] ON [dbo].[branche]
(
	[bra_storno_ab] ASC,
	[bra_kfzid] ASC,
	[bra_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_branche_3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_branche_3] ON [dbo].[branche]
(
	[bra_kfzid] ASC,
	[bra_persid] ASC,
	[bra_ortid] ASC,
	[bra_divid] ASC,
	[bra_as_tab_index] ASC,
	[bra_paket_daten] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_branche_covering]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_branche_covering] ON [dbo].[branche]
(
	[bra_obnr] ASC
)
INCLUDE([bra_bran],[bra_vertragid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_detailed]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_detailed] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_vertragid] ASC,
	[bra_bran] ASC,
	[bra_statistik_nr] ASC
)
INCLUDE([bra_branchenid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_Full_Covering]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_Full_Covering] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_bran] ASC,
	[bra_vertragid] ASC
)
INCLUDE([bra_vers_beginn],[bra_vers_ablauf],[bra_storno_ab],[bra_storno_kt_prozent],[bra_nettopraemie1],[bra_vst_prozent],[bra_statistik_nr],[bra_bruttopraemie],[bra_storno_grund],[bra_vv_ueb]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_obnr_bran]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_obnr_bran] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_bran] ASC
)
INCLUDE([bra_vers_beginn],[bra_vers_ablauf],[bra_storno_ab],[bra_storno_kt_prozent],[bra_nettopraemie1],[bra_vst_prozent],[bra_bruttopraemie],[bra_storno_grund]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_optimized_lookup]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_optimized_lookup] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_vertragid] ASC,
	[bra_bran] ASC
)
INCLUDE([bra_storno_grund]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_optimized_lookup_v2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_optimized_lookup_v2] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_vertragid] ASC,
	[bra_bran] ASC
)
INCLUDE([bra_storno_grund]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_policy_filter]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_policy_filter] ON [dbo].[branche]
(
	[bra_obnr] ASC,
	[bra_vertragid] ASC,
	[bra_bran] ASC,
	[bra_storno_grund] ASC
)
INCLUDE([bra_branchenid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_branche_vertragid]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_branche_vertragid] ON [dbo].[branche]
(
	[bra_vertragid] ASC
)
INCLUDE([bra_obnr],[bra_bran],[bra_vv_ueb],[bra_storno_grund]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [ix_brancheladen1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_brancheladen1] ON [dbo].[branche]
(
	[bra_divid] ASC,
	[bra_branchenid] ASC,
	[bra_as_tab_index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_brancheladen2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_brancheladen2] ON [dbo].[branche]
(
	[bra_ortid] ASC,
	[bra_paket_daten] ASC,
	[bra_branchenid] ASC,
	[bra_as_tab_index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_brancheladen3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_brancheladen3] ON [dbo].[branche]
(
	[bra_persid] ASC,
	[bra_branchenid] ASC,
	[bra_as_tab_index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tst_indx_bra]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [tst_indx_bra] ON [dbo].[branche]
(
	[bra_vertragid] ASC,
	[bra_obnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_gr_clients_all_embg_pib]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_clients_all_embg_pib] ON [dbo].[gr_clients_all]
(
	[embg/pib] ASC
)
INCLUDE([klijent],[datum_rodjenja],[adresa],[mjesto],[telefon1],[telefon2],[email],[polisa],[vkto]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_gr_clients_all_embg_pib_covering]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_clients_all_embg_pib_covering] ON [dbo].[gr_clients_all]
(
	[embg/pib] ASC
)
INCLUDE([polisa],[klijent],[datum_rodjenja],[adresa],[mjesto],[telefon1],[telefon2],[email],[pocetak_osiguranja],[istek_osiguranja],[datum_storna],[bransa],[status_polise]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_gr_clients_all_embg_pib_full_covering]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_clients_all_embg_pib_full_covering] ON [dbo].[gr_clients_all]
(
	[embg/pib] ASC
)
INCLUDE([polisa],[klijent],[datum_rodjenja],[adresa],[mjesto],[telefon1],[telefon2],[email],[pocetak_osiguranja],[istek_osiguranja],[datum_storna],[status_polise],[bransa]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_gr_clients_all_embg_pib_include]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_clients_all_embg_pib_include] ON [dbo].[gr_clients_all]
(
	[embg/pib] ASC
)
INCLUDE([klijent],[datum_rodjenja],[adresa],[mjesto],[telefon1],[telefon2],[email]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_gr_clients_all_embg_pib_INCLUDES]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_clients_all_embg_pib_INCLUDES] ON [dbo].[gr_clients_all]
(
	[embg/pib] ASC
)
INCLUDE([polisa],[klijent],[datum_rodjenja],[adresa],[mjesto],[telefon1],[telefon2],[email],[status_polise],[vkto]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_gr_clients_all_embg_pib_polisa]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_gr_clients_all_embg_pib_polisa] ON [dbo].[gr_clients_all]
(
	[embg/pib] ASC,
	[polisa] ASC
)
WHERE ([polisa] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_gr_clients_all_polisa]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_clients_all_polisa] ON [dbo].[gr_clients_all]
(
	[polisa] ASC
)
INCLUDE([klijent],[embg/pib],[status_polise]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_gr_pairing_permission_groups_permission_group_id]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_pairing_permission_groups_permission_group_id] ON [dbo].[gr_pairing_permission_groups_permission]
(
	[id_permission_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_gr_pairing_permisson_property_list_permission_id]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_pairing_permisson_property_list_permission_id] ON [dbo].[gr_pairing_permisson_property_list]
(
	[id_permission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_gr_pairing_users_groups_permission_user_id]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_pairing_users_groups_permission_user_id] ON [dbo].[gr_pairing_users_groups_permission]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_gr_permission_id]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_permission_id] ON [dbo].[gr_permission]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_gr_permission_properties_group_id]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_gr_permission_properties_group_id] ON [dbo].[gr_permission_properties]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertung1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung1] ON [dbo].[kunde]
(
	[kun_kundenkz] ASC,
	[kun_vf_vkto] ASC,
	[kun_achtung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertung3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung3] ON [dbo].[kunde]
(
	[kun_vf_vkto] ASC,
	[kun_vr_key] ASC,
	[kun_kunde_storno_grund] ASC,
	[kun_kundenkz] ASC,
	[kun_geburtsdatum] ASC,
	[kun_zuname] ASC,
	[kun_vorname] ASC,
	[kun_anrede] ASC,
	[kun_telefon_1] ASC,
	[kun_telefon_2] ASC,
	[kun_tele_mobil_1] ASC,
	[kun_tele_mobil_2] ASC,
	[kun_telefax_1] ASC,
	[kun_telefax_2] ASC
)
INCLUDE([kun_e_mail]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen4]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen4] ON [dbo].[kunde]
(
	[kun_vr_key] ASC,
	[kun_kundenkz] ASC,
	[kun_vf_vkto] ASC,
	[kun_achtung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertungen5]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen5] ON [dbo].[kunde]
(
	[kun_vr_key] ASC,
	[kun_vf_vkto] ASC,
	[kun_kundenkz] ASC,
	[kun_zuname] ASC,
	[kun_vorname] ASC
)
INCLUDE([kun_art],[kun_anrede],[kun_besondere_anrede],[kun_ak_titel],[kun_nachsatz],[kun_geburtsdatum],[kun_berufsbezeichnung],[kun_cs_stufe],[kun_telefon_1],[kun_telefon_2],[kun_tele_mobil_1],[kun_tele_mobil_2],[kun_kunde_storno_ab],[kun_e_mail],[kun_schadensatz],[kun_typ],[kun_gruppe],[kun_schadensatz_anzahl],[kun_mpk_jahr],[kun_kis_rating],[kun_guid],[kun_steuer_nr],[kun_oib],[kun_achtung],[kun_e_komm_zustimmung]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_kunde]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kunde] ON [dbo].[kunde]
(
	[kun_vr_key] ASC,
	[kun_zuname] ASC,
	[kun_vorname] ASC,
	[kun_art] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_kunde_guid]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kunde_guid] ON [dbo].[kunde]
(
	[kun_guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_kundenbereinigung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kundenbereinigung] ON [dbo].[kunde]
(
	[kun_geburtsdatum] ASC,
	[kun_vr_key] ASC,
	[kun_kundenkz] ASC,
	[kun_anrede] ASC,
	[kun_kunde_storno_ab] ASC,
	[kun_zuname] ASC,
	[kun_vorname] ASC
)
INCLUDE([kun_art],[kun_besondere_anrede],[kun_ak_titel],[kun_nachsatz],[kun_berufsbezeichnung],[kun_cs_stufe],[kun_telefon_1],[kun_telefon_2],[kun_tele_mobil_1],[kun_tele_mobil_2],[kun_vf_vkto],[kun_e_mail],[kun_schadensatz],[kun_typ],[kun_gruppe],[kun_schadensatz_anzahl],[kun_mpk_jahr],[kun_guid],[kun_achtung]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_kundenimport]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kundenimport] ON [dbo].[kunde]
(
	[kun_vr_key] ASC,
	[kun_anrede] ASC,
	[kun_kunde_storno_ab] ASC,
	[kun_kundenkz] ASC,
	[kun_zuname] ASC,
	[kun_vorname] ASC
)
INCLUDE([kun_art],[kun_besondere_anrede],[kun_ak_titel],[kun_nachsatz],[kun_geburtsdatum],[kun_berufsbezeichnung],[kun_cs_stufe],[kun_telefon_1],[kun_telefon_2],[kun_tele_mobil_1],[kun_tele_mobil_2],[kun_vf_vkto],[kun_e_mail],[kun_schadensatz],[kun_typ],[kun_gruppe],[kun_schadensatz_anzahl],[kun_mpk_jahr],[kun_guid],[kun_achtung]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_kundensuche]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kundensuche] ON [dbo].[kunde]
(
	[kun_vr_key] ASC,
	[kun_zuname] ASC,
	[kun_kundenkz] ASC,
	[kun_vorname] ASC,
	[kun_kunde_storno_ab] ASC
)
INCLUDE([kun_art],[kun_anrede],[kun_besondere_anrede],[kun_ak_titel],[kun_nachsatz],[kun_geburtsdatum],[kun_berufsbezeichnung],[kun_cs_stufe],[kun_telefon_1],[kun_telefon_2],[kun_tele_mobil_1],[kun_tele_mobil_2],[kun_vf_vkto],[kun_e_mail],[kun_schadensatz],[kun_typ],[kun_gruppe],[kun_schadensatz_anzahl],[kun_mpk_jahr],[kun_guid],[kun_achtung]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [knd_nonclustered_inx_kundekz]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [knd_nonclustered_inx_kundekz] ON [dbo].[kunde]
(
	[kun_kundenkz] ASC
)
INCLUDE([kun_yu_persnr],[kun_zuname],[kun_vorname],[kun_geburtsdatum],[kun_steuer_nr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tst_kunde_inx]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [tst_kunde_inx] ON [dbo].[kunde]
(
	[kun_kundenkz] ASC,
	[kun_zuname] ASC,
	[kun_vorname] ASC,
	[kun_steuer_nr] ASC,
	[kun_yu_persnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_exportOrgGebiet]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_exportOrgGebiet] ON [dbo].[mitarbeiter]
(
	[ma_vr_key] ASC,
	[ma_vkto] ASC,
	[ma_unterst_ld] ASC,
	[ma_unterst_firma] ASC,
	[ma_unterst_ob] ASC,
	[ma_unterst_og] ASC,
	[ma_unterst_bb] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_region] ASC,
	[ma_such_bb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_ISABerechtigung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_ISABerechtigung] ON [dbo].[mitarbeiter]
(
	[ma_vkto] ASC
)
INCLUDE([ma_unterst_ld],[ma_isa_berechtigung]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_mitarbeiterberechtigung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterberechtigung] ON [dbo].[mitarbeiter]
(
	[ma_vr_key] ASC,
	[ma_vkto_verwendung] ASC
)
INCLUDE([ma_vkto]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_mitarbeiterexport1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport1] ON [dbo].[mitarbeiter]
(
	[ma_vr_key] ASC,
	[ma_vkto] ASC,
	[ma_sa] ASC
)
INCLUDE([ma_vkto_verwendung],[ma_unterst_ld],[ma_unterst_lfb]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport10]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport10] ON [dbo].[mitarbeiter]
(
	[ma_such_vkto_3] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport11]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport11] ON [dbo].[mitarbeiter]
(
	[ma_such_vkto_4] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport2] ON [dbo].[mitarbeiter]
(
	[ma_team_s] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport3] ON [dbo].[mitarbeiter]
(
	[ma_such_vkto_1] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport4]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport4] ON [dbo].[mitarbeiter]
(
	[ma_team_a] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport5]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport5] ON [dbo].[mitarbeiter]
(
	[ma_unterst_lfb] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport6]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport6] ON [dbo].[mitarbeiter]
(
	[ma_unterst_et] ASC,
	[ma_vr_key] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport7]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport7] ON [dbo].[mitarbeiter]
(
	[ma_such_vkto_2] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport8]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport8] ON [dbo].[mitarbeiter]
(
	[ma_vr_key] ASC,
	[ma_vkto] ASC,
	[ma_unterst_et] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC,
	[ma_such_vkto_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_mitarbeiterexport9]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterexport9] ON [dbo].[mitarbeiter]
(
	[ma_such_vkto_5] ASC,
	[ma_vr_key] ASC,
	[ma_unterst_et] ASC,
	[ma_vkto] ASC,
	[ma_team_a] ASC,
	[ma_team_s] ASC,
	[ma_unterst_lfb] ASC,
	[ma_such_vkto_1] ASC,
	[ma_such_vkto_2] ASC,
	[ma_such_vkto_3] ASC,
	[ma_such_vkto_4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_mitarbeiterlogin]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterlogin] ON [dbo].[mitarbeiter]
(
	[ma_zuname] ASC,
	[ma_vorname] ASC,
	[ma_vkto] ASC,
	[ma_sa] ASC,
	[ma_vr_key] ASC,
	[ma_vkto_status_text] ASC
)
INCLUDE([ma_user_id],[ma_unterst_ld],[ma_unterst_ob],[ma_unterst_og],[ma_unterst_bb],[ma_ak_titel],[ma_ort],[ma_strasse],[ma_hausnr],[ma_post_nation],[ma_postlz],[ma_postort],[ma_geburtsdatum],[ma_tel_fest_priv],[ma_tel_fest_dienst],[ma_tel_mobil_priv],[ma_tel_mobil_dienst],[ma_email_priv],[ma_email_dienst],[ma_kz_scn_pc],[ma_unterst_firma],[ma_unterst_ldir],[ma_scn_lim_gesamt],[ma_scn_lim_kasko],[ma_scn_lim_unfall_knochenbruch],[ma_scn_lim]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_mitarbeiterlogin2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_mitarbeiterlogin2] ON [dbo].[mitarbeiter]
(
	[ma_vr_key] ASC,
	[ma_user_id] ASC,
	[ma_vkto_status_text] ASC,
	[ma_sa] ASC,
	[ma_vkto] ASC,
	[ma_zuname] ASC,
	[ma_vorname] ASC
)
INCLUDE([ma_unterst_ld],[ma_unterst_ob],[ma_unterst_og],[ma_unterst_bb],[ma_ak_titel],[ma_ort],[ma_strasse],[ma_hausnr],[ma_post_nation],[ma_postlz],[ma_postort],[ma_geburtsdatum],[ma_tel_fest_priv],[ma_tel_fest_dienst],[ma_tel_mobil_priv],[ma_tel_mobil_dienst],[ma_email_priv],[ma_email_dienst],[ma_kz_scn_pc],[ma_unterst_firma],[ma_unterst_ldir],[ma_scn_lim_gesamt],[ma_scn_lim_kasko],[ma_scn_lim_unfall_knochenbruch],[ma_scn_lim]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ma_nonclustered_inx_vkto]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ma_nonclustered_inx_vkto] ON [dbo].[mitarbeiter]
(
	[ma_vkto] ASC
)
INCLUDE([ma_unterst_og],[ma_vorname],[ma_zuname]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_load]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_load] ON [dbo].[mitarbeiter_kontakt]
(
	[makon_vkto] ASC,
	[makon_ges] ASC
)
INCLUDE([makon_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen1] ON [dbo].[praemienkonto]
(
	[pko_mahnstufe] ASC,
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen2] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen3] ON [dbo].[praemienkonto]
(
	[pko_gf_key] ASC,
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_pkoZuVtg]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_pkoZuVtg] ON [dbo].[praemienkonto]
(
	[pko_vr_key] ASC,
	[pko_obnr] ASC,
	[pko_buch_nr] ASC,
	[pko_oart] ASC,
	[pko_praemienkontoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_Complete_Covering]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_Complete_Covering] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC,
	[pko_buch_nr] ASC
)
INCLUDE([pko_wertedatumsaldo],[pko_betragsoll],[pko_betraghaben],[pko_g_fall],[pko_praemienkontoid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_latest_saldo]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_latest_saldo] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] DESC,
	[pko_buch_nr] DESC
)
INCLUDE([pko_wertedatumsaldo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_obnr_wertedatum]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_obnr_wertedatum] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)
INCLUDE([pko_wertedatumsaldo],[pko_buch_nr],[pko_betragsoll],[pko_betraghaben]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_obnr_wertedatum_INCLUDES]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_obnr_wertedatum_INCLUDES] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)
INCLUDE([pko_wertedatumsaldo],[pko_buch_nr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_obnr_wertedatum_saldo]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_obnr_wertedatum_saldo] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)
INCLUDE([pko_wertedatumsaldo],[pko_buch_nr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_policy_date]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_policy_date] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)
INCLUDE([pko_wertedatumsaldo],[pko_buch_nr],[pko_betragsoll],[pko_betraghaben]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_policy_details]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_policy_details] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC,
	[pko_buch_nr] ASC,
	[pko_praemienkontoid] ASC
)
INCLUDE([pko_b_art],[pko_g_fall],[pko_betragsoll],[pko_betraghaben],[pko_wertedatumsaldo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_saldo_lookup]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_saldo_lookup] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC,
	[pko_buch_nr] ASC
)
INCLUDE([pko_wertedatumsaldo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_praemienkonto_wertedatum_lookup]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_praemienkonto_wertedatum_lookup] ON [dbo].[praemienkonto]
(
	[pko_wertedatum] ASC
)
INCLUDE([pko_obnr],[pko_wertedatumsaldo],[pko_buch_nr],[pko_betragsoll],[pko_betraghaben]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [pko_nonclustered_inx_obn_wertedatum]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [pko_nonclustered_inx_obn_wertedatum] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_wertedatum] ASC
)
INCLUDE([pko_betragsoll],[pko_betraghaben],[pko_wertedatumsaldo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [pko_nonclustered_inx_obnr_fall]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [pko_nonclustered_inx_obnr_fall] ON [dbo].[praemienkonto]
(
	[pko_obnr] ASC,
	[pko_g_fall] ASC
)
INCLUDE([pko_betragsoll],[pko_betraghaben],[pko_wertedatumsaldo],[pko_wertedatum]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_berechtigung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_berechtigung] ON [dbo].[schaden]
(
	[scn_kundenkz_vn1] ASC,
	[scn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_drf]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_drf] ON [dbo].[schaden]
(
	[scn_pc_schaden_nummer] ASC
)
INCLUDE([scn_ident_bran],[scn_ident_jahr],[scn_ident_pol_filiale],[scn_ident_lfd_nr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_schaden]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schaden] ON [dbo].[schaden]
(
	[scn_ident_vr_key] ASC,
	[scn_ident_kreis] ASC,
	[scn_ident_bran] ASC,
	[scn_ident_jahr] ASC,
	[scn_ident_pol_filiale] ASC,
	[scn_ident_lfd_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_schaden_abzug]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schaden_abzug] ON [dbo].[schaden]
(
	[scn_ident_vr_key] ASC,
	[scn_sb_vkto] ASC,
	[scn_kundenkz_vn1] ASC,
	[scn_datneu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_schaden_vertrag]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schaden_vertrag] ON [dbo].[schaden]
(
	[scn_ident_vr_key] ASC,
	[scn_ptr_vte_obnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_schadenexport1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schadenexport1] ON [dbo].[schaden]
(
	[scn_id] ASC,
	[scn_ident_vr_key] ASC,
	[scn_kundenkz_vn1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_schadenexport2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schadenexport2] ON [dbo].[schaden]
(
	[scn_ident_vr_key] ASC,
	[scn_kundenkz_vn1] ASC,
	[scn_id] ASC
)
INCLUDE([scn_datneu]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_schadenexport]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schadenexport] ON [dbo].[schadenperson]
(
	[scp_ptr_kun_kundenkz] ASC,
	[scp_ku_rolle1] ASC,
	[scp_ku_rolle2] ASC,
	[scp_ku_rolle3] ASC,
	[scp_ku_rolle4] ASC,
	[scp_ku_rolle5] ASC
)
INCLUDE([scp_schadenid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_schadenexport3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schadenexport3] ON [dbo].[schadenperson]
(
	[scp_ptr_kun_kundenkz] ASC,
	[scp_schadenid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_schadenvi_import]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schadenvi_import] ON [dbo].[schadenvi]
(
	[scv_schadenid] ASC,
	[scv_identcounter] ASC,
	[scv_satzart] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_schadenexport4]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_schadenexport4] ON [dbo].[schadenzahlung]
(
	[scz_kundenkz] ASC,
	[scz_schadenid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_schadenzahlung]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_schadenzahlung] ON [dbo].[schadenzahlung]
(
	[scz_schadenid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertung1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung1] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_obnr] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_vertragid] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_pol_kopf] ASC,
	[vtg_grund_name] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_postort] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC,
	[vtg_pnr_storno_ab] ASC,
	[vtg_vtg_ueb] ASC
)
INCLUDE([vtg_branchengruppe],[vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_jahres_brutto_praemie],[vtg_tc_stichtag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertung2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertung2] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_pol_kreis] ASC,
	[vtg_pol_bran] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_vertragid] ASC,
	[vtg_obnr] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_pol_kopf] ASC,
	[vtg_grund_name] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_postort] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC
)
INCLUDE([vtg_branchengruppe],[vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_pnr_storno_ab],[vtg_jahres_brutto_praemie],[vtg_tc_stichtag],[vtg_vtg_ueb]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_auswertungen4]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen4] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_obnr] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertungen6]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen6] ON [dbo].[vertrag]
(
	[vtg_pnr_storno_ab] ASC,
	[vtg_vertragid] ASC,
	[vtg_obnr] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_vr_key] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_pol_kopf] ASC,
	[vtg_grund_name] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_postort] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC,
	[vtg_vtg_ueb] ASC
)
INCLUDE([vtg_branchengruppe],[vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_jahres_brutto_praemie],[vtg_tc_stichtag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertungen7]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen7] ON [dbo].[vertrag]
(
	[vtg_vae_vlauf] ASC,
	[vtg_vertragid] ASC,
	[vtg_obnr] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_vr_key] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_pol_kopf] ASC,
	[vtg_grund_name] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_postort] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC,
	[vtg_pnr_storno_ab] ASC
)
INCLUDE([vtg_branchengruppe],[vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_jahres_brutto_praemie],[vtg_tc_stichtag],[vtg_vtg_ueb]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_kundenkz2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kundenkz2] ON [dbo].[vertrag]
(
	[vtg_kundenkz_2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_pcAntrag]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_pcAntrag] ON [dbo].[vertrag]
(
	[vtg_pc_antrag] ASC
)
INCLUDE([vtg_obnr],[vtg_vae_polex]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_vertrag_Complete_Covering]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_vertrag_Complete_Covering] ON [dbo].[vertrag]
(
	[vtg_obnr] ASC,
	[vtg_vertragid] ASC,
	[vtg_pol_bran] ASC
)
INCLUDE([vtg_kundenkz_1],[vtg_antrag_obnr],[vtg_zahlungsweise],[vtg_pol_kreis]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertrag_kunden]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag_kunden] ON [dbo].[vertrag]
(
	[vtg_kundenkz_1] ASC,
	[vtg_kundenkz_2] ASC,
	[vtg_kundenkz_3] ASC,
	[vtg_kundenkz_4] ASC,
	[vtg_kundenkz_5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_vertrag_pol_bran_vertragid]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_vertrag_pol_bran_vertragid] ON [dbo].[vertrag]
(
	[vtg_pol_bran] ASC,
	[vtg_vertragid] ASC
)
INCLUDE([vtg_kundenkz_1]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_vertrag_vertragid_INCLUDES]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_vertrag_vertragid_INCLUDES] ON [dbo].[vertrag]
(
	[vtg_vertragid] ASC
)
INCLUDE([vtg_zahlungsweise],[vtg_antrag_obnr],[vtg_kundenkz_1]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_vertrag_vertragid_pol_bran]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_vertrag_vertragid_pol_bran] ON [dbo].[vertrag]
(
	[vtg_vertragid] ASC,
	[vtg_pol_bran] ASC
)
INCLUDE([vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_antrag_obnr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertrag_vkto]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag_vkto] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_obnr] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_zo_vkto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertrag2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag2] ON [dbo].[vertrag]
(
	[vtg_pnr_storno_ab] ASC,
	[vtg_obnr] ASC,
	[vtg_vr_key] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_vertragid] ASC
)
INCLUDE([vtg_jahres_brutto_praemie]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_vertrag3]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag3] ON [dbo].[vertrag]
(
	[vtg_obnr] ASC,
	[vtg_vertragid] ASC,
	[vtg_vr_key] ASC,
	[vtg_vtg_ueb] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC,
	[vtg_pnr_storno_ab] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_grund_name] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_grund_postort] ASC,
	[vtg_jahres_brutto_praemie] ASC
)
INCLUDE([vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_grund_ergaenzung],[vtg_tc_stichtag],[vtg_pol_kopf]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_vertrag4]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag4] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_grund_name] ASC,
	[vtg_vertragid] ASC,
	[vtg_obnr] ASC,
	[vtg_vtg_ueb] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC,
	[vtg_pnr_storno_ab] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_grund_postort] ASC,
	[vtg_jahres_brutto_praemie] ASC
)
INCLUDE([vtg_zahlungsweise],[vtg_kundenkz_1],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_grund_ergaenzung],[vtg_tc_stichtag],[vtg_pol_kopf]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertrag5]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag5] ON [dbo].[vertrag]
(
	[vtg_pnr_storno_ab] ASC,
	[vtg_vr_key] ASC,
	[vtg_obnr] ASC,
	[vtg_zahlungsweise] ASC
)
INCLUDE([vtg_jahres_brutto_praemie]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertragexport1]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport1] ON [dbo].[vertrag]
(
	[vtg_zo_vkto] ASC,
	[vtg_vr_key] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_obnr] ASC,
	[vtg_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertragexport2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport2] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_dataen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertragexport5]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport5] ON [dbo].[vertrag]
(
	[vtg_pol_vkto] ASC,
	[vtg_vr_key] ASC,
	[vtg_obnr] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_vertragid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_vertragsuche]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragsuche] ON [dbo].[vertrag]
(
	[vtg_vr_key] ASC,
	[vtg_obnr] ASC,
	[vtg_pnr_storno_ab] ASC,
	[vtg_vertragid] ASC,
	[vtg_vtg_ueb] ASC,
	[vtg_vae_art] ASC,
	[vtg_vae_ab] ASC,
	[vtg_folgedatum] ASC,
	[vtg_hauptfz] ASC,
	[vtg_pol_vkto] ASC,
	[vtg_zo_vkto] ASC,
	[vtg_grund_name] ASC,
	[vtg_grund_plz] ASC,
	[vtg_grund_adresse] ASC,
	[vtg_grund_postort] ASC,
	[vtg_jahres_brutto_praemie] ASC
)
INCLUDE([vtg_zahlungsweise],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_grund_ergaenzung],[vtg_tc_stichtag],[vtg_pol_kopf]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vorpolizzenSuche]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vorpolizzenSuche] ON [dbo].[vertrag]
(
	[vtg_ersatz_obnr] ASC,
	[vtg_vr_key] ASC
)
INCLUDE([vtg_obnr],[vtg_zahlungsweise],[vtg_pol_vkto],[vtg_zo_vkto],[vtg_folgedatum],[vtg_hauptfz],[vtg_vae_ab],[vtg_vae_art],[vtg_kundenkz_2],[vtg_antrag_obnr],[vtg_pnr_storno_ab],[vtg_grund_plz],[vtg_grund_name],[vtg_grund_adresse],[vtg_grund_ergaenzung],[vtg_grund_postort],[vtg_jahres_brutto_praemie],[vtg_tc_stichtag],[vtg_pol_kopf],[vtg_vtg_ueb]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_auswertungen2]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_auswertungen2] ON [dbo].[vertrag_kunde]
(
	[vtk_kundenkz] ASC,
	[vtk_kundenrolle] ASC,
	[vtk_obnr] ASC,
	[vtk_vr_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_kundenrollen]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_kundenrollen] ON [dbo].[vertrag_kunde]
(
	[vtk_kundenrolle] ASC,
	[vtk_kundenkz] ASC,
	[vtk_kunden_fnr] ASC
)
INCLUDE([vtk_vtkid],[vtk_obnr],[vtk_vr_key]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_vertrag_kunde]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag_kunde] ON [dbo].[vertrag_kunde]
(
	[vtk_vr_key] ASC,
	[vtk_obnr] ASC,
	[vtk_kundenkz] ASC,
	[vtk_kundenrolle] ASC,
	[vtk_kunden_fnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertrag_kunde_obnr]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertrag_kunde_obnr] ON [dbo].[vertrag_kunde]
(
	[vtk_obnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_vertragexport]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport] ON [dbo].[vertrag_kunde]
(
	[vtk_vr_key] ASC,
	[vtk_kundenrolle] ASC,
	[vtk_kundenkz] ASC,
	[vtk_obnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertragexport10]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport10] ON [dbo].[vertrag_kunde]
(
	[vtk_vr_key] ASC,
	[vtk_kundenkz] ASC,
	[vtk_obnr] ASC,
	[vtk_vtkid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertragexport7]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport7] ON [dbo].[vertrag_kunde]
(
	[vtk_kundenkz] ASC,
	[vtk_obnr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ix_vertragexport8]    Script Date: 3/5/2025 2:58:12 PM ******/
CREATE NONCLUSTERED INDEX [ix_vertragexport8] ON [dbo].[vertrag_kunde]
(
	[vtk_kundenkz] ASC,
	[vtk_vr_key] ASC
)
INCLUDE([vtk_obnr]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[gr_clients_all] ADD  DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[gr_hierarchy_groups] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[gr_hierarchy_vkto_mapping] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[gr_user_hierarchy_groups] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[kunde] ADD  CONSTRAINT [DF_kunde_kun_dataen]  DEFAULT (getdate()) FOR [kun_dataen]
GO
ALTER TABLE [dbo].[kunde] ADD  CONSTRAINT [df_kunde_kun_guid]  DEFAULT (newid()) FOR [kun_guid]
GO
ALTER TABLE [dbo].[mitarbeiter] ADD  CONSTRAINT [DF_mitarbeiter_ma_datneu]  DEFAULT (getdate()) FOR [ma_datneu]
GO
ALTER TABLE [dbo].[mitarbeiter] ADD  DEFAULT ((1)) FOR [ma_isIddMandatory]
GO
ALTER TABLE [dbo].[mitarbeiter] ADD  DEFAULT ((1)) FOR [ma_IsBiBMandatory]
GO
ALTER TABLE [dbo].[mitarbeiter] ADD  DEFAULT ((0)) FOR [ma_ApprovalPermission]
GO
ALTER TABLE [dbo].[mitarbeiter] ADD  DEFAULT ((0)) FOR [ma_PaymentBlocked]
GO
ALTER TABLE [dbo].[mitarbeiter] ADD  DEFAULT ((0)) FOR [ma_PaymentLimit]
GO
ALTER TABLE [dbo].[praemienkonto] ADD  CONSTRAINT [DF_praemienkonto_pko_datneu]  DEFAULT (getdate()) FOR [pko_datneu]
GO
ALTER TABLE [dbo].[schaden] ADD  CONSTRAINT [DF_schaden_scn_datneu]  DEFAULT (getdate()) FOR [scn_datneu]
GO
ALTER TABLE [dbo].[vertrag] ADD  CONSTRAINT [DF_vertrag_vtg_datneu]  DEFAULT (getdate()) FOR [vtg_datneu]
GO
ALTER TABLE [dbo].[gr_hierarchy_groups]  WITH CHECK ADD FOREIGN KEY([parent_id])
REFERENCES [dbo].[gr_hierarchy_groups] ([id])
GO
ALTER TABLE [dbo].[gr_hierarchy_vkto_mapping]  WITH CHECK ADD FOREIGN KEY([group_id])
REFERENCES [dbo].[gr_hierarchy_groups] ([id])
GO
ALTER TABLE [dbo].[gr_user_hierarchy_groups]  WITH CHECK ADD FOREIGN KEY([group_id])
REFERENCES [dbo].[gr_hierarchy_groups] ([id])
GO
ALTER TABLE [dbo].[gr_hierarchy_groups]  WITH CHECK ADD CHECK  (([level_type]>=(1) AND [level_type]<=(6)))
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Adressen ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_adressid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nation der Adresse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_post_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postleitzahk' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_postlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_postort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_ort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Strasse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_strasse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_hausnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ergänzung der Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_hauserg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postfach' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_postfach'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orts Schlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_ovkey'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postadresscode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adresse', @level2type=N'COLUMN',@level2name=N'adr_pac'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branchen ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_branchenid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertrags ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vertragid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'KFZ ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kfzid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Personen ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_persid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orts ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_ortid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Diverse ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_divid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_oart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Historiennummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_hist_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branche' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bran'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branchennummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_brnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fortlaufende Nummer eines VI(-Liste) im Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_evi_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Statistik Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_statistik_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schalter Polizze' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_schalterpol'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum der Veränderung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vae_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungsbeginn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vers_beginn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungsablauf' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vers_ablauf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertrag wird storniert ab Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_storno_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Storno Grund' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_storno_grund'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Storno Abrechnung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_storno_abrechnung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Storno KT Prozent' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_storno_kt_prozent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Storno Grund' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_storno_grund_text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sistiert ab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_sistiert_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sistiert bis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_sistiert_bis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sistiert aufgrund' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_sistiert_grund'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Prämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_tarifpraemie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bonus Betrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bonus_betrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Malus Betrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_malus_betrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Netto Prämie 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_nettopraemie1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Netto Prämie 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_nettopraemie2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Brutto Prämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bruttopraemie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prämienfrei' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_praemienfrei_wkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unterjährigkeitszuschlag in Prozent' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_uz_prozent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Variante' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kh_variante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sonder Tarif' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_sondertarif'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Pauschal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_pauschal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_person'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Ereignis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_ereignis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Sachschaden' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_sachschaden'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BM-Stufe aktuell (Grawe / Verband)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bm_stufe_vv_lfd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BM-Stufe alt (Grawe / Verband)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bm_stufe_vv_alt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BM Beobachtungszeitraum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bm_bzr_vv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BM Umreihung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bm_umreihung_am'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Abmelde Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_abmelde_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Abmelde Grund' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_abmelde_grund'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vorvr_key_ablauf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vers_beginn_ablaufk'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kaskoart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kaskoart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kasko Prozentsatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kasko_prsatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Listenpreis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_listenpreis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Selbstbehalt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_selbstbehalt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tagesmaximum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_tagesmaximum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insassenunfall Prozentsatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_iu_prsatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insassenunfall Art' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_iu_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insassenunfall krad' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_iu_krad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme bei Tod' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_tod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme bei Tod' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_invalid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Heilkosten' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_heilkosten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bergungskosten' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bergung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Taggeld' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_taggeld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Spitalgeld' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_spitalgeld'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vorsteuer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vorsteuer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Rückhol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_rueckhol'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kasko Wert' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kasko_wert'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'´Selbstbehalt Prozentsatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_selbstbehalt_proz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Selbstbehalt min.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_selbstbehalt_min'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Selbstbehalt max.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_selbstbehalt_max'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Index Art' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Index Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indexzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_zahl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indexaufwertung auf' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_auf_am'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indexaufwertung um' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_auf_um'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Index Datums Basis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_datum_basis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Index Zahl Basis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_index_zahl_basis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_waehrung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prämienfrei bis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_praemienfrei_bis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Blitz VS Betrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_blitz_betrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Blitz Versicherungsbeginn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_blitz_beginn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Blitz Versichersablauf' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_blitz_ablauf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_tarif_stichtag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kündigungs Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kuend_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kündigungs Grund' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_kuend_grund'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ende der Prämienzahlweise' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_pz_ende'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Laufzeit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_laufzeit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gewinn Modell' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_gewinn_modell'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Paket Daten' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_paket_daten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'alter Tarif' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_tarif_alter'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Satz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_tarif_satz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Taif ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_tarif_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssteuer 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vsst2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'frei von Versicherungssteuer 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vsst2_frei'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'End Alter bei der LV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_end_alter'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusammengesetzte Statistik Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_statistik_nr_zus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_rente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Renten Dauer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_rente_dauer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Renten Kennzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_rente_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Statistik Gruppe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_statistik_gruppe'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BM-Stufe alt (Grawe / Verband)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bm_stufe_gw_alt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BM-Stufe aktuell (Grawe / Verband)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_bm_stufe_gw_lfd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tab Index' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_as_tab_index'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Eigenheim Tarif' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_eh_tarif'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Haft mit Rechtsschutz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_haft_mit_rs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Laufzeit Kennzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_laufzeit_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lenker RS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_lenker'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rechtsschutz mit Selbstbehalt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_rs_mit_sbh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Umreihung BM (Grawe / Verband)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_umreihung_gw_bm'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Verzicht auf Unterversicherung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_untervers_verzicht'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Variante' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_variante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Voraus Bonus' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_voraus_bonus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Voraus Bonus Zusatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_voraus_bonus_zusatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Befreiungsgrund der Versicherungssteuer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vst_frei_grund'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Lebensversicherung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_lv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Lebensversicherung prämienfrei' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_lv_prfrei'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Lebensversicherung Rücklagen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_lv_rueckk'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Lebensversicherung Rente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_lv_rente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Lebensversicherung Prämienfrei' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_lv_prf_abl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Überschrift' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vv_ueb'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beteiligungs Kennzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_beteiligung_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungssumme Vermögen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vs_vermoegen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vinkulierungskennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'branche', @level2type=N'COLUMN',@level2name=N'bra_vink_alt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_kundenkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenart (Anbahner oder Bestandskunde)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_anrede'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Besondere Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_besondere_anrede'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Akademischer Titel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_ak_titel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zuname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_zuname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vorname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_vorname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Namennachsatz (jun. oder sen.)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_nachsatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geburtsdatum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_geburtsdatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vulgoname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_vulgoname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Berufsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_berufsschluessel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Berufsbezeichnung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_berufsbezeichnung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sprachkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sprach_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundennation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_ku_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Personennummer für Ex-Jugoslawien' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_yu_persnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Großkundennummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_gk_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cross Selling Modell' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_cs_modell'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cross-Selling-Erfüllungsprozent' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_cs_prozent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cross-Selling-Stufe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_cs_stufe'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cross-Selling Reservefeld' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_cs_reserve'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cross-Selling Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_cs_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatz aller Verträge in welchen der Kunde VN ist; ohne Berücksichtigung von Teilungsabkommen, Fremdverschulden, Schadenstand.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_schadensatz_gesamt_tk'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'siehe schadensatz_gesamt_tk' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_schadensatz_anzahl_tk'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum der Kundenbereinigung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_berein_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen der Kundenbereinigung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_berein_kundenkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telefonnummer1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_telefon_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telefonnummer2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_telefon_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Faxnummer1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_telefax_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Faxnummer2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_telefax_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobiltelefonnummer1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_tele_mobil_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobiltelefonnummer2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_tele_mobil_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stornodatum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_kunde_storno_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stornogrund' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_kunde_storno_grund'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenbetreuer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_vf_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum der letzten Kundenveränderung im Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_vn_vdat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Art bzgl. Zahlungsempfangs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_kz_schadenzahlung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Art der Adressänderung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_adr_vae_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sozialversicherungsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sv_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'E-Mailadresse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_e_mail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_schadensatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum der Änderung im Berater' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_dataen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum des Imports im Berater' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_datneu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User welche die Änderung im Berater durchgeführt hat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_usraen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User welcher den Kunden im Berater angelegt hat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_usrneu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Typ des Kunden ("L" oder "KU"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_typ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_ersterkunde'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertragsanzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_vertragsanzahl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatz in Prozent (FN)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_proz_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatz in Prozent (UH)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_proz_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatz in Prozent (KF)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_proz_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatz in Prozent (EH)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_proz_eh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadenanzahl für Schadensatz (FN)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_anz_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadenanzahl für Schadensatz (UH)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_anz_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadenanzahl für Schadensatz (KF)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_anz_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadenanzahl für Schadensatz (EH)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_sc_satz_anz_eh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CSV-Abbild aus Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_csv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundengruppe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_gruppe'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensatzanzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_schadensatz_anzahl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Änderungsart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_aenart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Betreuer der diesen Kunden als Mehrpolizzenkunden (MPK) in der Erfolgsprovision (EP) hat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_mpk_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Erfolgsprovisionsjahr' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_mpk_jahr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundeninformationsparameter' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_kis_rating'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Eindeutiger Schlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_guid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Steuernummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_steuer_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OIB für Kroatien' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_oib'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_bankkundennummer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt einen Achtungkunden an' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_achtung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Italienische Steuernummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_ital'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen des Kunden bei Bank oder Makler in Italien' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'kunde', @level2type=N'COLUMN',@level2name=N'kun_ndg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter ID zum einloggen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_user_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Passwort des Mitarbeiters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_user_password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittler Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_md_opid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittler Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittler Verwendung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_verwendung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittler Funktion' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_funktion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Team A' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_team_a'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Team S' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_team_s'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Suche nach Vermittler Nummer 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_vkto_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Suche nach Vermittler Nummer 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_vkto_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Suche nach Vermittler Nummer 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_vkto_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Suche nach Vermittler Nummer 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_vkto_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Suche nach Vermittler Nummer 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_vkto_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Suche Bezirksbüro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_bb'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_anr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vorname des Mitarbeiters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vorname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zuname des Mitarbeiters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zuname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Akademischer Titel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_ak_titel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Wohnort des Mitarbeites' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_ort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Strasse wo der Mitarbeiter wohnt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_strasse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hausnummer des Mitarbeites' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_hausnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Erzgänzung der Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_hauserg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nation der Adresse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_post_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_postlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_postort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dienst Titel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_dienst_titel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geburtsdatum des Mitarbeiters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_geburtsdatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Personal Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_persnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sozialversicherungs Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_sv_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sprachkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_sprach_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Festnetz Privat Telefonnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_tel_fest_priv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Festnetz Dienst Telefonnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_tel_fest_dienst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobil Telefon Privat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_tel_mobil_priv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobil Telefon Dienst' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_tel_mobil_dienst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Faxnummer Privat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_fax_priv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Faxnummer Dienst' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_fax_dienst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Adresse Privat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_email_priv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Adresse Dienst' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_email_dienst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'URL Privat' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_http_priv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'URL Dienst' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_http_dienst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MD oder AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_sa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatztext andrucken (MA Grundbild)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_nimmzusatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatztext 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zusatz1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatztext 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zusatz2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatztext 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zusatz3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatztext 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zusatz4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatztext 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zusatz5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CSV-Abbild aus Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_csv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum des Imports im Berater' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_datneu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema Berechtigung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_scn_pc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'sucht die Region zum Mitarbeiter' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_region'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'sucht die Provisionen zum Mitarbeiter' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_such_provision'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status des Vermittlers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_status_text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Eintritt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_eintritt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter ist inaktiv ab Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_inaktiv_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Steuer Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_steuer_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Register Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_register_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Finanzamt Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_finanzamt_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_waehrung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Provisions Schema' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_prov_schema'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kostenstelle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kostenstelle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_12'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 13' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_13'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 14' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_14'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_15'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 21' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_21'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 22' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_22'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 23' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_23'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 24' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_24'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 25' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_25'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 31' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 32' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_32'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 33' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_33'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 34' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_34'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 35' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_35'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 41' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_41'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 42' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_42'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 43' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_43'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 44' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_44'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer kzr 45' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_kzr_45'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_kundenkz_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankleitzahl_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankkonto Nummer 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankkontonummer_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_kundenkz_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankleitzahl_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankkonto Nummer 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankkontonummer_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_kundenkz_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankleitzahl_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankkonto Nummer 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankkontonummer_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_kundenkz_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankleitzahl_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankkonto Nummer 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_zs_bankkontonummer_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RVD Makler Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_fremd_rvd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Merkur Makler Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_fremd_merkur'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ABV Makler Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_fremd_abv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OMDS Makler Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_omds_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Art des OMDS Maklers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_omds_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OMDS Version' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_omds_version'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Adresse des OMDS Maklers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_omds_email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Anzahl der Laptops' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_anzahl_laptops'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Anzahl der Standgeräte' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_anzahl_standgeraete'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Papierantrag J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_papierantrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fachabteilungsversion FN J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_fachabt_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fachabteilungsversion UH J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_fachabt_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fachabteilungsversion KF J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_fachabt_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fachabteilungsversion LV J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_fachabt_lv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fachabteilungsversion KV J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_fachabt_kv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Rabatt FN J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_rabattstufe_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Rabatt UH J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_rabattstufe_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Rabatt KF J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_rabattstufe_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Rabatt LV J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_rabattstufe_lv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mitarbeiter Rabatt KV J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_rabattstufe_kv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unter Mindesprämien versichern FN J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_unter_mindestpraem_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unter Mindesprämien versichern UH J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_unter_mindestpraem_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unter Mindesprämien versichern KF J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_unter_mindestpraem_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unter Mindesprämien versichern LV J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_unter_mindestpraem_lv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unter Mindesprämien versichern KV J/N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_unter_mindestpraem_kv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DRF schicken J/N FN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_drf_erfassung_id_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DRF schicken J/N UH' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_drf_erfassung_id_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DRF schicken J/N KF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_drf_erfassung_id_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DRF schicken J/N LV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_drf_erfassung_id_lv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DRF schicken J/N KV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_drf_erfassung_id_kv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Ausschluss FN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_tarifvariante_fn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Ausschluss UH' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_tarifvariante_uh'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Ausschluss KF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_tarifvariante_kf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Ausschluss LV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_tarifvariante_lv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Ausschluss KV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_tarifvariante_kv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status des Vermittlers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_vkto_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an, ob Schadenkosten (in Schadenzahlung) angesehen werden dürfen. J=Ja, leer=Nein' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_sc_kosten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an, ob DRF durchgeführt werden darf oder nicht. O (ohne), M (mit)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_gb_drf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an ob und welcher Bestand gesehen werden darf. A (alle), E (eigener), O (ohne)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_gb_best'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an, ob und welche Provisionen gesehen werden dürfen. A (alle), E (eigene), O (ohne)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_gb_prov'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum der Änderung im Beraterbestand' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_dataen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an, ob Auswertungen durchgeführt werden dürfen. N für Nein' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_gb_best_ausw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SubUser möglich' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mitarbeiter', @level2type=N'COLUMN',@level2name=N'ma_kz_gb_sub_user'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prämien Konto ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_praemienkontoid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_oart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Werte Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_wertedatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Buchungsart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_b_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geschäftsfall' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_g_fall'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Wert von Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_wertvondat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Wert bis Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_wertbisdat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Betrag Soll' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_betragsoll'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Betrag Haben' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_betraghaben'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Werte Datum Saldo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_wertedatumsaldo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ausziffer Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_auszifferstatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mahnstufe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_mahnstufe'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Buchungssaldo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_buchungssaldo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Buchungsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_buch_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Aufgabe am Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_aufgabeamdatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_waehrung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geschäftsfall Schlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_gf_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CSV-Abbild aus Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_csv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum des Imports im Berater' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'praemienkonto', @level2type=N'COLUMN',@level2name=N'pko_datneu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ident_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kreis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ident_kreis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branche' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ident_bran'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Jahr' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ident_jahr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Filiale' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ident_pol_filiale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Laufende Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ident_lfd_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Historien Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_hist_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sprachkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_sprach_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_waehrung_scn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Versicherungsnehmer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_schaden_vn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Referent' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_referent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ursache' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_urschl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stand' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_stand'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadendatum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ereignis_dt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesamt Schaden' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_gesamt_schaden'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kosten' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_kosten_nodisplay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zahlungen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_zahlungen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Betreuer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_sb_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Statistik Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_statistik_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Statistik Nummer Zusatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_statistik_nr_zus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Verschulden' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_kz_f111_vv_verschkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antrags Art' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ptr_vte_oart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Polizzen Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ptr_vte_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Historie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ptr_vte_hist'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zeuge' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ptr_vve_evi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branche' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ptr_vve_bran'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branchen Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_ptr_vve_brnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Meldedatum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_anmelde_dt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schaden erledigt am Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_erledigt_am'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branchen Zugehörigkeit (Feuer, Sturm, Leitungswasser, Rechtsschutz,..)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_bran_ueb'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen VN1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_kundenkz_vn1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CSV-Abbild aus Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_csv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum des Imports im Berater' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_datneu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schaden Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_pc_schaden_nummer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum der Änderung im Beraterbestand' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schaden', @level2type=N'COLUMN',@level2name=N'scn_dataen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schaden ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_schadenid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_anrede'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zuname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_zuname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vorname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_vorname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vulgoname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_vulgoname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'akademischer Titel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_titel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Nation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_post_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_postlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Strasse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_strasse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_hausnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ergänzung der Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_hauserg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_bankleitzahl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bank Konto Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_bankkontonummer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ptr_kun_kundenkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertragsrolle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_vtg_ku_rolle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertragsrolle Zusatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_vtg_ku_rolle_fnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensperson Kunden Rolle 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ku_rolle1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensperson Kunden Rolle 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ku_rolle2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensperson Kunden Rolle 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ku_rolle3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensperson Kunden Rolle 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ku_rolle4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadensperson Kunden Rolle 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ku_rolle5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fremdschlüssel zu SchadenVI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ptr_satzart_vi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fremdschlüssel zu SchadenVI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenperson', @level2type=N'COLUMN',@level2name=N'scp_ptr_ident_vi_idc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schaden ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_schadenid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schadens Art' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_evi_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID Zähler' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_identcounter'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kurzform VI (Adresse)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_kurzform_vi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Satz Art' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_satzart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'KFZ Kennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_kfz_kennzeichen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nationalität des KFZ Kennzeichens' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_kfz_nationenkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Nation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_post_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_postlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_postort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Strasse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_strasse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_hausnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ergänzung der Hausnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_hauserg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_anrede'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zuname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_zuname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vorname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_vorname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name des Vaters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_vatersname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geburtsdatum VI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_geburtsdatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orts Schlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenvi', @level2type=N'COLUMN',@level2name=N'scv_ovkey'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schaden ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_schadenid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_waehrung_scn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Betrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_betrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'verbucht am Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_verbdatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ausbezahlt am Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_wertedatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zweck der Zahlung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_bu_zweck'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_bankleitzahl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bank Konto Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_bankkontonummer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kennzeichen Belegart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_kz_f116_belegart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kennzeichen Belegtyp' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_kz_f116_belegtyp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Großkunden Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_gk_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Zuname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_zuname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Vorname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_vorname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Vulgoname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_vulgoname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Post Nation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_post_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Postleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_postlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_ort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Strasse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_strasse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Haus Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_hausnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_anrede'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger akademischer Titel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_ak_titel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Besondere Anrede' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_bes_anrede'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empfänger Nachsatz' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_empf_nachsatz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_kundenkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an ob es sich um eine Zahlung an den Kunden oder um Kosten (Gutachter) handelt. Z=Zahlung, K=Kosten' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'schadenzahlung', @level2type=N'COLUMN',@level2name=N'scz_zahlungsartkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vertragid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vr_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_oart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branchen Gruppe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_branchengruppe'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Historien Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_hist_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Polizzen Kreis' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_kreis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Polizzen Branche' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_bran'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zahlungsweise' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_zahlungsweise'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Inkassoweg' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_inkassoweg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vermittlernummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zo-Vkto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_zo_vkto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_waehrung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Filiale' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_filiale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Folgedatum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_folgedatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Großkundennummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_gk_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Erlagschein Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_erlagschein_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertragsänderung ab Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vae_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatz Name 1 zum Vertrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_text_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatz Name 2 zum Vertrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_text_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Zusatz Name 3 zum Vertrag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_text_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Art der Vertragsänderung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vae_art'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenkz_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenkz_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenkz_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenkz_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenkz_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenrolle 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenrolle_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenrolle 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenrolle_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenrolle 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenrolle_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenrolle 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenrolle_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenrolle 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kundenrolle_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kunden Fnr 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kunden_fnr_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kunden Fnr 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kunden_fnr_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kunden Fnr 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kunden_fnr_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kunden Fnr 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kunden_fnr_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kunden Fnr 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kunden_fnr_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_bankleitzahl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kontonummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_bankkontonummer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bankeinzug Storno' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_bankeinzug_storno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_antrag_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Aufhebung des Vertrags ab Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pnr_storno_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ersatz Antragsart' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_ersatz_oart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ersatz Antragsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_ersatz_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postleitzahl' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_plz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Adresse' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_adresse'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ergänzung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_ergaenzung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Nation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_postnation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Post Ort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_postort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Info Extern' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_info_extern'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Folge Prämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_folge_praemie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Folge Prämie ab Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_folge_praemie_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Erst Prämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_erst_praemie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ergänzung der Polizzen Überschrift' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_ueb_erg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Jahres Brutto Prämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_jahres_brutto_praemie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Jahres Netto Prämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_jahres_netto_praemie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sprachkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_sprach_kz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung V' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_waehrung_v'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_st_nation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Währung 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_waehrung_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tarif Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_tc_stichtag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PC Antragsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pc_antrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IVK Nummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_ivk_nr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prämienfrei ab Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_praemienfrei_ab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datenweitergabe Klausel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_datenweitergabe_pkt_19'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Eigenheim Variaten Top / Standard' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_eh_variante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vorausbonus FN ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_fn_voraus_bonus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datum des Imports im Berater' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_datneu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Polizzen Überschrift ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_pol_kopf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertragsüberschrift mit VI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vtg_ueb'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'XML Datei wird zwecks DRF erstellt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_xml'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CSV-Abbild aus Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_csv'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VI (Adresse) / VN (Name der Person)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_risiko'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VI (Adresse) / VN (Name der Person) Ergänzung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_risiko_erg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VI (Adresse) / VN (Name der Person) Ergänzung 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_grund_risiko_erg2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kurs Datum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_kurs_datum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vertragsänderung im Korin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vae_vlauf'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Motorbezogene Versicherungssteuer in Folgeprämie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_vsst2_folgepr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Druckdatum der Polizze' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_poldruckdatum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gibt an, wann der Vertrag im Bestand (nicht KORIN) geändert wurde' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_dataen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Externe Polizzennummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag', @level2type=N'COLUMN',@level2name=N'vtg_ext_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag_kunde', @level2type=N'COLUMN',@level2name=N'vtk_vtkid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antragsnummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag_kunde', @level2type=N'COLUMN',@level2name=N'vtk_obnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenkennzeichen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag_kunde', @level2type=N'COLUMN',@level2name=N'vtk_kundenkz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kundenrolle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag_kunde', @level2type=N'COLUMN',@level2name=N'vtk_kundenrolle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kunden FNummer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag_kunde', @level2type=N'COLUMN',@level2name=N'vtk_kunden_fnr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gesellschaftsschlüssel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vertrag_kunde', @level2type=N'COLUMN',@level2name=N'vtk_vr_key'
GO
