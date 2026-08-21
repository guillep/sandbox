*Domains
runTestCaseUnderWatchdog: aTestCase

	[
		[
		
			Sandbox do: [ :sb |
					sb own: aTestCase.
					aTestCase runCase ]
		
		] ensure: [
			mainTestProcess isTerminating
				ifFalse: [ self handleCompletedTest ] ] ]
		on: Exception
		do: [ :err | self handleException: err ]
		
	

