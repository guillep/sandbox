Extension { #name : 'HashedCollection' }

{ #category : '*Domains' }
HashedCollection >> atNewIndex: index put: anObject [
	tally := tally + 1.
	array at: index put: anObject.

	self fullCheck
]
