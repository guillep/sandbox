Extension { #name : 'TestExecutionEnvironment' }

{ #category : '*Domains' }
TestExecutionEnvironment >> runTestCaseUnderWatchdog: aTestCase [

	[ [ Sandbox forTest do: [ :sb | 
			self assert: thisProcess currentDomain notNil.
			sb own: aTestCase.
			self assert: thisProcess currentDomain notNil.
			aTestCase runCase ] ] ensure: [ mainTestProcess isTerminating ifFalse: [ self handleCompletedTest ] ] ]
		on: Exception
		do: [ :err | self handleException: err ]
]
