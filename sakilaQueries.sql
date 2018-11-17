-- specifies the database
use sakila ;

-- 1a.Display the first and last names of all actors from the table actor
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b.Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actor name'
FROM
    actor;

-- 2a.You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';

--  2b.all actors whose last name contain the letters GEN
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

-- 2c.all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d.display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a.description of each actor.create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description BLOB;
  
-- display actor table  
select * from actor;

-- 3b.Delete the description column.
alter table actor
drop column description;

-- display actor table  
select * from actor;

-- 4a.List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT 
    last_name, COUNT(last_name) AS last_name_count
FROM
    actor
GROUP BY last_name
HAVING last_name_count > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'GROUCHO';

--  display the correct name
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'HARPO';

-- 4d. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'HARPO';

--  display the correct name
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'GROUCHO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a.Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT 
    s.first_name, s.last_name, a.address
FROM
    staff AS s
        LEFT JOIN
    address AS a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT 
    s.first_name, s.last_name, SUM(p.amount) AS total
FROM
    staff AS s
        LEFT JOIN
    payment AS p ON s.staff_id = p.staff_id
WHERE
    p.payment_date LIKE '2005-08%'
GROUP BY s.first_name , s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT 
    f.title, COUNT(fa.actor_id) AS 'number of actor'
FROM
    film AS f
        JOIN
    film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(film_id) AS 'copies of Hunchback Impossible'
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS 'total amount paid'
FROM
    customer AS c
        LEFT JOIN
    payment AS p ON c.customer_id = p.customer_id
GROUP BY c.first_name , c.last_name
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT 
    title
FROM
    film
WHERE
    language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English')
        AND title LIKE 'Q%'
        OR title LIKE 'K%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of 
-- all Canadian customers.
--  Use joins to retrieve this information.
SELECT 
    cs.first_name, cs.last_name, cs.email
FROM
    customer AS cs
        JOIN
    address AS ad ON cs.address_id = ad.address_id
        JOIN
    city AS ci ON ad.city_id = ci.city_id
        JOIN
    country AS cn ON ci.country_id = cn.country_id
WHERE
    country = 'canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.
SELECT 
    f.title, COUNT(f.film_id) AS 'count of rented movie'
FROM
    film AS f
        JOIN
    inventory AS i ON f.film_id = i.film_id
        JOIN
    rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY 'count of rented movie' DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    s.store_id, SUM(p.amount) AS 'store business in dollars'
FROM
    payment AS p
        JOIN
    staff AS s ON s.staff_id = p.staff_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id, cit.city, cont.country
FROM
    store AS s
        JOIN
    address AS a ON s.address_id = a.address_id
        JOIN
    city AS cit ON a.city_id = cit.city_id
        JOIN
    country AS cont ON cit.country_id = cont.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
SELECT 
    cat.name AS 'Top Five', SUM(p.amount) AS 'Gross'
FROM
    category AS cat
        JOIN
    film_category AS fcat ON cat.category_id = fcat.category_id
        JOIN
    inventory AS i ON fcat.film_id = i.film_id
        JOIN
    rental AS r ON i.inventory_id = r.inventory_id
        JOIN
    payment AS p ON r.rental_id = p.rental_id
GROUP BY cat.name
ORDER BY Gross
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five AS
    SELECT 
        cat.name AS 'Top Five', SUM(p.amount) AS 'Gross'
    FROM
        category AS cat
            JOIN
        film_category AS fcat ON cat.category_id = fcat.category_id
            JOIN
        inventory AS i ON fcat.film_id = i.film_id
            JOIN
        rental AS r ON i.inventory_id = r.inventory_id
            JOIN
        payment AS p ON r.rental_id = p.rental_id
    GROUP BY cat.name
    ORDER BY Gross
    LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
show create view top_five;
SELECT 
    *
FROM
    top_five;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five;

