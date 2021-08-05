-- Просмотр корзины по email
SELECT *
FROM 
    payment_transactions AS "pt"
JOIN carts AS "ca" ON pt.cart_id = ca.id
WHERE ca.user_id IN (SELECT users.id
FROM users 
WHERE email = {{e}})
ORDER BY pt.updated_at DESC

-- Статус платежа, принимает одно из следующих значений:
-- pending — изначальный статус, еще не получили информацию о статусе оплаты.
-- accepted — успешная оплата.
-- rejected — отказ в оплате.
-- archived — архивная транзакция.