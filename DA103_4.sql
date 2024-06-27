/*
Question #1: 
What are the unique states values available in the customer data? Count the number of customers associated to each state.

Expected columns: state, total_customers
*/

-- q1 solution:

select distinct state, -- For unique states
	count(customer_id) total_customers

from customers

group by state
;


-- commenting on my observations about the output of my solution to question 1:
/*
As we don’t have any previous data to compare, we will just assess the output in general.
Almost all of the states acquired customer in a same rythm except some fluctuations overall.
And there is a issue with a state name 'US State' which actually doesn’t make any sense.
We need to fix this issue.
*/





/*
Question #2: 
It looks like the state data is not 100% clean and your manager already one issue:
(1) We have a value called “US State” which doesn’t make sense.

After a careful investigation your manager concluded that the “US State” customers should be assigned to California.

What is the total number of orders that have been completed for every state? Only include orders for which customer 
data is available.

Expected columns: clean_state, total_completed_orders
*/

-- q2 solution:

select replace(c.state, 'US State', 'California') clean_state, -- Replace to 'California' for 'US State' only 
	count(distinct o.order_id) total_completed_orders -- Provides similar result without DISTINCT for this case.
  
from customers c

inner join orders o on c.customer_id = o.user_id -- inner join is to avoid missing data

where o.status = 'Complete'

group by clean_state
;


-- commenting on my observations about the output of my solution to question 2:
/*
Most of the states are going at a same pace where Texas is little bit lagging behind.
Also point to be noted that after inspecting overall data, there are some 'missing data' for which no states are available. 
*/





/*
Question #3: 
After excluding some orders since the customer information was not available, your manager gets back to and stresses what we can never presented a number that is missing any orders even if our customer data is bad.

What is the total number of orders, number of Nike Official orders, and number of Nike Vintage orders that are completed by every state?

If customer data is missing, you can assign the records to ‘Missing Data’.

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders
*/

-- q3 solution:

select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state, -- replace NULL values with the string 'Missing Data'
	count(distinct o.order_id) total_completed_orders,
       count(distinct oi.order_id) official_completed_orders,
       count(distinct oiv.order_id) vintage_completed_orders
  
from orders o

left join order_items oi on o.order_id = oi.order_id -- left join for all data from orders table for total business whereas in order_items table, we have only official nike data.           
left join order_items_vintage oiv on o.order_id = oiv.order_id 
full join customers c on c.customer_id = o.user_id -- FULL JOIN to get Missing Data

where o.status = 'Complete'

group by clean_state
;

-- commenting on my observations about the output of my solution to question 3:
/*
The result shows that there is a high value of 'Missing data' issues in both official and vintage business, which refers to a significant human or 
system error (depends on how data has obtained).
*/






/*
Question #4: 
When reviewing sales performance, there is one metric we can never forget; revenue. 

Reuse the query you created in question 3 and add the revenue (aggregate of the sales price) to your table: 
(1) Total revenue for the all orders (not just the completed!)

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders, total_revenue
*/

-- q4 solution:

with completed_orders as (
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state, -- replace NULL values with the string 'Missing Data'
	count(distinct o.order_id) total_completed_orders,
       count(distinct oi.order_id) official_completed_orders,
       count(distinct oiv.order_id) vintage_completed_orders
  
from orders o

left join order_items oi on o.order_id = oi.order_id -- left join for all data from orders table for total business whereas in order_items table, we have only official nike data.
left join order_items_vintage oiv on o.order_id = oiv.order_id
full join customers c on c.customer_id = o.user_id -- FULL JOIN to get Missing Data

where o.status = 'Complete'

group by clean_state

), -- UP TO here from the query of question 3

combined_order_items as ( -- So that the total business data can be obtained and reused when needed
 
select * from order_items
union all
select * from order_items_vintage
  
),

total_business_revenue as ( 
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state, -- To use clean_state as a join key
  	sum(coi.sale_price) total_revenue -- Aggregate of the sales price

from combined_order_items coi
  
full join customers c on coi.user_id = c.customer_id --FULL JOIN to get Missing Data

group by clean_state
  
)

select co.clean_state,
	   co.total_completed_orders,
       co.official_completed_orders,
       co.vintage_completed_orders,
       tbr.total_revenue

from completed_orders co 

join total_business_revenue tbr on co.clean_state = tbr.clean_state -- using clean_state as a join key that we created

;


-- commenting on my observations about the output of my solution to question 4:
/*
In terms of generating revenue, Ohio is small behind compare to other states. 
To add, the missing data column has a high revenue value 108880.220 that should be seriously resolved to get much clearer vision.
*/





/*
Question #5: 
The leadership team is also interested in understanding the number of order items that get returned. 

Reuse the query of question 4 and add an additional metric to the table: 
(1) Number of order items that have been returned (items where the return date is populated)

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders, total_revenue,returned_items
*/

-- q5 solution:

with completed_orders as (
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state,
	count(distinct o.order_id) total_completed_orders,
       count(distinct oi.order_id) official_completed_orders,
       count(distinct oiv.order_id) vintage_completed_orders
  
from orders o

left join order_items oi on o.order_id = oi.order_id -- left join for all data from orders table for total business whereas in order_items table, we have only official nike data.
left join order_items_vintage oiv on o.order_id = oiv.order_id
full join customers c on c.customer_id = o.user_id -- FULL JOIN to get Missing Data

where o.status = 'Complete'

group by clean_state

),

combined_order_items as ( -- So that the total business data can be obtained and reused when needed
 
select * from order_items
union all
select * from order_items_vintage
  
),

total_business_revenue as ( 
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state, -- To use clean_state as a join key
  	sum(coi.sale_price) total_revenue -- Aggregate of the sales price

from combined_order_items coi
  
full join customers c on coi.user_id = c.customer_id --FULL JOIN to get Missing Data

group by clean_state
  
), -- UP TO here from the query of question 4

total_returned_items as (
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state, -- To use clean_state as a join key
	count(coi.order_item_id) filter(where coi.returned_at is not null) returned_items -- using sub-filter for returned items
  
from combined_order_items coi
  
full join customers c on coi.user_id = c.customer_id --FULL JOIN to get Missing Data

group by clean_state
  
)

select co.clean_state,
	co.total_completed_orders,
       co.official_completed_orders,
       co.vintage_completed_orders,
       tbr.total_revenue,
       tri.returned_items

from completed_orders co 

join total_business_revenue tbr on co.clean_state = tbr.clean_state -- FULL JOIN will provide similar output as values are equal
join total_returned_items tri on co.clean_state = tri.clean_state

;


-- commenting on my observations about the output of my solution to question 5:
/*
Instead of having a good performance in completing orders, California has really a value of returned items.
On the other hand, Florida is the lowest on that value.
*/






/*
Question #6: 
When looking at the number of returned items by itself, it is hard to understand what number of returned items is acceptable. This is mainly caused by the fact that we don’t have a benchmark at the moment.

Because of that, it is valuable to add an additional metric that looks at the percentage of returned order items divided by the total order items, we can call this the return rate.

Reuse the query of question 5 and integrate the return rate into your table.

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders, 
total_revenue,returned_items,return_rate
*/

-- q6 solution:

with completed_orders as (
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state,
	count(distinct o.order_id) total_completed_orders,
       count(distinct oi.order_id) official_completed_orders,
       count(distinct oiv.order_id) vintage_completed_orders
  
from orders o

left join order_items oi on o.order_id = oi.order_id -- left join for all data from orders table for total business whereas in order_items table, we have only official nike data.
left join order_items_vintage oiv on o.order_id = oiv.order_id
full join customers c on c.customer_id = o.user_id -- FULL JOIN to get Missing Data

where o.status = 'Complete'

group by clean_state

),

combined_order_items as ( -- So that the total business data can be obtained and reused when needed
 
select * from order_items
union all
select * from order_items_vintage
  
),

total_business_revenue as ( 
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state, -- To use clean_state as a join key
  	sum(coi.sale_price) total_revenue -- Aggregate of the sales price

from combined_order_items coi
  
full join customers c on coi.user_id = c.customer_id --FULL JOIN to get Missing Data

group by clean_state
  
),

total_returned_items as ( -- We only added a new column 'return_rate' into this temp table already created in the query of question 5
  
select coalesce(replace(c.state, 'US State', 'California'), 'Missing Data') clean_state,  -- To use clean_state as a join key
	count(coi.order_item_id) filter(where coi.returned_at is not null) returned_items,
  	count(coi.order_item_id) filter(where coi.returned_at is not null) / cast(count(coi.order_item_id) as float) return_rate -- to calculate the return rate, CAST the denominator as a float.
  
from combined_order_items coi
  
full join customers c on coi.user_id = c.customer_id --FULL JOIN to get Missing Data

group by clean_state
  
) 

select co.clean_state,
	co.total_completed_orders,
       co.official_completed_orders,
       co.vintage_completed_orders,
       tbr.total_revenue,
       tri.returned_items,
       tri.return_rate

from completed_orders co 

join total_business_revenue tbr on co.clean_state = tbr.clean_state -- FULL JOIN will provide similar output as values are equal
join total_returned_items tri on co.clean_state = tri.clean_state

;

-- commenting on my observations about the output of my solution to question 6:
/*
From output, it can be visualised that Florida has the lowest and California has the highest return rate of 9.264% and 12.421% respectively.
Where California has the highest completed orders.
The other states are doing somewhere in between, which overall needs to be lowered as much as possible.
*/


