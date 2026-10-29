Class {
	#name : 'SandboxViolation',
	#superclass : 'Error',
	#instVars : [
		'object',
		'slot'
	],
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'accessing' }
SandboxViolation >> description [

	^ object class name asString , '(' , slot owningClass name asString , ').' , slot name asString
]

{ #category : 'accessing' }
SandboxViolation >> messageText [

	^ 'Escaping write: ', self description
]

{ #category : 'accessing' }
SandboxViolation >> object [

	^ object
]

{ #category : 'accessing' }
SandboxViolation >> object: anObject [

	object := anObject
]

{ #category : 'accessing' }
SandboxViolation >> slot [

	^ slot
]

{ #category : 'accessing' }
SandboxViolation >> slot: anObject [

	slot := anObject
]
