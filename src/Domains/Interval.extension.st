Extension { #name : 'Interval' }

{ #category : '*Domains' }
Interval class >> doBasicNew [
	"Primitive. Create and answer with a new instance of the receiver
	(a class) with no indexable fields. Fail if the class is indexable. Override
	SequenceableCollection new. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 70>
	self isVariable ifTrue: [ ^ self new: 0 ].
	"space must be low"
	OutOfMemory signal.
	^ self new  "retry if user proceeds"
]

{ #category : '*Domains' }
Interval class >> new [

	Processor activeProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew ].
	^ Processor activeProcess currentDomain allocateClass: self
]
