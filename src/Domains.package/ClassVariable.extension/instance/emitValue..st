*Domains
emitValue: methodBuilder

	true ifFalse: [ ^ self ].
	(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated) ifTrue: [
			methodBuilder pushLiteralVariable: self.
			^ self ]. "thisProcess currentDomainIsDefault"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.
	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
	methodBuilder pushLiteralVariable: self.
	methodBuilder jumpAheadTo: #continue.
	methodBuilder jumpAheadTarget: #nonDefaultDomain.
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushLiteral: self.
	methodBuilder send: #readClassVariable:.
	methodBuilder jumpAheadTarget: #continue