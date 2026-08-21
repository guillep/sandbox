*Domains
popScope

	<nonDomainMediated>
	currentDomain ifNotNil: [
		currentDomain := currentDomain previous.
		currentDomainIsDefault := currentDomain isNil]