Extension { #name : 'OrderedCollection' }

{ #category : '*Domains' }
OrderedCollection >> removeFirst [
	"Remove the first element of the receiver and answer it. If the receiver is
	empty, create an error notification."
	| firstObject indexToRemove |
	self emptyCheck.
	firstObject := array at: firstIndex.
	indexToRemove := firstIndex.
	firstIndex := firstIndex + 1.
	array at: indexToRemove put: nil.
	^ firstObject
]
