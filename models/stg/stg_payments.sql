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
    amount
    FROM orders 
    JOIN payment 
    ON payment.orderid = orders.order_id
)

SELECT * from payments