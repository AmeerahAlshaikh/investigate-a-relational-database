/* query for Q1 set#1 */
SELECT DISTINCT film_title,
category_name,
COUNT(*) OVER (PARTITION BY film_title) AS rental_count

FROM
(SELECT f.title AS film_title,
        c.name AS category_name,
        r.rental_id rental_id
FROM film f
JOIN film_category fc
ON f.film_id= fc.film_id
JOIN category c
ON c.category_id = fc.category_id
JOIN inventory i
ON i.film_id= f.film_id
JOIN rental r
ON r.inventory_id=i.inventory_id

WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music') )sub
ORDER BY 1

/* query for Q2 set#1 */
SELECT DISTINCT film_title,
category_name,
rental_duration,
NTILE(4) OVER(ORDER BY rental_duration ) AS quartiles

FROM
(SELECT f.title AS film_title,
        c.name AS category_name,
        f.rental_duration AS rental_duration
FROM film f
JOIN film_category fc
ON f.film_id= fc.film_id
JOIN category c
ON c.category_id = fc.category_id

WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music') )sub
ORDER BY 4

/* query for Q3 set#1 */
SELECT DISTINCT category_name,
                quartiles ,
                COUNT(*)
FROM
(SELECT c.name category_name,
        NTILE(4) OVER(ORDER BY f.rental_duration ) AS quartiles
FROM film f
JOIN film_category fc
ON f.film_id= fc.film_id
JOIN category c
ON c.category_id = fc.category_id

WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music') )sub
GROUP BY 1,2
ORDER BY 1,2

/* query for q1 set#2 */
SELECT DATE_PART('month', r.rental_date ) AS rental_month,
       DATE_PART('year', r.rental_date ) AS rental_year,
       s.store_id store_id,
       COUNT(*)
FROM rental r
JOIN staff st
ON r.staff_id= st.staff_id
JOIN store s
ON st.store_id= s.store_id
GROUP BY 1,2,3
ORDER BY 1
