Extension { #name : 'WeakSet' }

{ #category : '*Domains' }
WeakSet >> atNewIndex: index put: anObject [
	tally := tally + 1.
	array at: index put: anObject.

	self fullCheck
]
