Extension { #name : 'ClassVariable' }

{ #category : '*Domains' }
ClassVariable >> emitStore: methodBuilder [
	"generate store bytecode.
	Does not pop the stored value!"
	
	| tempName |

	(true or: [(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)])
		ifTrue: [ 
			methodBuilder storeIntoLiteralVariable: self.
			^ self ].
	
	"thisProcess currentDomainIsDefault"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.
	
	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
	"ifTrue: default write, then continue"
	methodBuilder storeIntoLiteralVariable: self.
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
	methodBuilder pushTemp: tempName.
	methodBuilder send: #writeClassVariable:value:.
	methodBuilder popTop.

	methodBuilder jumpAheadTarget: #continue
]

{ #category : '*Domains' }
ClassVariable >> emitValue: methodBuilder [

	(Domain isActive not or: [(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)]) ifTrue: [
			methodBuilder pushLiteralVariable: self.
			^ self ].
		
	"thisProcess currentDomainIsDefault"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.
	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.

	"Default domain"
	methodBuilder pushLiteralVariable: self.
	methodBuilder jumpAheadTo: #continue.
	
	"Domain controlled!"
	methodBuilder jumpAheadTarget: #nonDefaultDomain.
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder send: #readClassVariable:.
	
	"Then we continue here"
	methodBuilder jumpAheadTarget: #continue
]
