Extension { #name : 'Context' }

{ #category : '*Domain-Overrides' }
Context >> sender [
	"Answer the context that sent the message that created the receiver."
	<reflection: 'Stack Manipulation - Context'>
	| theSenderContext |
	theSenderContext := self basicSender.
	thisProcess currentDomainIsDefault ifTrue: [ ^ theSenderContext ].
	^ thisProcess currentDomain ownContext: theSenderContext
]
