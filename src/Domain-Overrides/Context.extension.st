Extension { #name : 'Context' }

{ #category : '*Domain-Overrides' }
Context >> copyTo: aContext [
	"Copy self and my sender chain down to, but not including, aContext.  End of copied chain will have nil sender."

	| current firstCopy previousCopy |
	self == aContext ifTrue: [^ nil].
	previousCopy := firstCopy := self copy.
	current := self sender.
	[ current notNil and: [ current ~~ aContext] ] whileTrue: [
		| copy |
		copy := current copy.
		previousCopy ifNotNil: [
			previousCopy privSender: copy.
		].
		previousCopy := copy.
		current := current sender.
	].
	previousCopy privSender: nil.
	^ firstCopy
]

{ #category : '*Domain-Overrides' }
Context >> sender [
	"Answer the context that sent the message that created the receiver."
	<reflection: 'Stack Manipulation - Context'>
	| theSenderContext |
	theSenderContext := self basicSender.
	thisProcess currentDomainIsDefault ifTrue: [ ^ theSenderContext ].
	^ thisProcess currentDomain ownContext: theSenderContext
]
