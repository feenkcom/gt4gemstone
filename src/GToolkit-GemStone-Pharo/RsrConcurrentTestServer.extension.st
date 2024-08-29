Extension { #name : #RsrConcurrentTestServer }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrConcurrentTestServer >> startBackgroundFactorialComputation [
	stashedProcess := [
		5000 timesRepeat: [ 5000 factorial ]  
	] forkAt: Processor userBackgroundPriority
]
