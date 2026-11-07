Class {
	#name : #GtGemStoneConnectorLogoutCause,
	#superclass : #GtGemStoneAbstractLogoutCause,
	#instVars : [
		'description'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneConnectorLogoutCause class >> description: aString [

	^ self new initializeWithDescription: aString

]

{ #category : #accessing }
GtGemStoneConnectorLogoutCause >> description [

	^ description

]

{ #category : #initialization }
GtGemStoneConnectorLogoutCause >> initializeWithDescription: aString [

	description := aString

]

{ #category : #printing }
GtGemStoneConnectorLogoutCause >> printWarningFor: aGtGemStoneSession on: aStream [

	aStream
		nextPutAll: aGtGemStoneSession name;
		nextPutAll: ': ';
		nextPutAll: description;
		nextPutAll: '. The session will be logged out. Postpone the logout only if you have a very good reason.'

]
