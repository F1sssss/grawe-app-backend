
WITH user_base_groups AS (
    -- Get the specific group the user is assigned to
    SELECT
        id,
        name,
        level_type,
        parent_id
    FROM gr_hierarchy_groups g
    JOIN gr_user_hierarchy_groups ug ON g.id = ug.group_id
    WHERE ug.user_id = @id
),
recursive_child_groups AS (
    -- Start with the user's base groups
    SELECT
        g.id,
        g.name,
        g.level_type,
        g.parent_id,
        0 AS depth
    FROM gr_hierarchy_groups g
    JOIN user_base_groups ub ON g.parent_id = ub.id

    UNION ALL

    -- Recursively get all descendant groups
    SELECT
        g.id,
        g.name,
        g.level_type,
        g.parent_id,
        rc.depth + 1
    FROM gr_hierarchy_groups g
    JOIN recursive_child_groups rc ON g.parent_id = rc.id
    WHERE rc.depth < 10  -- Prevent infinite recursion
)
SELECT DISTINCT
    rg.id,
    rg.name,
    rg.level_type,
    rg.parent_id,
    rg.depth
FROM recursive_child_groups rg
ORDER BY rg.depth, rg.name;