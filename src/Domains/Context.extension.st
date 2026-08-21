Extension { #name : 'Context' }

{ #category : '*Domains' }
Context >> basicSender [
	"Answer the context that sent the message that created the receiver."
	<reflection: 'Stack Manipulation - Context'>
	^sender
]
