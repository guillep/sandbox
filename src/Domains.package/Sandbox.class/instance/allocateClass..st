writing
allocateClass: aClass

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := aClass doBasicNew.
	
	self own: newInstance.

	"Add could make the array grow, thus we need to own it too.
	If the array did not grow the following line will do nothing because the array is already there.
	If the array did grow, it will not grow again right away, the next grow threshold is faaar away.
	Should we remove the old array?"
	self own: owned array.
	
	Processor activeProcess currentDomain: self.
	^ newInstance