writing
own: newInstance

	owned isImmediateObject ifTrue: [ ^ self ].
	newInstance isClass
		ifTrue: [ ownedBehaviors add: newInstance ]
		ifFalse: [ owned add: newInstance ]