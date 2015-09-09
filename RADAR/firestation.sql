DROP TABLE IF EXISTS 'predicates_for_fireStation';

CREATE TABLE predicates_for_fireStation (id int, description varchar(50));

insert into predicates_for_fireStation values (1, 'has_small_engines_number'), (2, 'has_big_engines_number'), (3, 'has_ladders_number'), (4, 'has_bulldozers_number'), (5, 'has_helicopters_number'), (6, 'has_rescuers_number');
