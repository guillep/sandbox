Extension { #name : 'ProcessorScheduler' }

{ #category : '*Domains' }
ProcessorScheduler >> activeProcess [
	"Answers the currently running Process.
	It can be just pretending to be the active process
	(like during the code simulation in the debugger)"

	<noInstrumentation>
	
	"Do not instrument/mediate this method"
	<nonDomainMediated>
	
	^ activeProcess effectiveProcess
]
