Extension { #name : 'Object' }

{ #category : '*Domain-Overrides' }
Object >> shallowCopy [

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doShallowCopy ].
	^ thisProcess currentDomain shallowCopy: self
]
