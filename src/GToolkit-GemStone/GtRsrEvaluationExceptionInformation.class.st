Class {
	#name : 'GtRsrEvaluationExceptionInformation',
	#superclass : 'Object',
	#instVars : [
		'exception',
		'process'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'accessing' }
GtRsrEvaluationExceptionInformation >> exception [

	^ exception
]

{ #category : 'accessing' }
GtRsrEvaluationExceptionInformation >> exception: anException [

	exception := anException
]

{ #category : 'accessing' }
GtRsrEvaluationExceptionInformation >> process [

	^ process
]

{ #category : 'accessing' }
GtRsrEvaluationExceptionInformation >> process: aGsProcess [

	process := aGsProcess
]
