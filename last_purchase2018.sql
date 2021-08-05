-- Учителя, которые последний раз покупали курсы летом 2018 и заходили до 2021
SELECT ag.fn "Полное Имя", 
    ag.re"Рабочий email",
    ag.rt "Рабочий телефон",
    ag.pr "Примечание", 
    'Предметный каталог: '||ag.case||' Вариант новой покупки: https://foxford.ru/courses/'||cou.id_last "Примечание" -- выводим последний курс по предмету
FROM
    (SELECT 
        us.last_name||' '||first_name||' '||middle_name fn,
        us.email re,
        us.phone rt,
        'Последняя покупка: '||co.subtitle||'. '||di.name||' https://foxford.ru/courses/'||co.id pr,
        discipline_id,
        CASE discipline_id WHEN 4 THEN 'https://foxford.ru/catalog/teacher/russkiy-yazyk'
              WHEN 2 THEN 'https://foxford.ru/catalog/teacher/informatika'
              WHEN 1 THEN 'https://foxford.ru/catalog/teacher/matematika'
              WHEN 8 THEN 'https://foxford.ru/catalog/teacher/angliyskiy-yazyk'
              WHEN 23 THEN 'https://foxford.ru/catalog/teacher/inostrannyy-yazyk'
              WHEN 6 THEN 'https://foxford.ru/catalog/teacher/obschestvoznanie'
              WHEN 9 THEN 'https://foxford.ru/catalog/teacher/biologiya'
              WHEN 7 THEN 'https://foxford.ru/catalog/teacher/istoriya'
              WHEN 26 THEN 'https://foxford.ru/catalog/teacher/geografiya'
              WHEN 42 THEN 'https://foxford.ru/catalog/teacher/ikt'
              WHEN 40 THEN 'https://foxford.ru/catalog/teacher/samorazvitie'
              WHEN 10 THEN 'https://foxford.ru/catalog/teacher/himiya'
              WHEN 27 THEN 'https://foxford.ru/catalog/teacher/literatura'
              WHEN 57 THEN 'https://foxford.ru/catalog/teacher/mhk-i-izo'
              WHEN 25 THEN 'https://foxford.ru/catalog/teacher/nachalnaya-shkola'
              WHEN 28 THEN 'https://foxford.ru/catalog/teacher/profperepodgotovka'
              WHEN 41 THEN 'https://foxford.ru/catalog/teacher/psihologiya-i-pedagogika'
              WHEN 22 THEN 'https://foxford.ru/catalog/teacher/metapredmetnyy'
              WHEN 33 THEN 'https://foxford.ru/catalog/teacher/upravlenie-oo'
              WHEN 32 THEN 'https://foxford.ru/catalog/teacher/fizicheskaya-kultura'
              WHEN 63 THEN 'https://foxford.ru/catalog/teacher/obzh'
              WHEN 69 THEN 'https://foxford.ru/catalog/teacher/fizika-i-astronomiya'
              WHEN 70 THEN 'https://foxford.ru/catalog/teacher/dopobrazovanie'
              WHEN 71 THEN 'https://foxford.ru/catalog/teacher/tehnologiya'
              WHEN 72 THEN 'https://foxford.ru/catalog/teacher/ovz'
              ELSE '-'
       END
        
    FROM 
        carts ca 
    JOIN payment_transactions pt ON pt.cart_id = ca.id
    JOIN users us ON ca.user_id = us.id 
    JOIN cart_items ci ON ca.id = ci.cart_id AND ci.resource_type = 'Course'
    JOIN courses co ON co.id = ci.resource_id
    JOIN disciplines di ON co.discipline_id = di.id
    WHERE pt.updated_at IN 
        (SELECT
            MAX(pt.updated_at)   -- последняя оплата
        FROM 
            carts ca 
        JOIN payment_transactions pt ON pt.cart_id = ca.id
        JOIN users us ON ca.user_id = us.id 
        WHERE pt.state = 'accepted' -- успешная оплата
        AND us.type = 'User::Agent' -- учитель
        AND us.phone IS NOT NULL -- есть телефон
        AND pt.amount > 400 -- не вебинары
        GROUP BY us.email) 
    AND pt.updated_at < timestamp '2018-09-01'
    AND pt.updated_at >= timestamp '2018-06-01'
    AND us.current_sign_in_at >= timestamp '2021-01-01' -- последнее посещение 
    ) ag
LEFT JOIN 
    (SELECT MAX(id) id_last, discipline_id di_last
    FROM Courses co_last
    WHERE business_unit_id = 5
    GROUP BY discipline_id) cou ON ag.discipline_id = cou.di_last 