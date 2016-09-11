INSERT INTO aircraft_tracks(icao) VALUES ("ttt");
Создаем базу и пользователя:
postgres=# CREATE DATABASE test_base;
CREATE DATABASE
postgres=# CREATE USER test_user WITH password 'test_password';
CREATE ROLE
postgres=# GRANT ALL privileges ON DATABASE test_base TO test_user;
GRANT

export PGPASSWORD='z5UHwrg8'; 

psql -u postgres  
ALTER USER postgres with encrypted password 'your_password';

echo "SELECT * FROM regions;SELECT * FROM cities;" |  psql -h 192.168.1.100 -U postgres -d test

CURRENT_DATE

INSERT INTO example
    (id, name)
SELECT 1, 'John'
WHERE
    NOT EXISTS (
        SELECT id FROM example_table WHERE id = 1
    );



CREATE TABLE table_name (
column_name1 data_type(size) DEFAULT 'default_name'
)


CREATE VIEW PlanetsView
AS SELECT PlanetName, OpeningYear
FROM Planets
В результате будет создано представление с названием PlanetsView которая будет содержать в себе значения столбцов PlanetName и OpeningYear


SELECT * FROM PlanetsView

### EXIST

select exists(select 1 from aircraft_tracks where icao='test2')
 

INSERT INTO invoices (invoiceid, billed) SELECT '12345', 'TRUE'
WHERE NOT EXISTS (SELECT 1 FROM invoices WHERE invoiceid = '12345')



INSERT INTO example_table
    (id, name)
SELECT 1, 'John'
WHERE
    NOT EXISTS (
        SELECT id FROM example_table WHERE id = 1
    );


SELECT TOP(3) Album, Year FROM Artists ORDER BY Year


ID	UniversityName	Students	Faculties	Professores	Location	Site
1	Perm State National Research University	12400	12	1229	Perm	psu.ru
2	Saint Petersburg State University	21300	24	13126	Saint-Petersburg	 spbu.ru
3	Novosibirsk State University	7200	13	1527	Novosibirsk	nsu.ru
4	Moscow State University	35100	39	14358	Moscow	msu.ru
5	Higher School of Economics	20335	12	1615	Moscow	hse.ru
6	Ural Federal University	57000	19	5640	Yekaterinburg	urfu.ru
7	National Research Nuclear University	8600	10	936	Moscow	mephi.ru
Пример 1. Используя оператор SQL IN вывести записи университетов из Новосибирска и Перми:

SELECT *
FROM Universities
WHERE Location IN ('Novosibirsk', 'Perm')

SELECT
  sum(amount),
  c.country_id,
  p.city_id
FROM payment AS p
  INNER JOIN city AS c
    ON p.city_id = c.id
GROUP BY GROUPING SETS(c.country_id, p.city_id);

