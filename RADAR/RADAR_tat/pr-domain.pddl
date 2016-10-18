(define
	(domain grounded-RADAR)
	(:requirements :strips :action-costs)
	(:predicates
		( ALERTED_APACHESTATION )
		( ALERTED_MESAFIRE )
		( ALERTED_LUKES )
		( ALERTED_BYENG )
		( UPDATED_POLICECHIEF )
		( UPDATED_FIRECHIEF )
		( UPDATED_MEDICHIEF )
		( UPDATED_TRANSPORTCHIEF )
		( DEPLOYED_POLICE_CARS_BYENG )
		( DEPLOYED_ENGINES_BYENG )
		( DEPLOYED_SMALL_ENGINES_BYENG )
		( NEEDED_BARRICADE_BYENG )
		( DEPLOYED_BIG_ENGINES_BYENG )
		( DEPLOYED_LADDERS_BYENG )
		( DEPLOYED_BULLDOZERS_BYENG )
		( DEPLOYED_HELICOPTERS_BYENG )
		( DEPLOYED_RESCUERS_BYENG )
		( DEPLOYED_AMBULANCES_BYENG )
		( POSITIONED_POLICEMEN_BYENG )
		( MEDIA_CONTACTED_POLICECHIEF )
		( MEDIA_CONTACTED_FIRECHIEF )
		( MEDIA_CONTACTED_MEDICHIEF )
		( MEDIA_CONTACTED_TRANSPORTCHIEF )
		( ACTIVE_HELPLINE_POLICECHIEF )
		( ACTIVE_HELPLINE_FIRECHIEF )
		( ACTIVE_HELPLINE_MEDICHIEF )
		( ACTIVE_HELPLINE_TRANSPORTCHIEF )
		( ACTIVE_LOCAL_ALERT_POLICECHIEF )
		( ACTIVE_LOCAL_ALERT_FIRECHIEF )
		( ACTIVE_LOCAL_ALERT_MEDICHIEF )
		( ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
		( BLOCKED_ROAD_BYENG_BYENG )
		( NEEDED_DIVERTED_TRAFFIC_BYENG_BYENG )
		( NEEDED_ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
		( TRAFFIC_DIVERTED_BYENG_BYENG )
		( NOT_NEEDED_DIVERTED_TRAFFIC_BYENG_BYENG )
		( PREPARED_EVACUATION_APACHESTATION )
		( PREPARED_EVACUATION_MESAFIRE )
		( PREPARED_EVACUATION_LUKES )
		( PREPARED_EVACUATION_BYENG )
		( EVACUATED_BYENG_BYENG )
		( EXTINGUISHED_FIRE_BYENG )
		( NEEDED_SEARCH_CASUALTIES_BYENG )
		( BARRICADED_BYENG )
		( NEEDED_ACTIVE_LOCAL_ALERT_FIRECHIEF )
		( NOT_NEEDED_BARRICADE_BYENG )
		( SEARCHED_BYENG )
		( NEEDED_ATTEND_CASUALTIES_BYENG )
		( NEEDED_ADDRESS_MEDIA )
		( ATTENDED_CASUALTIES_BYENG )
		( ADDRESSED_MEDIA )
		( NOT_NEEDED_ADDRESS_MEDIA )
		( NOT_NEEDED_ATTEND_CASUALTIES_BYENG )
		( NOT_NEEDED_ACTIVE_LOCAL_ALERT_FIRECHIEF )
		( FIRE_AT_BYENG )
		( NOT_NEEDED_SEARCH_CASUALTIES_BYENG )
		( NOT_NEEDED_ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
		( HAS_AMBULANCES_NUMBER_LUKES )
		( HAS_RESCUERS_NUMBER_MESAFIRE )
		( HAS_HELICOPTERS_NUMBER_MESAFIRE )
		( HAS_BULLDOZERS_NUMBER_MESAFIRE )
		( HAS_LADDERS_NUMBER_MESAFIRE )
		( HAS_BIG_ENGINES_NUMBER_MESAFIRE )
		( HAS_SMALL_ENGINES_NUMBER_MESAFIRE )
		( HAS_POLICE_CAR_NUMBER_APACHESTATION )
		( EXPLAINED_FULL_OBS_SEQUENCE )
		( NOT_EXPLAINED_FULL_OBS_SEQUENCE )
	) 
	(:action ADDRESS_MEDIA_TRANSPORTCHIEF
		:parameters ()
		:precondition
		(and
			( NEEDED_ADDRESS_MEDIA )
			( MEDIA_CONTACTED_TRANSPORTCHIEF )
		)
		:effect
		(and
			( ADDRESSED_MEDIA )
			( NOT_NEEDED_ADDRESS_MEDIA )
			(not ( NEEDED_ADDRESS_MEDIA ))
		)
	)
	(:action ADDRESS_MEDIA_MEDICHIEF
		:parameters ()
		:precondition
		(and
			( NEEDED_ADDRESS_MEDIA )
			( MEDIA_CONTACTED_MEDICHIEF )
		)
		:effect
		(and
			( ADDRESSED_MEDIA )
			( NOT_NEEDED_ADDRESS_MEDIA )
			(not ( NEEDED_ADDRESS_MEDIA ))
		)
	)
	(:action ADDRESS_MEDIA_FIRECHIEF
		:parameters ()
		:precondition
		(and
			( NEEDED_ADDRESS_MEDIA )
			( MEDIA_CONTACTED_FIRECHIEF )
		)
		:effect
		(and
			( ADDRESSED_MEDIA )
			( NOT_NEEDED_ADDRESS_MEDIA )
			(not ( NEEDED_ADDRESS_MEDIA ))
		)
	)
	(:action ADDRESS_MEDIA_POLICECHIEF
		:parameters ()
		:precondition
		(and
			( NEEDED_ADDRESS_MEDIA )
			( MEDIA_CONTACTED_POLICECHIEF )
		)
		:effect
		(and
			( ADDRESSED_MEDIA )
			( NOT_NEEDED_ADDRESS_MEDIA )
			(not ( NEEDED_ADDRESS_MEDIA ))
		)
	)
	(:action ATTEND_CASUALTIES_MEDICHIEF_BYENG
		:parameters ()
		:precondition
		(and
			( DEPLOYED_AMBULANCES_BYENG )
			( NEEDED_ATTEND_CASUALTIES_BYENG )
		)
		:effect
		(and
			( ATTENDED_CASUALTIES_BYENG )
			( NOT_NEEDED_ATTEND_CASUALTIES_BYENG )
			( NEEDED_ADDRESS_MEDIA )
			(not ( NEEDED_ATTEND_CASUALTIES_BYENG ))
			(not ( NOT_NEEDED_ADDRESS_MEDIA ))
		)
	)
	(:action SEARCH_CASUALTIES_FIRECHIEF_BYENG
		:parameters ()
		:precondition
		(and
			( DEPLOYED_RESCUERS_BYENG )
			( DEPLOYED_HELICOPTERS_BYENG )
			( DEPLOYED_BULLDOZERS_BYENG )
			( EXTINGUISHED_FIRE_BYENG )
		)
		:effect
		(and
			( SEARCHED_BYENG )
			( NEEDED_ATTEND_CASUALTIES_BYENG )
			( NEEDED_ADDRESS_MEDIA )
			(not ( NOT_NEEDED_ATTEND_CASUALTIES_BYENG ))
			(not ( NOT_NEEDED_ADDRESS_MEDIA ))
		)
	)
	(:action BARRICADE_FIRECHIEF_BYENG
		:parameters ()
		:precondition
		(and
			( DEPLOYED_ENGINES_BYENG )
		)
		:effect
		(and
			( BARRICADED_BYENG )
			( NEEDED_ACTIVE_LOCAL_ALERT_FIRECHIEF )
			( NOT_NEEDED_BARRICADE_BYENG )
			(not ( NOT_NEEDED_ACTIVE_LOCAL_ALERT_FIRECHIEF ))
			(not ( NEEDED_BARRICADE_BYENG ))
		)
	)
	(:action EXTINGUISH_BIG_FIRE_FIRECHIEF_BYENG
		:parameters ()
		:precondition
		(and
			( DEPLOYED_BIG_ENGINES_BYENG )
			( FIRE_AT_BYENG )
		)
		:effect
		(and
			( EXTINGUISHED_FIRE_BYENG )
			( NEEDED_SEARCH_CASUALTIES_BYENG )
			(not ( FIRE_AT_BYENG ))
			(not ( NOT_NEEDED_SEARCH_CASUALTIES_BYENG ))
		)
	)
	(:action EVACUATE_POLICECHIEF_BYENG_BYENG
		:parameters ()
		:precondition
		(and
			( BLOCKED_ROAD_BYENG_BYENG )
			( DEPLOYED_POLICE_CARS_BYENG )
			( POSITIONED_POLICEMEN_BYENG )
			( PREPARED_EVACUATION_BYENG )
		)
		:effect
		(and
			( EVACUATED_BYENG_BYENG )
		)
	)
	(:action PREPARE_EVACUATION_POLICECHIEF_BYENG
		:parameters ()
		:precondition
		(and
			( ACTIVE_LOCAL_ALERT_POLICECHIEF )
		)
		:effect
		(and
			( PREPARED_EVACUATION_BYENG )
		)
	)
	(:action PREPARE_EVACUATION_POLICECHIEF_LUKES
		:parameters ()
		:precondition
		(and
			( ACTIVE_LOCAL_ALERT_POLICECHIEF )
		)
		:effect
		(and
			( PREPARED_EVACUATION_LUKES )
		)
	)
	(:action PREPARE_EVACUATION_POLICECHIEF_MESAFIRE
		:parameters ()
		:precondition
		(and
			( ACTIVE_LOCAL_ALERT_POLICECHIEF )
		)
		:effect
		(and
			( PREPARED_EVACUATION_MESAFIRE )
		)
	)
	(:action PREPARE_EVACUATION_POLICECHIEF_APACHESTATION
		:parameters ()
		:precondition
		(and
			( ACTIVE_LOCAL_ALERT_POLICECHIEF )
		)
		:effect
		(and
			( PREPARED_EVACUATION_APACHESTATION )
		)
	)
	(:action DIVERT_TRAFFIC_TRANSPORTCHIEF_BYENG_BYENG
		:parameters ()
		:precondition
		(and
			( BLOCKED_ROAD_BYENG_BYENG )
			( ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
		)
		:effect
		(and
			( TRAFFIC_DIVERTED_BYENG_BYENG )
			( NOT_NEEDED_DIVERTED_TRAFFIC_BYENG_BYENG )
			(not ( NEEDED_DIVERTED_TRAFFIC_BYENG_BYENG ))
		)
	)
	(:action BLOCK_ROAD_TRANSPORTCHIEF_BYENG_BYENG
		:parameters ()
		:precondition
		(and
			( DEPLOYED_POLICE_CARS_BYENG )
			( POSITIONED_POLICEMEN_BYENG )
			( ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
		)
		:effect
		(and
			( BLOCKED_ROAD_BYENG_BYENG )
			( NEEDED_DIVERTED_TRAFFIC_BYENG_BYENG )
			( NEEDED_ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
			(not ( NOT_NEEDED_DIVERTED_TRAFFIC_BYENG_BYENG ))
			(not ( NOT_NEEDED_ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF ))
		)
	)
	(:action ISSUE_LOCAL_ALERT_TRANSPORTCHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_TRANSPORTCHIEF )
		)
		:effect
		(and
			( ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
			( NOT_NEEDED_ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF )
			(not ( NEEDED_ACTIVE_LOCAL_ALERT_TRANSPORTCHIEF ))
		)
	)
	(:action ISSUE_LOCAL_ALERT_MEDICHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_MEDICHIEF )
		)
		:effect
		(and
			( ACTIVE_LOCAL_ALERT_MEDICHIEF )
		)
	)
	(:action ISSUE_LOCAL_ALERT_FIRECHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_FIRECHIEF )
		)
		:effect
		(and
			( ACTIVE_LOCAL_ALERT_FIRECHIEF )
			( NOT_NEEDED_ACTIVE_LOCAL_ALERT_FIRECHIEF )
			(not ( NEEDED_ACTIVE_LOCAL_ALERT_FIRECHIEF ))
		)
	)
	(:action ISSUE_LOCAL_ALERT_POLICECHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_POLICECHIEF )
		)
		:effect
		(and
			( ACTIVE_LOCAL_ALERT_POLICECHIEF )
		)
	)
	(:action SET_UP_HELPLINE_TRANSPORTCHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_TRANSPORTCHIEF )
		)
		:effect
		(and
			( ACTIVE_HELPLINE_TRANSPORTCHIEF )
		)
	)
	(:action SET_UP_HELPLINE_MEDICHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_MEDICHIEF )
		)
		:effect
		(and
			( ACTIVE_HELPLINE_MEDICHIEF )
		)
	)
	(:action SET_UP_HELPLINE_FIRECHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_FIRECHIEF )
		)
		:effect
		(and
			( ACTIVE_HELPLINE_FIRECHIEF )
		)
	)
	(:action SET_UP_HELPLINE_POLICECHIEF
		:parameters ()
		:precondition
		(and
			( MEDIA_CONTACTED_POLICECHIEF )
		)
		:effect
		(and
			( ACTIVE_HELPLINE_POLICECHIEF )
		)
	)
	(:action CONTACT_MEDIA_TRANSPORTCHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( MEDIA_CONTACTED_TRANSPORTCHIEF )
		)
	)
	(:action CONTACT_MEDIA_MEDICHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( MEDIA_CONTACTED_MEDICHIEF )
		)
	)
	(:action CONTACT_MEDIA_FIRECHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( MEDIA_CONTACTED_FIRECHIEF )
		)
	)
	(:action CONTACT_MEDIA_POLICECHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( MEDIA_CONTACTED_POLICECHIEF )
		)
	)
	(:action POSITION_POLICEMEN_POLICECHIEF_APACHESTATION_BYENG
		:parameters ()
		:precondition
		(and
			( ALERTED_APACHESTATION )
		)
		:effect
		(and
			( POSITIONED_POLICEMEN_BYENG )
			(not ( ALERTED_APACHESTATION ))
		)
	)
	(:action DEPLOY_AMBULANCES_POLICECHIEF_LUKES_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_AMBULANCES_NUMBER_LUKES )
			( ALERTED_LUKES )
		)
		:effect
		(and
			( DEPLOYED_AMBULANCES_BYENG )
			(not ( ALERTED_LUKES ))
			(not ( HAS_AMBULANCES_NUMBER_LUKES ))
		)
	)
	(:action DEPLOY_RESCUERS_FIRECHIEF_MESAFIRE_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_RESCUERS_NUMBER_MESAFIRE )
			( ALERTED_MESAFIRE )
		)
		:effect
		(and
			( DEPLOYED_RESCUERS_BYENG )
			(not ( ALERTED_MESAFIRE ))
			(not ( HAS_RESCUERS_NUMBER_MESAFIRE ))
		)
	)
	(:action DEPLOY_HELICOPTERS_FIRECHIEF_MESAFIRE_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_HELICOPTERS_NUMBER_MESAFIRE )
			( ALERTED_MESAFIRE )
		)
		:effect
		(and
			( DEPLOYED_HELICOPTERS_BYENG )
			(not ( ALERTED_MESAFIRE ))
			(not ( HAS_HELICOPTERS_NUMBER_MESAFIRE ))
		)
	)
	(:action DEPLOY_BULLDOZERS_FIRECHIEF_MESAFIRE_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_BULLDOZERS_NUMBER_MESAFIRE )
			( ALERTED_MESAFIRE )
		)
		:effect
		(and
			( DEPLOYED_BULLDOZERS_BYENG )
			(not ( ALERTED_MESAFIRE ))
			(not ( HAS_BULLDOZERS_NUMBER_MESAFIRE ))
		)
	)
	(:action DEPLOY_LADDERS_FIRECHIEF_MESAFIRE_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_LADDERS_NUMBER_MESAFIRE )
			( DEPLOYED_BIG_ENGINES_BYENG )
			( ALERTED_MESAFIRE )
		)
		:effect
		(and
			( DEPLOYED_LADDERS_BYENG )
			(not ( ALERTED_MESAFIRE ))
			(not ( HAS_LADDERS_NUMBER_MESAFIRE ))
		)
	)
	(:action DEPLOY_BIG_ENGINES_FIRECHIEF_MESAFIRE_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_BIG_ENGINES_NUMBER_MESAFIRE )
			( ALERTED_MESAFIRE )
		)
		:effect
		(and
			( DEPLOYED_ENGINES_BYENG )
			( DEPLOYED_BIG_ENGINES_BYENG )
			( NEEDED_BARRICADE_BYENG )
			(not ( ALERTED_MESAFIRE ))
			(not ( NOT_NEEDED_BARRICADE_BYENG ))
			(not ( HAS_BIG_ENGINES_NUMBER_MESAFIRE ))
		)
	)
	(:action DEPLOY_SMALL_ENGINES_FIRECHIEF_MESAFIRE_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_SMALL_ENGINES_NUMBER_MESAFIRE )
			( ALERTED_MESAFIRE )
		)
		:effect
		(and
			( DEPLOYED_ENGINES_BYENG )
			( DEPLOYED_SMALL_ENGINES_BYENG )
			( NEEDED_BARRICADE_BYENG )
			(not ( ALERTED_MESAFIRE ))
			(not ( NOT_NEEDED_BARRICADE_BYENG ))
			(not ( HAS_SMALL_ENGINES_NUMBER_MESAFIRE ))
		)
	)
	(:action DEPLOY_POLICE_CARS_POLICECHIEF_APACHESTATION_BYENG
		:parameters ()
		:precondition
		(and
			( HAS_POLICE_CAR_NUMBER_APACHESTATION )
			( ALERTED_APACHESTATION )
		)
		:effect
		(and
			( DEPLOYED_POLICE_CARS_BYENG )
			(not ( ALERTED_APACHESTATION ))
			(not ( HAS_POLICE_CAR_NUMBER_APACHESTATION ))
		)
	)
	(:action UPDATE_TRANSPORTCHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( UPDATED_TRANSPORTCHIEF )
		)
	)
	(:action UPDATE_MEDICHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( UPDATED_MEDICHIEF )
		)
	)
	(:action UPDATE_FIRECHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( UPDATED_FIRECHIEF )
		)
	)
	(:action UPDATE_POLICECHIEF
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( UPDATED_POLICECHIEF )
		)
	)
	(:action ALERT_TRANSPORTCHIEF_BYENG
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_BYENG )
		)
	)
	(:action ALERT_TRANSPORTCHIEF_LUKES
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_LUKES )
		)
	)
	(:action ALERT_TRANSPORTCHIEF_MESAFIRE
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_MESAFIRE )
		)
	)
	(:action ALERT_TRANSPORTCHIEF_APACHESTATION
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_APACHESTATION )
		)
	)
	(:action ALERT_MEDICHIEF_BYENG
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_BYENG )
		)
	)
	(:action ALERT_MEDICHIEF_LUKES
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_LUKES )
		)
	)
	(:action ALERT_MEDICHIEF_MESAFIRE
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_MESAFIRE )
		)
	)
	(:action ALERT_MEDICHIEF_APACHESTATION
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_APACHESTATION )
		)
	)
	(:action ALERT_FIRECHIEF_BYENG
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_BYENG )
		)
	)
	(:action ALERT_FIRECHIEF_LUKES
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_LUKES )
		)
	)
	(:action ALERT_FIRECHIEF_MESAFIRE
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_MESAFIRE )
		)
	)
	(:action ALERT_FIRECHIEF_APACHESTATION
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_APACHESTATION )
		)
	)
	(:action ALERT_POLICECHIEF_BYENG
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_BYENG )
		)
	)
	(:action ALERT_POLICECHIEF_LUKES
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_LUKES )
		)
	)
	(:action ALERT_POLICECHIEF_MESAFIRE
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_MESAFIRE )
		)
	)
	(:action ALERT_POLICECHIEF_APACHESTATION
		:parameters ()
		:precondition
		(and
		)
		:effect
		(and
			( ALERTED_APACHESTATION )
		)
	)

)
