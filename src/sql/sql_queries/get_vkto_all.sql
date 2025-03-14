SELECT
vtg_pol_vkto												[vkto],
isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')		[naziv_zastupnika],
ISNULL(gv.group_id, '')											[group_id]
FROM vertrag v (nolock)
LEFT JOIN mitarbeiter m (nolock) ON vtg_pol_vkto=ma_vkto
LEFT JOIN gr_hierarchy_vkto_mapping gv (nolock) ON vtg_pol_vkto=gv.vkto
GROUP BY vtg_pol_vkto,
         gv.group_id,
         isnull(m.ma_zuname,'') + ' ' + isnull(m.ma_vorname,'')
ORDER BY vtg_pol_vkto