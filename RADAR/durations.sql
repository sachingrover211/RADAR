DROP TABLE IF EXISTS 'durations';

CREATE TABLE durations(type varchar(50), duration int);

INSERT INTO durations VALUES ('duration_unit_actions', 1), ('duration_deploy_police_cars', 1), ('duration_deploy_small_engines', 2), ('duration_deploy_big_engines', 4),
				   ('duration_deploy_ladders', 3), ('duration_deploy_bulldozers', 3), ('duration_deploy_helicopters', 3), ('duration_deploy_rescuers', 3), 
				   ('duration_deploy_ambulances', 2), ('duration_position_policemen', 1),   ('duration_contact_media', 1), ('duration_set_up_helpline', 1), 
                                   ('duration_issue_local_alert', 1), ('duration_block_road', 2), ('duration_prepare_evacuation', 1), ('duration_evacuation', 5), ('duration_extinguish_small_fire', 1), 					   ('duration_extinguish_big_fire', 1), ('duration_barricade', 1), ('duration_search_casualties', 3), ('dduration_attend_casualties', 3), ('duration_address_media', 2);
