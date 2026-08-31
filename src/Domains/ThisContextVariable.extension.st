Extension { #name : 'ThisContextVariable' }

{ #category : '*Domains' }
ThisContextVariable >> emitValue: methodBuilder [

	(Domain isActive not or: [(methodBuilder rawIR hasPragmaNamed: #nonDomainMediated)])
		ifTrue: [ 
			methodBuilder pushThisContext.
			^ self ].
		
	"Otherwise, check if we are in a default domain.
	If not, push the domain, the context, and own it."
	
	"thisProcess currentDomainIsDefault"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomainIsDefault.
		
	methodBuilder jumpAheadTo: #nonDefaultDomain if: false.
	"ifTrue: default push process, then continue"
	methodBuilder pushThisContext.
	methodBuilder jumpAheadTo: #continue.
	
	"ifFalse: non default domain, send and continue"
	methodBuilder jumpAheadTarget: #nonDefaultDomain.
	
	"thisProcess currentDomain ownContext: thisContext"
	methodBuilder pushThisProcess.
	methodBuilder send: #currentDomain.
	methodBuilder pushThisContext.
	methodBuilder send: #ownContext:.

	methodBuilder jumpAheadTarget: #continue
]
