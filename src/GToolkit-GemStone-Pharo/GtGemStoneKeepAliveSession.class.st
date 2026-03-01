Class {
	#name : #GtGemStoneKeepAliveSession,
	#superclass : #Object,
	#instVars : [
		'session',
		'dirtyCount',
		'maxKeepAlive'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneKeepAliveSession class >> session: aGtGemStoneSession [

	^ self new session: aGtGemStoneSession
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> dirtyCount [

	^ dirtyCount
]

{ #category : #private }
GtGemStoneKeepAliveSession >> incrementDirtyCount [

	dirtyCount := dirtyCount + 1.
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> initialize [

	super initialize.
	self resetDirtyCount.
]

{ #category : #testing }
GtGemStoneKeepAliveSession >> isDirty [
	"Answer a boolean indicating whether the receiver's session is considered dirty, i.e. it has needed a commit for the last two keepAlive polls"

	^ dirtyCount > 1
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> maxKeepAlive [
	"Answer the number of minutes to keep the session alive"

	^ maxKeepAlive
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> maxKeepAlive: anInteger [

	maxKeepAlive := anInteger
]

{ #category : #private }
GtGemStoneKeepAliveSession >> resetDirtyCount [

	dirtyCount := 0.
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneKeepAliveSession >> session: anObject [
	session := anObject
]
