Extension { #name : 'TestExecutionEnvironment' }

{ #category : '*Domains' }
TestExecutionEnvironment >> runTestCaseUnderWatchdog: aTestCase [

	[
		[
		Sandbox do: [ :sb |
			sb own: aTestCase.
			aTestCase runCase
		]
		] ensure: [
			"Terminated test is not considered as completed (user just closed a debugger for example)"
			mainTestProcess isTerminating ifFalse: [
				self handleCompletedTest ]]
	] on: Exception do: [ :err |
			self handleException: err
	]
]
