initialization
initialize
	super initialize.

	owned := IdentitySet new.
	owned add: self.
	owned add: owned.
	owned add: owned array.
	
	"Behaviors cannot be hashed before they are ready.
	We capture them at basicNew and they have no superclass, method dict, nor format.
	Store them in an ordered collection instead"
	ownedBehaviors := OrderedCollection new.
	
	classVarValues := Dictionary new.
	owned add: classVarValues.
	owned add: classVarValues array.