*Domains
emitStore: methodBuilder
	"generate store bytecode.
	Does not pop the stored value!"
	
	| tempName |

	(false or: [(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)])
		ifTrue: [ 
			methodBuilder storeInstVar: index.
			^ self ].
	
	"thisProcess currentDomainIsDefault"
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