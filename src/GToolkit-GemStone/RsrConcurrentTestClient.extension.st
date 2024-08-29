Extension { #name : #RsrConcurrentTestClient }

{ #category : #'*GToolkit-GemStone' }
RsrConcurrentTestClient >> counter: anArray [
	 remoteSelf counter: anArray
]

{ #category : #'*GToolkit-GemStone' }
RsrConcurrentTestClient >> startBackgroundFactorialComputation [

	^ remoteSelf startBackgroundFactorialComputation
]
