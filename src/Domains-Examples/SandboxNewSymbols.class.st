Class {
	#name : 'SandboxNewSymbols',
	#superclass : 'Object',
	#instVars : [
		'localNewSymbols'
	],
	#category : 'Domains-Examples-Objects',
	#package : 'Domains-Examples',
	#tag : 'Objects'
}

{ #category : 'adding' }
SandboxNewSymbols >> add: aString [

	^ localNewSymbols add: aString	
]

{ #category : 'initialization' }
SandboxNewSymbols >> initialize [

	super initialize.
	localNewSymbols := WeakSet new.
]

{ #category : 'accessing' }
SandboxNewSymbols >> like: aString [ 
	
	^ localNewSymbols like: aString
]
