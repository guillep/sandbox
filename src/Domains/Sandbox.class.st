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
		'bindings',
		'freshClassVars',
		'classInstVarInitialValues',
		'freshClassInstVars'
	],
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'enumerating' }
Sandbox class >> do: aBlock [

	^ self new do: aBlock
]

{ #category : 'enumerating' }
Sandbox class >> forTest [

	| newSymbols symbolTable theSandbox |
	theSandbox := self new.
	theSandbox do: [ :sb |
			newSymbols := SandboxNewSymbols new.
			symbolTable := SandboxSymbolTable new.
			sb
				simulateFreshClassVar: (Symbol bindingOf: #NewSymbols)
				initialValue: newSymbols.
			sb
				simulateFreshClassVar: (Symbol bindingOf: #SymbolTable)
				initialValue: symbolTable.

			sb
				simulateFreshClassVar: (OCASTCache class slotNamed: #default)
				initialValue: OCASTCache new.

			sb
				simulateFreshClassVar: (Smalltalk bindingOf: #Undeclared)
				initialValue: UndeclaredRegistry new.
			
			sb
				simulateFreshClassVar: (TestCase class slotNamed: #history)
				initialValue: TestCase newTestDictionary.
	].

	^ theSandbox
]

{ #category : 'enumerating' }
Sandbox class >> with: bindings do: aBlock [

	^ self new
		bindings: bindings asDictionary;
		do: aBlock
]

{ #category : 'writing' }
Sandbox >> _own: newInstance [

	newInstance isImmediateObject ifTrue: [ ^ newInstance ].
	owned add: newInstance.
	^newInstance 
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
	"Activate the sandbox"

	| returnValue theError |
	thisProcess pushScope: self.

	"Just catch the exception and do not pass/retry/resume.
	This guarantees that all ensure blocks in between the signal and this method are executed with the sandbox enabled."
	returnValue := [ aBlock value: self ]
		               on: Exception
		               do: [ :error | "theError := error freeze."
				               thisProcess popScope.
				               error pass ].

	"Desactivate the sandbox"
	thisProcess popScope.

	"Now check, if there was an error, tell the user"
	theError ifNil: [ ^ returnValue ].
	theError copy signal
]

{ #category : 'halting' }
Sandbox >> halt [

	"Utility for debugging purposes. Avoid the sandbox just in case"
	<nonDomainMediated>
	Processor activeProcess currentDomain: nil.
	super halt.
	Processor activeProcess currentDomain: self.
]

{ #category : 'halting' }
Sandbox >> haltIf: aBlock [

	"Utility for debugging purposes. Avoid the sandbox just in case"
	<nonDomainMediated>
	Processor activeProcess currentDomain: nil.
	super haltIf: aBlock.
	Processor activeProcess currentDomain: self.
]

{ #category : 'halting' }
Sandbox >> haltIfTest [

	"Utility for debugging purposes. Avoid the sandbox just in case"
	<nonDomainMediated>
	Processor activeProcess currentDomain: nil.
	super haltIfTest.
	Processor activeProcess currentDomain: self.
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
	freshClassVars := Dictionary new.
	freshClassInstVars := Dictionary new.
	classInstVarInitialValues := Dictionary new.
	
	"classVarValues := Dictionary new.
	owned add: classVarValues.
	owned add: classVarValues array."
]

{ #category : 'writing' }
Sandbox >> newProcess: aClosure [

	<nonDomainMediated>
	| newInstance |
	
	Processor activeProcess currentDomain: nil.
	newInstance := [ thisProcess currentDomain: self. aClosure value ] basicNewProcess.
	
	self own: newInstance.
	
	Processor activeProcess currentDomain: self.
	^ newInstance
]

{ #category : 'writing' }
Sandbox >> own: newInstance [

	newInstance isImmediateObject ifTrue: [ ^ newInstance ].
	thisProcess unmediatedDo: [
			[ owned add: newInstance ]
				on: Exception
				do: [ :error | ownedBehaviors add: newInstance ] ].
	^ newInstance
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
Sandbox >> readClassSlot: slot on: aClass [

	<nonDomainMediated>
	Processor activeProcess currentDomain: nil.

	[  | classVars |
		"Check for overrides per class"
		classVars := freshClassInstVars at: aClass ifAbsentPut: [ Dictionary new ].

		"If we have it, return it"
		classVars at: slot ifPresent: [ :v | ^ v ] ifAbsent: [
			(aClass isKindOf: slot definingClass) ifTrue: [
				"Otherwise
					- if we have an initial value, set it for next time and return it
					- if we don't, continue with the normal read"
					classInstVarInitialValues at: slot ifPresent: [ :initialValue |
							classVars at: slot put: initialValue.
							^ initialValue ] ] ].

		"Otherwise, read from the environment"
		^ slot read: aClass ] ensure: [ Processor activeProcess currentDomain: self ]
]

{ #category : 'writing' }
Sandbox >> readClassVariable: classVariableSlot [

	<nonDomainMediated>	

	freshClassVars at: classVariableSlot
		ifPresent: [ :replacementObject | ^ replacementObject ].
	^ classVariableSlot value
]

{ #category : 'writing' }
Sandbox >> readGlobalVariable: globalVariableSlot [

	<nonDomainMediated>	

	freshClassVars at: globalVariableSlot
		ifPresent: [ :replacementObject | ^ replacementObject ].
	^ globalVariableSlot value
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

{ #category : 'as yet unclassified' }
Sandbox >> simulateFreshClassVar: aClassSlot [

	<nonDomainMediated>
	self simulateFreshClassVar: aClassSlot initialValue: nil
]

{ #category : 'as yet unclassified' }
Sandbox >> simulateFreshClassVar: aClassSlot initialValue: aValue [

	<nonDomainMediated>
	Processor activeProcess currentDomain: nil.

	[
		aClassSlot isClassVariable
			ifTrue: [ freshClassVars at: aClassSlot put: aValue ]
			ifFalse: [ classInstVarInitialValues at: aClassSlot put: aValue ] ]
				ensure: [ Processor activeProcess currentDomain: self ]
]

{ #category : 'writing' }
Sandbox >> writeClassSlot: slot on: aClass value: value [

	<nonDomainMediated>
	| classVars |
	thisProcess unmediatedDo: [
		classVars := freshClassInstVars at: aClass ifAbsentPut: [ Dictionary new ].

		"If we have it, write it"
		classVars
			at: slot
			ifPresent: [ :v |
					classVars at: slot put: value.
					^ value ]
			ifAbsent: [
					(aClass isKindOf: slot definingClass) ifTrue: [ "Otherwise
				- if we have an initial value, override with our value!
				- if we don't, continue with the normal write"
							classInstVarInitialValues at: slot ifPresent: [ :initialValue |
									classVars at: slot put: value.
									^ value ] ] ] ].
					
		"Otherwise, write to the environment"
		^ self writeSlot: slot on: aClass value: value
]

{ #category : 'writing' }
Sandbox >> writeClassVariable: slot value: value [

	<nonDomainMediated>	
	"Nope!"
	| classVarValues |
	1halt.
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
	self error: 'Escaping write'
]
