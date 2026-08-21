Extension { #name : 'Behavior' }

{ #category : '*Domains' }
Behavior >> basicNew [

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew ].
	^ thisProcess currentDomain allocateClass: self
]

{ #category : '*Domains' }
Behavior >> basicNew: sizeRequested [

	thisProcess currentDomainIsDefault ifTrue: [ ^ self doBasicNew: sizeRequested ].
	^ thisProcess currentDomain allocateClass: self size: sizeRequested
]

{ #category : '*Domains' }
Behavior >> doBasicNew [
	"Primitive. Answer an instance of the receiver (which is a class) with no
	 indexable variables. Fail if the class is indexable. Essential. See Object
	 documentation whatIsAPrimitive.

	 If the primitive fails because space is low then the scavenger will run
	 before the method is activated.  Check that space was low and retry
	 via handleFailingBasicNew if so."

	<primitive: 70 error: ec>
	ec == #'insufficient object memory' ifTrue:
		[^self handleFailingBasicNew].
	self isVariable ifTrue: [^self basicNew: 0].
	self primitiveFailed
]

{ #category : '*Domains' }
Behavior >> doBasicNew: sizeRequested [
	"Primitive. Answer an instance of this class with the number of indexable
	 variables specified by the argument, sizeRequested.  Fail if this class is not
	 indexable or if the argument is not a positive Integer, or if there is not
	 enough memory available. Essential. See Object documentation whatIsAPrimitive.

	 If the primitive fails because space is low then the scavenger will run before the
	 method is activated.  Check args and retry via handleFailingBasicNew: if they're OK."

	<primitive: 71 error: ec>
	ec == #'insufficient object memory' ifTrue:
		[^self handleFailingBasicNew: sizeRequested].
	self isVariable ifFalse:
		[self error: self printString, ' cannot have variable sized instances'].
	self primitiveFailed
]
