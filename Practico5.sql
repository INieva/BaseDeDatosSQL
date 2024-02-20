-- Practico de Laboratorio 5-2022
use sakila;

-- 2 El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e.
-- el mayor número de películas filmadas) son también directores de las películas en
-- las que participaron. Basados en esta información, inserten, utilizando una subquery
-- los valores correspondientes en la tabla `directors`.
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS movie_numbers
FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id  
GROUP BY a.actor_id
ORDER BY movie_numbers DESC LIMIT 5;

INSERT INTO directors (directors_id, first_name, last_name, movie_numbers)
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS movie_numbers
FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id  
GROUP BY a.actor_id
ORDER BY movie_numbers DESC LIMIT 5;


-- 3 Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a
-- si el cliente es "premium" o no. Por defecto ningún cliente será premium.
ALTER TABLE customer ADD COLUMN premium_customer enum('T', 'F') DEFAULT 'F';


-- 4 Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de
-- los 10 clientes con mayor dinero gastado en la plataforma.

-- SELECT c.customer_id, c.first_name, c.last_name, COUNT(p.amount) AS total_amount
-- FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id 
-- GROUP BY c.customer_id 
-- ORDER BY total_amount DESC LIMIT 10;


-- 5 Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings
-- de las películas existentes (Hint: rating se refiere en este caso a la clasificación
-- según edad: G, PG, R, etc).
SELECT f.rating, COUNT(f.rating) as total_movies
FROM film f 
GROUP BY f.rating 
ORDER BY total_movies DESC;


-- 6 ¿Cuáles fueron la primera y última fecha donde hubo pagos?
-- Voy a usar un PROCEDIMIENTO almacenado.
CALL last_first_payment();

-- 7 Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el
-- nombre del mes de una fecha).
-- (otra opcion es MONTH en vez de MONTHNAME)
SELECT MONTHNAME(p.payment_date) AS `month`, AVG (p.amount) AS average_amount
FROM payment p
GROUP BY `month`;


-- 8 Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total
-- de alquileres). rental customer adress
SELECT a.district AS district, count(r.rental_id) AS cantidad 
FROM address a INNER JOIN (rental r INNER JOIN customer c ON r.customer_id = c.customer_id) ON a.address_id = c.address_id 
GROUP BY a.district
ORDER BY cantidad DESC LIMIT 10;


-- 9 Modifique la table `inventory_id` agregando una columna `stock` que sea un número
-- entero y representa la cantidad de copias de una misma película que tiene
-- determinada tienda. El número por defecto debería ser 5 copias.
ALTER TABLE inventory ADD COLUMN stock INT DEFAULT 5;


-- 10 Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la
-- tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la
-- película rentada (Hint: revisar que el rental no tiene información directa sobre la
-- tienda, sino sobre el cliente, que está asociado a una tienda en particular).
-- NOTA: use sakila; EN UN SCRIPT SEPARADO

DROP TRIGGER IF EXISTS update_stock;
DELIMITER $$
CREATE TRIGGER update_stock
AFTER INSERT ON rental
FOR EACH ROW 
BEGIN 
	UPDATE inventory  SET inventory.stock  = inventory.stock -1
	WHERE rental.inventory_id = inventory.inventory_id AND rental.customer_id = customer.customer_id AND customer.store_id = store.store_id 
	AND store.store_id = inventory.store_id;
END $$
DELIMITER ;


-- 11 Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es
-- una clave foránea a la tabla rental y el segundo es un valor numérico con dos
-- decimales.
DROP TABLE IF EXISTS fines;
CREATE TABLE fines (
	rental_id INT NOT NULL AUTO_INCREMENT, 
	amount DECIMAL (5,2) NOT NULL,
	PRIMARY KEY (rental_id),
	CONSTRAINT fk_fines_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id)
)	ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--12 Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un
-- registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya
-- tardado más de 3 días (comparación con rental_date). El valor de la multa será el
-- número de días de retraso multiplicado por 1.5.
DELIMITER $$
DROP PROCEDURE IF EXISTS check_date_and_fine$$
CREATE PROCEDURE check_date_and_fine()
	BEGIN 
		INSERT INTO fines (rental_id, amount) 
		SELECT rental_id, TIMESTAMPDIFF(DAY, rental_date, return_date)*1.5
		FROM rental r 
		WHERE return_date > DATE_ADD(rental_date, INTERVAL 3 DAY);
	END$$
DELIMITER ;	


-- 13 Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a
-- la tabla `rental`.
DROP ROLE IF EXISTS employee;
CREATE ROLE employee;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE rental
TO employee;


-- 14 Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que
-- tenga todos los privilegios sobre la BD `sakila`.

REVOKE DELETE ON rental
FROM employee;

DROP ROLE IF EXISTS administrator;
CREATE ROLE administrator;

GRANT ALL ON sakila
TO administrator;

-- 15 Crear dos empleados con acceso local. A uno asignarle los permisos de `employee`
-- y al otro de `administrator`.












