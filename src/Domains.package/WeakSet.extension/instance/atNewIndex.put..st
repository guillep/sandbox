*Domains
atNewIndex: index put: anObject
	<nonDomainMediated>
	tally := tally + 1.
	array at: index put: anObject.

	self fullCheck