(define
	(problem grounded-BYENG)
	(:domain grounded-RADAR)
	(:init
		(= (total-cost) 0)
		( FIRE_AT_BYENG )
		( NOT_EXPLAINED_ADDRESS_MEDIA_POLICECHIEF_1 )
		( NOT_EXPLAINED_FULL_OBS_SEQUENCE )
	)
	(:goal
		(and 
		( ADDRESSED_MEDIA )
		( EXTINGUISHED_FIRE_BYENG )
		( EXPLAINED_FULL_OBS_SEQUENCE )
		)
	)
	(:metric minimize (total-cost))

)
