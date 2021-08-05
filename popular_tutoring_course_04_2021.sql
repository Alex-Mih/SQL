-- Ищем в каком репетиторском курсе состоялось больше всего вводных занятий в апреле 2021
SELECT 
    cc.id AS "id course",
    COUNT(cl.user_course_id)
FROM 
    coach_lessons AS "cl"
LEFT JOIN Coach_user_courses AS "cuc" 
    ON cl.user_course_id = cuc.id
JOIN Coach_courses AS "cc" 
    ON cuc.course_id = cc.id
WHERE (cl.starts_at >= timestamp with time zone '2021-04-01 00:00:00.000Z'
  AND cl.starts_at < timestamp with time zone '2021-05-01 00:00:00.000Z')
  AND (intro OR open)
  AND cl.state = 'visited'
GROUP BY cc.id 
