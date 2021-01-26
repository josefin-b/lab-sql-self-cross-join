-- Lab | SQL Self and cross join --

-- In this lab, you will be using the Sakila database of movie rentals.
use sakila;

-- 1 Get all pairs of actors that worked together.

select 
	fa1.film_id, 
    fa1.actor_id as actor_id1, 
    concat(a1.first_name, ' ', a1.last_name) as actor_name1, 
    fa2.actor_id as actor_id2, 
    concat(a2.first_name, ' ', a2.last_name) as actor_name2
from actor as a1
	join film_actor as fa1 #inner join to get actor_name1
	on a1.actor_id = fa1.actor_id
	join film_actor as fa2 #self join to get all actor pairs (without duplicates)
	on fa1.actor_id <> fa2.actor_id
	and fa1.actor_id < fa2.actor_id
	and fa1.film_id = fa2.film_id
	join actor as a2 #inner join to get actor_name2
	on a2.actor_id = fa2.actor_id
order by film_id, actor_id1, actor_id2;


-- 2 Get all pairs of customers that have rented the same film more than 3 times.

select 
	c1.customer_id as customer_id1,
    concat(c1.first_name, ' ', c1.last_name)  as customer_name1,
    c2.customer_id as customer_id2,
    concat(c2.first_name, ' ', c2.last_name)  as customer_name2,
    count(f.title) as nr_of_same_rentals
from customer as c1
	join rental as r1 
    on c1.customer_id = r1.customer_id
    join inventory as i1 
    on r1.inventory_id = i1.inventory_id
    join film as f 
    on i1.film_id = f.film_id
    join inventory as i2 
    on f.film_id = i2.film_id
	join rental as r2 
    on r2.inventory_id = i2.inventory_id
    join customer as c2 
    on r2.customer_id = c2.customer_id
	where c1.customer_id > c2.customer_id
group by customer_id1, customer_id2
having count(f.film_id) > 3
order by nr_of_same_rentals desc, customer_id1, customer_id2;


-- 3 Get all possible pairs of actors and films.

select 
	f3.title,
    concat(a1.first_name, ' ', a1.last_name) as actor1,
    concat(a2.first_name, ' ', a2.last_name) as actor2
from film_actor as f1
	join film_actor as f2 #self join
    on f1.actor_id>f2.actor_id
    and f1.film_id=f2.film_id
	join actor as a1 #inner join
    on f1.actor_id = a1.actor_id
    join actor as a2 #inner join
    on f2.actor_id = a2.actor_id
    join film as f3 #inner join
    on f1.film_id = f3.film_id
order by title;
