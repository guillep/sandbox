*Domains
shallowCopy

	Processor activeProcess currentDomainIsDefault ifTrue: [ ^ self doShallowCopy ].
	^ Processor activeProcess currentDomain shallowCopy: self