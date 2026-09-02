Extension { #name : 'InstanceVariableSlot' }

{ #category : '*Domains' }
InstanceVariableSlot >> emitValue: methodBuilder [

	true
		ifTrue: [ methodBuilder pushInstVar: index ]
		ifFalse: [
				(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated) ifTrue: [
						methodBuilder pushInstVar: index.
						^ self ]. "Processor activeProcess instVarAt: #currentDomainIsDefault"
				methodBuilder pushLiteralVariable: (Smalltalk globals bindingOf: #Processor).
				methodBuilder send: #activeProcess.
				methodBuilder pushLiteral: (Process instVarIndexFor: #currentDomainIsDefault).
				methodBuilder send: #instVarAt:.

				methodBuilder jumpAheadTo: #nonDefaultDomain if: false. "ifTrue: default write, then continue"
				methodBuilder pushInstVar: index.
				methodBuilder jumpAheadTo: #continue. "ifFalse: non default domain, send and continue"
				methodBuilder jumpAheadTarget: #nonDefaultDomain. "value := stack_top.
		Processor activeProcess currentDomain readSlot: self on: object "
				methodBuilder pushLiteralVariable: (Smalltalk globals bindingOf: #Processor).
				methodBuilder send: #activeProcess.
				methodBuilder send: #currentDomain.
				methodBuilder pushLiteral: self.
				methodBuilder pushReceiver.
				methodBuilder send: #readSlot:on:.

				methodBuilder jumpAheadTarget: #continue ]
]
