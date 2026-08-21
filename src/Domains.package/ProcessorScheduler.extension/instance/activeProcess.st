*Domains
activeProcess
	"Answers the currently running Process.
	It can be just pretending to be the active process
	(like during the code simulation in the debugger)"

	<noInstrumentation>
	<nonDomainMediated>
	^ activeProcess effectiveProcess