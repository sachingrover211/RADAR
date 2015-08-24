(define (problem BYENG) (:domain RADAR)

(:objects 	
		policechief - police
		firechief   - fire
		medicchief  - medic
		transportchief - transport
		apachestation courtstation substation - policestation
		adminfire mesafire scottsfire phxfire guadafire - firestation
		lukes joseph banner - hospital
		lake mill marketplace rural byeng - pois
)

(:init
	(fire_at byeng)
	;;(small_fire_at byeng)

	(= (total-cost) 0.0)

	(= (has_police_car_number apachestation) 6.0)
	(= (has_police_car_number courtstation) 6.0)
	(= (has_police_car_number substation) 6.0)

	(= (has_policemen_number apachestation) 6.0)
	(= (has_policemen_number courtstation) 6.0)
	(= (has_policemen_number substation) 6.0)

	(= (has_small_engines_number adminfire) 6.0)
	(= (has_small_engines_number mesafire) 6.0)
	(= (has_small_engines_number scottsfire) 6.0)
	(= (has_small_engines_number phxfire) 6.0)
	(= (has_small_engines_number guadafire) 6.0)

	(= (has_big_engines_number adminfire) 6.0)
	(= (has_big_engines_number mesafire) 6.0)
	(= (has_big_engines_number scottsfire) 6.0)
	(= (has_big_engines_number phxfire) 6.0)
	(= (has_big_engines_number guadafire) 6.0)

	(= (has_ladders_number adminfire) 6.0)
	(= (has_ladders_number mesafire) 6.0)
	(= (has_ladders_number scottsfire) 6.0)
	(= (has_ladders_number phxfire) 6.0)
	(= (has_ladders_number guadafire) 6.0)

	(= (has_bulldozers_number adminfire) 6.0)
	(= (has_bulldozers_number mesafire) 6.0)
	(= (has_bulldozers_number scottsfire) 6.0)
	(= (has_bulldozers_number phxfire) 6.0)
	(= (has_bulldozers_number guadafire) 6.0)

	(= (has_helicopters_number adminfire) 6.0)
	(= (has_helicopters_number mesafire) 6.0)
	(= (has_helicopters_number scottsfire) 6.0)
	(= (has_helicopters_number phxfire) 6.0)
	(= (has_helicopters_number guadafire) 6.0)

	(= (has_rescuers_number adminfire) 6.0)
	(= (has_rescuers_number mesafire) 6.0)
	(= (has_rescuers_number scottsfire) 6.0)
	(= (has_rescuers_number phxfire) 6.0)
	(= (has_rescuers_number guadafire) 6.0)

	(= (has_ambulances_number lukes) 6.0)
	(= (has_ambulances_number joseph) 6.0)
	(= (has_ambulances_number banner) 6.0)

	(= (duration_unit_actions) 1.0)
	(= (duration_deploy_police_cars) 1.0)
	(= (duration_deploy_small_engines) 2.0)
	(= (duration_deploy_big_engines) 4.0)
	(= (duration_deploy_ladders) 3.0)
	(= (duration_deploy_bulldozers) 3.0)
	(= (duration_deploy_helicopters) 3.0)
	(= (duration_deploy_rescuers) 3.0)
	(= (duration_deploy_ambulances) 2.0)
	(= (duration_position_policemen) 1.0)
	(= (duration_contact_media) 1.0)
	(= (duration_set_up_helpline) 1.0)
	(= (duration_issue_local_alert) 1.0)
	(= (duration_block_road) 2.0)
	(= (duration_prepare_evacuation) 1.0)
	(= (duration_evacuation) 5.0)
	(= (duration_extinguish_small_fire) 1.0)
	(= (duration_extinguish_big_fire) 1.0)
	(= (duration_barricade) 1.0)
	(= (duration_search_casualties) 3.0)
	(= (duration_attend_casualties) 3.0)
	(= (duration_address_media) 2.0)
)

(:goal (and
       	(extinguished_fire byeng)
       	(addressed_media)
		;;not needed effects -- all combinations
))

(:metric minimize (total-cost))

)
