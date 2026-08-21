*Domains
pushScope: aDomain

	<nonDomainMediated>
	| previousScope |
	previousScope := currentDomain.
	aDomain ifNotNil: [
		aDomain previous: previousScope ].
	
	currentDomain := aDomain.
	currentDomainIsDefault := aDomain isNil