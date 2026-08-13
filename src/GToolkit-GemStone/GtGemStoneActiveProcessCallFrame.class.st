Class {
	#name : 'GtGemStoneActiveProcessCallFrame',
	#superclass : 'GtGemStoneLocalCallFrame',
	#category : 'GToolkit-GemStone'
}

{ #category : 'printing' }
GtGemStoneActiveProcessCallFrame >> printClassLabelOn: aStream [

	aStream nextPutAll: '[unknown]'
]

{ #category : 'printing' }
GtGemStoneActiveProcessCallFrame >> printMethodDescriptionOn: aStream [
	self isForBlock ifTrue: [
		aStream nextPutAll: '[] in ' ].
	self selector 
		ifNil: [ aStream nextPutAll: '<none>']
		ifNotNil: [ :aSelector | 
			aStream nextPutAll: aSelector ]
]

{ #category : 'accessing' }
GtGemStoneActiveProcessCallFrame >> selfObject [

	self error: 'Active process call frames don''t know self'
]
