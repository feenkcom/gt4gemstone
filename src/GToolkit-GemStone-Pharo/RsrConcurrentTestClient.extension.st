Extension { #name : #RsrConcurrentTestClient }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrConcurrentTestClient >> counter: anArray [
	 remoteSelf counter: anArray
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrConcurrentTestClient >> startBackgroundFactorialComputation [

	^ remoteSelf startBackgroundFactorialComputation
]
