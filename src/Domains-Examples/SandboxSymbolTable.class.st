Class {
	#name : 'SandboxSymbolTable',
	#superclass : 'Object',
	#category : 'Domains-Examples-Objects',
	#package : 'Domains-Examples',
	#tag : 'Objects'
}

{ #category : 'accessing' }
SandboxSymbolTable >> like: aString [

	^ ((Symbol classPool at: #SymbolTable) value like: aString)
		ifNil: [ (Symbol classPool at: #NewSymbols) value like: aString ]
]
