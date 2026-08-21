*Domains
basicNew: sizeRequested

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew: sizeRequested ].
	^ thisProcess currentDomain allocateClass: self size: sizeRequested