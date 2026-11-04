Class {
	#name : #GtGemStoneAbstractLogoutCause,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneAbstractLogoutCause >> description [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractLogoutCause >> loggedOutDescription [

	^ 'Auto-logged out'

]

{ #category : #printing }
GtGemStoneAbstractLogoutCause >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: self description ]

]

{ #category : #printing }
GtGemStoneAbstractLogoutCause >> printWarningFor: aGtGemStoneSession on: aStream [

]
