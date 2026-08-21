Extension { #name : 'Interval' }

{ #category : '*Domain-Overrides' }
Interval class >> new [

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew ].
	^ thisProcess currentDomain allocateClass: self
]
