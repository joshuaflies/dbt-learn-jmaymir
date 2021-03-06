with orders as (

    SELECT * FROM {{ ref('stg_orders') }}

),

payment as (
    SELECT * FROM raw.stripe.payment
),

/* Looking to create
order id
customer_id
amount of payment
*/

payments as (
    SELECT 
    order_id,
    customer_id,
    SUM(amount)::FLOAT/100::FLOAT as payment
    FROM orders 
    JOIN payment 
    ON payment.orderid = orders.order_id
    WHERE payment.STATUS = 'success'
    GROUP BY order_id, customer_id
)

SELECT * FROM payments

/*
SELECT 
 order_id,
 COUNT(order_id) as dup_count
 from payments
 group by order_id
 HAVING dup_count > 1

 Can see we have duplicate order ids

 Corrected by grouping by order id
 */

 /*
Incorrect total amount

Need to filter payment status to be "success" instead of "fail"

SELECT SUM(payment) FROM payments

Also divide by 100 in order to get dollar instead of cents
 */