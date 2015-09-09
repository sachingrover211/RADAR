DROP TABLE IF EXISTS object_type;

CREATE TABLE object_type(id int, name varchar(50));

INSERT INTO object_type values (1, 'police'), (2, 'fire'), (3, 'medic'), (4, 'transport'), (5, 'policestation'), (6, 'firestation'), (7, 'hospital'), (8, 'pois');
