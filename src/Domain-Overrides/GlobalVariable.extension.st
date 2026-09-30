Extension { #name : 'GlobalVariable' }

{ #category : '*Domain-Overrides' }
GlobalVariable >> emitNonMediatedValue: methodBuilder [
	methodBuilder pushLiteralVariable: self
]

{ #category : '*Domain-Overrides' }
GlobalVariable >> emitValue: methodBuilder [

	(Domain isActive not or: [(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)]) ifTrue: [
			self emitNonMediatedValue: methodBuilder.
			^ self ].
		
	"thisProcess currentDomainIsDefault"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.
	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.

	"Default domain"
	self emitNonMediatedValue: methodBuilder.
	methodBuilder jumpAheadTo: #continue.
	
	"Domain controlled!"
	methodBuilder jumpAheadTarget: #nonDefaultDomain.
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder send: #readGlobalVariable:.
	
	"Then we continue here"
	methodBuilder jumpAheadTarget: #continue
]
