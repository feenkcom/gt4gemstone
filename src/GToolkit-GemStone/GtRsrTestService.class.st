Class {
	#name : 'GtRsrTestService',
	#superclass : 'RsrService',
	#instVars : [
		'object'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'accessing' }
GtRsrTestService class >> templateClassName [

	^ #GtRsrTestService
]

{ #category : 'testing' }
GtRsrTestService >> isGtGemStoneRsrProxy [

	^ true
]

{ #category : 'accessing' }
GtRsrTestService >> object [
	^ object
]

{ #category : 'accessing' }
GtRsrTestService >> object: anObject [
	object := anObject
]
