Extension { #name : 'TestExecutionEnvironment' }

{ #category : '*Domains' }
TestExecutionEnvironment >> runTestCaseUnderWatchdog: aTestCase [

	[ [ Sandbox forTest do: [ :sb | 
			sb own: aTestCase.
			aTestCase runCase ] ] ensure: [ mainTestProcess isTerminating ifFalse: [ self handleCompletedTest ] ] ]
		on: Exception
		do: [ :err | self handleException: err ]
]
