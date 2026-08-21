writing
readClassVariable: slot

	<nonDomainMediated>	
	"Well, you can read a class variable, but only a copy/memento of the original.
	This way we will be able to write into it."
	| value val |
	value := classVarValues at: slot ifAbsent: nil.
	
	value
		ifNil: [
			val := slot value.
			val isBehavior
				ifTrue: [ val ]
				ifFalse: [ val := val copy ]]
		ifNotNil: [ val := value ].
	
	classVarValues at: slot put: val.
	^ val