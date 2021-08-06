-- выручка по учителям за период
SELECT SUM(ci.price) AS price
    FROM cart_items ci
    JOIN users u ON u.id = ca.user_id
    JOIN carts ca ON ca.id = ci.cart_id
    WHERE ca.state = 'successful' -- успешные оплаты
        AND u.type = 'User::Agent' -- учителя
        [[AND ca.purchased_at >= {{StartDate}}]]
        [[AND ca.purchased_at <= {{EndDate}}]]