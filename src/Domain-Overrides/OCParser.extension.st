Extension { #name : 'OCParser' }

{ #category : '*Domain-Overrides' }
OCParser >> stepBar [
	"When possible, only consume the first bar (`|`) of the current binary token"

	"All of this because | can be a separator (block args), a type of brackets (temps) and a valid first character of binary operators."

	| value |
	value := currentToken value.
	(value size < 2 or: [ value first ~= $| ]) ifTrue: [ ^ self step ].

	"Because the current token might escape, we need to update the old curent token and create a new current token"
	currentToken value: '|'.
	currentToken := currentToken copy.
	currentToken value: value allButFirst.
	currentToken start: currentToken start + 1
]
