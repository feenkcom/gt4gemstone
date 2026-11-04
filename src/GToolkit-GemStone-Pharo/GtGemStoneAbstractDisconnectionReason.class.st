Class {
	#name : #GtGemStoneAbstractDisconnectionReason,
	#superclass : #Object,
	#instVars : [
		'time'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneAbstractDisconnectionReason class >> time: aDateAndTime [

	^ self new initializeWithTime: aDateAndTime

]

{ #category : #accessing }
GtGemStoneAbstractDisconnectionReason >> causeDescription [

	^ self statusDescription

]

{ #category : #accessing }
GtGemStoneAbstractDisconnectionReason >> description [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractDisconnectionReason >> detailAttributes [

	^ OrderedCollection new

]

{ #category : #testing }
GtGemStoneAbstractDisconnectionReason >> hadUncommittedChanges [

	^ false

]

{ #category : #initialization }
GtGemStoneAbstractDisconnectionReason >> initializeWithTime: aDateAndTime [

	time := aDateAndTime

]

{ #category : #testing }
GtGemStoneAbstractDisconnectionReason >> isKnown [

	^ true

]

{ #category : #printing }
GtGemStoneAbstractDisconnectionReason >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: self description ]

]

{ #category : #accessing }
GtGemStoneAbstractDisconnectionReason >> statusDescription [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractDisconnectionReason >> time [

	^ time

]

{ #category : #accessing }
GtGemStoneAbstractDisconnectionReason >> timeDescription [

	^ time asTime print24

]
