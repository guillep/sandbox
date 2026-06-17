Extension { #name : 'WeakSet' }

{ #category : '*Domains' }
WeakSet >> atNewIndex: index put: anObject [
	<nonDomainMediated>
	tally := tally + 1.
	array at: index put: anObject.

	self fullCheck
]

{ #category : '*Domains' }
WeakSet >> growTo: anInteger [
	"Grow the elements array and reinsert the old elements"

	| oldElements |
	<nonDomainMediated>
	oldElements := array.
	array := WeakArray new: anInteger withAll: flag.
	self noCheckNoGrowFillFrom: oldElements
]
