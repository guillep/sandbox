Class {
	#name : 'Domain',
	#superclass : 'Object',
	#instVars : [
		'previous',
		'owned'
	],
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'writing' }
Domain >> do: aBlock [

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
]

{ #category : 'accessing' }
Domain >> previous [
	
	^ previous
]

{ #category : 'accessing' }
Domain >> previous: aPreviousScope [
	
	previous := aPreviousScope
]
