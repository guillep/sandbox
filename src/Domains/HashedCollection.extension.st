Extension { #name : 'HashedCollection' }

{ #category : '*Domains' }
HashedCollection >> atNewIndex: index put: anObject [

	"This override just inverts the effects below to capture it with i.v. sandbox"
	tally := tally + 1.
	array at: index put: anObject.

	self fullCheck
]
