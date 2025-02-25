SELECT
    u.id,
    u.username,
    u.name,
    u.last_name,
    u.email
FROM
    users u
JOIN
    gr_user_hierarchy_groups ug ON u.id = ug.user_id
WHERE
    ug.group_id = @id
ORDER BY
    u.name, u.last_name;