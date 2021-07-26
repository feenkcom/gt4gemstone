Extension { #name : 'GtRsrEvaluatorServiceTest' }

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceTest >> errorClass [

	^ CompileError
]

{ #category : '*GToolkit-GemStone-GemStone' }
GtRsrEvaluatorServiceTest >> should: testBlock raise: anErrorClass withExceptionDo: exceptionBlock [

	testBlock
		on: anErrorClass
		do: [ :ex | 
			exceptionBlock value: ex.
			^ self ].
	self error: anErrorClass printString, ' not raised'.
]
