Class {
	#name : #GtGemStoneActiveProcessCallFrame,
	#superclass : #GtGemStoneLocalCallFrame,
	#category : #'GToolkit-GemStone'
}

{ #category : #printing }
GtGemStoneActiveProcessCallFrame >> printClassLabelOn: aStream [

	aStream nextPutAll: '[unknown]'
]

{ #category : #printing }
GtGemStoneActiveProcessCallFrame >> printMethodDescriptionOn: aStream [
	| gsMethod currentReceiver |
	
	gsMethod := frameContents at: 1.
	gsMethod ifNil:[
   	aStream nextPutAll: '<Reenter marker>'.
   	^ self ].
   	
	 currentReceiver := frameContents at: 10 .
	 "We reuse the current description of the gs method here"
   aStream nextPutAll: (gsMethod _descrForStackPadTo: 0 rcvr: currentReceiver)
]

{ #category : #accessing }
GtGemStoneActiveProcessCallFrame >> selfObject [

	self error: 'Active process call frames don''t know self'
]
