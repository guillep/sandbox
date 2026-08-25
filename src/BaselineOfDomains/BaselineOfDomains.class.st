Class {
	#name : 'BaselineOfDomains',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDomains',
	#package : 'BaselineOfDomains'
}

{ #category : 'baselines' }
BaselineOfDomains >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec preLoadDoIt: #preload:package:.
			spec postLoadDoIt: #postload:package:.

			spec
				package: #Domains;
				package: #'Domain-Overrides' with: [ spec requires: #( #Domains ) ] ]
]

{ #category : 'baselines' }
BaselineOfDomains >> postload: loader package: packageSpec [
	"Ignore pre and post loads if already executed"

	packageSpec name asString = 'Domain'
		ifTrue: [ Process allInstances do: [ :p | p currentDomain: nil ] ]
		ifFalse: [ Domain activate ]
]

{ #category : 'baselines' }
BaselineOfDomains >> preload: loader package: packageSpec [
	"Ignore pre and post loads if already executed"

	packageSpec name asString = 'Domain'
		ifTrue: [
				(Process allSlots anySatisfy: [ :s | s name = #currentDomain ]) ifTrue: [ ^ self ].
				Process addSlot: #currentDomain asSlot.
				Process addSlot: #currentDomainIsDefault asSlot ]
		ifFalse: [ ]
]
