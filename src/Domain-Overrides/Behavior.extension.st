Extension { #name : 'Behavior' }

{ #category : '*Domain-Overrides' }
Behavior >> basicNew [

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew ].
	^ thisProcess currentDomain allocateClass: self
]

{ #category : '*Domain-Overrides' }
Behavior >> basicNew: sizeRequested [

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew: sizeRequested ].
	^ thisProcess currentDomain allocateClass: self size: sizeRequested
]
