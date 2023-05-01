-- 3)Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

SELECT 
    `order-directory`.customer.CUS_GENDER, count(DISTINCT(`order-directory`.customer.CUS_ID))
FROM 
    customer
INNER JOIN 
     `order-directory`.order  
ON
   `order-directory`.customer.CUS_ID= `order-directory`.order .CUS_ID
WHERE 
    ORD_AMOUNT>=3000
GROUP BY `order-directory`.customer.CUS_GENDER;

-- 4)Display all the orders along with product name ordered by a customer having Customer_Id=2
SELECT 
    `order-directory`.order.ORD_ID as Order_Id, 
	`order-directory`.order.CUS_ID as Customer_Id,
	`order-directory`.product.PRO_NAME,
    `order-directory`.order.ORD_AMOUNT as Order_Amount,
    `order-directory`.order.ORD_DATE as Order_Date
FROM 
   `order-directory`.order
INNER JOIN 
     `order-directory`.supplier_pricing  
ON
   `order-directory`.order.PRICING_ID= `order-directory`.supplier_pricing.PRICING_ID
INNER JOIN 
     `order-directory`.product  
ON
   `order-directory`.supplier_pricing.PRO_ID= `order-directory`.product.PRO_ID
WHERE 
     `order-directory`.order.CUS_ID=2;

-- 5)Display the Supplier details who can supply more than one product.
SELECT 
    `order-directory`.supplier_pricing.SUPP_ID as Supplier_Id,
	`order-directory`.supplier.SUPP_NAME as Supplier_Name,
	`order-directory`.supplier.SUPP_PHONE as Supplier_ContactNo,
	`order-directory`.supplier.SUPP_CITY as Supplier_City,
	count(`order-directory`.supplier_pricing.PRO_ID) as Count_Of_Products
FROM 
     `order-directory`.supplier
INNER JOIN 
 `order-directory`.supplier_pricing
 ON
   `order-directory`.supplier_pricing.SUPP_ID= `order-directory`.supplier.SUPP_ID
GROUP BY
 `order-directory`.supplier_pricing.SUPP_ID
HAVING
count(`order-directory`.supplier_pricing.PRO_ID)>1;

-- 6)Find the least expensive product from each category and print the table with category id, name,product name and price of the product

SELECT 
    `order-directory`.category.CAT_ID as Category_id,
    `order-directory`.category.CAT_NAME as Category_Name,
    `order-directory`.product.PRO_NAME as Product_Name,
    min(`order-directory`.supplier_pricing.SUPP_PRICE) as Price_Of_Product
FROM 
     `order-directory`.category

INNER JOIN 
 `order-directory`.product
 ON
   `order-directory`.product.CAT_ID=  `order-directory`.category.CAT_ID 

INNER JOIN 
 `order-directory`.supplier_pricing
 ON
   `order-directory`.supplier_pricing.PRO_ID=  `order-directory`.product.PRO_ID 

GROUP BY
  `order-directory`.category.CAT_ID 
HAVING
min(`order-directory`.supplier_pricing.SUPP_PRICE);

-- 7)Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT 
    `order-directory`.product.PRO_ID as Product_id,
    `order-directory`.product.PRO_NAME as Product_Name,
    `order-directory`.order.ORD_DATE as Order_Date
FROM 
     `order-directory`.order

INNER JOIN 
 `order-directory`.supplier_pricing
 ON
   `order-directory`.supplier_pricing.PRICING_ID=  `order-directory`.order.PRICING_ID 
   
INNER JOIN 
 `order-directory`.product
 ON
   `order-directory`.product.PRO_ID=  `order-directory`.supplier_pricing.PRO_ID 

WHERE `order-directory`.order.ORD_DATE > '2021-10-05' ;




-- 8)Display customer name and gender whose names start or end with character 'A'.

SELECT 
`order-directory`.customer.CUS_NAME as Customer_Name,
`order-directory`.customer.CUS_GENDER as Customer_Gender
FROM 
	`order-directory`.customer
WHERE 
	LEFT(CUS_NAME , 1) IN ('a')
	OR 
    RIGHT(CUS_NAME,1) IN  ('a');



-- 9)Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
--   For Type_of_Service,
--  	If rating =5, print “Excellent Service”,
--  	If rating >4 print “Good Service”, 
--  	If rating >2 print “Average Service” 
--  	else print “Poor Service”.
CREATE PROCEDURE `reviewProcedure` ()
BEGIN
	SELECT `order-directory`.supplier.SUPP_ID as Supplier_id,
`order-directory`.supplier.SUPP_NAME as Supplier_Name,
 `order-directory`.rating.RAT_RATSTARS as Rating,
CASE
WHEN `order-directory`.rating.RAT_RATSTARS =5 THEN 'Excellent Service'
WHEN `order-directory`.rating.RAT_RATSTARS >4 THEN 'Good Service'
WHEN `order-directory`.rating.RAT_RATSTARS >2 THEN 'Average Service'
ELSE 'Poor Service'
END as Type_Of_Service
FROM supplier
INNER JOIN `order-directory`.supplier_pricing on `order-directory`.supplier_pricing.SUPP_ID = `order-directory`.supplier.SUPP_ID
INNER JOIN `order-directory`.order on `order-directory`.order.PRICING_ID = `order-directory`.supplier_pricing.PRICING_ID
INNER JOIN `order-directory`.rating on `order-directory`.rating.ORD_ID = `order-directory`.order.ORD_ID
END;