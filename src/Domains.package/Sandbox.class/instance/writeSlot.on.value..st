writing
writeSlot: slot on: object value: value

	<nonDomainMediated>
	(self owns: object) ifTrue: [
		^ slot write: value to: object.
	].
	
	"Nope!"
	Processor activeProcess popScope.
	self error: 'Se te escapo la escritura'