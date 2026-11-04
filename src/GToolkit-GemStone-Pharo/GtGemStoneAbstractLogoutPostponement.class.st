Class {
	#name : #GtGemStoneAbstractLogoutPostponement,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneAbstractLogoutPostponement >> description [

	^ self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractLogoutPostponement >> hasBeenPostponed [

	^ self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractLogoutPostponement >> isPostponedAt: aDateAndTime [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractLogoutPostponement >> logoutTimeAfter: aDateAndTime [

	^ self subclassResponsibility

]

{ #category : #printing }
GtGemStoneAbstractLogoutPostponement >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: self description ]

]
