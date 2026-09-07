"
p := Point new.
Sandbox do: [ :s |
	p setX: 1 setY: 17.
].
"
Class {
	#name : 'Sandbox',
	#superclass : 'Domain',
	#instVars : [
		'ownedBehaviors',
		'classVarValues'
	],
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'enumerating' }
Sandbox class >> do: aBlock [

	^ self new do: aBlock
]

{ #category : 'writing' }
Sandbox >> allocateClass: aClass [

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := aClass doBasicNew.
	
	self own: newInstance.

	"Add could make the array grow, thus we need to own it too.
	If the array did not grow the following line will do nothing because the array is already there.
	If the array did grow, it will not grow again right away, the next grow threshold is faaar away.
	Should we remove the old array?"
	"self own: owned array."
	
	Processor activeProcess currentDomain: self.
	^ newInstance
]

{ #category : 'writing' }
Sandbox >> allocateClass: aClass size: sizeRequested [

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := aClass doBasicNew: sizeRequested.

	self own: newInstance.

	Processor activeProcess currentDomain: self.
	^ newInstance
]

{ #category : 'writing' }
Sandbox >> do: aBlock [

	| popped |
	popped := false.
	Processor activeProcess pushScope: self.
	^ [
		  [ aBlock value: self ]
			  on: Exception
			  do: [ :e |
					  Processor activeProcess popScope.
					  popped := true.
					  e pass ] ] ensure: [ popped ifFalse: [ Processor activeProcess popScope ] ]
]

{ #category : 'initialization' }
Sandbox >> initialize [
	super initialize.

	owned := WeakIdentitySet new.
	owned add: self.
	owned add: owned.
	owned add: owned array.
	
	"Behaviors cannot be hashed before they are ready.
	We capture them at basicNew and they have no superclass, method dict, nor format.
	Store them in an ordered collection instead"
	ownedBehaviors := WeakOrderedCollection new.
	
	"classVarValues := Dictionary new.
	owned add: classVarValues.
	owned add: classVarValues array."
]

{ #category : 'writing' }
Sandbox >> own: newInstance [

	newInstance isImmediateObject ifTrue: [ ^ newInstance ].
	[owned add: newInstance]
		on: Exception do: [ ownedBehaviors add: newInstance ].		
	^newInstance 
]

{ #category : 'writing' }
Sandbox >> ownContext: newInstance [

	<nonDomainMediated>
	Processor activeProcess currentDomain: nil.
	owned add: newInstance.
	Processor activeProcess currentDomain: self.
	^newInstance 
]

{ #category : 'writing' }
Sandbox >> owns: newInstance [

	| basicOwnership |
	basicOwnership := [ owned includes: newInstance ]
		on: Exception do: [ :err | ^ ownedBehaviors includes: newInstance ].
	
	^ basicOwnership or: [ ownedBehaviors includes: newInstance ]
]

{ #category : 'accessing' }
Sandbox >> previous [
	
	^ previous
]

{ #category : 'accessing' }
Sandbox >> previous: aPreviousScope [
	
	previous := aPreviousScope
]

{ #category : 'writing' }
Sandbox >> readClassVariable: slot [

	<nonDomainMediated>	
	"Well, you can read a class variable, but only a copy/memento of the original.
	This way we will be able to write into it."
	| value val |
	value := classVarValues at: slot ifAbsent: nil.
	
	value
		ifNil: [
			val := slot value.
			val isBehavior
				ifTrue: [ val ]
				ifFalse: [ val := val copy ]]
		ifNotNil: [ val := value ].
	
	classVarValues at: slot put: val.
	^ val
]

{ #category : 'writing' }
Sandbox >> readSlot: slot on: object [

	<nonDomainMediated>
	^ slot read: object
]

{ #category : 'writing' }
Sandbox >> shallowCopy: anObject [

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := anObject doShallowCopy.
	
	self own: newInstance.
	
	Processor activeProcess currentDomain: self.
	^ newInstance
]

{ #category : 'writing' }
Sandbox >> writeClassVariable: slot value: value [

	<nonDomainMediated>	
	"Nope!"
	classVarValues at: slot put: value.
	^ value
]

{ #category : 'writing' }
Sandbox >> writeSlot: slot on: object value: value [

	<nonDomainMediated>
	(self owns: object) ifTrue: [
		^ slot write: value to: object.
	].
	
	"Nope!"
	Processor activeProcess popScope.
	self error: 'Se te escapo la escritura'
]
