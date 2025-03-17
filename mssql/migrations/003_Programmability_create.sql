USE [GRAWE_DEV]
GO
/****** Object:  UserDefinedFunction [dbo].[Bruto_polisirana_premija_klijent]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Filip Stankovic
-- Create date: 2024.06.30
-- Description:	Funkcija za racunanje bruto polisrane premija za jednu polisu
-- =============================================

--select dbo.Bruto_polisirana_premija_polisa ('98020946','2024.09.30')

CREATE FUNCTION [dbo].[Bruto_polisirana_premija_klijent] 
(
	@embg_pib varchar,
	@datum  datetime
)
RETURNS decimal (18,2)
AS
BEGIN
    DECLARE @final decimal(18,2) = 0;

	DECLARE @client_policies TABLE (
        polisa INT
    );


    INSERT INTO @client_policies (polisa)
    SELECT DISTINCT polisa
    FROM gr_clients_all
    WHERE [embg/pib] = @embg_pib;

    
    DECLARE @branch_data TABLE (
        polisa int,
		bransa int,
        pocetak_osiguranja datetime,
        istek_osiguranja datetime,
        datum_storna datetime,
        bruto_polisirana_premija decimal(18,2),
        neto_polisirana_premija decimal(18,2),
        storno_tip int,
        premija decimal(18,2)
    );
    
    INSERT INTO @branch_data (
		polisa,
        bransa, 
        pocetak_osiguranja, 
        istek_osiguranja, 
        datum_storna, 
        bruto_polisirana_premija, 
        neto_polisirana_premija, 
        storno_tip
    )
    SELECT 
		cp.polisa,
        b.bra_bran,
        b.bra_vers_beginn,
        b.bra_vers_ablauf,
        b.bra_storno_ab,
        CASE WHEN 
            v.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
        THEN
            b.bra_storno_kt_prozent/100 * 
            CASE WHEN (b.bra_vers_beginn BETWEEN '2022.01.01' AND '2022.12.31') 
                THEN b.bra_nettopraemie1 * (ISNULL((1 + b.bra_vst_prozent/100), 0)) 
                ELSE b.bra_bruttopraemie 
            END
        ELSE 
            b.bra_bruttopraemie
        END,
        CASE WHEN 
            v.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
        THEN
            b.bra_storno_kt_prozent * b.bra_nettopraemie1
        ELSE 
            b.bra_nettopraemie1 
        END,
        b.bra_storno_grund
    FROM branche b
    JOIN @client_policies cp ON b.bra_obnr = cp.polisa
	JOIN vertrag v ON v.vtg_obnr = cp.polisa AND b.bra_bran = v.vtg_pol_bran
    
    -- Calculate premium for all branches
    UPDATE @branch_data
    SET premija = 
        CASE  
            -- 1. Istekla or Aktivna
            WHEN ISNULL(datum_storna, '') = ISNULL(istek_osiguranja, '') 
                OR ISNULL(datum_storna, '') > @datum 
            THEN bruto_polisirana_premija
            
            -- 2. Stornirana od pocetka
            WHEN ISNULL(datum_storna, '') = ISNULL(pocetak_osiguranja, '') 
            THEN 0  
            
            -- 3. Prekid
            WHEN ISNULL(datum_storna, '') > ISNULL(pocetak_osiguranja, '') 
                AND ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, '') 
            THEN ISNULL(
                ABS((SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = polisa) -
                    (SELECT ABS(SUM(pko_betragsoll)) FROM praemienkonto pk WITH (NOLOCK) 
                    WHERE pko_wertedatum > datum_storna AND polisa = pk.pko_obnr AND pko_betragsoll < 0)),
                0)
            
            -- 4. Ostalo
            ELSE 0
        END;
    
    -- Update status for each branch
    UPDATE @branch_data
    SET premija = 
        CASE 
            -- Update premium for status 'Prekid'
            WHEN ISNULL(datum_storna, '') = ISNULL(istek_osiguranja, '') 
                AND ISNULL(datum_storna, '') > @datum 
                OR ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, '') 
                AND ISNULL(datum_storna, '') > @datum
            THEN 
                premija -- 'Aktivna'
                
            WHEN ISNULL(datum_storna, '') = ISNULL(pocetak_osiguranja, '')
            THEN 
                0 -- 'Stornirana od pocetka'
                
            WHEN ISNULL(datum_storna, '') > ISNULL(pocetak_osiguranja, '') 
                AND ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, '')
            THEN 
                -- 'Prekid'
                (SELECT SUM(pko_betragsoll) FROM praemienkonto pk WITH (NOLOCK) WHERE pk.pko_obnr = polisa)
                
            ELSE 
                premija -- 'Istekla'
        END;
    
    -- Apply premium adjustment for status 'Prekid'
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN (ISNULL(datum_storna, '') > ISNULL(pocetak_osiguranja, '') 
                AND ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, ''))
                AND NOT (ISNULL(datum_storna, '') = ISNULL(pocetak_osiguranja, ''))
            THEN 
                CASE 
                    WHEN (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = polisa) = 0 
                    THEN 0 
                    ELSE ISNULL(
                        (premija * bruto_polisirana_premija) / 
                        (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = polisa), 
                        0) 
                END
            ELSE premija
        END;
    
    -- Apply special rules by branch and storno type
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN storno_tip = 2 AND bransa = 11 
            THEN neto_polisirana_premija
            ELSE premija 
        END;
    
    -- Apply rules for branches 78 and 79
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN bransa IN (78, 79) 
            THEN bruto_polisirana_premija * CAST(CEILING(CAST(DATEDIFF(day, pocetak_osiguranja, @datum) AS decimal(18,2))/365) AS int)
            ELSE premija
        END;
    
    -- Apply special rules for 2022 policies in branch 10
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN pocetak_osiguranja BETWEEN '2022.01.01' AND '2022.12.31' 
                AND bransa = 10 
                AND (SELECT SUM(pko_betragsoll) FROM praemienkonto pk WITH (NOLOCK) 
                    WHERE pko_wertedatum <= @datum AND polisa = pk.pko_obnr) > bruto_polisirana_premija 
            THEN 
                (SELECT SUM(pko_betragsoll) FROM praemienkonto pk WITH (NOLOCK) 
                WHERE pko_wertedatum <= @datum AND polisa = pk.pko_obnr)
            ELSE premija
        END;
    
    -- Sum up all branch premiums
    SELECT @final = ISNULL(SUM(premija), 0)
    FROM @branch_data;
    
    RETURN @final;


end

GO
/****** Object:  UserDefinedFunction [dbo].[Bruto_polisirana_premija_polisa]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Filip Stankovic
-- Create date: 2024.06.30
-- Description:	Funkcija za racunanje bruto polisrane premija za jednu polisu
-- =============================================

--select dbo.Bruto_polisirana_premija_polisa ('98020946','2024.09.30')

CREATE FUNCTION [dbo].[Bruto_polisirana_premija_polisa] 
(
	@polisa int,
	@datum  datetime
)
RETURNS decimal (18,2)
AS
BEGIN
    DECLARE @final decimal(18,2) = 0;
    
    DECLARE @branch_data TABLE (
        bransa int,
        pocetak_osiguranja datetime,
        istek_osiguranja datetime,
        datum_storna datetime,
        bruto_polisirana_premija decimal(18,2),
        neto_polisirana_premija decimal(18,2),
        storno_tip int,
        premija decimal(18,2)
    );
    
    INSERT INTO @branch_data (
        bransa, 
        pocetak_osiguranja, 
        istek_osiguranja, 
        datum_storna, 
        bruto_polisirana_premija, 
        neto_polisirana_premija, 
        storno_tip
    )
    SELECT 
        b.bra_bran,
        b.bra_vers_beginn,
        b.bra_vers_ablauf,
        b.bra_storno_ab,
        CASE WHEN 
            v.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
        THEN
            b.bra_storno_kt_prozent/100 * 
            CASE WHEN (b.bra_vers_beginn BETWEEN '2022.01.01' AND '2022.12.31') 
                THEN b.bra_nettopraemie1 * (ISNULL((1 + b.bra_vst_prozent/100), 0)) 
                ELSE b.bra_bruttopraemie 
            END
        ELSE 
            b.bra_bruttopraemie
        END,
        CASE WHEN 
            v.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
        THEN
            b.bra_storno_kt_prozent * b.bra_nettopraemie1
        ELSE 
            b.bra_nettopraemie1 
        END,
        b.bra_storno_grund
    FROM branche b
    JOIN vertrag v ON v.vtg_obnr = @polisa AND b.bra_obnr = @polisa AND b.bra_bran = v.vtg_pol_bran;
    
    -- Calculate premium for all branches
    UPDATE @branch_data
    SET premija = 
        CASE  
            -- 1. Istekla or Aktivna
            WHEN ISNULL(datum_storna, '') = ISNULL(istek_osiguranja, '') 
                OR ISNULL(datum_storna, '') > @datum 
            THEN bruto_polisirana_premija
            
            -- 2. Stornirana od pocetka
            WHEN ISNULL(datum_storna, '') = ISNULL(pocetak_osiguranja, '') 
            THEN 0  
            
            -- 3. Prekid
            WHEN ISNULL(datum_storna, '') > ISNULL(pocetak_osiguranja, '') 
                AND ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, '') 
            THEN ISNULL(
                ABS((SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = @polisa) -
                    (SELECT ABS(SUM(pko_betragsoll)) FROM praemienkonto pk WITH (NOLOCK) 
                    WHERE pko_wertedatum > datum_storna AND @polisa = pk.pko_obnr AND pko_betragsoll < 0)),
                0)
            
            -- 4. Ostalo
            ELSE 0
        END;
    
    -- Update status for each branch
    UPDATE @branch_data
    SET premija = 
        CASE 
            -- Update premium for status 'Prekid'
            WHEN ISNULL(datum_storna, '') = ISNULL(istek_osiguranja, '') 
                AND ISNULL(datum_storna, '') > @datum 
                OR ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, '') 
                AND ISNULL(datum_storna, '') > @datum
            THEN 
                premija -- 'Aktivna'
                
            WHEN ISNULL(datum_storna, '') = ISNULL(pocetak_osiguranja, '')
            THEN 
                0 -- 'Stornirana od pocetka'
                
            WHEN ISNULL(datum_storna, '') > ISNULL(pocetak_osiguranja, '') 
                AND ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, '')
            THEN 
                -- 'Prekid'
                (SELECT SUM(pko_betragsoll) FROM praemienkonto pk WITH (NOLOCK) WHERE pk.pko_obnr = @polisa)
                
            ELSE 
                premija -- 'Istekla'
        END;
    
    -- Apply premium adjustment for status 'Prekid'
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN (ISNULL(datum_storna, '') > ISNULL(pocetak_osiguranja, '') 
                AND ISNULL(datum_storna, '') < ISNULL(istek_osiguranja, ''))
                AND NOT (ISNULL(datum_storna, '') = ISNULL(pocetak_osiguranja, ''))
            THEN 
                CASE 
                    WHEN (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = @polisa) = 0 
                    THEN 0 
                    ELSE ISNULL(
                        (premija * bruto_polisirana_premija) / 
                        (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = @polisa), 
                        0) 
                END
            ELSE premija
        END;
    
    -- Apply special rules by branch and storno type
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN storno_tip = 2 AND bransa = 11 
            THEN neto_polisirana_premija
            ELSE premija 
        END;
    
    -- Apply rules for branches 78 and 79
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN bransa IN (78, 79) 
            THEN bruto_polisirana_premija * CAST(CEILING(CAST(DATEDIFF(day, pocetak_osiguranja, @datum) AS decimal(18,2))/365) AS int)
            ELSE premija
        END;
    
    -- Apply special rules for 2022 policies in branch 10
    UPDATE @branch_data
    SET premija = 
        CASE 
            WHEN pocetak_osiguranja BETWEEN '2022.01.01' AND '2022.12.31' 
                AND bransa = 10 
                AND (SELECT SUM(pko_betragsoll) FROM praemienkonto pk WITH (NOLOCK) 
                    WHERE pko_wertedatum <= @datum AND @polisa = pk.pko_obnr) > bruto_polisirana_premija 
            THEN 
                (SELECT SUM(pko_betragsoll) FROM praemienkonto pk WITH (NOLOCK) 
                WHERE pko_wertedatum <= @datum AND @polisa = pk.pko_obnr)
            ELSE premija
        END;
    
    -- Sum up all branch premiums
    SELECT @final = ISNULL(SUM(premija), 0)
    FROM @branch_data;
    
    RETURN @final;


end

GO
/****** Object:  UserDefinedFunction [dbo].[Bruto_polisirana_premija_polisa_stara]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Filip Stankovic
-- Create date: 2024.06.30
-- Description:	Funkcija za racunanje bruto polisrane premija za jednu polisu
-- =============================================

--select dbo.[Bruto_polisirana_premija_polisa_stara] ('98020668','2024.09.30')

CREATE FUNCTION [dbo].[Bruto_polisirana_premija_polisa_stara] 
(
	@polisa int,
	@datum  datetime
)
RETURNS decimal (18,2)
AS
BEGIN


	declare @Pocetak_osiguranja datetime
	declare @Istek_osiguranja   datetime
	declare @Datum_storna		datetime
	declare @StatusPolise		varchar(20)
	declare @Premija			decimal(18,2)
	declare @Bruto_polisirana_premija decimal(18,2)
	declare @Neto_polisirana_premija decimal(18,2)
	declare @porez				decimal(18,2)
	declare @bransa				int
	declare @stornoTip			int
	declare @final				decimal(18,2)

declare cursor_1 CURSOR
	for select bra_bran from branche where bra_obnr=@polisa

	open cursor_1

	fetch next from cursor_1
	into @bransa

	while @@FETCH_STATUS = 0

	begin


	select 
	@Pocetak_osiguranja =bra_vers_beginn,
	@Istek_osiguranja=bra_vers_ablauf,
	@Datum_storna=bra_storno_ab,
	@StatusPolise=cast('' as vaRCHAR(20)),
	@Bruto_polisirana_premija=case when 
	(select vtg_pol_bran from vertrag where vtg_obnr=@polisa)=11 and DATEDIFF(day,bra_vers_beginn,bra_vers_ablauf)<365
	then
	bra_storno_kt_prozent/100 * case when bra_vers_beginn between '2022.01.01' and '2022.12.31' then bra_nettopraemie1 * (1 + ISNULL(bp.porez,0)) else bra_bruttopraemie end
	else 
	bra_bruttopraemie
	end,
	@Neto_polisirana_premija=case when 
	(select vtg_pol_bran from vertrag where vtg_obnr=@polisa)=11 and DATEDIFF(day,bra_vers_beginn,bra_vers_ablauf)<365
	then
	bra_storno_kt_prozent * bra_nettopraemie1
	else 
	bra_nettopraemie1 
	end,
	@porez= ISNULL(bp.porez,0),
	@bransa= bra_bran,
	@stornoTip=bra_storno_grund
	from branche b
	left join brache_porezi bp on bp.branche_id=b.bra_bran
	where bra_obnr=@polisa  and bra_bran=@bransa

	set @Premija = 
	case  -- 1. Istekla or Aktivna; 2. Stornirana od pocetka; 3. Prekid; 4. Ostalo
	 when isnull(@Datum_storna,'')=isnull(@Istek_osiguranja,'') or isnull(@Datum_storna,'')>@datum then @Bruto_polisirana_premija
	 when isnull(@Datum_storna,'')=isnull(@Pocetak_osiguranja,'') then 0  
	 when isnull(@Datum_storna,'')>isnull(@Pocetak_osiguranja,'') and isnull(@Datum_storna,'')<isnull(@Istek_osiguranja,'') then isnull(ABS((select sum(bra_bruttopraemie) from branche t2 where t2.bra_obnr=@polisa)-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum > @Datum_storna and @polisa=pk.pko_obnr and pko_betragsoll < 0 )),0)
	 else 0
	 end

	 set @StatusPolise=
	 case when isnull(@Datum_storna,'')=isnull(@Istek_osiguranja,'') and isnull(@Datum_storna,'')>@datum then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull(@Datum_storna,'')<isnull(@Istek_osiguranja,'') and isnull(@Datum_storna,'')>@datum then 'Aktivna'
	 when isnull(@Datum_storna,'')=isnull(@Pocetak_osiguranja,'') then 'Stornirana od pocetka' 
	 when isnull(@Datum_storna,'')>isnull(@Pocetak_osiguranja,'') and isnull(@Datum_storna,'')<isnull(@Istek_osiguranja,'') then 'Prekid'
	 else 'Istekla' 
	 end

	 set @Premija=
	 case when @StatusPolise='Prekid' then (select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=@polisa) 
		  else @Premija
	end

	set @Premija=
	 case when  @StatusPolise='Prekid' and @StatusPolise<>'Stornirana od pocetka' then
	 case when (select sum(bra_bruttopraemie) from branche t2 where t2.bra_obnr=@polisa)=0 then 0 else  isnull((@Premija*@Bruto_polisirana_premija) /(select sum(bra_bruttopraemie) from branche t2 where t2.bra_obnr=@polisa),0) end
		  else @Premija
	 end

	 --set @Premija=
	 --case when  @StatusPolise='Prekid' and @StatusPolise<>'Stornirana od pocetka' then
	 --case when (select sum(cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))) from branche t2 where t2.bra_obnr=@polisa)=0 then 0 else  isnull((@Premija*@Bruto_polisirana_premija) /(select sum(cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))) from branche t2 where t2.bra_obnr=@polisa),0) end
		--  else @Premija
	 --end



	 set @Premija=
	 case when @stornoTip=2 and @bransa=11 then @Neto_polisirana_premija
	 else @Premija 
	 end

	 set @Premija=
	 case when @bransa in (78,79) then @Bruto_polisirana_premija * cast(CEILING(cast(DATEDIFF(day,@Pocetak_osiguranja,@datum) as decimal(18,2))/365) as int) 
	 else @premija
	 end

	 set @Premija=
	 case when @Pocetak_osiguranja  between '2022.01.01' and '2022.12.31' and @bransa=10 and (select sum(pko_betragsoll) from praemienkonto pk (nolock) where pko_wertedatum <= @Datum and @polisa=pk.pko_obnr) > @Bruto_polisirana_premija then 
	 (select sum(pko_betragsoll) from praemienkonto pk (nolock) where pko_wertedatum <= @Datum and @polisa=pk.pko_obnr)
	 else @Premija
	 end



	 set @final=isnull(@final,0)+@Premija



	 FETCH NEXT FROM cursor_1   
     INTO @bransa

	 end

	 CLOSE cursor_1;  
	 DEALLOCATE cursor_1;  



	 return @final

end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_user_accessible_vktos]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create the function
CREATE FUNCTION [dbo].[fn_get_user_accessible_vktos](@currentUserId INT)
RETURNS @results TABLE (vkto INT)
AS
BEGIN
    -- Get all hierarchy groups the user belongs to
    WITH user_hierarchy_groups AS (
        -- Direct groups the user belongs to
        SELECT 
            g.id, 
            g.level_type
        FROM 
            gr_hierarchy_groups g
        JOIN 
            gr_user_hierarchy_groups ug ON g.id = ug.group_id
        WHERE 
            ug.user_id = @currentUserId
        
        UNION ALL
        
        -- Add child groups (recursive)
        SELECT 
            child.id, 
            child.level_type
        FROM 
            gr_hierarchy_groups child
        JOIN 
            user_hierarchy_groups parent ON child.parent_id = parent.id
    )
    
    -- Insert all VKTOs from all user's hierarchy groups
    INSERT INTO @results
    SELECT DISTINCT vkto
    FROM gr_hierarchy_vkto_mapping vm
    JOIN user_hierarchy_groups g ON vm.group_id = g.id;
    
    -- If no VKTOs found, return a dummy VKTO that doesn't exist
    -- This prevents SQL errors when no VKTOs are accessible
    IF NOT EXISTS (SELECT 1 FROM @results)
    BEGIN
        INSERT INTO @results VALUES (0);
    END
    
    RETURN;
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_gr_premije_klijent]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_gr_premije_klijent]
(
    @embg VARCHAR(20),
    @datum DATETIME
)
RETURNS @ResultTable TABLE
(
    Bruto_polisirana_premija DECIMAL(18,2),
    Neto_polisirana_premija DECIMAL(18,2)
)
AS
BEGIN
    -- Create temporary tables
    DECLARE @TEMP TABLE (
        polisa INT,
        bransa INT,
        Bruto_polisirana_premija DECIMAL(18,2),
        Neto_polisirana_premija DECIMAL(18,2)
    )

    DECLARE @finalPremije TABLE (
        polisa INT,
        bransa INT,
        Bruto_polisirana_premija DECIMAL(18,2),
        Neto_polisirana_premija DECIMAL(18,2)
    )

    DECLARE @PolicyData TABLE (
        polisa INT,
        bransa INT,
        Pocetak_osiguranja DATETIME,
        Istek_osiguranja DATETIME,
        Datum_storna DATETIME,
        storno_kt_prozent DECIMAL(18,2),
        nettopraemie DECIMAL(18,2),
        vst_prozent DECIMAL(18,2),
        bruttopraemie DECIMAL(18,2),
        stornoTip INT,
        vtg_pol_bran INT,
        Bruto_polisirana_premija DECIMAL(18,2),
        Neto_polisirana_premija DECIMAL(18,2),
        porez DECIMAL(18,2),
        policy_status VARCHAR(20) -- Added status field
    )

    -- Insert initial data
    INSERT INTO @TEMP
    SELECT 
        polisa,
        bransa,
        0,
        0
    FROM gr_clients_all
    WHERE [embg/pib] = @embg

    -- Insert policy data and calculate status once
    INSERT INTO @PolicyData
    SELECT DISTINCT
        b.bra_obnr,
        b.bra_bran,
        b.bra_vers_beginn,
        b.bra_vers_ablauf,
        b.bra_storno_ab,
        b.bra_storno_kt_prozent,
        b.bra_nettopraemie1,
        b.bra_vst_prozent,
        b.bra_bruttopraemie,
        b.bra_storno_grund,
        vtg.vtg_pol_bran,
        -- Calculate Bruto premium
        CASE 
            WHEN vtg.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365        
            THEN b.bra_storno_kt_prozent/100 * 
                CASE 
                    WHEN (b.bra_vers_beginn BETWEEN '2022.01.01' AND '2022.12.31')            
                    THEN b.bra_nettopraemie1 * (ISNULL((1 + b.bra_vst_prozent/100), 0)) 
                    ELSE b.bra_bruttopraemie 
                END
            ELSE b.bra_bruttopraemie
        END,
        -- Calculate Neto premium
        CASE 
            WHEN vtg.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
            THEN b.bra_storno_kt_prozent/100 * b.bra_nettopraemie1
            ELSE b.bra_nettopraemie1 
        END,
        ISNULL((1 + b.bra_vst_prozent/100), 0),
        -- Calculate policy status once
        CASE
            WHEN ISNULL(b.bra_storno_ab,'') = ISNULL(b.bra_vers_ablauf,'') 
                OR ISNULL(b.bra_storno_ab,'') > @datum 
            THEN 'AKTIVNA'
            WHEN ISNULL(b.bra_storno_ab,'') = ISNULL(b.bra_vers_beginn,'') 
            THEN 'ISTEKLA'
            WHEN ISNULL(b.bra_storno_ab,'') > ISNULL(b.bra_vers_beginn,'') 
                AND ISNULL(b.bra_storno_ab,'') < ISNULL(b.bra_vers_ablauf,'') 
            THEN 'PREKID'
            ELSE 'OSTALO'
        END
    FROM branche b
    INNER JOIN @TEMP t ON b.bra_obnr = t.polisa
    INNER JOIN vertrag vtg ON b.bra_obnr = vtg.vtg_obnr;

    -- Initial calculations using pre-calculated status
    INSERT INTO @finalPremije
    SELECT DISTINCT
        pd.polisa,
        pd.bransa,
        CASE
            WHEN pd.policy_status = 'AKTIVNA' 
            THEN pd.Bruto_polisirana_premija
            WHEN pd.policy_status = 'ISTEKLA' 
            THEN 0
            WHEN pd.policy_status = 'PREKID' 
            THEN 
                CASE WHEN (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = pd.polisa) = 0 
                     THEN 0 
                     ELSE (SELECT SUM(pko_betragsoll) FROM praemienkonto pk(NOLOCK) WHERE pk.pko_obnr = pd.polisa AND pko_g_fall <> 'SVOR') 
                END
            ELSE 0
        END,
        CASE
            WHEN pd.policy_status = 'AKTIVNA' 
            THEN pd.Neto_polisirana_premija
            WHEN pd.policy_status = 'ISTEKLA' 
            THEN 0
            WHEN pd.policy_status = 'PREKID' 
            THEN 
                (SELECT SUM(pko_betragsoll) FROM praemienkonto pk(NOLOCK) WHERE pk.pko_obnr = pd.polisa) / porez
            ELSE 0 
        END
    FROM @PolicyData pd;

    -- Za Polise u prekidu, Po bransama rasporediti iznose
    UPDATE r
    SET Neto_polisirana_premija = 
        CASE WHEN (SELECT SUM(Neto_polisirana_premija) FROM @PolicyData t2 WHERE t2.polisa = pd.polisa) = 0 
             THEN 0  
             ELSE ISNULL((r.Neto_polisirana_premija * pd.Bruto_polisirana_premija) / 
                  (SELECT SUM(Bruto_polisirana_premija) FROM @PolicyData t WHERE t.polisa = pd.polisa), 0) 
        END
    FROM @finalPremije r
    INNER JOIN @PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa
    WHERE pd.policy_status = 'PREKID'

    -- Ostali slucajevi (Kas je storno 2 i bransa 11, i kad je bransa 19 i u prekidu)
    UPDATE r
    SET Neto_polisirana_premija = 
        CASE
            WHEN pd.stornoTip = 2 AND pd.bransa = 11 
            THEN pd.Neto_polisirana_premija
            WHEN pd.policy_status <> 'AKTIVNA' 
                 AND pd.bransa <> 19 
                 AND ISNULL(pd.Datum_storna,'') <= ISNULL(pd.Pocetak_osiguranja,'') 
                 AND ISNULL(pd.Datum_storna,'') >= ISNULL(pd.Istek_osiguranja,'')
            THEN r.Neto_polisirana_premija / pd.porez
            ELSE r.Neto_polisirana_premija
        END
    FROM @finalPremije r
    INNER JOIN @PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa;

    -- Special case adjustments
    UPDATE r
    SET Bruto_polisirana_premija = 
        CASE
            WHEN pd.stornoTip = 2 AND pd.bransa = 11 
            THEN pd.Neto_polisirana_premija
            WHEN pd.bransa IN (78,79)        
            THEN pd.Bruto_polisirana_premija * 
                CAST(CEILING(CAST(DATEDIFF(day, pd.Pocetak_osiguranja, @datum) AS decimal(18,2))/365) AS int)
            ELSE r.Bruto_polisirana_premija
        END
    FROM @finalPremije r
    INNER JOIN @PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa;

    -- Za Polise u prekidu, po bransama rasporediti iznose
    UPDATE r
    SET Bruto_polisirana_premija = 
        CASE WHEN (SELECT SUM(Bruto_polisirana_premija) FROM @PolicyData t2 WHERE t2.polisa = pd.polisa) = 0 
             THEN 0  
             ELSE ISNULL((r.Bruto_polisirana_premija * pd.Bruto_polisirana_premija) /
                  (SELECT SUM(Bruto_polisirana_premija) FROM @PolicyData t WHERE t.polisa = pd.polisa), 0)
        END
    FROM @finalPremije r
    INNER JOIN @PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa
    WHERE pd.policy_status = 'PREKID'

    -- Update total values to #TEMP
    UPDATE t
    SET Neto_polisirana_premija = (SELECT SUM(Neto_polisirana_premija) FROM @finalPremije f WHERE t.polisa = f.polisa),
        Bruto_polisirana_premija = (SELECT SUM(Bruto_polisirana_premija) FROM @finalPremije f WHERE t.polisa = f.polisa)
    FROM @TEMP t

    -- Insert result
    INSERT INTO @ResultTable
    SELECT 
        SUM(Bruto_polisirana_premija),
        SUM(Neto_polisirana_premija)
    FROM @TEMP

    RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[Neto_polisirana_premija_polisa]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Filip Stankovic
-- Create date: 2024.06.30
-- Description:	Funkcija za racunanje neto polisrane premija za jednu polisu
-- =============================================

--select dbo.Neto_polisirana_premija_polisa (98020356,'2024.07.31')

CREATE FUNCTION [dbo].[Neto_polisirana_premija_polisa] 
(
	@polisa int,
	@datum  datetime
)
RETURNS decimal (18,2)
AS
BEGIN


	declare @Pocetak_osiguranja datetime
	declare @Istek_osiguranja   datetime
	declare @Datum_storna		datetime
	declare @StatusPolise		varchar(20)
	declare @Premija			decimal(18,2)
	declare @Bruto_polisirana_premija decimal(18,2)
	declare @Neto_polisirana_premija decimal(18,2)
	declare @porez				decimal(18,2)
	declare @bransa				int
	declare @stornoTip			int
	declare @final				decimal(18,2)

declare cursor_1 CURSOR
	for select bra_bran from branche where bra_obnr=@polisa

	open cursor_1

	fetch next from cursor_1
	into @bransa

	while @@FETCH_STATUS = 0

	begin

	select 
	@Pocetak_osiguranja =bra_vers_beginn,
	@Istek_osiguranja=bra_vers_ablauf,
	@Datum_storna=bra_storno_ab,
	@StatusPolise=cast('' as vaRCHAR(20)),
	@Bruto_polisirana_premija=case when 
	(select vtg_pol_bran from vertrag where vtg_obnr=@polisa)=11 and DATEDIFF(day,bra_vers_beginn,bra_vers_ablauf)<365
	then
	bra_storno_kt_prozent/100 * case when bra_vers_beginn between '2022.01.01' and '2022.12.31' then bra_nettopraemie1 else bra_bruttopraemie end
	else 
	bra_bruttopraemie
	end,
	@Neto_polisirana_premija=case when 
	(select vtg_pol_bran from vertrag where vtg_obnr=@polisa)=11 and DATEDIFF(day,bra_vers_beginn,bra_vers_ablauf)<365
	then
	bra_storno_kt_prozent/100 * bra_nettopraemie1
	else 
	bra_nettopraemie1
	end,
	@porez= ISNULL((1+ bra_vst_prozent/100),0),
	@bransa= bra_bran,
	@stornoTip=bra_storno_grund
	from branche b
	left join brache_porezi bp on bp.branche_id=b.bra_bran
	where bra_obnr=@polisa  and bra_bran=@bransa

	set @Premija = 
	case  -- 1. Istekla or Aktivna; 2. Stornirana od pocetka; 3. Prekid; 4. Ostalo
	 when isnull(@Datum_storna,'')=isnull(@Istek_osiguranja,'') or isnull(@Datum_storna,'')>@datum then @Neto_polisirana_premija
	 when isnull(@Datum_storna,'')=isnull(@Pocetak_osiguranja,'') then 0  
	 when isnull(@Datum_storna,'')>isnull(@Pocetak_osiguranja,'') and isnull(@Datum_storna,'')<isnull(@Istek_osiguranja,'') then isnull(ABS((select sum(bra_bruttopraemie) from branche t2 where t2.bra_obnr=@polisa)-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum > @Datum_storna and @polisa=pk.pko_obnr and pko_betragsoll<0 )),0)
	 else 0
	 end

	 set @StatusPolise=
	 case when isnull(@Datum_storna,'')=isnull(@Istek_osiguranja,'') and isnull(@Datum_storna,'')>@datum then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull(@Datum_storna,'')<isnull(@Istek_osiguranja,'') and isnull(@Datum_storna,'')>@datum then 'Aktivna'
	 when isnull(@Datum_storna,'')=isnull(@Pocetak_osiguranja,'') then 'Stornirana od pocetka' 
	 when isnull(@Datum_storna,'')>isnull(@Pocetak_osiguranja,'') and isnull(@Datum_storna,'')<isnull(@Istek_osiguranja,'') then 'Prekid'
	 else 'Istekla' 
	 end

	 set @Premija=
	 case when @StatusPolise='Prekid' then (select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=@polisa) 
		  else @Premija
	end

	 set @Premija=
	 case when  @StatusPolise='Prekid' and @StatusPolise<>'Stornirana od pocetka' then
	 case when (select sum(bra_bruttopraemie) from branche t2 where t2.bra_obnr=@polisa)=0 then 0 else  isnull((@Premija*@Neto_polisirana_premija) /(select sum(bra_nettopraemie1) from branche t2 where t2.bra_obnr=@polisa),0) end
		  else @Premija
	 end


	 set @Premija=
	 case when isnull(@Datum_storna,'')<>isnull(@Istek_osiguranja,'') and isnull(@Datum_storna,'')<@datum -- da se ne bi ponovo umanjila za porez
     and @Bransa<>19
		  then @Premija / @porez
		  else @Premija
	 end


	 set @Premija=
	 case when @stornoTip=2 and @bransa=11 then @Neto_polisirana_premija
	 else @Premija 
	 end



	 set @final=isnull(@final,0)+@Premija




	 FETCH NEXT FROM cursor_1   
     INTO @bransa

	 end

	 CLOSE cursor_1;  
	 DEALLOCATE cursor_1;  



	 return @final

end

GO
/****** Object:  StoredProcedure [dbo].[daily_replacate]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[daily_replacate] 
AS
BEGIN


create table #temp(
name varchar(100)
)

insert into #temp 
select name from GRAWE_BESTANDME.sys.tables


DECLARE @name varchar(100)
DECLARE @sql_stmn varchar(800)

DECLARE db_cursor CURSOR FOR
select name from #temp

OPEN db_cursor
FETCH NEXT FROM db_cursor into @name

WHILE @@FETCH_STATUS=0

begin

	set @sql_stmn= 'insert into '+@name +' select * from GRAWE_BESTANDME.dbo.'+ @name
	exec (@sql_stmn)

FETCH NEXT FROM db_cursor into @name
end

CLOSE db_cursor 
DEALLOCATE db_cursor

drop table #temp


END
GO
/****** Object:  StoredProcedure [dbo].[Dani_kasnjenja]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec dani_kasnjenja '30.09.2022'

CREATE procedure [dbo].[Dani_kasnjenja]
(
--declare 
@DatumIzvjestaja varchar(10)='15.09.2022'
) as BEGIN


set @DatumIzvjestaja = case when substring(@DatumIzvjestaja,1,4) like '[0-9][0-9][0-9][0-9]' then convert(varchar,convert(date,@DatumIzvjestaja,102),104) else @DatumIzvjestaja end


--Pomocne promjenjive za kursore

declare @Datum varchar(10),
@Obaveze decimal(18,2),
@Uplate decimal(18,2),
@saldo decimal(18,2),
@PrethodniSaldo  decimal(18,2)=0,
@DatumPocetkaKasnjenja varchar(10)='',
@TrenutnaUplata decimal(18,2),
@Datum2 varchar(10),
@Obaveze2 decimal(18,2),
@Uplate2 decimal(18,2),
@saldo2 decimal(18,2),
@Polisa int



--Pomnocna temp tabela za drugi cursor, cuva uzastopne neizmirene dospjele obaveze 

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
drop table #temp

create table #temp
(
datum varchar(10),
Obaveze varchar(10),
Uplate decimal(18,2),
saldo decimal(18,2),
)

IF OBJECT_ID('tempdb..#finall') IS NOT NULL
drop table #finall

create table #finall
(
Polisa int,
DaniKasnjenja int
)



IF OBJECT_ID('tempdb..#Stanja_Po_Datumima') IS NOT NULL
drop table #Stanja_Po_Datumima



select 
pko_obnr pko_obnr,
pko_wertedatum								 datum,	 
sum(cast(replace(pko_betragsoll,',','.') as float))  Obaveze, 
sum(cast(replace(pko_betraghaben,',','.') as float)) Uplate,
cast((
select sum(cast(replace(pko_betraghaben,',','.') as float)) - sum(cast(replace(pko_betragsoll,',','.') as float))
from praemienkonto (nolock)
where pko_obnr=p.pko_obnr and convert(date,pko_wertedatum,104)<=convert(date,p.pko_wertedatum,104)
)as decimal(18,2))									 saldo
into #Stanja_Po_Datumima
from praemienkonto p
where convert(date,pko_wertedatum,104)<convert(date,@DatumIzvjestaja,104)
and pko_obnr in (select distinct pko_obnr from #final)
group by pko_obnr,pko_wertedatum
order by pko_obnr,convert(date,pko_wertedatum,104)asc



------------------------------------------------------------------------------------------------------------------------


declare polisa_cursor CURSOR for 

select distinct pko_obnr from #Stanja_Po_Datumima

OPEN polisa_cursor  
FETCH NEXT FROM polisa_cursor INTO @Polisa


WHILE @@FETCH_STATUS = 0  
BEGIN  

--Prvi (glavni) cursor, koji prolazi kroz svaki dan pojedinacno t.j.kroz #Stanja_Po_Datumima red po red

DECLARE db_cursor CURSOR FOR

select datum,
cast(replace(Obaveze,',','.') as float),
cast(replace(Uplate,',','.') as float), 
cast(replace(Saldo,',','.') as float)
from #Stanja_Po_Datumima 
where pko_obnr=@Polisa
order by convert(date,datum,104)asc

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @Datum,  @Obaveze , @Uplate, @saldo

WHILE @@FETCH_STATUS = 0  
BEGIN  

/*
Ukoliko je saldo negativan za datum negativan, provjeri da li postoji datum pocetka kasnjenja, 
ukoliko ne, postavi ga i puni temp tabelu, ako postoji, samo puni temp tabelu
*/

		if @saldo<0  
		begin
			
			if @DatumPocetkaKasnjenja=''
			begin
				set @DatumPocetkaKasnjenja=@datum
			end

			insert into #temp
			SELECT @Datum,  @Obaveze , @Uplate, @saldo
		
		end

--Ukoliko saldo nije negativan, klijent je ovoga dana imao izmirene sve obaveze, zato postavljamo datum pocetka kasnjenja da ne postoji
		if @saldo>=0
		begin
			truncate table #temp
			set @DatumPocetkaKasnjenja=''
		end


--Ukoliko je saldo negativan, a klijent je u ovome danu imao uplatu, ulazimo u drugi cursor koji prolazi kroz drugu pomocnu tabelu (svi uzastopni negativni saldi)

		if @saldo<0 and @PrethodniSaldo<0 and @saldo>@PrethodniSaldo and @Uplate>0

		begin

		--Pomocne varijable, jedna koja cuva vrijednost uplate, a druga provjerava da li je prvi prolaz kroz kursor

				set @TrenutnaUplata=@Uplate
				declare @Prolaz int=0

				--Drugi cursor, za pomocnu tabelu negativnih uzastopnih salda
				DECLARE db_cursor2 CURSOR FOR 
				
				SELECT * from #TEMP
				order by convert(date,datum,104)asc

				OPEN db_cursor2  
				FETCH NEXT FROM db_cursor2 INTO @Datum2,  @Obaveze2 , @Uplate2, @saldo2  

				WHILE @@FETCH_STATUS = 0  
				BEGIN  
		
					--Ukoliko nije prvi prolaz, postavi vrijednost poslednjeg dana kasnjenja da je jednak trenutnome datumu
					  if @Prolaz=1
					  begin
						set @DatumPocetkaKasnjenja=@Datum2
					  end

					--Vrati vrijednost pomocne varijable na 0, ukoliko poslednja uplata izmiri jos obaveza
					  set @Prolaz=0
					  


					--Ukoliko uplata ne mozoe da isplati trenutnu obavezu izadji iz crursora
					  if @TrenutnaUplata-@Obaveze2<0
					  begin
						BREAK
					  end

					--Ukoliko uplata isplacuje najstariju dospjelu obavezu, isplati tu obavezu i provjeri drugu najstariju, 
					--postavi prolaz na 1 kako bi se datum poslednjeg kasnjenja azurirao na 
					  else 

					  begin
						set @TrenutnaUplata=@TrenutnaUplata-@Obaveze2
						set @Prolaz=1
					  end


					  FETCH NEXT FROM db_cursor2 INTO @Datum2,  @Obaveze2 , @Uplate2, @saldo2   
				END 

				CLOSE db_cursor2  
				DEALLOCATE db_cursor2 

		end
		
		
		set @PrethodniSaldo=@saldo

		

      FETCH NEXT FROM db_cursor INTO @Datum,  @Obaveze , @Uplate, @saldo 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 


--select @DatumPocetkaKasnjenja


----Kraj izvjestaja, racunaj dane kasnjenja od datuma pocetka kasnjenja do datuma izvjestaja

if @DatumPocetkaKasnjenja='' 
begin
	insert into #finall
	select @Polisa,0
end

else
begin

insert into #finall
select @polisa, DATEDIFF(DD,convert(date,@DatumPocetkaKasnjenja,104),convert(date,@DatumIzvjestaja,104))
end

FETCH NEXT FROM polisa_cursor INTO @Polisa
END 

CLOSE polisa_cursor  
DEALLOCATE polisa_cursor 



END
GO
/****** Object:  StoredProcedure [dbo].[Dani_kasnjenja_polisa]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec Dani_kasnjenja_polisa '2023.12.17','98022593' 

CREATE procedure [dbo].[Dani_kasnjenja_polisa](
@datum	datetime,
@Polisa	varchar(20)='7001179'
)as 

BEGIN



CREATE TABLE #Izuzetci (
    Polisa INT,
    Dani_Kasnjenja INT
);


INSERT INTO #Izuzetci (Polisa, Dani_Kasnjenja)
VALUES
(1399536, 2063),
(1399538, 0),
(1399539, 0),
(1399556, 1359),
(1399601, 2116),
(1399604, 2116),
(1399609, 1880),
(1399676, 960),
(1399717, 0),
(1399718, 0),
(1399824, 606),
(1399839, 0),
(1399916, 404),
(1399918, 344),
(1399920, 428),
(1399921, 381),
(7199128, 386),
(7199129, 488),
(7199130, 428),
(7199131, 516),
(7199132, 367),
(7199133, 425),
(7199134, 367),
(8699805, 344),
(8699806, 385),
(8699807, 183),
(8699808, 548),
(9900017, 509),
(9900021, 567),
(9900027, 212),
(9900083, 372),
(9900105, 382),
(9900109, 360),
(9900124, 716),
(9900136, 253),
(9900137, 31),
(9900180, 94),
(9900181, 94),
(9900196, 71),
(9900200, 326),
(9900201, 38),
(9900202, 453),
(9900203, 365),
(9900204, 599),
(9900205, 892),
(9900206, 422),
(9900207, 253),
(9900208, 872),
(9900209, 905),
(9900210, 419),
(9900211, 395),
(9900212, 1295),
(9900214, 617),
(9900215, 974),
(9900216, 671),
(9900217, 234),
(9900220, 529),
(9900221, 567),
(9900222, 343),
(9900223, 398),
(9900227, 442),
(9900228, 187),
(9900229, 261),
(9900231, 244),
(9900233, 333),
(9900234, 512),
(9900235, 150),
(90114240, 1397),
(90148293, 950),
(90148294, 950),
(90148295, 950),
(90167215, 514),
(90172334, 710),
(90176637, 375),
(90176638, 374),
(90180847, 471),
(90180867, 520),
(90181802, 498),
(90187372, 372),
(90188632, 416),
(90195191, 487),
(90196509, 462),
(90196547, 412),
(90198796, 424),
(90201596, 404),
(90204657, 389),
(90205168, 379),
(98008230, 1430),
(98008616, 1415),
(98008971, 1417),
(98009020, 1402),
(98009075, 1380),
(98009564, 996),
(98010268, 1052),
(98010675, 943),
(98010801, 270),
(98010830, 880),
(98011081, 819),
(98011149, 534),
(98011361, 571),
(98011397, 744),
(98011528, 684),
(98011576, 475),
(98011577, 475),
(98011715, 312),
(98012123, 241),
(98012124, 241),
(98012125, 271),
(98012126, 271),
(98012151, 319),
(98012236, 511),
(98012243, 549),
(98012303, 527),
(98012367, 512),
(98012479, 474),
(98012519, 440),
(98012547, 463),
(98012619, 326),
(98012690, 122),
(98012759, 354),
(98012780, 381),
(98012819, 403);



declare @UkupnoDospjelo			decimal(18,2),
@ukupnoUplaceno					decimal(18,2),
@trenutnaObaveza				decimal(18,2),
@TrenutniDatum					datetime,
@DatumPocetkaKasnjenja			datetime


IF OBJECT_ID('tempdb..#kasnjenjeTemp') IS NOT NULL
drop table #kasnjenjeTemp

create table #kasnjenjeTemp(
polisa int,
datum varchar(10),
danikasnjenja int,
iznos decimal(18,2)
)



set @ukupnoUplaceno = isnull((select sum(pko_betraghaben) from praemienkonto (nolock)
where pko_obnr=@Polisa and pko_wertedatum <= @datum ),0) 

set @UkupnoDospjelo=isnull((select sum(pko_betragsoll) from praemienkonto (nolock)
where pko_obnr=@Polisa and pko_wertedatum <= @datum ),0) 




if @ukupnoUplaceno>=@UkupnoDospjelo 
begin
 select @polisa,0
 return
end


DECLARE db_cursor CURSOR FOR

select * from(
select sum(pko_betragsoll) iznos,
pko_wertedatum 
from praemienkonto
where pko_wertedatum <= @datum and pko_obnr=@Polisa and pko_betragsoll <> 0
group by pko_wertedatum
)a 
order by convert(date,pko_wertedatum ,104) asc 


OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @trenutnaObaveza,@TrenutniDatum

WHILE @@FETCH_STATUS = 0  
BEGIN  
	


	if(@ukupnoUplaceno-@trenutnaObaveza>=0)
	begin
	set @ukupnoUplaceno=@ukupnoUplaceno-@trenutnaObaveza
	set @UkupnoDospjelo=@UkupnoDospjelo-@trenutnaObaveza
	set @DatumPocetkaKasnjenja=isnull(@TrenutniDatum,'')
	end

	else
	begin
		set @DatumPocetkaKasnjenja=isnull(@TrenutniDatum,'')
	break
	end


	FETCH NEXT FROM db_cursor INTO @trenutnaObaveza,@TrenutniDatum
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 



if(@Polisa in (select polisa from #Izuzetci))

begin


		if(convert(date,@DatumPocetkaKasnjenja,104) <= convert(date,'2024.01.01',102))
		begin
			
			select 
			@polisa polisa,
			DATEDIFF(DD,'2022.12.31',@datum) + (select Dani_Kasnjenja from #Izuzetci where polisa=@polisa) dani_kasnjenja

		end

end

else

begin
	
	select 
	@polisa polisa,
	DATEDIFF(DD,@DatumPocetkaKasnjenja,@datum) dani_kasnjenja

end



end
GO
/****** Object:  StoredProcedure [dbo].[gr_dospjela_potrazivanja]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DD.MM.YYYY

--  exec gr_dospjela_potrazivanja '31.01.2024'
CREATE procedure [dbo].[gr_dospjela_potrazivanja]
(
--declare
@datum varchar(10)='30.09.2022'
)as begin



IF OBJECT_ID('tempdb..#final') IS NOT NULL
drop table #final



select distinct
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [Osiguranik],
	k.kun_telefon_1												[Broj Telefona],
	k.kun_e_mail												[Mejl],
	vtg_pol_vkto												[VKTO],
	isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[Naziv Posrednika],
	m.ma_unterst_og												[Kanal Prodaje],
	b.bra_obnr													[Broj Polise],						
	v.vtg_antrag_obnr											[Broj Ponude],
	v.vtg_ivk_nr												[Broj Zelene Karte],
	b.bra_bran													[Bransa],
	b.bra_vv_ueb												[Vrsta osiguranja],
	vtg_zahlungsweise											[Nacin Placanja],
	(select sum(bra_bruttopraemie)from branche b2 where b.bra_obnr=b2.bra_obnr)[Bruto_polisirana_premija],
	ISNULL((select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall<>'SVOR'),0) [Uplacena_premija],
	cast(0 as decimal(18,2))									[Ukupno Potrazivanje],
	isnull(cast(((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @Datum and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0) [Dospjelo Potrazivanje],
	cast(0 as decimal(18,2))									[<=30 tage],
	cast(0 as decimal(18,2))									[31-60 tage],
	cast(0 as decimal(18,2))									[61-90 tage],
	cast(0 as decimal(18,2))									[91-180 tage],
	cast(0 as decimal(18,2))									[181-270 tage],
	cast(0 as decimal(18,2))									[271-365 tage],
	cast(0 as decimal(18,2))									[365+ tage],
	cast(0 as int)												[Dani Kasnjenja],
	cast(0 as decimal(18,2))									Obezvredjenje,
	bra_vers_beginn   											[Pocetak_osiguranja],
	bra_vers_ablauf   											[Istek_osiguranja],
	bra_storno_ab  												[Datum_storna],
	cast('' as vaRCHAR(400))									[StatusPolise],
	vtg_zahlungsweise											[Nacin_Placanja],
	bra_storno_grund											[Storno tip],
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))	[Neto_polisirana_premija],
	case when v.vtg_pol_bran=b.bra_bran then vtg_ivk_nr	 else 0 end		[ZelenaKarta],										
	cast(0 as decimal(18,2))									[SaldoZelenaKarta]
	into #final
from branche b (nolock)
join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid and b.bra_bran=v.vtg_pol_bran
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik



------Izracunavamo Saldo ZK ukoliko nije bransa 19. Nakon toga droppamo pomocne kolone iz tabele final

update f
set [SaldoZelenaKarta]=case when Bransa=19 then [Dospjelo Potrazivanje]
							else 0
							end
from #final f



update #final
set [SaldoZelenaKarta]=0
where [ZelenaKarta]=0




--------------Brisanje svih nepotrebnih polisa (optimizacija)----------------

delete from #final
where [Dospjelo Potrazivanje]=0 or [Dospjelo Potrazivanje] between 0.01 and 0.03



------------------------------------Potrazivanje------------------------------

update t
set Obezvredjenje=
case  
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Neto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #final t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum > t.Datum_storna and t.[Broj Polise]=pk.pko_obnr and pko_betragsoll < 0 )),0)
	 else 0
end
from #final t



update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>convert(varchar,convert(date,@datum,104),102) then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>convert(varchar,convert(date,@datum,104),102) then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka' 
	 -- when @datumdo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem. 
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #final t



update t 
set Obezvredjenje=(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise] and pko_g_fall<>'SVOR')
from #final t
where StatusPolise='Prekid' and Nacin_Placanja not in (0,1)



--- ovo je totalna steta. Izmijenjeno 11042023 jer 9 vise ne postoji i sad se koristi 2 a 9 vise nema sa ovom namjenom
update t
set Obezvredjenje=Neto_polisirana_premija
from #final t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)


----------Bruto Polisirana premija-----------------

update t
set Bruto_polisirana_premija=
case  
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Bruto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #final t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum >= t.Datum_storna and t.[Broj Polise]=pk.pko_obnr and pko_betragsoll < 0 )),0)
	 else 0
end
from #final t



update t 
set Bruto_polisirana_premija=(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise] and pko_g_fall<>'SVOR')
from #final t
where StatusPolise='Prekid' --and Nacin_Placanja not in (0,1)



update t
set Bruto_polisirana_premija=Neto_polisirana_premija
from #final t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)




update t
set Bruto_polisirana_premija=Bruto_polisirana_premija * cast(CEILING(cast(DATEDIFF(day,[Pocetak_osiguranja],@datum) as decimal(18,2))/365) as int)
from #final t
where Bransa in (78,79)



----------- proporcionalno po bransama
--update t

--set Bruto_polisirana_premija=Bruto_polisirana_premija*[Procenat Udjela]* (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
--from #final t
--where StatusPolise='Prekid'
--and statuspolise<>'Stornirana od pocetka'

------------------------Kraj Bruto Polisirane premije----------------------------


update t
set [Ukupno Potrazivanje]=Bruto_polisirana_premija-[Uplacena_premija]
from #final t



update t

set Obezvredjenje=Obezvredjenje / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #final t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datum -- da se ne bi ponovo umanjila za porez






-------------------------Kasnjenja-------------------------------------


declare @polisa int

IF OBJECT_ID('tempdb..#kasnjenja') IS NOT NULL 
drop table #kasnjenja

create table #kasnjenja
(
polisa			int,
[<=30 tage]		decimal(18,2),
[31-60 tage]	decimal(18,2),
[61-90 tage]	decimal(18,2),
[91-180 tage]	decimal(18,2),	
[181-270 tage]	decimal(18,2),
[271-365 tage]	decimal(18,2),
[365+ tage]		decimal(18,2),
[Dani Kasnjenja]int
)

--declare polisa_cursor CURSOR for 

--select distinct [Broj Polise] from #final where [Dospjelo Potrazivanje]<0

--OPEN polisa_cursor  
--FETCH NEXT FROM polisa_cursor INTO @Polisa
--WHILE @@FETCH_STATUS = 0  
--BEGIN  


--insert into #Kasnjenja
--exec Iznosi_kasnjenja_polisa @Datum,@polisa


--FETCH NEXT FROM polisa_cursor INTO @Polisa
--END
--CLOSE polisa_cursor  
--DEALLOCATE polisa_cursor 




update f
set [<=30 tage]=  isnull((SELECT [<=30 tage]       from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[31-60 tage]=     isnull((SELECT [31-60 tage]      from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[61-90 tage]=     isnull((SELECT [61-90 tage]      from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[91-180 tage]=    isnull((SELECT [91-180 tage]     from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[181-270 tage]=   isnull((SELECT [181-270 tage]    from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[271-365 tage]=   isnull((SELECT [271-365 tage]    from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[365+ tage]=      isnull((SELECT [365+ tage]       from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
[Dani Kasnjenja]= isnull((SELECT [Dani Kasnjenja]  from #kasnjenja k where k.polisa=f.[Broj Polise]),0)
from #final f



update #final
set Obezvredjenje= [Ukupno Potrazivanje] *
case when [365+ tage]<>0    then 1
	 when [271-365 tage]<>0 then 0.75
	 when [181-270 tage]<>0 then 0.5
	 when [91-180 tage]<>0	then 0.25
else 0 end



IF OBJECT_ID('tempdb..#Dopuna') IS NOT NULL
drop table #Dopuna

create table #Dopuna (
[Ugovarac]					varchar(200),
[Osiguranik]				varchar(200),
[Broj Telefona]				varchar(200),
[Mejl]						varchar(200),
[VKTO]						varchar(200),
[Naziv Posrednika]			varchar(200),
[Kanal Prodaje]				int,
[Broj Polise]				int,
[Broj Ponude]				int,
[Bransa]					int,
[Pocetak_osiguranja]		varchar(100),
[Istek_osiguranja]			varchar(100),
[Vrsta osiguranja]			varchar(200),
[Nacin Placanja]			int,
[Bruto_polisirana_premija]	decimal(18,2),
[Uplacena_premija]			decimal(18,2),
[Ukupno Potrazivanje]		decimal(18,2),
[Dospjelo Potrazivanje]		decimal(18,2),
[<=30 tage]					decimal(18,2),
[31-60 tage]				decimal(18,2),
[61-90 tage]				decimal(18,2),
[91-180 tage]				decimal(18,2),
[181-270 tage]				decimal(18,2),
[271-365 tage]				decimal(18,2),
[365+ tage]					decimal(18,2),
[Dani Kasnjenja]			int,
Obezvredjenje				decimal(18,2),
[Broj Zelene Karte]			int,
SaldoZelenaKarta			decimal(18,2)
)




UPDATE #final 
SET [Dospjelo Potrazivanje] = 
    CASE WHEN [Ukupno Potrazivanje] = 0 
        THEN 0 
        ELSE [Dospjelo Potrazivanje] 
    END



delete from #final
where [Dospjelo Potrazivanje]=0 and [Ukupno Potrazivanje]=0


update #Dopuna
set [Dospjelo Potrazivanje]=ABS([Dospjelo Potrazivanje])


update #Dopuna
set Uplacena_premija=(select ISNULL(sum(pko_betraghaben),0) from praemienkonto p (nolock) where p.pko_obnr=#Dopuna.[Broj Polise] and pko_wertedatum <= @Datum and pko_g_fall<>'SVOR')


select distinct
[Ugovarac],
[Osiguranik],
[Broj Telefona],
[Mejl],
[VKTO],
[Naziv Posrednika],
[Kanal Prodaje],
[Broj Polise],
[Broj Ponude],
[Bransa],
[Pocetak_osiguranja],
[Istek_osiguranja],
[Vrsta osiguranja],
[Nacin Placanja],
[Bruto_polisirana_premija],
[Uplacena_premija],
[Ukupno Potrazivanje],
[Dospjelo Potrazivanje]*-1 [Dospjelo Potrazivanje],
[<=30 tage]*-1 [<=30 tage],
[31-60 tage]*-1 [31-60 tage],
[61-90 tage]*-1 [61-90 tage],
[91-180 tage]*-1 [91-180 tage],
[181-270 tage]*-1 [181-270 tage],
[271-365 tage]*-1 [271-365 tage],
[365+ tage]*-1 [365+ tage],
[Dani Kasnjenja],
Obezvredjenje*-1 Obezvredjenje,
[Broj Zelene Karte],
SaldoZelenaKarta*-1 SaldoZelenaKarta--,
--StatusPolise
from #final



END
GO
/****** Object:  StoredProcedure [dbo].[gr_kanal_prodaje]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [gr_kanal_prodaje] '2024.07.31',91014

CREATE procedure [dbo].[gr_kanal_prodaje](
--declare
@datum varchar(10),
@KanalProdaje int=91014
)as

BEGIN



IF OBJECT_ID('tempdb..#final') IS NOT NULL
drop table #final



select distinct
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [Osiguranik],
	k.kun_telefon_1												[Broj Telefona],
	k.kun_e_mail												[Mejl],
	vtg_pol_vkto												[VKTO],
	isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[Naziv Posrednika],
	m.ma_unterst_og												[Kanal Prodaje],
	b.bra_obnr													[Broj Polise],						
	v.vtg_antrag_obnr											[Broj Ponude],
	v.vtg_ivk_nr												[Broj Zelene Karte],
	b.bra_bran													[Bransa],
	b.bra_vv_ueb												[Vrsta osiguranja],
	vtg_zahlungsweise											[Nacin Placanja],
	(select sum(bra_bruttopraemie) from branche b2 where b2.bra_obnr=b.bra_obnr)   [Bruto_polisirana_premija],
	(select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum) [Uplacena_premija],
	cast(0 as decimal(18,2))									[Ukupno Potrazivanje],
--Iznos Potrazivanja
	isnull(cast(((select top 1 p.pko_wertedatumsaldo from praemienkonto p (nolock) where pko_wertedatum <= @Datum and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0) [Dospjelo Potrazivanje],
	cast(0 as decimal(18,2))									[<=30 tage],
	cast(0 as decimal(18,2))									[31-60 tage],
	cast(0 as decimal(18,2))									[61-90 tage],
	cast(0 as decimal(18,2))									[91-180 tage],
	cast(0 as decimal(18,2))									[181-270 tage],
	cast(0 as decimal(18,2))									[271-365 tage],
	cast(0 as decimal(18,2))									[365+ tage],
	cast(0 as decimal(18,2))									Obezvredjenje,
	bra_vers_beginn   											[Pocetak_osiguranja],
	bra_vers_ablauf   											[Istek_osiguranja],
	bra_storno_ab  												[Datum_storna],
	cast('' as vaRCHAR(400))									[StatusPolise],
	vtg_zahlungsweise											[Nacin_Placanja],
	bra_storno_grund											[Storno tip],
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))	[Neto_polisirana_premija],
	case when v.vtg_pol_bran=b.bra_bran then vtg_ivk_nr	 else 0 end		[ZelenaKarta],
	case when exists (select 1 from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK') then 
	case when (select COUNT(*) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and abs(pko_betraghaben)=20)=(select COUNT(*) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK') then 0 else (isnull((select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and abs(pko_betraghaben)=20),0)-(select sum(pko_betragsoll) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK')) end
	else 0 end													[SaldoZelenaKarta]
	into #final
from branche b (nolock)
join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid and b.bra_bran=v.vtg_pol_bran
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik
where bra_vers_beginn < @datum and m.ma_unterst_og=@KanalProdaje



--------------Brisanje svih nepotrebnih polisa (optimizacija)----------------

delete from #final
where [Dospjelo Potrazivanje]=0 or [Dospjelo Potrazivanje] between 0.01 and 0.03



------------------------------------Potrazivanje------------------------------

update t
set Obezvredjenje=
case  
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Neto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #final t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum > t.Datum_storna and t.[Broj Polise]=pk.pko_obnr and pko_betragsoll < 0 )),0)
	 else 0
end
from #final t



update t
set [Ukupno Potrazivanje]=Bruto_polisirana_premija-[Uplacena_premija]
from #final t


delete from #final
where [Ukupno Potrazivanje]=0


update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka' 
	 -- when @datumdo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem. 
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #final t


update t 
set Obezvredjenje=(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise] and pko_g_fall<>'SVOR')
from #final t
where StatusPolise='Prekid' and Nacin_Placanja not in (0,1)



update t

set Obezvredjenje=Obezvredjenje / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #final t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datum -- da se ne bi ponovo umanjila za porez



--- ovo je totalna steta. Izmijenjeno 11042023 jer 9 vise ne postoji i sad se koristi 2 a 9 vise nema sa ovom namjenom
update t
set Obezvredjenje=Neto_polisirana_premija
from #final t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)




-------------------------Kasnjenja-------------------------------------


--declare @polisa int

--IF OBJECT_ID('tempdb..#kasnjenja') IS NOT NULL 
--drop table #kasnjenja

--create table #kasnjenja
--(
--polisa			int,
--[<=30 tage]		decimal(18,2),
--[31-60 tage]	decimal(18,2),
--[61-90 tage]	decimal(18,2),
--[91-180 tage]	decimal(18,2),	
--[181-270 tage]	decimal(18,2),
--[271-365 tage]	decimal(18,2),
--[365+ tage]		decimal(18,2)
--)

--declare polisa_cursor CURSOR for 

--select distinct [Broj Polise] from #final where [Dospjelo Potrazivanje]<0

--OPEN polisa_cursor  
--FETCH NEXT FROM polisa_cursor INTO @Polisa
--WHILE @@FETCH_STATUS = 0  
--BEGIN  


--insert into #Kasnjenja
--exec Iznosi_kasnjenja_polisa @Datum,@polisa


--FETCH NEXT FROM polisa_cursor INTO @Polisa
--END
--CLOSE polisa_cursor  
--DEALLOCATE polisa_cursor 




--update f
--set [<=30 tage]=isnull((SELECT [<=30 tage] from #kasnjenja k where k.polisa=f.[Broj Polise])   ,0)	,
--[31-60 tage]=   isnull((SELECT [31-60 tage]   from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[61-90 tage]=   isnull((SELECT [61-90 tage]   from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[91-180 tage]=  isnull((SELECT [91-180 tage]  from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[181-270 tage]= isnull((SELECT [181-270 tage] from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[271-365 tage]= isnull((SELECT [271-365 tage] from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[365+ tage]=    isnull((SELECT [365+ tage]    from #kasnjenja k where k.polisa=f.[Broj Polise]),0)
--from #final f


--update #final
--set Obezvredjenje= 0*isnull([<=30 tage],0) + 0*isnull([31-60 tage],0) + 0*isnull([61-90 tage],0) + 0.25 * isnull([91-180 tage],0) + 0.5 * isnull([181-270 tage],0) +0.75 * isnull([271-365 tage],0) + 1 * isnull([365+ tage],0)



update #final
set [SaldoZelenaKarta]=0
where [ZelenaKarta]=0




select distinct
[Ugovarac],
[Osiguranik],
[Broj Telefona],
[Mejl],
[VKTO],
[Naziv Posrednika],
[Kanal Prodaje],
[Broj Polise],
[Broj Ponude],
[Bransa],
[Pocetak_osiguranja],
[Istek_osiguranja],
[Vrsta osiguranja],
[Nacin Placanja],
[Bruto_polisirana_premija],
[Uplacena_premija],
[Ukupno Potrazivanje],
[Dospjelo Potrazivanje],
[<=30 tage],
[31-60 tage],
[61-90 tage],
[91-180 tage],
[181-270 tage],
[271-365 tage],
[365+ tage],
Obezvredjenje,
[Broj Zelene Karte],
SaldoZelenaKarta
from #final





END
GO
/****** Object:  StoredProcedure [dbo].[gr_likvidirane_stete]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec gr_likvidirane_stete '2024.01.01', '2024.07.31'
CREATE PROCEDURE [dbo].[gr_likvidirane_stete](
--declare
@datumod  varchar(10),
@datumdo  varchar(10)
)AS

BEGIN



select 
--
CAST(scn_ident_bran as varchar)+'-'+
CAST(scn_ident_pol_filiale as varchar)+'-'+ 
CAST(scn_ident_lfd_nr as varchar)+'-'+
CAST(scn_ident_jahr as varchar)					[Broj stete],
scn_ereignis_dt									[Datum Nastanka],
scn_anmelde_dt									[Datum prijave],
scz_verbdatum									[Datum likvidacije],
scz_betrag										[Iznos],
scn_ptr_vte_obnr								[Broj Polise],
scn_ident_bran									[Bransa],
scn_statistik_nr								[Statisticki broj],
scn_schaden_vn									[Ugovarac]
from schaden scn(nolock)
join schadenzahlung scz (nolock) on scn.scn_id=scz_schadenid
where scz_verbdatum between @datumod and @datumdo


END
GO
/****** Object:  StoredProcedure [dbo].[gr_polisirane_premije]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec gr_polisirane_premije '2022.01.01','2024.10.10'

CREATE PROCEDURE [dbo].[gr_polisirane_premije] 
(
--declare 
		@datumod  varchar(10)='2022.01.01',
		@datumdo  varchar(10)='2022.09.30',
		@optional int=1
)AS
BEGIN


IF OBJECT_ID('tempdb..#temp') is not null
	DROP TABLE #temp

select distinct
	b.bra_obnr					[Broj Polise],
	vtg_antrag_obnr				[Broj Ponude],
	vtg_pol_kreis				[Pol_kreis],
	bra_bran					[Bransa],
	bra_vv_ueb					[Naziv_Branse],
	bra_statistik_nr			[Statisticki_broj],
	bra_vers_beginn  			[Pocetak_osiguranja],
	bra_vers_ablauf  			[Istek_osiguranja],
	bra_storno_ab				[Datum_storna],
	bra_storno_grund			[Storno tip],
	cast('' as vaRCHAR(400))	[StatusPolise],
	vtg_zahlungsweise			[Nacin_Placanja],
	bra_bruttopraemie			[Bruto_polisirana_premija],
	bra_nettopraemie1			[Neto_polisirana_premija],
	cast(0 as decimal(18,2))	[Premija],
	vtg_pol_vkto				[Sifra zastupnika], 
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'') [Naziv zastupnika],
	ma_unterst_og				[Kanal_prodaje], 
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
where ((vtg_pol_kreis=98 and bra_vers_beginn>='2024.01.01') or (vtg_pol_kreis<>98  and bra_vers_beginn<'2024.01.01'))
and bra_vers_beginn between @datumod and @datumdo


update t
set Premija=
case  -- 1. Istekla or Aktivna; 2. Stornirana od pocetka; 3. Prekid; 4. OStalo
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') or isnull([Datum_storna],'')>@datumdo then [Neto_polisirana_premija]
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum >= t.Datum_storna and t.[Broj Polise]=pk.pko_obnr and pko_betragsoll<0 )),0)
	 else 0
end
from #temp t



--- statusi
-- GR-88 Promjena za Prekid uslov
update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka' 
	 -- when @datumdo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem. 
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #temp t


-- 29.02 - zakomentarisano and Nacin_Placanja not in (0,1) sanja potvrdila
update t 
set Premija=(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise])
from #temp t
where StatusPolise='Prekid' -- and Nacin_Placanja not in (0,1)


--------- proporcionalno po bransama
update t

set Premija=case when (select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj Polise]=t.[Broj Polise])=0 then 0 else  isnull((Premija*Bruto_polisirana_premija) /(select sum(Bruto_polisirana_premija) from #temp t2 where t2.[Broj Polise]=t.[Broj Polise]),0) end
from #temp t
where StatusPolise='Prekid' -- isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo -- prekid
and statuspolise<>'Stornirana od pocetka'



------Bruto premija umanjena za prekid po bransama - Vec umanjeno u prvom update-u
/* 
Update t
set premija=Bruto_polisirana_premija-Premija
from #temp t
where StatusPolise='Prekid'
/*
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') -- and isnull([Datum_storna],'')>@datumdo -- sta je ovaj uslov
--and statuspolise<>'Stornirana od pocetka'
*/
*/

---Porez

update t

set Premija=Premija / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #temp t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datumdo -- da se ne bi ponovo umanjila za porez
and Bransa<>19



-- Totalna steta. To je iznos neto premije ali je prekid

--update t 
--set Premija=case when cast(replace((select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[Broj Polise]=pk.pko_obnr),',','.') as decimal(18,2))<0 then Premija else Neto_polisirana_premija end
--from #temp t
--where  cast(replace((select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[Broj Polise]=pk.pko_obnr),',','.') as decimal(18,2))>0
--and StatusPolise='Prekid'

-- Totalna steta kod kasko osiguranja2
update t

set Premija=Neto_polisirana_premija
from #temp t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)



update t
set Neto_polisirana_premija=Premija
from #temp t


alter table #temp
drop column Premija

select top 100 *  from #temp


END
GO
/****** Object:  StoredProcedure [dbo].[gr_potrazivanje_klijent]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [gr_potrazivanje_klijent] '2024.07.31'
CREATE procedure [dbo].[gr_potrazivanje_klijent] (
--declare
@datum  varchar(10)='31.10.2022'
)as

BEGIN

IF OBJECT_ID('tempdb..#final') IS NOT NULL
drop table #final

select distinct
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_kundenkz,isnull(k.kun_kundenkz,'')) else /*PA*/ isnull(k.kun_kundenkz,isnull(k1.kun_kundenkz,''))  end [Ugovarac ID],
	k.kun_telefon_1												[Broj Telefona],
	k.kun_e_mail												[Mejl],
	vtg_pol_vkto												[VKTO],
	isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[Naziv Posrednika],
	m.ma_unterst_og												[Kanal Prodaje],
	b.bra_obnr													[Broj Polise],						
	v.vtg_antrag_obnr											[Broj Ponude],
	v.vtg_ivk_nr												[Broj Zelene Karte],
	b.bra_bran													[Bransa],
	b.bra_vv_ueb												[Vrsta osiguranja],
	vtg_zahlungsweise											[Nacin Placanja],
	(select sum(bra_bruttopraemie) from branche b2 where b2.bra_obnr=b.bra_obnr)   [Bruto_polisirana_premija],
	(select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum) [Uplacena_premija],
	cast(0 as decimal(18,2))									[Ukupno Potrazivanje],
--Iznos Potrazivanja
	isnull(cast(((select top 1 p.pko_wertedatumsaldo from praemienkonto p (nolock) where pko_wertedatum <= @Datum and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0) [Dospjelo Potrazivanje],
	cast(0 as decimal(18,2))									[<=30 tage],
	cast(0 as decimal(18,2))									[31-60 tage],
	cast(0 as decimal(18,2))									[61-90 tage],
	cast(0 as decimal(18,2))									[91-180 tage],
	cast(0 as decimal(18,2))									[181-270 tage],
	cast(0 as decimal(18,2))									[271-365 tage],
	cast(0 as decimal(18,2))									[365+ tage],
	cast(0 as decimal(18,2))									Obezvredjenje,
	bra_vers_beginn   											[Pocetak_osiguranja],
	bra_vers_ablauf   											[Istek_osiguranja],
	bra_storno_ab  												[Datum_storna],
	cast('' as vaRCHAR(400))									[StatusPolise],
	vtg_zahlungsweise											[Nacin_Placanja],
	bra_storno_grund											[Storno tip],
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))	[Neto_polisirana_premija],
	case when v.vtg_pol_bran=b.bra_bran then vtg_ivk_nr	 else 0 end		[ZelenaKarta],
	case when exists (select 1 from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK') then 
	case when (select COUNT(*) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and abs(pko_betraghaben)=20)=(select COUNT(*) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK') then 0 else (isnull((select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and abs(pko_betraghaben)=20),0)-(select sum(pko_betragsoll) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK')) end
	else 0 end													[SaldoZelenaKarta]
	into #final
from branche b (nolock)
join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid and b.bra_bran=v.vtg_pol_bran
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac



--------------Brisanje svih nepotrebnih polisa (optimizacija)----------------

delete from #final
where [Dospjelo Potrazivanje]=0 or [Dospjelo Potrazivanje] between 0.01 and 0.03 




------------------------------------Potrazivanje------------------------------

update t
set Obezvredjenje=
case  
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Neto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #final t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum > t.Datum_storna and t.[Broj Polise]=pk.pko_obnr and pko_betragsoll < 0 )),0)
	 else 0
end
from #final t



update t
set [Ukupno Potrazivanje]=Bruto_polisirana_premija-[Uplacena_premija]
from #final t


delete from #final
where [Ukupno Potrazivanje]=0


update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka' 
	 -- when @datumdo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem. 
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #final t


update t 
set Obezvredjenje=(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise] and pko_g_fall<>'SVOR')
from #final t
where StatusPolise='Prekid' and Nacin_Placanja not in (0,1)



update t

set Obezvredjenje=Obezvredjenje / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #final t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datum -- da se ne bi ponovo umanjila za porez



--- ovo je totalna steta. Izmijenjeno 11042023 jer 9 vise ne postoji i sad se koristi 2 a 9 vise nema sa ovom namjenom
update t
set Obezvredjenje=Neto_polisirana_premija
from #final t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)



-------------------------Kasnjenja-------------------------------------


--declare @polisa int

--IF OBJECT_ID('tempdb..#kasnjenja') IS NOT NULL 
--drop table #kasnjenja

--create table #kasnjenja
--(
--polisa			int,
--[<=30 tage]		decimal(18,2),
--[31-60 tage]	decimal(18,2),
--[61-90 tage]	decimal(18,2),
--[91-180 tage]	decimal(18,2),	
--[181-270 tage]	decimal(18,2),
--[271-365 tage]	decimal(18,2),
--[365+ tage]		decimal(18,2)
--)

--declare polisa_cursor CURSOR for 

--select distinct [Broj Polise] from #final where [Dospjelo Potrazivanje]<0

--OPEN polisa_cursor  
--FETCH NEXT FROM polisa_cursor INTO @Polisa
--WHILE @@FETCH_STATUS = 0  
--BEGIN  


--insert into #Kasnjenja
--exec Iznosi_kasnjenja_polisa @Datum,@polisa


--FETCH NEXT FROM polisa_cursor INTO @Polisa
--END
--CLOSE polisa_cursor  
--DEALLOCATE polisa_cursor 




--update f
--set [<=30 tage]=isnull((SELECT [<=30 tage] from #kasnjenja k where k.polisa=f.[Broj Polise])   ,0)	,
--[31-60 tage]=   isnull((SELECT [31-60 tage]   from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[61-90 tage]=   isnull((SELECT [61-90 tage]   from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[91-180 tage]=  isnull((SELECT [91-180 tage]  from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[181-270 tage]= isnull((SELECT [181-270 tage] from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[271-365 tage]= isnull((SELECT [271-365 tage] from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[365+ tage]=    isnull((SELECT [365+ tage]    from #kasnjenja k where k.polisa=f.[Broj Polise]),0)
--from #final f


--update #final
--set Obezvredjenje= 0*isnull([<=30 tage],0) + 0*isnull([31-60 tage],0) + 0*isnull([61-90 tage],0) + 0.25 * isnull([91-180 tage],0) + 0.5 * isnull([181-270 tage],0) +0.75 * isnull([271-365 tage],0) + 1 * isnull([365+ tage],0)



update #final
set [SaldoZelenaKarta]=0
where [ZelenaKarta]=0



select distinct
[Ugovarac ID],
[Ugovarac],
[Broj Telefona],
[Mejl],
sum([Bruto_polisirana_premija])[Bruto_polisirana_premija],
sum([Uplacena_premija])[Uplacena_premija],
sum([Ukupno Potrazivanje])[Ukupno Potrazivanje],
sum([Dospjelo Potrazivanje])[Dospjelo Potrazivanje],
sum([<=30 tage])[<=30 tage],
sum([31-60 tage])[31-60 tage],
sum([61-90 tage])[61-90 tage],
sum([91-180 tage])[91-180 tage],
sum([181-270 tage])[181-270 tage],
sum([271-365 tage])[271-365 tage],
sum([365+ tage])[365+ tage],
sum([Obezvredjenje])[Obezvredjenje],
sum([SaldoZelenaKarta])[SaldoZelenaKarta]
from #final
group by 
[Ugovarac ID],
[Ugovarac],
[Broj Telefona],
[Mejl]




end
GO
/****** Object:  StoredProcedure [dbo].[gr_potrazivanje_naplata]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [gr_potrazivanje_naplata] '2024.07.31'

CREATE procedure [dbo].[gr_potrazivanje_naplata] (
--declare
@datum varchar(10)
)as
BEGIN



IF OBJECT_ID('tempdb..#final') IS NOT NULL
drop table #final



select distinct
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end [Osiguranik],
	k.kun_telefon_1												[Broj Telefona],
	k.kun_e_mail												[Mejl],
	vtg_pol_vkto												[VKTO],
	isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[Naziv Posrednika],
	m.ma_unterst_og												[Kanal Prodaje],
	b.bra_obnr													[Broj Polise],						
	v.vtg_antrag_obnr											[Broj Ponude],
	v.vtg_ivk_nr												[Broj Zelene Karte],
	b.bra_bran													[Bransa],
	b.bra_vv_ueb												[Vrsta osiguranja],
	vtg_zahlungsweise											[Nacin Placanja],
	(select sum(bra_bruttopraemie) from branche b2 where b2.bra_obnr=b.bra_obnr)   [Bruto_polisirana_premija],
	(select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum) [Uplacena_premija],
	cast(0 as decimal(18,2))									[Ukupno Potrazivanje],
--Iznos Potrazivanja
	isnull(cast(((select top 1 p.pko_wertedatumsaldo from praemienkonto p (nolock) where pko_wertedatum <= @Datum and p.pko_obnr=b.bra_obnr order by pko_wertedatum desc,pko_buch_nr desc )) as decimal(18,2)),0) [Dospjelo Potrazivanje],
	cast(0 as decimal(18,2))									[<=30 tage],
	cast(0 as decimal(18,2))									[31-60 tage],
	cast(0 as decimal(18,2))									[61-90 tage],
	cast(0 as decimal(18,2))									[91-180 tage],
	cast(0 as decimal(18,2))									[181-270 tage],
	cast(0 as decimal(18,2))									[271-365 tage],
	cast(0 as decimal(18,2))									[365+ tage],
	cast(0 as decimal(18,2))									Obezvredjenje,
	bra_vers_beginn   											[Pocetak_osiguranja],
	bra_vers_ablauf   											[Istek_osiguranja],
	bra_storno_ab  												[Datum_storna],
	cast('' as vaRCHAR(400))									[StatusPolise],
	vtg_zahlungsweise											[Nacin_Placanja],
	bra_storno_grund											[Storno tip],
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))	[Neto_polisirana_premija],
	case when v.vtg_pol_bran=b.bra_bran then vtg_ivk_nr	 else 0 end		[ZelenaKarta],
	case when exists (select 1 from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK') then 
	case when (select COUNT(*) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and abs(pko_betraghaben)=20)=(select COUNT(*) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK') then 0 else (isnull((select sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and abs(pko_betraghaben)=20),0)-(select sum(pko_betragsoll) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum and pko_g_fall='IVK')) end
	else 0 end													[SaldoZelenaKarta]
	into #final
from branche b (nolock)
join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid and b.bra_bran=v.vtg_pol_bran
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik
where bra_vers_beginn < @datum




--------------Brisanje svih nepotrebnih polisa (optimizacija)----------------

delete from #final
where [Dospjelo Potrazivanje]=0 or [Dospjelo Potrazivanje] between 0.01 and 0.03



------------------------------------Potrazivanje------------------------------

update t
set Obezvredjenje=
case  
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') then Neto_polisirana_premija
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<=isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #final t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(pko_betragsoll)) from praemienkonto pk (nolock) where pko_wertedatum > t.Datum_storna and t.[Broj Polise]=pk.pko_obnr and pko_betragsoll < 0 )),0)
	 else 0
end
from #final t



update t
set [Ukupno Potrazivanje]=Bruto_polisirana_premija-[Uplacena_premija]
from #final t


delete from #final
where [Ukupno Potrazivanje]=0


update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka' 
	 -- when @datumdo>isnull([Datum_storna],'') then 0 then 0  --- ovo je problem. 
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #final t


update t 
set Obezvredjenje=(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise] and pko_g_fall<>'SVOR')
from #final t
where StatusPolise='Prekid' and Nacin_Placanja not in (0,1)



update t

set Obezvredjenje=Obezvredjenje / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #final t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datum -- da se ne bi ponovo umanjila za porez



--- ovo je totalna steta. Izmijenjeno 11042023 jer 9 vise ne postoji i sad se koristi 2 a 9 vise nema sa ovom namjenom
update t
set Obezvredjenje=Neto_polisirana_premija
from #final t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)



-------------------------Kasnjenja-------------------------------------


--declare @polisa int

--IF OBJECT_ID('tempdb..#kasnjenja') IS NOT NULL 
--drop table #kasnjenja

--create table #kasnjenja
--(
--polisa			int,
--[<=30 tage]		decimal(18,2),
--[31-60 tage]	decimal(18,2),
--[61-90 tage]	decimal(18,2),
--[91-180 tage]	decimal(18,2),	
--[181-270 tage]	decimal(18,2),
--[271-365 tage]	decimal(18,2),
--[365+ tage]		decimal(18,2)
--)

--declare polisa_cursor CURSOR for 

--select distinct [Broj Polise] from #final where [Dospjelo Potrazivanje]<0

--OPEN polisa_cursor  
--FETCH NEXT FROM polisa_cursor INTO @Polisa
--WHILE @@FETCH_STATUS = 0  
--BEGIN  


--insert into #Kasnjenja
--exec Iznosi_kasnjenja_polisa @Datum,@polisa


--FETCH NEXT FROM polisa_cursor INTO @Polisa
--END
--CLOSE polisa_cursor  
--DEALLOCATE polisa_cursor 




--update f
--set [<=30 tage]=isnull((SELECT [<=30 tage] from #kasnjenja k where k.polisa=f.[Broj Polise])   ,0)	,
--[31-60 tage]=   isnull((SELECT [31-60 tage]   from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[61-90 tage]=   isnull((SELECT [61-90 tage]   from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[91-180 tage]=  isnull((SELECT [91-180 tage]  from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[181-270 tage]= isnull((SELECT [181-270 tage] from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[271-365 tage]= isnull((SELECT [271-365 tage] from #kasnjenja k where k.polisa=f.[Broj Polise]),0),
--[365+ tage]=    isnull((SELECT [365+ tage]    from #kasnjenja k where k.polisa=f.[Broj Polise]),0)
--from #final f


--update #final
--set Obezvredjenje= 0*isnull([<=30 tage],0) + 0*isnull([31-60 tage],0) + 0*isnull([61-90 tage],0) + 0.25 * isnull([91-180 tage],0) + 0.5 * isnull([181-270 tage],0) +0.75 * isnull([271-365 tage],0) + 1 * isnull([365+ tage],0)



update #final
set [SaldoZelenaKarta]=0
where [ZelenaKarta]=0



select distinct
[Ugovarac],
[Osiguranik],
[Broj Telefona],
[Mejl],
[VKTO],
[Naziv Posrednika],
[Kanal Prodaje],
[Broj Polise],
[Broj Ponude],
[Bransa],
[Pocetak_osiguranja],
[Istek_osiguranja],
[Vrsta osiguranja],
[Nacin Placanja],
[Bruto_polisirana_premija],
[Uplacena_premija],
[Ukupno Potrazivanje],
[Dospjelo Potrazivanje],
[<=30 tage],
[31-60 tage],
[61-90 tage],
[91-180 tage],
[181-270 tage],
[271-365 tage],
[365+ tage],
Obezvredjenje,
[Broj Zelene Karte],
SaldoZelenaKarta
from #final



end
GO
/****** Object:  StoredProcedure [dbo].[gr_prijavljene_stete]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec gr_prijavljene_stete '2024.01.01', '2024.07.31'

CREATE PROCEDURE [dbo].[gr_prijavljene_stete](
--declare
@datumod  varchar(10),
@datumdo  varchar(10)
)AS

BEGIN



select 
CAST(scn_ident_bran as varchar)+'-'+CAST(scn_ident_pol_filiale as varchar)+'-'+ CAST(scn_ident_lfd_nr as varchar)+'-'+CAST(scn_ident_jahr as varchar) [Broj stete],
scn_ereignis_dt						[Datum Nastanka],
scn_anmelde_dt						[Datum prijave],
scn_gesamt_schaden - scn_zahlungen	[Rezervisani iznos],
scn_ptr_vte_obnr					[Broj Polise],
scn_schaden_vn						[Ugovarac]
from schaden (nolock)
where scn_anmelde_dt between @datumod and @datumdo


END
GO
/****** Object:  StoredProcedure [dbo].[gr_provjera_gresaka]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  exec gr_provjera_gresaka '2023.02.28'
CREATE procedure [dbo].[gr_provjera_gresaka] (
	@datum varchar(10)
	
	)as

BEGIN

create table #greske(
	id_greske int,
	polisa int,
	opis_greske varchar(300)
)

select distinct
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [Osiguranik],
	isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[Naziv Posrednika],
	m.ma_unterst_og												[Kanal Prodaje],
	b.bra_obnr													[Broj Polise],						
	v.vtg_antrag_obnr											[Broj Ponude],
	v.vtg_ivk_nr												[Broj Zelene Karte],
	b.bra_bran													[Bransa],
	bra_vers_beginn   											[Pocetak_osiguranja],
	bra_vers_ablauf   											[Istek_osiguranja],
	bra_storno_ab 												[Datum_storna],
	bra_storno_grund											[Storno tip],
	(select  sum(pko_betraghaben) from praemienkonto p (nolock) where p.pko_obnr=b.bra_obnr and pko_wertedatum <= @Datum) Uplacena_Premija,
	bra_bruttopraemie											[Bruto_premija],
	bra_nettopraemie1											[Neto_polisirana_premija],
	vtg_pol_kreis												[Pol_kreis],
	vtg_vae_fil													[Filijala],
	bra_statistik_nr											[Statisticki Broj],
	vtg_vae_vlauf												[Datum_vlauf],
	vtg_zahlungsweise,
	bra_vers_beginn  											[Pocetak_osiguranja],
	bra_vers_ablauf  											[Istek_osiguranja],
	bra_storno_ab												[Datum_storna]

into #temp
from branche b(nolock)
join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid and b.bra_bran=v.vtg_pol_bran
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik



-----------sve polise kojima je Uplacena_Premija>brutoPremija

insert into #greske
/*
select distinct 1,[Broj Polise],'Polisi je veca uplacena premija nego bruto premija'
from #temp
where cast(Uplacena_Premija as decimal(18,2))>(select sum(cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))) from branche b2 where b2.bra_obnr=#temp.[Broj Polise])
*/
SELECT DISTINCT 
1,
[Broj Polise],
'Polisi je veca uplacena premija nego bruto premija'
FROM #temp
WHERE (cast(Uplacena_Premija as decimal(18,2)) - (SELECT SUM(cast(replace(bra_bruttopraemie,',','.') as decimal(18,2))) FROM branche b2 WHERE b2.bra_obnr=#temp.[Broj Polise] )) - case when Bransa=10 then (select sum(cast(replace(pko_betraghaben,',','.') as decimal(18,2))) from praemienkonto pk (nolock) where pk.pko_obnr=Bransa and cast(replace(pko_betraghaben,',','.') as decimal(18,2))<>20) else 0 end> 0.1


----------Sve polise kojima je datum pocetka>datuma kraja

insert into #greske
select distinct 
2,
[Broj Polise],
'Polisi je stariji datum pocetka od datuma kraja'
from #temp
where [Pocetak_osiguranja]>[Istek_osiguranja]


----------Sve polise kojima je datum storna prazan

insert into #greske
select distinct 
3,
[Broj Polise],
'Datum storna ne smije biti prazan'
from #temp
where ISNULL(Datum_storna,'') = ''


--Bruto premija ne moze biti manja od neto premije

insert into #greske
select distinct 
4,
[Broj Polise],
'Bruto premija ne moze biti manja od neto premije'
from #temp
where [Neto_polisirana_premija] - [Bruto_premija] > 0.1


--Polise sa kreisom 98 ne smiju imati fakturisanu premiju

insert into #greske
select distinct 5,
[Broj Polise],
'Polise sa kreisom 98 i stornogrudom 67 ili 48 ne smiju imati fakturisanu premiju'
from #temp
where (select SUM(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from praemienkonto p (nolock) where p.pko_obnr=#temp.[Broj Polise]  and p.pko_g_fall<>'IVK')<>0 and Pol_kreis=98 and [Datum_vlauf] < '2023.01.01' and [Storno tip] in(67,48)


--Polise sa Kreisom 99 I 97 trebaju da imaju filijalu 0

insert into #greske
select distinct 
6,
[Broj Polise],
'Polise sa Kreisom 99 I 97 trebaju da imaju filijalu 0'
from #temp
where Pol_kreis in (97,99) and Filijala<>0


--Za sve branse osim 10, 11, 56 I 08 I ako je polisa sa Kreisom 98, onda njen statisticki broj pocinje sa 9, Sve ostalo nije ok.

insert into #greske
select distinct 
7,
[Broj Polise],
'Polise koje nisu u bransama 10,11,19,56 i 8 i sa Pol Kreisom 98, statisticki broj treba da pocinje sa 9'
from #temp
where Pol_kreis=98 and Bransa not in (10,11,19,56,8) and left(cast([Statisticki Broj] as varchar),1)<>'9'

/*
--Za sve branse osim 10, 11, 56 I 08 I ako je polisa sa Kreisom 99, onda njen statisticki broj pocinje sa 1 ili 2. Sve ostalo nije ok.

insert into #greske
select distinct 
8,
[Broj Polise],
'Polise koje nisu u bransama 10,11,56 i 8 i sa Pol Kreisom 98, onda njen statisticki broj pocinje sa 1 ili 2'
from #temp
where Pol_kreis=99 and Bransa not in (10,11,56,8) and left(cast([Statisticki Broj] as varchar),1) not in ('1','2')

*/

--Ako je datum storna jednak datumu pocetka, onda je storno grund 16

insert into #greske
select distinct 
9,
[Broj Polise],
'Ukoliko je datum storna jednak datumu pocetka, tip storna treba da je 16'
from #temp
where Datum_storna=[Pocetak_osiguranja] and [Storno tip]<>16 and Pol_kreis<>98 


--Ako je stornirana od pocetka (storno grund 16) onda ne smije imati fakturisanu premiju

insert into #greske
select distinct 
10,
[Broj Polise],
'Ako je stornirana od pocetka (storno grund 16) onda ne smije imati fakturisanu premiju'
from #temp
where [Storno tip]=16 and (select SUM(cast(replace(pko_betragsoll,',','.')as decimal(18,2))) from praemienkonto p (nolock) where p.pko_obnr=#temp.[Broj Polise])<>0



--Ukoliko je prekid (bra_vers_ablauf <>bra_storno_ab) vtg_zahlungsweise treba da bude 0 ili 1 (ako je 2,4 ili 6 treba da javi grešku).
insert into #greske
select distinct 
11,
[Broj Polise],
'Ukoliko je prekid (polisa), vtg_zahlungsweise treba da bude 0 ili 1'
from #temp
where Istek_osiguranja <> Datum_storna and vtg_zahlungsweise not in (0,1)




---------------FINAL
insert into gr_dnevne_greske
select id_greske,polisa,opis_greske,GETDATE() from #greske
order by polisa, id_greske asc

select id_greske,polisa,opis_greske from #greske
order by polisa, id_greske asc

END

GO
/****** Object:  StoredProcedure [dbo].[gr_rezervisane_stete]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec gr_rezervisane_stete 
CREATE PROCEDURE [dbo].[gr_rezervisane_stete]
AS
BEGIN



select distinct 
--
CAST(scn_ident_bran as varchar)+'-'+
CAST(scn_ident_pol_filiale as varchar)+'-'+ 
CAST(scn_ident_lfd_nr as varchar)+'-'+
CAST(scn_ident_jahr as varchar)							[Broj stete],
convert(varchar,scn_ereignis_dt,104)					[Datum Nastanka],
convert(varchar,scn_anmelde_dt,104)						[Datum prijave],
convert(varchar,scz_verbdatum,104)						[Datum likvidacije],
scz_betrag												[Iznos],
scn_gesamt_schaden										[Rezervisani iznos],
scn_ptr_vte_obnr										[Broj Polise],
scn_ident_bran											[Bransa],
scn_statistik_nr										[Statisticki broj],
ISNULL(scp_zuname,'') + ' ' + ISNULL(scp_vorname,'')	[Ostecenik],
cast('' as varchar (100))								[Proizvod],
case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
case when bra_bran not in (10,11,56,8) then isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,'')) else /*VA*/ isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,''))  end  [Osiguranik],
case when scn_stand = 0 then 'NIJE REAKTIVIRANA' when scn_stand = 4 then 'REAKTIVIRANA' else '' end [Reaktivirana],
scn_sb_vkto												VKTO,
ISNULL(ma_vorname,'') + ' ' + ISNULL(ma_zuname,'')      VKTO_naziv   
from schaden scn(nolock)
join schadenzahlung scz (nolock) on scn.scn_id=scz_schadenid
left join schadenperson scp (nolock) on scn.scn_id = scp.scp_schadenid and (scp_ku_rolle1 ='GS' or scp_ku_rolle2 ='GS' or scp_ku_rolle3 ='GS' or scp_ku_rolle4 ='GS' or scp_ku_rolle5 ='GS')
left join branche b (nolock) on scn_ptr_vte_obnr=bra_obnr
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik




END
GO
/****** Object:  StoredProcedure [dbo].[gr_sp_azuriranje_premije]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[gr_sp_azuriranje_premije] (
@datum varchar(10)=''
)
as

begin

IF OBJECT_ID('tempdb..#premija') IS NOT NULL
drop table #premija
	



	select 
	bra_obnr														[Broj Polise],
	convert(varchar,convert(date,bra_vers_beginn,104),102)			Pocetak_osiguranja,
	convert(varchar,convert(date,bra_vers_ablauf,104),102)			Istek_osiguranja,
	convert(varchar,convert(date,bra_storno_ab,104),102)			Datum_storna,
	cast('' as vaRCHAR(400))										StatusPolise,
	cast(replace(bra_bruttopraemie,',','.')	as decimal(18,2))		Bruto_polisirana_premija,
	cast(replace(bra_nettopraemie1,',','.')as decimal(18,2))		Neto_polisirana_premija,
	ISNULL(bp.porez,0)porez,
	bra_bran bransa,
	bra_storno_grund [Storno tip],
	cast (0 as decimal(18,2)) Premija
	into #premija
	from branche b
	left join brache_porezi bp on bp.branche_id=b.bra_bran
	where exists (select 1 from #final t where t.[Broj Polise]=bra_obnr)


	
update t
set Premija=
case  -- 1. Istekla or Aktivna; 2. Stornirana od pocetka; 3. Prekid; 4. OStalo
	 when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') or isnull([Datum_storna],'')>@datum then [Neto_polisirana_premija]
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 0  
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then isnull(ABS((select sum(Bruto_polisirana_premija) from #premija t2 where t2.[Broj Polise]=t.[Broj Polise])-
	 (select ABS(sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2)))) from praemienkonto pk (nolock) where convert(varchar,convert(date,pko_wertedatum,104),102)>=cast(t.Datum_storna as varchar) and t.[Broj Polise]=pk.pko_obnr and cast(replace(pko_betragsoll,',','.') as decimal(18,2))<0 )),0)
	 else 0
end
from #premija t

update t
set StatusPolise=
case when isnull([Datum_storna],'')=isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna' -- or isnull([Istek_osiguranja],'')>@datumdo  then 'Aktivna' 
	 when isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datum then 'Aktivna'
	 when isnull([Datum_storna],'')=isnull([Pocetak_osiguranja],'') then 'Stornirana od pocetka' 
	 when isnull([Datum_storna],'')>isnull([Pocetak_osiguranja],'') and isnull([Datum_storna],'')<isnull([Istek_osiguranja],'') then 'Prekid'
	 else 'Istekla' ---isnull([Datum_storna],'')=isnull([Istek_osiguranja],'')
end
from #premija t



update t 
set Premija=(select sum(cast(replace(pko_betragsoll,',','.') as decimal(18,2))) from praemienkonto pk(nolock) where pk.pko_obnr=t.[Broj Polise])
from #premija t
where StatusPolise='Prekid' -- and Nacin_Placanja not in (0,1)


--------- proporcionalno po bransama
update t

set Premija=case when (select sum(Bruto_polisirana_premija) from #premija t2 where t2.[Broj Polise]=t.[Broj Polise])=0 then 0 else  isnull((Premija*Bruto_polisirana_premija) /(select sum(Bruto_polisirana_premija) from #premija t2 where t2.[Broj Polise]=t.[Broj Polise]),0) end
from #premija t
where StatusPolise='Prekid' -- isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')>@datumdo -- prekid
and statuspolise<>'Stornirana od pocetka'



update t

set Premija=Premija / (1+(select porez from brache_porezi a where a.branche_id=t.Bransa))
from #premija t
where isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datum -- da se ne bi ponovo umanjila za porez
and Bransa<>19



update t

set Premija=Neto_polisirana_premija
from #premija t
where [Storno tip]=2 and Bransa=11 -- and Nacin_Placanja in (0,1)


update #final 
set [Bruto_polisirana_premija]= (select sum(Premija) from #premija p where #final.[Broj Polise]=p.[Broj Polise])

--select @datum,* from #premija

end
GO
/****** Object:  StoredProcedure [dbo].[Iznosi_kasnjenja_polisa]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [Iznosi_kasnjenja_polisa] '2023.12.19',9001024
CREATE PROCEDURE [dbo].[Iznosi_kasnjenja_polisa] (
--declare
@DatumIzvjestaja  varchar(10)='30.09.2022',
@Polisa			 varchar(20)=91012649
)aS


BEGIN



CREATE TABLE #Izuzetci (
    Polisa INT,
    Dani_Kasnjenja INT
);


INSERT INTO #Izuzetci (Polisa, Dani_Kasnjenja)
VALUES
(1399536, 2063),
(1399538, 0),
(1399539, 0),
(1399556, 1359),
(1399601, 2116),
(1399604, 2116),
(1399609, 1880),
(1399676, 960),
(1399717, 0),
(1399718, 0),
(1399824, 606),
(1399839, 0),
(1399916, 404),
(1399918, 344),
(1399920, 428),
(1399921, 381),
(7199128, 386),
(7199129, 488),
(7199130, 428),
(7199131, 516),
(7199132, 367),
(7199133, 425),
(7199134, 367),
(8699805, 344),
(8699806, 385),
(8699807, 183),
(8699808, 548),
(9900017, 509),
(9900021, 567),
(9900027, 212),
(9900083, 372),
(9900105, 382),
(9900109, 360),
(9900124, 716),
(9900136, 253),
(9900137, 31),
(9900180, 94),
(9900181, 94),
(9900196, 71),
(9900200, 326),
(9900201, 38),
(9900202, 453),
(9900203, 365),
(9900204, 599),
(9900205, 892),
(9900206, 422),
(9900207, 253),
(9900208, 872),
(9900209, 905),
(9900210, 419),
(9900211, 395),
(9900212, 1295),
(9900214, 617),
(9900215, 974),
(9900216, 671),
(9900217, 234),
(9900220, 529),
(9900221, 567),
(9900222, 343),
(9900223, 398),
(9900227, 442),
(9900228, 187),
(9900229, 261),
(9900231, 244),
(9900233, 333),
(9900234, 512),
(9900235, 150),
(90114240, 1397),
(90148293, 950),
(90148294, 950),
(90148295, 950),
(90167215, 514),
(90172334, 710),
(90176637, 375),
(90176638, 374),
(90180847, 471),
(90180867, 520),
(90181802, 498),
(90187372, 372),
(90188632, 416),
(90195191, 487),
(90196509, 462),
(90196547, 412),
(90198796, 424),
(90201596, 404),
(90204657, 389),
(90205168, 379),
(98008230, 1430),
(98008616, 1415),
(98008971, 1417),
(98009020, 1402),
(98009075, 1380),
(98009564, 996),
(98010268, 1052),
(98010675, 943),
(98010801, 270),
(98010830, 880),
(98011081, 819),
(98011149, 534),
(98011361, 571),
(98011397, 744),
(98011528, 684),
(98011576, 475),
(98011577, 475),
(98011715, 312),
(98012123, 241),
(98012124, 241),
(98012125, 271),
(98012126, 271),
(98012151, 319),
(98012236, 511),
(98012243, 549),
(98012303, 527),
(98012367, 512),
(98012479, 474),
(98012519, 440),
(98012547, 463),
(98012619, 326),
(98012690, 122),
(98012759, 354),
(98012780, 381),
(98012819, 403);


declare @UkupnoDospjelo decimal(18,2),
@ukupnoUplaceno		    decimal(18,2),
@trenutnaObaveza				decimal(18,2),
@TrenutniDatum					datetime,
@PrethodniDatum					datetime,
@DatumPocetkaKasnjenja			datetime,
@temp1  int=0,
@temp2  decimal(18,2),
@temp3	int=0


IF OBJECT_ID('tempdb..#kasnjenjeTemp') IS NOT NULL
drop table #kasnjenjeTemp
create table #kasnjenjeTemp(

polisa int,
datum varchar(10),
danikasnjenja int,
iznos decimal(18,2)
)



set @ukupnoUplaceno=isnull((select sum(pko_betraghaben) from praemienkonto (nolock)
where pko_obnr=@Polisa  and pko_wertedatum <= @DatumIzvjestaja) ,0) 

set @UkupnoDospjelo=isnull((select sum(pko_betragsoll) from praemienkonto (nolock)
where pko_obnr=@Polisa  and pko_wertedatum <= @DatumIzvjestaja) ,0)


DECLARE db_cursor CURSOR FOR

select * from(
select sum(pko_betragsoll) iznos,pko_wertedatum from praemienkonto
where pko_wertedatum <= @DatumIzvjestaja and pko_obnr=@Polisa and pko_betragsoll<>0
group by pko_wertedatum
)a 
order by convert(date,pko_wertedatum ,104) asc 


OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @trenutnaObaveza,@TrenutniDatum

WHILE @@FETCH_STATUS = 0  
BEGIN  
	


	if(@ukupnoUplaceno-@trenutnaObaveza>=0)
	begin
	set @ukupnoUplaceno=@ukupnoUplaceno-@trenutnaObaveza
	set @UkupnoDospjelo=@UkupnoDospjelo-@trenutnaObaveza
	set @DatumPocetkaKasnjenja=isnull(@TrenutniDatum,'')
	end

	else
	begin
		set @DatumPocetkaKasnjenja=isnull(@TrenutniDatum,'')
	break
	end


	FETCH NEXT FROM db_cursor INTO @trenutnaObaveza,@TrenutniDatum
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 



set @PrethodniDatum=NULL

if @UkupnoDospjelo=0 
begin

select @polisa,cast(0 as decimal(18,2)),cast(0 as decimal(18,2)),cast(0 as decimal(18,2)),cast(0 as decimal(18,2)),cast(0 as decimal(18,2)),cast(0 as decimal(18,2)),cast(0 as decimal(18,2)),0
return

end

else
begin


--Da li je nacin placanja na rate ili odjednom. Dodato 6,2,4 po GR-60
if (select vtg_zahlungsweise from vertrag where vtg_obnr=@polisa) in (0,1,2,4)
begin

set @temp1=case when @polisa in (select polisa from #Izuzetci) then DATEDIFF(DD,'2023.01.01',@DatumIzvjestaja) + (select Dani_kasnjenja from #Izuzetci where polisa=@Polisa) else DATEDIFF(DD,@DatumPocetkaKasnjenja,@DatumIzvjestaja) end


--select @polisa,@temp1

select
@polisa,
case when @temp1<=30				 then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [<=30 tage],
case when @temp1 between 31 and 60	 then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [31-60 tage], 
case when @temp1 between 61 and 90	 then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [61-90 tage],
case when @temp1 between 91 and 180  then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [91-180 tage],
case when @temp1 between 181 and 270 then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [181-270 tage],
case when @temp1 between 271 and 365 then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [271-365 tage],
case when @temp1 >365				 then isnull((select top 1 p.pko_wertedatumsaldo  from praemienkonto p (nolock) where pko_wertedatum <= @datumIzvjestaja and p.pko_obnr=@Polisa order by pko_wertedatum desc,pko_buch_nr desc ),0)   else 0 end [365+ tage],
@temp1

return

end

else

begin



DECLARE db_cursor CURSOR FOR

select * from(
select pk.pko_wertedatum
from praemienkonto pk
where pko_wertedatum <= @DatumIzvjestaja and pko_wertedatum >= @DatumPocetkaKasnjenja 
and pko_obnr=@Polisa and  pko_betragsoll<>0
)a 
order by pko_wertedatum desc


OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @TrenutniDatum


WHILE @@FETCH_STATUS = 0  
BEGIN  
	
	

	set @temp1=@temp1+DATEDIFF(DD,@TrenutniDatum,isnull(@PrethodniDatum,@DatumIzvjestaja))
	set @temp2=cast((
	select top 1 sum(pko_betragsoll)
	from praemienkonto
	where pko_obnr=@Polisa and pko_wertedatum >= @TrenutniDatum
	group by pko_wertedatum
	order by pko_wertedatum asc
	)as decimal(18,2))*-1 --+ isnull(cast((select sum(cast(replace(pko_betragsoll,',','.')	as decimal(18,2))) from praemienkonto where pko_obnr=@Polisa and convert(date,pko_wertedatum,104)>=convert(date,@TrenutniDatum,104)) as decimal(18,2)),0)
	

	insert into #kasnjenjeTemp
	select @polisa,@TrenutniDatum,@temp1,@temp2
	--select DATEDIFF(@TrenutniDatum,@PrethodniDatum)
	set @PrethodniDatum=@TrenutniDatum


	set @temp2=0

	FETCH NEXT FROM db_cursor INTO @TrenutniDatum
END 



CLOSE db_cursor  
DEALLOCATE db_cursor 


--select * from #kasnjenjeTemp

--select @ukupnoUplaceno

update #kasnjenjeTemp
set iznos=iznos+@ukupnoUplaceno
where datum=(select min(datum) from #kasnjenjeTemp) 




--select @ukupnoUplaceno

select 
@polisa Polisa,
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja <=30),0)					[<=30 tage],
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja between 31 and 60),0)	[31-60 tage],
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja between 61 and 90),0)	[61-90 tage],
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja between 91 and 180),0)	[91-180 tage],
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja between 181 and 270),0)	[181-270 tage],
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja between 271 and 365),0)	[271-365 tage],
isnull((select sum(iznos) from #kasnjenjeTemp where  danikasnjenja >365),0)					[365+ tage],
isnull((select max(danikasnjenja) from #kasnjenjeTemp ),0)	        danikasnjenja

end

end




END
GO
/****** Object:  StoredProcedure [dbo].[sp_bruto_polisirana_premija]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_bruto_polisirana_premija]
(
    @datum datetime='2024.09.30',
	@po_bransama int
) as
BEGIN


	IF OBJECT_ID('tempdb..#final') IS NOT NULL
	DROP TABLE #final

    -- Create table to store final results
    CREATE TABLE #final (
        polisa int,
        bransa int,
        Bruto_polisirana_premija decimal(18,2)
    );

	
	IF OBJECT_ID('tempdb..#PolicyData') IS NOT NULL
	DROP TABLE #PolicyData

    -- Create temp table for policy data
    CREATE TABLE #PolicyData (
        polisa int,
        bransa int,
        Pocetak_osiguranja datetime,
        Istek_osiguranja datetime,
        Datum_storna datetime,
        storno_kt_prozent decimal(18,2),
        nettopraemie decimal(18,2),
        vst_prozent decimal(18,2),
        bruttopraemie decimal(18,2),
        stornoTip int,
        vtg_pol_bran int,
        Bruto_polisirana_premija decimal(18,2),
        Neto_polisirana_premija decimal(18,2),
        porez decimal(18,2)
    );

    -- Fill policy data temp table
    INSERT INTO #PolicyData
    SELECT DISTINCT
        b.bra_obnr,
        b.bra_bran,
        b.bra_vers_beginn,
        b.bra_vers_ablauf,
        b.bra_storno_ab,
        b.bra_storno_kt_prozent,
        b.bra_nettopraemie1,
        b.bra_vst_prozent,
        b.bra_bruttopraemie,
        b.bra_storno_grund,
        vtg.vtg_pol_bran,
        CASE 
            WHEN vtg.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
            THEN b.bra_storno_kt_prozent/100 * 
                CASE 
                    WHEN (b.bra_vers_beginn BETWEEN '2022.01.01' AND '2022.12.31') 
                    THEN b.bra_nettopraemie1 * (ISNULL((1 + b.bra_vst_prozent/100), 0)) 
                    ELSE b.bra_bruttopraemie 
                END
            ELSE b.bra_bruttopraemie
        END,
        CASE 
            WHEN vtg.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
            THEN b.bra_storno_kt_prozent * b.bra_nettopraemie1
            ELSE b.bra_nettopraemie1 
        END,
        ISNULL((1 + b.bra_vst_prozent/100), 0)
    FROM branche b
    INNER JOIN #temp t ON b.bra_obnr = t.polisa
    INNER JOIN vertrag vtg ON b.bra_obnr = vtg.vtg_obnr;

    -- Insert initial calculations
    INSERT INTO #final
    SELECT DISTINCT
        pd.polisa,
        pd.bransa,
        CASE
            -- Basic premium calculation
            WHEN ISNULL(pd.Datum_storna,'') = ISNULL(pd.Istek_osiguranja,'') 
                OR ISNULL(pd.Datum_storna,'') > @datum 
            THEN pd.Bruto_polisirana_premija

            WHEN ISNULL(pd.Datum_storna,'') = ISNULL(pd.Pocetak_osiguranja,'') 
            THEN 0

            WHEN ISNULL(pd.Datum_storna,'') > ISNULL(pd.Pocetak_osiguranja,'') 
                AND ISNULL(pd.Datum_storna,'') < ISNULL(pd.Istek_osiguranja,'') 
            THEN 
                CASE
                    WHEN (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = pd.polisa) = 0 
                    THEN 0
                    ELSE ISNULL(
                        ((SELECT SUM(pko_betragsoll) FROM praemienkonto pk WHERE pk.pko_obnr = pd.polisa) 
                        * pd.Bruto_polisirana_premija) 
                        / (SELECT SUM(bra_bruttopraemie) FROM branche t2 WHERE t2.bra_obnr = pd.polisa),
                        0
                    )
                END
            ELSE 0
        END as calculated_premium
    FROM #PolicyData pd;

    -- Special case adjustments
    UPDATE r
    SET Bruto_polisirana_premija = 
        CASE
            -- Special handling for storno type 2 and bransa 11
            WHEN pd.stornoTip = 2 AND pd.bransa = 11 
            THEN pd.Neto_polisirana_premija

            -- Special handling for bransa 78,79
            WHEN pd.bransa IN (78,79) 
            THEN pd.Bruto_polisirana_premija * 
                CAST(CEILING(CAST(DATEDIFF(day, pd.Pocetak_osiguranja, @datum) AS decimal(18,2))/365) AS int)

            -- Special handling for 2022 policies with bransa 10
            WHEN pd.Pocetak_osiguranja BETWEEN '2022.01.01' AND '2022.12.31' 
                AND pd.bransa = 10 
                AND (SELECT SUM(pko_betragsoll) 
                     FROM praemienkonto pk 
                     WHERE pko_wertedatum <= @datum 
                     AND pd.polisa = pk.pko_obnr) > pd.Bruto_polisirana_premija
            THEN (SELECT SUM(pko_betragsoll) 
                  FROM praemienkonto pk 
                  WHERE pko_wertedatum <= @datum 
                  AND pd.polisa = pk.pko_obnr)

            ELSE r.Bruto_polisirana_premija
        END
    FROM #final r
    INNER JOIN #PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa;

    -- Return final results
    --SELECT 
    --    SUM(r.Bruto_polisirana_premija) as Bruto_Polisirana_Premija
    --FROM #temp t
    --LEFT JOIN #final r ON t.polisa = r.polisa
    --GROUP BY t.polisa;

	--update #temp
	--set Bruto_Polisirana_Premija =  
	--(SELECT  
	--		SUM(f.Bruto_polisirana_premija) 
	--from #final f 
	--where f.polisa=#temp.polisa and 1=case when @po_bransama=1 then case when f.bransa=#temp.bransa then 1 else 0 end else 1 end
	--group by f.polisa


	if (@po_bransama = 1)
		begin

			update #temp
			set Bruto_Polisirana_Premija =  
			(select SUM(Bruto_polisirana_premija) from #final f where #temp.polisa=f.polisa and f.bransa=#temp.bransa)

		end
	else 
		begin

			update #temp
			set Bruto_Polisirana_Premija =  
			(select SUM(Bruto_polisirana_premija) from #final f where #temp.polisa=f.polisa )

		end


    -- Cleanup
    DROP TABLE #final;
    DROP TABLE #PolicyData;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_gr_provizije]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  exec sp_gr_provizije '2024.07.01','2024.07.31', ''

CREATE PROCEDURE [dbo].[sp_gr_provizije] 
(--declare 
		@datumod  varchar(10),
		@datumdo  varchar(10),
		@Polisa int
)AS




if OBJECT_ID('tempdb..#final') is not null
drop table #final


select distinct
	bra_bran					[Bransa],
	cast('' as varchar(2000))   [Komentar],
	b.bra_obnr					[Broj Polise],
	vtg_antrag_obnr				[Broj Ponude],
	bra_statistik_nr			[Statisticki_broj],
	bra_vers_beginn   			[Pocetak_osiguranja],
	bra_vers_ablauf   			[Istek_osiguranja],
	@DatumDo					[Datum obracuna provizije],
	(select sum(pko_betraghaben) from praemienkonto (nolock) where pko_obnr=b.bra_obnr and pko_wertedatum between @DatumOd and @Datumdo)   [Naplacena neto premija],
	isnull(k3.VKTO_	,vtg_pol_vkto)						[Sifra zastupnika], 
	isnull(ma_vorname,'')+ ' ' + isnull(ma_zuname,'')	[Naziv zastupnika],
	case when bra_bran not in (10,11,56,8) then isnull(k1.kun_zuname,isnull(k.kun_zuname,'')) + ' ' + isnull(k1.kun_vorname,isnull(k.kun_vorname,'')) else /*PA*/ isnull(k.kun_zuname,isnull(k1.kun_zuname,'')) + ' ' + isnull(k.kun_vorname,isnull(k1.kun_vorname,''))  end [Ugovarac],
	vtg_zahlungsweise			[Nacin_Placanja],
	cast(0 as int)				[Dani Kasnjenja],
	case when isnull((select sum(bra_bruttopraemie) from branche b2 (nolock) where b2.bra_obnr=b.bra_obnr),0)=0 then 0 else
	cast(bra_bruttopraemie/(select sum(bra_bruttopraemie) from branche b2 (nolock) where b2.bra_obnr=b.bra_obnr) as decimal(18,2)) end	[Procenat Udjela],
	case when bra_bran in (7,8,9,48,19) then 1 else 1.09 end Porez,
	case when convert(varchar,convert(date,bra_vers_beginn,104),102)>='2023.01.01' and bra_bran=19 then vtg_antrag_obnr
		 when convert(varchar,convert(date,bra_vers_beginn,104),102)<'2023.01.01' and bra_bran<>19 then 
				case when v.vtg_pol_bran=b.bra_bran then vtg_ivk_nr	 else 0 end
		 else 0 end  [ZelenaKarta]--,
	--isnull(k3.VKTO_,0)							[Sifra zastupnika1],
	--ISNULL(vtg_pol_vkto,0)						[Sifra zastupnika2]

	into #final
from branche b(nolock)
left join vertrag v (nolock) on b.bra_vertragid=v.vtg_vertragid
left join mitarbeiter m (nolock) on vtg_pol_vkto=ma_vkto
left join kunde k (nolock) on k.kun_kundenkz=v.vtg_kundenkz_1
left join kunde k1 (nolock) on k1.kun_kundenkz=v.vtg_kundenkz_2
left join vertrag_kunde vk(nolock) on vk.vtk_obnr=b.bra_obnr and vk.vtk_kundenkz=k.kun_kundenkz and vk.vtk_kundenrolle='PA'  --Ugovarac
left join vertrag_kunde vk1(nolock) on vk.vtk_obnr=b.bra_obnr and vk1.vtk_kundenkz=k1.kun_kundenkz and vk.vtk_kundenrolle='VN' --Osiguranik
left join K3StrictEvidenceExport575 k3(nolock) on k3.Nummer=case when bra_bran=19 then vtg_antrag_obnr when bra_bran=10 and vtg_ivk_nr<>0 then vtg_ivk_nr else 0 end
where bra_obnr=@Polisa




--------------------Izmjena zbog zelene karte--------------------


if OBJECT_ID('tempdb..#ZeleneKarte') is not null
drop table #ZeleneKarte

select * into #ZeleneKarte from #final
where ZelenaKarta<>0

--update #final
--set [Sifra zastupnika]=case when Bransa=19 then [Sifra zastupnika1]
--							when Bransa=10 and ZelenaKarta<>0 then ()
--							else 
--						end


--update #final
--set [Sifra zastupnika]=case when ZelenaKarta=0 then [Sifra zastupnika2] else [Sifra zastupnika1] end


update #final
set [Naplacena neto premija]=(select isnull(sum(pko_betraghaben),0) from praemienkonto (nolock) where pko_obnr=#final.[Broj Polise] and pko_betraghaben <> 20 and pko_wertedatum between @DatumOd and @Datumdo)
where ZelenaKarta<>0


update #ZeleneKarte
set [Naplacena neto premija]=(select isnull(sum(pko_betraghaben),0) from praemienkonto (nolock) where pko_obnr=#ZeleneKarte.[Broj Polise] and pko_betraghaben = 20 and pko_wertedatum between @DatumOd and @Datumdo)


insert into #final
select * from #ZeleneKarte



--ALTER TABLE #final
--drop column [Sifra zastupnika1]

--ALTER TABLE #final
--drop column [Sifra zastupnika2]

-------------------------------------------------------------------


update f
set [Naplacena neto premija]=[Naplacena neto premija]*[Procenat Udjela]/Porez
from #final f
where ZelenaKarta=0

--Da li ovo treba?
delete from #final
where isnull([Naplacena neto premija],0)=0

if OBJECT_ID('tempdb..#Kasnjenja') is not null
drop table #Kasnjenja

create table #Kasnjenja
(
polisa int,
DaniKasnjenja int
)



DECLARE polise CURSOR FOR

select distinct [Broj Polise] from #final


OPEN polise  
FETCH NEXT FROM polise INTO @Polisa


WHILE @@FETCH_STATUS = 0  
BEGIN  
	

	insert into #Kasnjenja
	exec Dani_kasnjenja_polisa @Datumdo,@Polisa

	FETCH NEXT FROM polise INTO @Polisa
END 

CLOSE polise  
DEALLOCATE polise 

update f
set [Dani Kasnjenja]=isnull((select DaniKasnjenja from #Kasnjenja where #Kasnjenja.polisa=f.[Broj Polise]),0)
from #final f

select distinct * from #final
GO
/****** Object:  StoredProcedure [dbo].[sp_premije_iznosi]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Za execute ove procedure, mora da je napravljena tabela #temp sa minimum sledecim kolonama:
--      polisa int,
--      bransa int,
--      Statisticki_broj int,
--      Bruto_polisirana_premija decimal(18,2),
--	    Neto_polisirana_premija decimal(18,2)

--Drugi parametar je opcioni parametar, po bransama, da li zelis update po bransama i statistickom broju, ili sumarno za polisu
CREATE PROCEDURE [dbo].[sp_premije_iznosi]
(
    @datum datetime='2024.09.30',
	@po_bransama int=0
) as
BEGIN

	IF NOT EXISTS (Select 1 
           from tempdb.sys.columns 
           where [object_id] = object_id('tempdb..#temp') 
             and name ='Statisticki_broj')
	BEGIN

		ALTER TABLE #TEMP
		ADD Statisticki_broj int

	END


	IF OBJECT_ID('tempdb..#finalPremije') IS NOT NULL
	DROP TABLE #finalPremije


    CREATE TABLE #finalPremije (
        polisa int,
        bransa int,
		statisticki_broj int,
        Bruto_polisirana_premija decimal(18,2),
		Neto_polisirana_premija decimal(18,2)
    );

	
	IF OBJECT_ID('tempdb..#PolicyData') IS NOT NULL
	DROP TABLE #PolicyData

    CREATE TABLE #PolicyData (
        polisa int,
        bransa int,
        Pocetak_osiguranja datetime,
        Istek_osiguranja datetime,
        Datum_storna datetime,
        storno_kt_prozent decimal(18,2),
        nettopraemie decimal(18,2),
        vst_prozent decimal(18,2),
		statistik_nr int,
        bruttopraemie decimal(18,2),
        stornoTip int,
        vtg_pol_bran int,
        Bruto_polisirana_premija decimal(18,2),
        Neto_polisirana_premija decimal(18,2),
        porez decimal(18,2)
    );



    INSERT INTO #PolicyData
    SELECT DISTINCT
        b.bra_obnr,
        b.bra_bran,
        b.bra_vers_beginn,
        b.bra_vers_ablauf,
        b.bra_storno_ab,
        b.bra_storno_kt_prozent,
        b.bra_nettopraemie1,
        b.bra_vst_prozent,
		b.bra_statistik_nr,
        b.bra_bruttopraemie,
        b.bra_storno_grund,
        vtg.vtg_pol_bran,
		--Za bransu 11 u godini 2022 (posebni slucajevi)
        CASE 
            WHEN vtg.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365		
            THEN b.bra_storno_kt_prozent/100 * 
                CASE 
                    WHEN (b.bra_vers_beginn BETWEEN '2022.01.01' AND '2022.12.31')			
                    THEN b.bra_nettopraemie1 * (ISNULL((1 + b.bra_vst_prozent/100), 0)) 
                    ELSE b.bra_bruttopraemie 
                END
            ELSE b.bra_bruttopraemie
        END,
        CASE 
            WHEN vtg.vtg_pol_bran = 11 AND DATEDIFF(day, b.bra_vers_beginn, b.bra_vers_ablauf) < 365
            THEN b.bra_storno_kt_prozent/100 * b.bra_nettopraemie1 --- dodato /100
            ELSE b.bra_nettopraemie1 
        END,
        ISNULL((1 + b.bra_vst_prozent/100), 0) porez
    FROM branche b
    INNER JOIN #temp t ON b.bra_obnr = t.polisa
    INNER JOIN vertrag vtg ON b.bra_obnr = vtg.vtg_obnr;


    -- Initial calculations --- 
    INSERT INTO #finalPremije
    SELECT DISTINCT
        pd.polisa,
        pd.bransa,
		pd.statistik_nr,
        CASE
            -- Aktivna
            WHEN ISNULL(pd.Datum_storna,'') = ISNULL(pd.Istek_osiguranja,'') 
                OR ISNULL(pd.Datum_storna,'') > @datum 
            THEN pd.Bruto_polisirana_premija
			-- Istekla
            WHEN ISNULL(pd.Datum_storna,'') = ISNULL(pd.Pocetak_osiguranja,'') 
            THEN 0
			-- Prekid
            WHEN ISNULL(pd.Datum_storna,'') > ISNULL(pd.Pocetak_osiguranja,'') 
                AND ISNULL(pd.Datum_storna,'') < ISNULL(pd.Istek_osiguranja,'') 
            THEN 
				case when (select sum(bra_bruttopraemie) from branche t2 where t2.bra_obnr=pd.polisa)=0 then 0 else (select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=pd.polisa and pko_g_fall<>'SVOR') end
            ELSE 0
        END Bruto_polisirana_premija,


		CASE
		    -- Aktivna
            WHEN ISNULL(pd.Datum_storna,'') = ISNULL(pd.Istek_osiguranja,'') 
                OR ISNULL(pd.Datum_storna,'') > @datum 
            THEN pd.Neto_polisirana_premija
			-- Istekla
            WHEN ISNULL(pd.Datum_storna,'') = ISNULL(pd.Pocetak_osiguranja,'') 
            THEN 0
			-- Prekid
            WHEN ISNULL(pd.Datum_storna,'') > ISNULL(pd.Pocetak_osiguranja,'') 
                AND ISNULL(pd.Datum_storna,'') < ISNULL(pd.Istek_osiguranja,'') 
            THEN 
				(select sum(pko_betragsoll) from praemienkonto pk(nolock) where pk.pko_obnr=pd.Polisa) / porez 
            ELSE 0 
		END Neto_polisirana_premija
    FROM #PolicyData pd;


	-- Za Polise u prekidu, Po bransama rasporediti iznose
	UPDATE r
    SET Neto_polisirana_premija = 
	case when (select sum(Neto_polisirana_premija) from #PolicyData t2 where t2.polisa=pd.polisa)=0 then 0  
	else  isnull((r.Neto_polisirana_premija*pd.Bruto_polisirana_premija) /(select sum(Bruto_polisirana_premija) from #PolicyData t where t.polisa=pd.polisa),0) end
    FROM #finalPremije r
    INNER JOIN #PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa AND r.statisticki_broj=pd.statistik_nr
	WHERE ISNULL(pd.Datum_storna,'') > ISNULL(pd.Pocetak_osiguranja,'') 
    AND ISNULL(pd.Datum_storna,'') < ISNULL(pd.Istek_osiguranja,'') AND NOT (
	ISNULL(pd.Datum_storna,'') = ISNULL(pd.Istek_osiguranja,'') 
    OR ISNULL(pd.Datum_storna,'') > @datum)


	--Ostali slucajevi (Kas je storno 2 i bransa 11, i kad je bransa 19 i u prekidu)
	UPDATE r
    SET Neto_polisirana_premija = 
        CASE
            WHEN pd.stornoTip = 2 AND pd.bransa = 11 
            THEN pd.Neto_polisirana_premija

			WHEN isnull([Datum_storna],'')<>isnull([Istek_osiguranja],'') and isnull([Datum_storna],'')<@datum and pd.Bransa<>19 AND 
			     ISNULL(pd.Datum_storna,'') <= ISNULL(pd.Pocetak_osiguranja,'') AND ISNULL(pd.Datum_storna,'') >= ISNULL(pd.Istek_osiguranja,'')  -- Ukoliko nije u prekidu (jer smo vec smanjili porez za te polise u inicijalnim kalkulacijama)
			THEN r.Neto_polisirana_premija/porez		

            ELSE r.Neto_polisirana_premija
        END
    FROM #finalPremije r
    INNER JOIN #PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa and statisticki_broj=statistik_nr;



    -- Special case adjustments
    UPDATE r
    SET Bruto_polisirana_premija = 
        CASE
   
            WHEN pd.stornoTip = 2 AND pd.bransa = 11 
            THEN pd.Neto_polisirana_premija

            WHEN pd.bransa IN (78,79)		
            THEN pd.Bruto_polisirana_premija * 
                CAST(CEILING(CAST(DATEDIFF(day, pd.Pocetak_osiguranja, @datum) AS decimal(18,2))/365) AS int)

            ELSE r.Bruto_polisirana_premija
        END
    FROM #finalPremije r
    INNER JOIN #PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa and statisticki_broj=statistik_nr;



	-- Za Polise u prekidu, po bransama rasporediti iznose
	UPDATE r
    SET Bruto_polisirana_premija = 
	case when (select sum(Bruto_polisirana_premija) from #PolicyData t2 where t2.polisa=pd.polisa)=0 then 0  
	else  isnull((r.Bruto_polisirana_premija*pd.Bruto_polisirana_premija) /(select sum(Bruto_polisirana_premija) from #PolicyData t where t.polisa=pd.polisa),0) end
    FROM #finalPremije r
    INNER JOIN #PolicyData pd ON r.polisa = pd.polisa AND r.bransa = pd.bransa  and statisticki_broj=statistik_nr
	WHERE (ISNULL(pd.Datum_storna,'') > ISNULL(pd.Pocetak_osiguranja,'') 
    AND ISNULL(pd.Datum_storna,'') < ISNULL(pd.Istek_osiguranja,'')) AND NOT (
	ISNULL(pd.Datum_storna,'') = ISNULL(pd.Istek_osiguranja,'') 
    OR ISNULL(pd.Datum_storna,'') > @datum)


	if (@po_bransama = 1)
		begin

			update #temp
			set Bruto_Polisirana_Premija =  
			(select max(Bruto_polisirana_premija) from #finalPremije b where #temp.polisa=b.polisa and b.bransa=#temp.bransa  and b.statisticki_broj=#temp.statisticki_broj)

			update #temp
			set Neto_Polisirana_Premija =  
			(select max(Neto_Polisirana_Premija) from #finalPremije f where #temp.polisa=f.polisa and f.bransa=#temp.bransa  and f.statisticki_broj=#temp.statisticki_broj)

		end
	else 
		begin

			update #temp
			set Neto_Polisirana_Premija =  
			(select SUM(Neto_Polisirana_Premija) from #finalPremije f where #temp.polisa=f.polisa )

			update #temp
			set Bruto_Polisirana_Premija =  
			(select SUM(Bruto_polisirana_premija) from #finalPremije f where #temp.polisa=f.polisa )

		end


    -- Cleanup
    DROP TABLE #finalPremije;
    DROP TABLE #PolicyData;
END
GO
/****** Object:  StoredProcedure [dbo].[test]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec gr_rezervisane_stete 
CREATE PROCEDURE [dbo].[test]
(
@datum datetime
)
AS
BEGIN


select @datum as datum

END
GO
/****** Object:  StoredProcedure [dbo].[test_10_sec]    Script Date: 3/5/2025 3:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[test_10_sec] 
(
@TEST INT
)
AS
BEGIN


DECLARE @StartTime DATETIME = GETDATE()

-- The main delay
WAITFOR DELAY '00:00:20'  -- Format is 'hh:mm:ss'

-- Optional: Return the actual elapsed time to verify
SELECT 
    'Start Time' = @StartTime,
    'End Time' = GETDATE(),
    'Elapsed Seconds' = DATEDIFF(SECOND, @StartTime, GETDATE())

END
GO
