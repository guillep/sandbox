Class {
	#name : 'DomainExperiments',
	#superclass : 'Object',
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'as yet unclassified' }
DomainExperiments >> runFor: packageUnderTest [

	| ps ts |
	ps := PackageOrganizer default packages select: [ :e | (e name beginsWith: packageUnderTest) and: [ e name endsWith: '-Tests' ] ].
	ts := ps flatCollect: [ :p |
			      p testSuite tests flatCollect: [ :t |
					      (t isKindOf: TestSuite)
						      ifTrue: [ t tests ]
						      ifFalse: [ { t } ] ] ].

	FileSystem workingDirectory / packageUnderTest , 'json' writeStreamDo: [ :stream |
			| writer |
			writer := NeoJSONWriter on: stream.
			writer prettyPrint: true.
			ts do: [ :t |
					| result |
					result := [ t debug ]
						          on: Exception
						          do: [ :err | err freezeUpTo: thisContext ].
					((result isKindOf: Error) and: [ result messageText = 'Escaping write' ]) ifTrue: [
							| sandbox frontier testContext |
							sandbox := (result signalerContext stack detect: [ :ctxt | ctxt method == (Sandbox >> #do:) ]) receiver.
							frontier := result signalerContext stack detect: [ :ctx |
								            (sandbox owns: ctx receiver) not and: [ sandbox owns: ctx sender receiver ] ].
							testContext := result signalerContext stack detect: [ :e |
								               (e receiver isKindOf: TestCase) and: [ e selector beginsWith: 'runCase' ] ].
							writer nextPut: {
									('package' -> packageUnderTest).
									('test' -> testContext method method name).
									('violationStack' -> ((result signalerContext stack copyUpTo: testContext) collect: [ :ctx | ctx method method name ])).
									('violationCause' -> result signalerContext sender arguments first asString).
									('ownershipFrontier' -> {
										 frontier sender method method name.
										 frontier method method name }) } asDictionary ] ] ]
]

{ #category : 'as yet unclassified' }
DomainExperiments >> runForAll [

	^ self runForAll: #( Roassal AST Opal Refactoring Kernel Microdown Enlumineur FileSystem Clap Collections Zinc )
]

{ #category : 'as yet unclassified' }
DomainExperiments >> runForAll: aList [

	^ aList do: [ :a | self runFor: a ]
]
