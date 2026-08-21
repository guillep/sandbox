writing
owns: newInstance

	^ newInstance isClass
		ifTrue: [ ownedBehaviors includes: newInstance ]
		ifFalse: [ owned includes: newInstance ]