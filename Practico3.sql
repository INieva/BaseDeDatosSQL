use world2;
select * from `country`;

--Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 10 ciudades más pobladas del mundo.--

select city.Name as Ciudad, country.Name as Pais, country.Region as Region, country.GovernmentForm as 'Forma de Gobierno' 
from city inner join country on city.CountryCode = country.Code
order by city.Population desc limit 10;

--Listar los 10 países con menor población del mundo, junto a sus ciudades capitales 
--(Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL").

select country.Name as Nombre, city.Name as Capital
from country left join city on country.Code = city.CountryCode 
order by country.Population asc limit 10;

--Listar el nombre, continente y todos los lenguajes oficiales de cada país. 
(Hint: habrá más de una fila por país si tiene varios idiomas oficiales).

select country.name as Pais, continent.Name as Continente, countrylanguage.`Language` as Idioma
from (countrylanguage right join country on countrylanguage.CountryCode = country.Code)
left join continent on country.Continent = continent.Name;

-- Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
select country.Name as Nombre, city.Name  as Capital, country.SurfaceArea  as Superficie
from country left join city on country.Capital = city.ID
order by country.SurfaceArea  desc limit 20;

-- Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad) y el porcentaje de hablantes del idioma.
-- Tambien va con inner en vez de left
select city.Name as Ciudad, countrylanguage.`Language` as Idioma, countrylanguage.Percentage 
from city 
left join country on city.CountryCode = country.Code
left join countrylanguage on country.Code = countrylanguage.CountryCode 
order by city.Population desc, countrylanguage.Percentage asc;

-- Listar los 10 países con mayor población y los 10 países con menor población (que tengan al menos 100 habitantes) en la misma consulta.
(select country.Name as Nombre, country.Population as Poblacion
from country 
where country.Population > 100 
order by country.Population desc limit 10)
union 
(select country.Name as Nombre2, country.Population 
from country 
where country.Population > 100 
order by country.Population asc limit 10);

-- Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés (hint: no debería haber filas duplicadas).
select country.Name  
from country inner join countrylanguage on country.Code = countrylanguage.CountryCode
where countrylanguage.`Language` = 'English'
and country.Name in 
	(select country.Name
	from country inner join countrylanguage on country.Code = countrylanguage.CountryCode 
	where countrylanguage.`Language` = 'French'
	);

-- Listar aquellos países que tengan hablantes del Inglés pero no del Español en su población.
select country.Name 
from country inner join countrylanguage on country.Code = countrylanguage.CountryCode 
where countrylanguage.`Language` = 'English'
and country.Name not in
	(select country.Name
	from country inner join countrylanguage on country.Code = countrylanguage.CountryCode 
	where countrylanguage.`Language` = 'Spanish'
	);


























