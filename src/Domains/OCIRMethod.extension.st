Extension { #name : 'OCIRMethod' }

{ #category : '*Domains' }
OCIRMethod >> hasPragmaNamed: aName [

	
	^ pragmas anySatisfy: [ :e | e keyword = aName ]
]
