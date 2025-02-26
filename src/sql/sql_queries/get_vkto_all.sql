SELECT
vtg_pol_vkto												[sifra_zastupnika],
isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[naziv_zastupnika]
FROM vertrag v (nolock)
LEFT JOIN mitarbeiter m (nolock) ON vtg_pol_vkto=ma_vkto
GROUP BY vtg_pol_vkto,
isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')