"
GtGemStoneSessionCodeSync holds the code sync state for a session
"
Class {
	#name : #GtGemStoneSessionCodeSync,
	#superclass : #Object,
	#instVars : [
		'classStrategy',
		'eventStrategy',
		'enabled',
		'gtSession'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #'instance creation' }
GtGemStoneSessionCodeSync class >> gtSession: aGtGemStoneSession [

	^ self new gtSession: aGtGemStoneSession
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> classStrategy [

	^ classStrategy ifNil: [ self registry codeSync defaultClassStrategy ]
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> classStrategy: anObject [
	classStrategy := anObject
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> connector [

	^ gtSession connector
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> enabled [
	^ enabled
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> enabled: aBoolean [
	"Set the code sync flag.
	It can only be true if the connector allows code sync."

	(aBoolean and: [ self connector isCodeSyncAllowed not ]) ifTrue:
		[ self error: 'Code-sync not allowed' ].
	enabled := aBoolean
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> eventStrategy [
	^ eventStrategy
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> eventStrategy: anObject [
	eventStrategy := anObject
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> gtSession: anObject [
	gtSession := anObject
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> initialize [

	super initialize.
	enabled := false.
	eventStrategy := GtGemStoneCodeSyncEpEventStrategy new.
]

{ #category : #accessing }
GtGemStoneSessionCodeSync >> registry [

	^ gtSession registry
]
