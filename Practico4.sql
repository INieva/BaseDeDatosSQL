-- Practico de Laboratorio 5-2022

use world2;
-- 1 Listar el nombre de la ciudad y el nombre del país de todas las ciudades que 
-- pertenezcan a países con una población menor a 10000 habitantes.

select city.Name as nombre, country.Name as pais 
from city inner join country on city.CountryCode = country.Code 
where country.Population < 10000;

-- 2 Listar todas aquellas ciudades cuya población sea mayor que la población promedio
-- entre todas las ciudades

select name from city 
where Population > (
	select avg(Population) from city
);

-- 3 Listar todas aquellas ciudades no asiáticas cuya población sea igual o 
-- mayor a la población total de algún país de Asia.

select city.Name from 
city inner join country on city.CountryCode = country.Code
where country.Continent != 'Asia' and country.Population >=
	(select min(Population) from country
	where country.Continent = 'Asia');
	

-- 4 Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje 
-- de hablantes a cada uno de los idiomas oficiales del país.

select c.Name, l.`Language`
from country c inner join countrylanguage l on c.Code = l.CountryCode 
where l.IsOfficial = 'F' and l.Percentage > 
(select max(l1.Percentage) from countrylanguage l1 where l1.IsOfficial = 'T' and c.Code = l1.CountryCode
group by c.Name);


SELECT c.Name, l.Language
FROM country c JOIN countrylanguage l ON c.Code=l.CountryCode AND l.IsOfficial='F'
WHERE l.Percentage >  ALL(
 SELECT l2.Percentage 
 FROM countrylanguage l2 WHERE l2.IsOfficial='T' AND c.Code=l2.CountryCode)
;


-- 5 Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 
-- 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. 
-- (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas).

select distinct c.Region 
from country c inner join city on c.Code = city.CountryCode 
where c.SurfaceArea < 1000 and city.Population > 100000;


-- 6 Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. 
-- (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).

select c.Name  as Country, ci.Name, ci.Population from 
country c inner join city ci on c.Code = ci.CountryCode
where ci.Population >= all (
	select ci2.Population from city ci2 where ci2.CountryCode = c.Code); 


-- 7 Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor 
-- al promedio de hablantes de los lenguajes oficiales.

select c.Name, l.`Language` from 
country c inner join countrylanguage l on c.Code = l.CountryCode 
where l.IsOfficial = 'F' and l.Percentage >
(select avg (l1.Percentage) from countrylanguage l1 where l1.IsOfficial = 'T' and c.Code = l1.CountryCode);



-- 8 Listar la cantidad de habitantes por continente ordenado en forma descendiente.
select c.Name, sum(all c1.Population) as Population from 
continent c inner join country c1 on c.Name = c1.Continent
group by c.Name
order by Population desc;


-- 9 Listar el promedio de esperanza de vida (LifeExpectancy) por continente con 
-- una esperanza de vida entre 40 y 70 años.
select c1.Name , avg(c.LifeExpectancy) as Average from country c 
inner join continent c1 on c.Continent = c1.Name 
where c.LifeExpectancy between 40 and 70
group by c1.Name
-- having c.LifeExpectancy between 40 and 70 -- > 40 and c.LifeExpectancy  < 70
order by Average desc;

-- 10 Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.



