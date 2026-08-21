writing
do: aBlock

	| popped |
	popped := false.
	thisProcess pushScope: self.
	^ [
		  [ aBlock value: self ]
			  on: Exception
			  do: [ :e |
					  thisProcess popScope.
					  popped := true.
					  e pass ] ] ensure: [ popped ifFalse: [ thisProcess popScope ] ]