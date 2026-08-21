writing
shallowCopy: anObject

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := anObject doShallowCopy.
	
	self own: newInstance.
	
	Processor activeProcess currentDomain: self.
	^ newInstance