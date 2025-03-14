SELECT
    gc.polisa
FROM gr_clients_all gc WITH (NOLOCK)
JOIN vertrag v WITH (NOLOCK) ON gc.polisa = v.vtg_obnr
WHERE gc.[embg/pib] = @id
--AND gc.vkto IN (SELECT vkto FROM dbo.fn_get_user_accessible_vktos(@currentUserID))
GROUP BY gc.polisa