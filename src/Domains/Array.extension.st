Extension { #name : 'Array' }

{ #category : '*Domains' }
Array >> printOn: aStream [

	"Override to remove smelly exception management"

	self shouldBePrintedAsLiteral ifTrue: [
			self printAsLiteralFormOn: aStream.
			^ self ].
	self isSelfEvaluating ifTrue: [
			self printAsSelfEvaluatingFormOn: aStream.
			^ self ].


	super printOn: aStream
]
