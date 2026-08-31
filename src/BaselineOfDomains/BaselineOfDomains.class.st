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

			spec
				package: #Domains;
				package: #'Domain-Overrides' with: [ spec requires: #( #Domains ) ] ]
]

{ #category : 'baselines' }
BaselineOfDomains >> preload: loader package: packageSpec [
	"Ignore pre and post loads if already executed"

	(Process allSlots anySatisfy: [ :s | s name = #currentDomain ]) ifTrue: [ ^ self ].
	Process addSlot: #currentDomain asSlot.
	Process addSlot: #currentDomainIsDefault asSlot
]
