Extension { #name : 'OrderedCollection' }

{ #category : '*Domain-Overrides' }
OrderedCollection >> removeIndex: removedIndex [
  "  removedIndex is an index in the range firstIndex .. lastIndex, such an index is not known from outside the collection.
    Never use this method in your code, it is meant for private use by OrderedCollection only.
     The method for public use is:
        #removeAt: "

	| indexToRemove |
	indexToRemove := lastIndex.
	lastIndex := lastIndex - 1.
	array
		replaceFrom: removedIndex
		to: indexToRemove - 1
		with: array
		startingAt: removedIndex+1.
	array at: indexToRemove put: nil.
]

{ #category : '*Domain-Overrides' }
OrderedCollection >> removeLast [
	"Remove the last element of the receiver and answer it. If the receiver is
	empty, create an error notification."
	| lastObject indexToRemove |
	self emptyCheck.
	lastObject := array at: lastIndex.
	indexToRemove := lastIndex.
	lastIndex := lastIndex - 1.
	array at: indexToRemove put: nil.
	^ lastObject
]
