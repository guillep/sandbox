writing
do: aBlock

	| popped |
	popped := false.
	Processor activeProcess pushScope: self.
	^ [
		  [ aBlock value: self ]
			  on: Exception
			  do: [ :e |
					  Processor activeProcess popScope.
					  popped := true.
					  e pass ] ] ensure: [ popped ifFalse: [ Processor activeProcess popScope ] ]