Class {
	#name : #GtGemStoneAbstractGemLogEnding,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneAbstractGemLogEnding >> attributes [

	^ OrderedCollection new
		add: 'Reason' -> self description;
		add: 'Explanation' -> self explanation;
		yourself

]

{ #category : #accessing }
GtGemStoneAbstractGemLogEnding >> description [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemLogEnding >> explanation [

	^ self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractGemLogEnding >> isTerminatedByGemStone [

	^ false

]

{ #category : #printing }
GtGemStoneAbstractGemLogEnding >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: self description ]

]
