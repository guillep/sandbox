Extension { #name : 'Process' }

{ #category : '*Domains' }
Process >> currentDomain [

	<nonDomainMediated>
	^ currentDomain
]

{ #category : '*Domains' }
Process >> currentDomain: aDomain [

	<nonDomainMediated>
	"Context>>step may step over the following code non atomically.
	Thus, we could observe these variables in an incoherent state.
	
	The code below manages two cases:
		defaultDomain (nil) -> non default domain (sandbox)
		non default domain (sandbox) -> defaultDomain (nil)
		
	What should happen in the following case?
		non default domain (sandbox1) -> non default domain (sandbox2)
	"
	aDomain
		ifNil: [
			"If the new domain is nil, first tell the process to use the default.
			Thus, the currentDomain will not be used."
			currentDomainIsDefault := aDomain == nil.
			currentDomain := aDomain ]
		ifNotNil: [
			"If the new domain is not nil, first set it.
			It will not be used until the flag is set"
			currentDomain := aDomain.
			currentDomainIsDefault := aDomain == nil ]
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
	"shouldOverflow := true."
	currentDomainIsDefault := true
]

{ #category : '*Domains' }
Process >> popScope [

	<nonDomainMediated>
	currentDomain ifNotNil: [
		self currentDomain: currentDomain previous ]
]

{ #category : '*Domains' }
Process >> pushScope: aDomain [

	<nonDomainMediated>
	| previousScope |
	previousScope := currentDomain.
	aDomain ifNotNil: [
		aDomain previous: previousScope ].
	
	self currentDomain: aDomain
]

{ #category : '*Domains' }
Process >> unmediatedDo: aBlock [

	| domain |
	domain := self currentDomain.
	self currentDomain: nil.
	aBlock ensure: [ self currentDomain: domain ].
]
