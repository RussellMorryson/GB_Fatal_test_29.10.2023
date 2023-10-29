/* 7. В подключенном MySQL репозитории создать базу данных "Друзья человека"
8. Создать таблицы с иерархией из диаграммы в БД.
9. Заполнить низкоуровневые таблицы именами (животных), командами, которые они 
выполняют, и датами рождения.*/

USE peoplefriends;

CREATE TABLE cat (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE
);

CREATE TABLE dog (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE
);

CREATE TABLE hamster (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE
);

CREATE TABLE horse (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE
);

CREATE TABLE camel (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE
);

CREATE TABLE donkey (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE
);

INSERT INTO cat (name, command, date_of_birth) VALUES 
	('barsik', 'meow', '2021-01-01'),
	('kosh', 'meow, stand', '2019-12-10'),
    	('frank', 'meow, wlow', '2020-02-02'),
    	('dir', 'meow', '2022-03-03'),
    	('krop', 'meow', '2018-05-05');
   
INSERT INTO dog (name, command, date_of_birth) VALUES 
	('wolf', 'flufy', '2021-01-01'),
	('ralf', 'site', '2019-12-10'),
    	('qwerty', 'left hand', '2020-02-02'),
    	('asdfg', 'right hand', '2022-03-03'),
    	('red', 'meow', '2018-05-05');
    
INSERT INTO hamster (name, command, date_of_birth) VALUES 
	('crack', 'eat', '2021-01-01'),
	('jisus', 'eat', '2019-12-10'),
    	('qwerty', 'left hand', '2020-02-02'),
    	('asdfg', 'right hand', '2022-03-03'),
    	('black', 'meow', '2018-05-05');
    
INSERT INTO horse (name, command, date_of_birth) VALUES 
	('igogo', 'eat', '2021-01-01'),
	('igaga', 'eat', '2019-12-10'),
    	('ijoho', 'left hand', '2020-02-02'),
    	('jijij', 'right hand', '2022-03-03'),
    	('aoaoaa', 'meow', '2018-05-05');
    
INSERT INTO camel (name, command, date_of_birth) VALUES 
	('quma', 'eat', '2021-01-01'),
	('duma', 'eat', '2019-12-10'),
    	('gena', 'left hand', '2020-02-02'),
    	('gana', 'right hand', '2022-03-03'),
    	('wersu', 'meow', '2018-05-05');
    
INSERT INTO donkey (name, command, date_of_birth) VALUES 
	('stup', 'eat', '2021-01-01'),
	('tupi', 'eat', '2019-12-10'),
    	('upid', 'left hand', '2020-02-02'),
    	('tost', 'right hand', '2022-03-03'),
    	('shone', 'meow', '2018-05-05');
    
/* 10. Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в 
другой питомник на зимовку, объединить таблицы лошади и ослы в одну таблицу.*/

TRUNCATE camel;

INSERT INTO horse (name, command, date_of_birth)
SELECT name, command, date_of_birth
FROM donkey;

DROP TABLE donkey;

RENAME TABLE horse TO horse_donkey;

/* 11. Создать новую таблицу “молодые животные”, в которую попадут все животные 
старше 1 года, но младше 3 лет и в отдельном столбце с точностью до месяца 
подсчитать возраст животных в новой таблице.*/

CREATE TABLE young_animal (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE,
    	age TEXT
);


DELIMITER $$
CREATE FUNCTION age_animal (date_b DATE)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE res TEXT DEFAULT '';
	SET res = CONCAT(
            TIMESTAMPDIFF(YEAR, date_b, CURDATE()),
            ' years ',
            TIMESTAMPDIFF(MONTH, date_b, CURDATE()) % 12,
            ' month'
        );
	RETURN res;
END $$
DELIMITER ;

INSERT INTO young_animal (name, command, date_of_birth, age)
SELECT name, command, date_of_birth, age_animal(date_of_birth)
FROM cat
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT name, command, date_of_birth, age_animal(date_of_birth)
FROM dog
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT name, command, date_of_birth, age_animal(date_of_birth)
FROM hamster
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT name, command, date_of_birth, age_animal(date_of_birth)
FROM horse_donkey
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM cat 
WHERE TIMESTAMPDIFF(YEAR, cat.date_of_birth, CURDATE()) IN (1, 2, 3);

DELETE FROM dog 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

DELETE FROM hamster 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

DELETE FROM horse_donkey 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 1 AND 3;

/* 12. Объединить все таблицы в одну, при этом сохраняя поля, указывающие на прошлую 
принадлежность к старым таблицам.*/

CREATE TABLE animals (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name CHAR(30),
    	command TEXT,
    	date_of_birth DATE,
    	age TEXT,
    	type ENUM('cat','dog','hamster', 'horse_donkey', 'young_animals') NOT NULL
);

INSERT INTO animals (name, command, date_of_birth, age, atype)
SELECT name, command, date_of_birth, age_animal(date_of_birth), 'cat'
FROM cat;

INSERT INTO animals (name, command, date_of_birth, age, animal_type)
SELECT name, command, date_of_birth, age_animal(date_of_birth), 'dog'
FROM dog;

INSERT INTO animals (name, commands, date_of_birth, age, animal_type)
SELECT name, command, date_of_birth, age_animal(date_of_birth), 'hamster'
FROM hamster;

INSERT INTO animals (name, command, date_of_birth, age, animal_type)
SELECT name, command, date_of_birth, age_animal(date_of_birth), 'horse_donkey'
FROM horse_donkey;

INSERT INTO animals (name, command, date_of_birth, age, animal_type)
SELECT name, command, date_of_birth, age_animal(date_of_birth), 'young_animals'
FROM young_animal;