Extension { #name : 'OCIRMethod' }

{ #category : '*Domains' }
OCIRMethod >> hasPragmaNamed: aName [

	"Expose pragmas during compilation"
	^ pragmas anySatisfy: [ :e | e keyword = aName ]
]
