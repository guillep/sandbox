*Domains
basicNew

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew ].
	^ thisProcess currentDomain allocateClass: self