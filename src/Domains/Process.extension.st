Extension { #name : 'Process' }

{ #category : '*Domains' }
Process >> currentDomain [

	<nonDomainMediated>
	^ currentDomain
]

{ #category : '*Domains' }
Process >> currentDomain: aDomain [

	<nonDomainMediated>
	currentDomain := aDomain.
	currentDomainIsDefault := aDomain isNil
]

{ #category : '*Domains' }
Process >> currentDomainIsDefault [

	<nonDomainMediated>
	^ currentDomainIsDefault
]

{ #category : '*Domains' }
Process >> effectiveProcess: aProcess [

	<nonDomainMediated>
	effectiveProcess := aProcess
]

{ #category : '*Domains' }
Process >> initialize [
	super initialize.

	terminating := false.
	currentDomainIsDefault := true
]

{ #category : '*Domains' }
Process >> popScope [

	<nonDomainMediated>
	currentDomain ifNotNil: [
		currentDomain := currentDomain previous.
		currentDomainIsDefault := currentDomain isNil]
]

{ #category : '*Domains' }
Process >> pushScope: aDomain [

	<nonDomainMediated>
	| previousScope |
	previousScope := currentDomain.
	aDomain ifNotNil: [
		aDomain previous: previousScope ].
	
	currentDomain := aDomain.
	currentDomainIsDefault := aDomain isNil
]
