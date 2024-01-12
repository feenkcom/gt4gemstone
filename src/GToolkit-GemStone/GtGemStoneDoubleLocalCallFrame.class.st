Class {
	#name : #GtGemStoneDoubleLocalCallFrame,
	#superclass : #Object,
	#instVars : [
		'previousCallFrame',
		'newCallFrame',
		'sender'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneDoubleLocalCallFrame class >> forPreviousCallFrame: aPreviousCallFrame newCallFrame: aNewCallFrame [
	^ self new 
		initializeForPreviousCallFrame: aPreviousCallFrame 
		newCallFrame: aNewCallFrame
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> frameIdentifierDescription [
	^ String streamContents: [ :aStream | 
		self printFrameIdentifierDescriptionOn: aStream ]
]

{ #category : #testing }
GtGemStoneDoubleLocalCallFrame >> hasCallFrames [ 
	^ previousCallFrame notNil and: [ newCallFrame notNil ]
]

{ #category : #testing }
GtGemStoneDoubleLocalCallFrame >> hasSameProperties [
	^ self hasCallFrames and: [ 
			previousCallFrame hasSamePropertiesAs: newCallFrame ]
]

{ #category : #testing }
GtGemStoneDoubleLocalCallFrame >> hasSamePropertiesSinceTheBeginning [
	| currentContext |
	currentContext := self.
	[ currentContext notNil and: [currentContext hasSameProperties ] ]
		whileTrue: [ currentContext := currentContext sender ].
		
	^ currentContext isNil
]

{ #category : #initialization }
GtGemStoneDoubleLocalCallFrame >> initializeForPreviousCallFrame: aPreviousCallFrame newCallFrame: aNewCallFrame [ 
	previousCallFrame := aPreviousCallFrame.
	newCallFrame := aNewCallFrame.
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> ipOffsetDescription [
	^ String streamContents: [ :aStream | 
		self printIpOffsetDescriptionOn: aStream ]
]

{ #category : #testing }
GtGemStoneDoubleLocalCallFrame >> isForSameMethodOrBlock [
	^ self hasCallFrames and: [
			previousCallFrame isForSameMethodOrBlockAs: newCallFrame ]
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> methodDescription [
	^ String streamContents: [ :aStream | 
		self printMethodDescriptionOn: aStream ]
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> newCallFrame [
	^ newCallFrame
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> newFrameIdentifier [
	^ newCallFrame 
		ifNil: [ nil ]
		ifNotNil: [ :aCallFrame | aCallFrame frameIdentifier ]
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> newIpOffset [
	^ newCallFrame 
		ifNil: [ nil ]
		ifNotNil: [ :aCallFrame | aCallFrame ipOffset ]
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> phlowBackgroundColor [
	| allSendersMatch |
	allSendersMatch := self sender
		ifNil: [true] 
		ifNotNil: [ :aSender | aSender hasSamePropertiesSinceTheBeginning ].
	
	^ (self hasSameProperties and: [ allSendersMatch ])
			ifTrue: [ GtPhlowColor named: #green alpha: 0.4 ]
			ifFalse: [ 
				allSendersMatch
					ifTrue: [ GtPhlowColor named: #orange alpha: 0.4 ]
					ifFalse: [ GtPhlowColor transparent ]  ]
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> phlowBackgroundColorInIsolation [
	| senderMatches |
	senderMatches := self sender
		ifNil: [true] 
		ifNotNil: [ :aSender | aSender hasSameProperties ].
	
	^ self hasSameProperties
			ifTrue: [ GtPhlowColor named: #green alpha: 0.4 ]
			ifFalse: [ 
				senderMatches
					ifTrue: [ GtPhlowColor named: #orange alpha: 0.4 ]
					ifFalse: [ GtPhlowColor transparent ]  ]
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> previousCallFrame [
	^ previousCallFrame
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> previousFrameIdentifier [
	^ previousCallFrame 
		ifNil: [ nil ]
		ifNotNil: [ :aCallFrame | aCallFrame frameIdentifier ]
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> previousIpOffset [
	^ previousCallFrame 
		ifNil: [ nil ]
		ifNotNil: [ :aCallFrame | aCallFrame ipOffset ]
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> printComparisonBetween: anObject and: anotherObject withFormat: aFormatBlock on: aStream [
	| previousDescription newDescription|
	previousDescription := anObject
		ifNil: [ ' - '] ifNotNil: [ :targetObject | aFormatBlock cull: targetObject ].
	newDescription := anotherObject
		ifNil: [ ' - '] ifNotNil: [ :targetObject | aFormatBlock cull: targetObject ].
	
	anObject = anotherObject
		ifTrue: [
			aStream
				nextPutAll: previousDescription ]
		ifFalse: [
			aStream
				nextPutAll: previousDescription;
				nextPutAll: ' / ';
				nextPutAll: newDescription ]
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> printFrameIdentifierDescriptionOn: aStream [
	^ self 
		printComparisonBetween: self previousFrameIdentifier 
		and: self newFrameIdentifier 
		withFormat: [ :anIdentifier | anIdentifier description ] 
		on: aStream
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> printIpOffsetDescriptionOn: aStream [
	^ self 
		printComparisonBetween: self previousIpOffset 
		and: self newIpOffset 
		withFormat: [ :anOffset | anOffset asString ]
		on: aStream
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> printMethodDescriptionOn: aStream [
	| previousDescription newDescription|
	previousDescription := self previousCallFrame
		ifNil: [ ' - '] ifNotNil: [ :aCallFrame | aCallFrame methodDescription ].
	newDescription := self newCallFrame
		ifNil: [ ' - '] ifNotNil: [ :aCallFrame | aCallFrame methodDescription ].
	
	self isForSameMethodOrBlock
		ifTrue: [
			aStream
				nextPutAll: previousDescription ]
		ifFalse: [
			aStream
				nextPutAll: previousDescription;
				nextPutAll: ' / ';
				nextPutAll: newDescription ]
]

{ #category : #printing }
GtGemStoneDoubleLocalCallFrame >> printOn: aStream [
	super printOn: aStream.
	
	self isForSameMethodOrBlock ifTrue: [
		aStream parenthesize: [ 
			previousCallFrame printMethodDescriptionOn: aStream.
			aStream 
				nextPutAll: ' ['.
			self printIpOffsetDescriptionOn: aStream.
			aStream
				nextPutAll: ']; id='.
			self printFrameIdentifierDescriptionOn: aStream ].
		^ self ].
		
	aStream parenthesize: [ 
		previousCallFrame
			ifNil: [ aStream nextPutAll: ' - ']
			ifNotNil: [ 
				previousCallFrame printMethodDescriptionOn: aStream.
				aStream nextPutAll: ' '.
				previousCallFrame printExtraDetailsOn: aStream. ].
		aStream nextPutAll: ' / '.
		newCallFrame
			ifNil: [ aStream nextPutAll: ' - ']
			ifNotNil: [ 
				newCallFrame printMethodDescriptionOn: aStream.
				aStream nextPutAll: ' '.
				newCallFrame printExtraDetailsOn: aStream. ] ] 
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> sender [
	^ sender
]

{ #category : #accessing }
GtGemStoneDoubleLocalCallFrame >> sender: aDoubleStackFrame [
	(sender isNil and: [ aDoubleStackFrame notNil ]) ifFalse: [ Error signal] .
	
	sender := aDoubleStackFrame
]
