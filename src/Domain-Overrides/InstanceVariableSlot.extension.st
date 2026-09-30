Extension { #name : 'InstanceVariableSlot' }

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitDomainMediatedReadOnClassSide: methodBuilder [

	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.

	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
	"ifTrue: default read, then continue"
	methodBuilder pushInstVar: index.
	methodBuilder jumpAheadTo: #continue.
	
	"ifFalse: non default domain, send and continue"
	methodBuilder jumpAheadTarget: #nonDefaultDomain.

	"... value.
	thisProcess currentDomain readClassSlot: self on: object (the class)"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder pushReceiver.
	methodBuilder send: #readClassSlot:on:.

	methodBuilder jumpAheadTarget: #continue
]

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitDomainMediatedReadOnInstanceSide: methodBuilder [

	methodBuilder pushInstVar: index
]

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitDomainMediatedStoreOnClassSide: methodBuilder [

	self emitDomainMediatedStoreWithSelector: #writeClassSlot:on:value: builder: methodBuilder
]

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitDomainMediatedStoreOnInstanceSide: methodBuilder [
	
	"thisProcess currentDomainIsDefault"
	| tempName |
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.
		
	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
	"ifTrue: default write, then continue"
	methodBuilder storeInstVar: index.
	methodBuilder jumpAheadTo: #continue.
	
	"ifFalse: non default domain, send and continue"
	methodBuilder jumpAheadTarget: #nonDefaultDomain.
	
	"value := stack_top.
	Processor activeProcess currentDomain writeSlot: self on: object value: value (top of stack)"
	tempName := '0slotTempForWriteDomain'.
	methodBuilder
		addTemp: tempName;
		storeTemp: tempName.

	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder pushReceiver.
	methodBuilder pushTemp: tempName.
	methodBuilder send: #writeSlot:on:value:.
	methodBuilder popTop.

	methodBuilder jumpAheadTarget: #continue
]

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitDomainMediatedStoreWithSelector: selector builder: methodBuilder [

	| tempName |
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.

	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
	"ifTrue: default write, then continue"
	methodBuilder storeInstVar: index.
	methodBuilder jumpAheadTo: #continue.

	"ifFalse: non default domain, send and continue"
	methodBuilder jumpAheadTarget: #nonDefaultDomain.

	"value := stack_top.
	Processor activeProcess currentDomain writeSlot: self on: object value: value (top of stack)"
	tempName := '0slotTempForWriteDomain'.
	methodBuilder
		addTemp: tempName;
		storeTemp: tempName.

	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder pushReceiver.
	methodBuilder pushTemp: tempName.
	methodBuilder send: selector.
	methodBuilder popTop.

	methodBuilder jumpAheadTarget: #continue
]

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitStore: methodBuilder [
	"generate store bytecode.
	Does not pop the stored value!"

	"thisProcess currentDomainIsDefault""ifTrue: default write, then continue""ifFalse: non default domain, send and continue""value := stack_top.
	Processor activeProcess currentDomain writeSlot: self on: object value: value (top of stack)"
	(Domain isActive not or: [ methodBuilder rawIR hasPragmaNamed: #nonDomainMediated ]) ifTrue: [
			methodBuilder storeInstVar: index.
			^ self ].
		
	self owningClass isInstanceSide
		ifTrue: [ self emitDomainMediatedStoreOnInstanceSide: methodBuilder ]
		ifFalse: [ self emitDomainMediatedStoreOnClassSide: methodBuilder ]
]

{ #category : '*Domain-Overrides' }
InstanceVariableSlot >> emitValue: methodBuilder [

	(Domain isActive not or: [ methodBuilder rawIR hasPragmaNamed: #nonDomainMediated ]) ifTrue: [
			methodBuilder pushInstVar: index.
			^ self ].

	self owningClass isInstanceSide
		ifTrue: [ self emitDomainMediatedReadOnInstanceSide: methodBuilder ]
		ifFalse: [ self emitDomainMediatedReadOnClassSide: methodBuilder ]
]
