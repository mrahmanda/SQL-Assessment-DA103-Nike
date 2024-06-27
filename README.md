# SQL-Assessment-DA103-Nike

## SQL Assessment


### At the end of every quarter, the analyst teams are required to do a lot of number crunching to understand what the performance has been of our sales over the past three months. The meetings based on all this number crunching are called quarterly business reviews.

During these quarterly business reviews, two key topics are discussed:

Looking back on the performance of the last three months. What went well? Which business areas are high-performing? What can be improved?
Looking forward to the next three months ahead. What is the plan? Based on the last months, what needs to be changed?
At Nike, the business performance in the United States is assessed state by state rather than country level. Because of that, you are asked to prepare the performance for the different states for your leadership team to run their quarterly business reviews effectively. Let’s dive in!

⚠️
Please note: two business units have order items stored in separate tables. When the question refers to Nike Official, you need to work with the order_items table. When the question refers to Nike Vintage, you need to work with the order_items_vintage table.


## Question #1: 
What are the unique states values available in the customer data? Count the number of customers associated to each state.

Expected columns: state, total_customers
💡


## Question #2: 
It looks like the state data is not 100% clean and your manager already one issue:
(1) We have a value called “US State” which doesn’t make sense.

After a careful investigation your manager concluded that the “US State” customers should be assigned to California.

What is the total number of orders that have been completed for every state? Only include orders for which customer data is available.

Expected columns: clean_state, total_completed_orders
💡


## Question #3: 
After excluding some orders since the customer information was not available, your manager gets back to and stresses what we can never presented a number that is missing any orders even if our customer data is bad.

What is the total number of orders, number of Nike Official orders, and number of Nike Vintage orders that are completed by every state?

If customer data is missing, you can assign the records to ‘Missing Data’.

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders
💡


## Question #4: 
When reviewing sales performance, there is one metric we can never forget; revenue. 

Reuse the query you created in question 3 and add the revenue (aggregate of the sales price) to your table: 
(1) Total revenue for the all orders (not just the completed!)

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders, total_revenue
💡


## Question #5: 
The leadership team is also interested in understanding the number of order items that get returned. 

Reuse the query of question 4 and add an additional metric to the table: 
(1) Number of order items that have been returned (items where the return date is populated)

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders, total_revenue,returned_items
💡

⭐
Pro-Tip: CAST the denominator as a float to calculate the return rate.


## Question #6: 
When looking at the number of returned items by itself, it is hard to understand what number of returned items is acceptable. This is mainly caused by the fact that we don’t have a benchmark at the moment.

Because of that, it is valuable to add an additional metric that looks at the percentage of returned order items divided by the total order items, we can call this the return rate.

Reuse the query of question 5 and integrate the return rate into your table.

Expected columns: clean_state, total_completed_orders, official_completed_orders, vintage_completed_orders, total_revenue,returned_items,return_rate
💡
