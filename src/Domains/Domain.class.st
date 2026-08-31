Class {
	#name : 'Domain',
	#superclass : 'Object',
	#instVars : [
		'previous',
		'owned'
	],
	#classVars : [
		'IsActive'
	],
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'testing' }
Domain class >> activate [

	IsActive ifTrue: [ ^ self ].
	IsActive := true.
	OpalCompiler recompileAll.
]

{ #category : 'testing' }
Domain class >> deactivate [

	IsActive ifFalse: [ ^ self ].
	IsActive := false.
	OpalCompiler recompileAll.
]

{ #category : 'class initialization' }
Domain class >> initialize [

	"When I'm loaded, I will reset all processes to have the default domain"
	Process allInstances do: [ :p | p currentDomain: nil ]
]

{ #category : 'testing' }
Domain class >> isActive [

	<nonDomainMediated>
	"By default domains are not active"
	^ IsActive ifNil: [ IsActive := false ]
]

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
