Extension { #name : 'Collection' }

{ #category : '*Domains' }
Collection >> printOn: aStream [
	"Append a sequence of characters that identify the receiver to aStream."

	self printNameOn: aStream.
	self printElementsOn: aStream
]
