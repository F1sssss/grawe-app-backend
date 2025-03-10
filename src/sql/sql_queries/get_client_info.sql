SELECT TOP 1
    [klijent],
    convert(varchar,[datum_rodjenja], 104) as [datum_rodjenja],
    [embg/pib],
    ISNULL([adresa], '') as [adresa],
    ISNULL([mjesto], '') as [mjesto],
    ISNULL([telefon1], '') as [telefon1],
    ISNULL([telefon2], '') as [telefon2],
    ISNULL([email], '') as [email]
FROM gr_clients_all
WHERE [embg/pib] = @id
--AND gc.vkto IN (SELECT vkto FROM dbo.fn_get_user_accessible_vktos(@currentUserID))