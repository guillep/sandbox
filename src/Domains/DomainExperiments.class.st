Class {
	#name : 'DomainExperiments',
	#superclass : 'Object',
	#category : 'Domains',
	#package : 'Domains'
}

{ #category : 'as yet unclassified' }
DomainExperiments >> isSandboxViolation: result [

	^ result isKindOf: SandboxViolation
]

{ #category : 'as yet unclassified' }
DomainExperiments >> runFor: packageUnderTest [

	| ps ts parent |
	ps := PackageOrganizer default packages select: [ :e | (e name beginsWith: packageUnderTest) and: [ e name endsWith: '-Tests' ] ].
	ts := ps flatCollect: [ :p |
			      p testSuite tests flatCollect: [ :t |
					      (t isKindOf: TestSuite)
						      ifTrue: [ t tests ]
						      ifFalse: [ { t } ] ] ].

	parent := FileSystem workingDirectory / 'results'.
	parent ensureCreateDirectory.
	parent / packageUnderTest , 'json' writeStreamDo: [ :stream |
			| writer |
			writer := NeoJSONWriter on: stream.
			writer prettyPrint: true.
			ts do: [ :t | self runTest: t package: packageUnderTest resultWriter: writer ] ]
]

{ #category : 'as yet unclassified' }
DomainExperiments >> runForAll [

	^ self runForAll: #( Roassal AST Opal Refactoring Kernel Microdown Enlumineur FileSystem Clap Collections Zinc )
]

{ #category : 'as yet unclassified' }
DomainExperiments >> runForAll: aList [

	^ aList do: [ :a | self runFor: a ]
]

{ #category : 'as yet unclassified' }
DomainExperiments >> runTest: t package: packageUnderTest resultWriter: writer [

	| result timeToRun |
	result := [ timeToRun := [ t debug ] timeToRun ]
		          on: Exception
		          do: [ :err | err freezeUpTo: thisContext ].
	(self isSandboxViolation: result)
		ifTrue: [
				self
					writeViolationOf: t
					package: packageUnderTest
					result: result
					toWriter: writer ]
		ifFalse: [ "Two cases, either the test finished correctly, and thus we have a time to run.
			Or the test failed for another reason (e.g., exception that is not a violation, maybe hiding a violation)"
				timeToRun
					ifNil: [
							self
								writeErrorOfTest: t
								package: packageUnderTest
								result: result
								reason: 'error'
								writer: writer
								extraEntries: #(  ) ]
					ifNotNil: [
							writer nextPut: {
									('package' -> packageUnderTest).
									('test' -> t printString).
									('result' -> 'success').
									('timeToRun' -> timeToRun asMilliSeconds) } asDictionary ] ]
]

{ #category : 'as yet unclassified' }
DomainExperiments >> writeErrorOfTest: t package: packageUnderTest result: result reason: reason writer: writer extraEntries: extraEntries [

	| testContext |
	testContext := (result signalerContext stackOfSize: 30000) detect: [ :e |
		               (e receiver isKindOf: TestCase) and: [ e selector beginsWith: 'runCase' ] ] ifNone: [  ].
	^ writer nextPut: ({
			   ('package' -> packageUnderTest).
			   ('test' -> t printString).
			   ('result' -> reason).
			   ('errorStack' -> ((result signalerContext stack copyUpTo: testContext) collect: [ :ctx | ctx method method name ])) }
		   , extraEntries) asDictionary
]

{ #category : 'as yet unclassified' }
DomainExperiments >> writeViolationOf: t package: packageUnderTest result: result toWriter: writer [

	| frontier sandbox extraEntries reason |
	sandbox := (result signalerContext stack detect: [ :ctxt | ctxt method == (Sandbox >> #do:) ]) receiver.
	frontier := result signalerContext stack detect: [ :ctx |
		            (sandbox owns: ctx receiver) not and: [ sandbox owns: ctx sender receiver ] ].
	reason := 'sandboxViolation'.
	extraEntries := {
		                ('violationCause' -> result description).
		                ('ownershipFrontier' -> {
			                 frontier sender method method name.
			                 frontier method method name }) }.
	self
		writeErrorOfTest: t
		package: packageUnderTest
		result: result
		reason: reason
		writer: writer
		extraEntries: extraEntries
]
