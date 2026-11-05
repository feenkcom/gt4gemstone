Class {
	#name : #GtGemStoneAbstractGemDetails,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> description [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> detailAttributes [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> gemHost [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> gemLogFileName [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> gemProcessId [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> gemStoneSessionId [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> gemStoneVersion [

	^ self subclassResponsibility

]

{ #category : #ui }
GtGemStoneAbstractGemDetails >> gtDetailsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Gem details';
		priority: 10;
		items: [ self detailAttributes ];
		column: 'Attribute' text: #key;
		column: 'Value' text: #value;
		send: #value

]

{ #category : #testing }
GtGemStoneAbstractGemDetails >> hasGemLog [

	^ self subclassResponsibility

]

{ #category : #printing }
GtGemStoneAbstractGemDetails >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: self description ]

]

{ #category : #actions }
GtGemStoneAbstractGemDetails >> readGemLogUsing: aGtGemStoneSession [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractGemDetails >> stoneName [

	^ self subclassResponsibility

]
