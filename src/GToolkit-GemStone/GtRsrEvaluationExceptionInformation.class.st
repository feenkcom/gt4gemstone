"
GtRsrEvaluationExceptionInformation is used to pass information about an exception that occurred in GemStone back to GT, allowing a debugger to be opened on the exception.
"
Class {
	#name : #GtRsrEvaluationExceptionInformation,
	#superclass : #Object,
	#instVars : [
		'exception',
		'process'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrEvaluationExceptionInformation >> exception [

	^ exception
]

{ #category : #accessing }
GtRsrEvaluationExceptionInformation >> exception: anException [

	exception := anException
]

{ #category : #accessing }
GtRsrEvaluationExceptionInformation >> process [

	^ process
]

{ #category : #accessing }
GtRsrEvaluationExceptionInformation >> process: aGsProcess [

	process := aGsProcess
]
