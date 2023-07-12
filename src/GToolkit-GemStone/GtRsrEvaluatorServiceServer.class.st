Class {
	#name : #GtRsrEvaluatorServiceServer,
	#superclass : #GtRsrEvaluatorService,
	#category : 'GToolkit-GemStone'
}

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result"

	^ self
		gtDo: [ self gtEvaluate: aString for: anObject bindings: aDictionary ]
		gemstoneDo: [ self gsEvaluate: aString for: anObject bindings: aDictionary ]
]

{ #category : #actions }
GtRsrEvaluatorServiceServer >> evaluateAndWait: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result.
	 On the server it is always synchronous"

	^ self evaluate: aString for: anObject bindings: aDictionary
]

{ #category : #'private - GemStone' }
GtRsrEvaluatorServiceServer >> gsEvaluate: aString for: anObject bindings: aDictionary [
	"Evaluate the receiver's script, answering the result"
	| method result receiver symbolDictionary bindings object semaphore evaluationProcess |

	receiver := anObject class == GtRsrProxyServiceServer
		ifTrue: [ anObject object ]
		ifFalse: [ anObject ].
	symbolDictionary := SymbolDictionary new.
	aDictionary keysAndValuesDo: [ :key :value |
		object := (value isKindOf: GtRsrProxyService)
			ifTrue: [ value object ]
			ifFalse: [ value ].
		symbolDictionary at: key put: object ].
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).
	method := aString _compileInContext: receiver symbolList: bindings.
	semaphore := Semaphore new.

	evaluationProcess := [ [ result := method _executeInContext: receiver. semaphore signal ]
		on: Exception
		do: [ :ex |
			result := GtRsrEvaluationExceptionInformation new
				exception: ex;
				process: evaluationProcess.
			semaphore signal.
			evaluationProcess suspend ]
				] newProcess.
	evaluationProcess debugActionBlock: [ :ex |
		result := GtRsrEvaluationExceptionInformation new
			exception: ex;
			process: evaluationProcess.
		semaphore signal.
		evaluationProcess suspend ].
	evaluationProcess
		name: 'GT evaluation';
		priority: 15;
		breakpointLevel: 1.
	evaluationProcess resume.
	semaphore waitForSeconds: 10.

	^ result asGtRsrProxyObjectForConnection: _connection
]
