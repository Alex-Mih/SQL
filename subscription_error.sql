-- Сколько курсов КиР для девятого класса не вошло в состав абонемента
SELECT 
    *
FROM 
    courses AS "co"
JOIN course_grades AS "cg" ON co.id = cg.course_id
WHERE co.id not in 
    (SELECT 
        resource_id 
    FROM 
        product_pack_items
    WHERE product_pack_iD = 135 
        AND resource_type = 'Course')
    AND payments_opened
    AND purchase_mode = 1
    AND business_unit_id = 1
    and cg.grade_id = 4
    and visible_in_list
    and co.created_at >= timestamp with time zone '2021-01-01 00:00:00.000Z'
