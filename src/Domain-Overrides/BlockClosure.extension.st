Extension { #name : 'BlockClosure' }

{ #category : '*Domain-Overrides' }
BlockClosure >> newProcess [
	
	| isDefault current |
	isDefault := thisProcess currentDomainIsDefault.
	current := thisProcess currentDomain.

	^ isDefault
		ifTrue: [ self basicNewProcess ]
		ifFalse: [ current newProcess: self ]
]
