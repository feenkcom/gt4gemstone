Class {
	#name : #GtGemStoneMaxKeepAliveLogoutCause,
	#superclass : #GtGemStoneAbstractLogoutCause,
	#instVars : [
		'maxKeepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneMaxKeepAliveLogoutCause class >> maxKeepAlive: aNumber [

	^ self new initializeWithMaxKeepAlive: aNumber

]

{ #category : #accessing }
GtGemStoneMaxKeepAliveLogoutCause >> description [

	^ 'Max keep alive of ' , maxKeepAlive printString , ' minutes reached'

]

{ #category : #initialization }
GtGemStoneMaxKeepAliveLogoutCause >> initializeWithMaxKeepAlive: aNumber [

	maxKeepAlive := aNumber

]

{ #category : #accessing }
GtGemStoneMaxKeepAliveLogoutCause >> maxKeepAlive [

	^ maxKeepAlive

]
