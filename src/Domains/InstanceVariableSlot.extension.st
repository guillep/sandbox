Extension { #name : 'InstanceVariableSlot' }

{ #category : '*Domains' }
InstanceVariableSlot >> emitStore: methodBuilder [
	"generate store bytecode.
	Does not pop the stored value!"
	
	| tempName |

	(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)
		ifTrue: [ 
			methodBuilder storeInstVar: index.
			^ self ].
	
	"Processor activeProcess instVarAt: #currentDomainIsDefault"
	methodBuilder pushLiteralVariable: (Smalltalk globals bindingOf: #Processor).
	methodBuilder send: #activeProcess.
	methodBuilder pushLiteral: (Process instVarIndexFor: #currentDomainIsDefault).
	methodBuilder send: #instVarAt:.
	
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

	methodBuilder pushLiteralVariable: (Smalltalk globals bindingOf: #Processor).
	methodBuilder send: #activeProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder pushReceiver.
	methodBuilder pushTemp: tempName.
	methodBuilder send: #writeSlot:on:value:.
	methodBuilder popTop.

	methodBuilder jumpAheadTarget: #continue
]

{ #category : '*Domains' }
InstanceVariableSlot >> emitValue: methodBuilder [
	
	methodBuilder pushInstVar: index.
	
	"Disable mediated reads for now"
	false ifTrue:[
		(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)
			ifTrue: [ 
				methodBuilder pushInstVar: index.
				^ self ].
		
		"Processor activeProcess instVarAt: #currentDomainIsDefault"
		methodBuilder pushLiteralVariable: (Smalltalk globals bindingOf: #Processor).
		methodBuilder send: #activeProcess.
		methodBuilder pushLiteral: (Process instVarIndexFor: #currentDomainIsDefault).
		methodBuilder send: #instVarAt:.
		
		methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
		"ifTrue: default write, then continue"
		methodBuilder pushInstVar: index.
		methodBuilder jumpAheadTo: #continue.
		
		"ifFalse: non default domain, send and continue"
		methodBuilder jumpAheadTarget: #nonDefaultDomain.
		
		"value := stack_top.
		Processor activeProcess currentDomain readSlot: self on: object "
		methodBuilder pushLiteralVariable: (Smalltalk globals bindingOf: #Processor).
		methodBuilder send: #activeProcess.
		methodBuilder send: #currentDomain.
		methodBuilder pushLiteral: self.
		methodBuilder pushReceiver.
		methodBuilder send: #readSlot:on:.

		methodBuilder jumpAheadTarget: #continue]
]
