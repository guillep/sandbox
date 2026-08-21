*Domains
new

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew ].
	^ thisProcess currentDomain allocateClass: self