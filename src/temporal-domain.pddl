(define (domain RADAR)

(:requirements :typing :durative-actions :fluents)

;; TYPES
(:types		police fire transport medic - agents
			hospital policestation firestation pois - location
)

;; PREDICATES

(:predicates	(alerted ?loc - location)
	     		(updated ?a - agents)
	     		(deployed_police_cars ?at - location)
	     		(deployed_engines ?at - location)
	     		(deployed_small_engines ?at - location)
	     		(deployed_big_engines ?at - location)
	     		(deployed_ladders ?at - location)
	     		(deployed_bulldozers ?at - location)
	     		(deployed_helicopters ?at - location)
	     		(deployed_rescuers ?at - location)
	     		(deployed_ambulances ?at - location)
	     		(positioned_policemen ?at - location)
	     		(media_contacted ?a - agents)
	     		(active_helpline ?a - agents)
	     		(active_local_alert ?a - agents)
	     		(blocked_road ?from - location ?to - location)
	     		(traffic_diverted ?from - location ?to - location)
	     		(prepared_evacuation ?from - location)
	     		(evacuated ?from - location ?to - location)
	     		(extinguished_fire ?at - location)
	     		(fire_at ?at - location)
	     		(small_fire_at ?at - location)
	     		(barricaded ?at - location)
	     		(searched ?at - location)
	     		(attended_casualties ?at - location)
	     		(addressed_media)
	     		(needed_barricade ?at - location)
	     		(needed_active_local_alert ?a - agents)
	     		(needed_diverted_traffic ?from - location ?to - location)
	     		(needed_search_casualties ?at - location)
	     		(needed_attend_casualties ?at - location)
	     		(needed_address_media)
)


;; FUNCTIONS 

(:functions 
	(has_police_car_number ?at - policestation)
	(has_policemen_number ?at - policestation)
	(has_small_engines_number ?at - firestation)
	(has_big_engines_number ?at - firestation)
	(has_ladders_number ?at - firestation)
	(has_bulldozers_number ?at - firestation)
	(has_helicopters_number ?at - firestation)
	(has_rescuers_number ?at - firestation)
	(has_ambulances_number ?at - hospital)
	(duration_unit_actions)
	(duration_deploy_police_cars)
	(duration_deploy_small_engines)
	(duration_deploy_big_engines)
	(duration_deploy_ladders)
	(duration_deploy_bulldozers)
	(duration_deploy_helicopters)
	(duration_deploy_rescuers)
	(duration_deploy_ambulances)
	(duration_position_policemen)
	(duration_contact_media)
	(duration_set_up_helpline)
	(duration_issue_local_alert)
	(duration_block_road)
	(duration_prepare_evacuation)
	(duration_evacuation)
	(duration_extinguish_small_fire)
	(duration_extinguish_big_fire)
	(duration_barricade)
	(duration_search_casualties)
	(duration_attend_casualties)
	(duration_address_media)
)

;; ACTIONS / OPERATORS

(:durative-action alert 
 	:parameters	(?a - agents ?loc - location)
 	:duration 	(= ?duration (duration_unit_actions))
 	:condition 	(and
 				)
 	:effect		(and	
 					(at end (alerted ?loc))
 				)
) 	    	 


(:durative-action update
 	:parameters	(?a - agents)
 	:duration 	(= ?duration (duration_unit_actions))
 	:condition 	(and
 				)
 	:effect		(and	
 					(at end (updated ?a))
 				)
) 	    	 


(:durative-action deploy_police_cars
	:parameters	(?a - police ?from - policestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_police_cars))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_police_car_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_police_cars ?to))
					(at end (decrease (has_police_car_number ?from) 1.0))
 				)
)

(:durative-action deploy_small_engines
	:parameters	(?a - fire ?from - firestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_small_engines))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_small_engines_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_engines ?to))
 					(at end (deployed_small_engines ?to))
 					(at end (needed_barricade ?to))
					(at end (decrease (has_small_engines_number ?from) 1.0))
 				)
)

(:durative-action deploy_big_engines
	:parameters	(?a - fire ?from - firestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_big_engines))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_big_engines_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_engines ?to))
 					(at end (deployed_big_engines ?to))
 					(at end (needed_barricade ?to))
					(at end (decrease (has_big_engines_number ?from) 1.0))
 				)
)

(:durative-action deploy_ladders
	:parameters	(?a - fire ?from - firestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_ladders))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(at start (deployed_big_engines ?to))
 					(over all (alerted ?from))
 					(over all (deployed_big_engines ?to))
					(at start (>= (has_ladders_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_ladders ?to))
					(at end (decrease (has_ladders_number ?from) 1.0))
 				)
)

(:durative-action deploy_bulldozers
	:parameters	(?a - fire ?from - firestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_bulldozers))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_bulldozers_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_bulldozers ?to))
					(at end (decrease (has_bulldozers_number ?from) 1.0))
 				)
)

(:durative-action deploy_helicopters
	:parameters	(?a - fire ?from - firestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_helicopters))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_helicopters_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_helicopters ?to))
					(at end (decrease (has_helicopters_number ?from) 1.0))
 				)
)

(:durative-action deploy_rescuers
	:parameters	(?a - fire ?from - firestation ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_rescuers))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_rescuers_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_rescuers ?to))
					(at end (decrease (has_rescuers_number ?from) 1.0))
 				)
)

(:durative-action deploy_ambulances
	:parameters	(?a - police ?from - hospital ?to - pois) 
 	:duration 	(= ?duration (duration_deploy_ambulances))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_ambulances_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (deployed_ambulances ?to))
					(at end (decrease (has_ambulances_number ?from) 1.0))
 				)
)

(:durative-action position_policemen
	:parameters	(?a - police ?from - policestation ?to - pois) 
 	:duration 	(= ?duration (duration_position_policemen))
 	:condition 	(and	
 					(at start (alerted ?from))
 					(over all (alerted ?from))
					(at start (>= (has_policemen_number ?from) 1.0))
				)
 	:effect		(and	
 					(at end (not (alerted ?from)))
 					(at end (positioned_policemen ?to))
 				)
)

(:durative-action contact_media
	:parameters	(?a - agents) 
 	:duration 	(= ?duration (duration_contact_media))
 	:condition 	(and	
				)
 	:effect		(and	
 					(at end (media_contacted ?a))
 				)
)

(:durative-action set_up_helpline
	:parameters	(?a - agents) 
 	:duration 	(= ?duration (duration_set_up_helpline))
 	:condition 	(and	
 					(at start (media_contacted ?a))
 					(over all (media_contacted ?a))
				)
 	:effect		(and	
 					(at end (active_helpline ?a))
 				)
)

(:durative-action issue_local_alert
	:parameters	(?a - agents) 
 	:duration 	(= ?duration (duration_issue_local_alert))
 	:condition 	(and	
 					(at start (media_contacted ?a))
 					(over all (media_contacted ?a))
				)
 	:effect		(and	
 					(at end (active_local_alert ?a))
 					(at end (not (needed_active_local_alert ?a)))
 				)
)

(:durative-action block_road
	:parameters	(?a - transport ?from - location ?to - location) 
 	:duration 	(= ?duration (duration_block_road))
 	:condition 	(and	
 					(at start (active_local_alert ?a))
 					(over all (active_local_alert ?a))
 					(at start (positioned_policemen ?to))
 					(over all (positioned_policemen ?to))
 					(at start (deployed_police_cars ?to))
 					(over all (deployed_police_cars ?to))
 					(at start (positioned_policemen ?from))
 					(over all (positioned_policemen ?from))
 					(at start (deployed_police_cars ?from))
 					(over all (deployed_police_cars ?from))
				)
 	:effect		(and	
 					(at end (blocked_road ?from ?to))
 					(at end (needed_diverted_traffic ?from ?to))
 					(at end (needed_active_local_alert ?a))
 				)
)

(:durative-action divert_traffic
	:parameters	(?a - transport ?from - location ?to - location) 
 	:duration 	(= ?duration (duration_unit_actions))
 	:condition 	(and	
 					(at start (active_local_alert ?a))
 					(over all (active_local_alert ?a))
 					(at start (blocked_road ?from ?to))
 					(over all (blocked_road ?from ?to))
				)
 	:effect		(and	
 					(at end (traffic_diverted ?from ?to))
 					(at end (not (needed_diverted_traffic ?from ?to)))
 				)
)

(:durative-action prepare_evacuation
	:parameters	(?a - police ?from - location) 
 	:duration 	(= ?duration (duration_prepare_evacuation))
 	:condition 	(and	
 					(at start (active_local_alert ?a))
 					(over all (active_local_alert ?a))
				)
 	:effect		(and	
 					(at end (prepared_evacuation ?from))
 				)
)

(:durative-action evacuate
	:parameters	(?a - police ?from - location ?to - location) 
 	:duration 	(= ?duration (duration_evacuation))
 	:condition 	(and	
 					(at start (prepared_evacuation ?from))
 					(over all (prepared_evacuation ?from))
 					(at start (positioned_policemen ?from))
 					(over all (positioned_policemen ?from))
 					(at start (deployed_police_cars ?from))
 					(over all (deployed_police_cars ?from))
 					(at start (blocked_road ?from ?to))
 					(over all (blocked_road ?from ?to))
				)
 	:effect		(and	
 					(at end (evacuated ?from ?to))
 				)
)

(:durative-action extinguish_small_fire 
	:parameters	(?a - fire ?at - pois) 
 	:duration 	(= ?duration (duration_extinguish_small_fire))
 	:condition 	(and	
 					(at start (fire_at ?at))
 					(at start (small_fire_at ?at))
 					(at start (deployed_engines ?at))
 					(over all (deployed_engines ?at))
				)
 	:effect		(and	
 					(at end (extinguished_fire ?at))
 					(at end (not (fire_at ?at)))
 					(at end (needed_address_media))
 					(at end (needed_search_casualties ?at))
 				)
)

(:durative-action extinguish_big_fire 
	:parameters	(?a - fire ?at - pois) 
 	:duration 	(= ?duration (duration_extinguish_big_fire))
 	:condition 	(and	
 					(at start (fire_at ?at))
 					(at start (deployed_big_engines ?at))
 					(over all (deployed_big_engines ?at))
				)
 	:effect		(and	
 					(at end (extinguished_fire ?at))
 					(at end (not (fire_at ?at)))
 					(at end (needed_search_casualties ?at))
 				)
)

(:durative-action barricade
	:parameters	(?a - fire ?at - pois) 
 	:duration 	(= ?duration (duration_barricade))
 	:condition 	(and	
 					(at start (deployed_engines ?at))
 					(over all (deployed_engines ?at))
				)
 	:effect		(and	
 					(at end (barricaded ?at))
 					(at end (needed_active_local_alert ?a))
 					(at end (not (needed_barricade ?at)))
 				)
)

(:durative-action search_casualties
	:parameters	(?a - fire ?at - pois) 
 	:duration 	(= ?duration (duration_search_casualties))
 	:condition 	(and	
 					(at start (extinguished_fire ?at))
 					(over all (extinguished_fire ?at))
 					(at start (deployed_bulldozers ?at))
 					(over all (deployed_bulldozers ?at))
 					(at start (deployed_helicopters ?at))
 					(over all (deployed_helicopters ?at))
 					(at start (deployed_rescuers ?at))
 					(over all (deployed_rescuers ?at))
				)
 	:effect		(and	
 					(at end (searched ?at))
 					(at end (needed_attend_casualties ?at))
 					(at end (needed_address_media))
 				)
)

(:durative-action attend_casualties
	:parameters	(?a - medic ?at - pois) 
 	:duration 	(= ?duration (duration_attend_casualties))
 	:condition 	(and	
 					(at start (needed_attend_casualties ?at))
 					(at start (deployed_ambulances ?at))
 					(over all (deployed_ambulances ?at))
				)
 	:effect		(and	
 					(at end (attended_casualties ?at))
 					(at end (not (needed_attend_casualties ?at)))
 					(at end (needed_address_media))
 				)
)

(:durative-action address_media
	:parameters	(?a - agents ?at - pois) 
 	:duration 	(= ?duration (duration_address_media))
 	:condition 	(and	
 					(at start (media_contacted ?a))
 					(over all (media_contacted ?a))
 					(at start (needed_address_media))
				)
 	:effect		(and	
 					(at end (addressed_media))
 					(at end (not (needed_address_media)))
 				)
)

)