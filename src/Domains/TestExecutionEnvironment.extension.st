Extension { #name : 'TestExecutionEnvironment' }

{ #category : '*Domains' }
TestExecutionEnvironment >> runTestCaseUnderWatchdog: aTestCase [

	[
		[
			Sandbox do: [ :sb |
					self assert: thisProcess currentDomain notNil.

					"Make the test resources available outside of the sandbox.
					How do we sandbox them? They have global state!!!"
					aTestCase resources do: [ :each | each availableFor: aTestCase ].



					self services do: [ :s | sb own: s ].
					sb own: self.
					sb own: self watchDogProcess.

					sb own: aTestCase.
					self assert: thisProcess currentDomain notNil.

					(aTestCase isKindOf: ParametrizedTestCase) ifTrue: [ aTestCase parametersToUse do: [ :kv | sb own: kv value ] ].

					aTestCase runCase ] ] ensure: [ mainTestProcess isTerminating ifFalse: [ self handleCompletedTest ] ] ]
		on: Exception
		do: [ :err | self handleException: err ]
]
