Class {
	#name : #GtGemStoneAbstractSessionConnectionRecord,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #adding }
GtGemStoneAbstractSessionConnectionRecord >> addFirstTo: anOrderedCollection [

	self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractSessionConnectionRecord >> canPostponeAutoLogout [

	^ self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractSessionConnectionRecord >> canRecordConnectionLoss [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractSessionConnectionRecord >> description [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractSessionConnectionRecord >> disconnectionReason [

	^ self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractSessionConnectionRecord >> hasKeepAlive [

	^ self subclassResponsibility

]

{ #category : #testing }
GtGemStoneAbstractSessionConnectionRecord >> isLogoutPending [

	^ self subclassResponsibility

]

{ #category : #accessing }
GtGemStoneAbstractSessionConnectionRecord >> keepAlive [

	^ self subclassResponsibility

]

{ #category : #printing }
GtGemStoneAbstractSessionConnectionRecord >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: self description ]

]

{ #category : #recording }
GtGemStoneAbstractSessionConnectionRecord >> recordDisconnectionReason: aDisconnectionReason [

	self subclassResponsibility

]
