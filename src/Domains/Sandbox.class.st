"
p := Point new.
Sandbox do: [ :s |
	p setX: 1 setY: 17.
].
"
Class {
	#name : 'Sandbox',
	#superclass : 'Domain',
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

	owned add: newInstance.
	"Add could make the array grow, thus we need to own it too.
	If the array did not grow the following line will do nothing because the array is already there.
	If the array did grow, it will not grow again right away, the next grow threshold is faaar away.
	Should we remove the old array?"
	owned add: owned array.
	
	Processor activeProcess currentDomain: self.
	^ newInstance
]

{ #category : 'writing' }
Sandbox >> allocateClass: aClass size: sizeRequested [

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := aClass doBasicNew: sizeRequested.
	owned add: newInstance.
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

{ #category : 'writing' }
Sandbox >> initialize [
	super initialize.

	owned := IdentitySet new.
	owned add: self.
	owned add: owned.
	owned add: owned array
]

{ #category : 'writing' }
Sandbox >> own: anObject [

	owned add: anObject
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
Sandbox >> shallowCopy: anObject [

	<nonDomainMediated>
	| newInstance |
	Processor activeProcess currentDomain: nil.
	newInstance := anObject doShallowCopy.
	owned add: newInstance.
	Processor activeProcess currentDomain: self.
	^ newInstance
]

{ #category : 'writing' }
Sandbox >> writeSlot: slot on: object value: value [

	<nonDomainMediated>
	(owned includes: object) ifTrue: [
		^ slot write: value to: object.
	].
	
	"Nope!"
	Processor activeProcess popScope.
	self error
]
