*Domains
schedule: aDelay
	"This is the front-half of scheduling a delay. For back-half see #timingPrioritySchedule:"

	<nonDomainMediated>

	"Only one signal is sent when delay expires. Check if that is already spoken for"
	aDelay beingWaitedOn ifTrue: [^self error: 'This Delay has already been scheduled.'].

	readyToSchedule wait.  "Starts signalled. Resignalled from back-end #scheduleAtTimingPriority"
	delayToStart := aDelay.
	timingSemaphore signal. "Transfer execution to back-end #scheduleAtTimingPriority"