Extension { #name : 'Object' }

{ #category : '*Domain-Overrides' }
Object >> shallowCopy [

	Processor activeProcess currentDomainIsDefault ifTrue: [ ^ self doShallowCopy ].
	^ Processor activeProcess currentDomain shallowCopy: self
]
