Class {
	#name : #GtGemStoneExplicitSessionIdentifier,
	#superclass : #GtGemStoneSessionIdentifier,
	#instVars : [
		'sessionName'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'lepiter-store' }
GtGemStoneExplicitSessionIdentifier class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: #sessionName -> #sessionName;
		yourself
]

{ #category : #'lepiter-store' }
GtGemStoneExplicitSessionIdentifier class >> leJsonV4Name [

	^ #gtGemStoneExplicitSessionIdentifier
]

{ #category : #'instance creation' }
GtGemStoneExplicitSessionIdentifier class >> sessionName: aSessionName [

	^ self new sessionName: aSessionName
]

{ #category : #converting }
GtGemStoneExplicitSessionIdentifier >> asExplicitSessionIdentifier [

	^ self
]

{ #category : #'as yet unclassified' }
GtGemStoneExplicitSessionIdentifier >> displayName [ 
	"Auto-generated - move out of session-compatibility if a manually maintained version is required"

	^ (sessionName endsWith: ':default')
		ifTrue: [ sessionName copyFrom: 1 to: sessionName size - 8 ]
		ifFalse: [ sessionName ]
]

{ #category : #accessing }
GtGemStoneExplicitSessionIdentifier >> displayNameIn: aGtGemStoneSessionRegistry [

	^ self displayName
]

{ #category : #accessing }
GtGemStoneExplicitSessionIdentifier >> identifierLabel [

	^ 'Explicit'
]

{ #category : #testing }
GtGemStoneExplicitSessionIdentifier >> isExplicitSessionIdentifier [

	^ true
]

{ #category : #accessing }
GtGemStoneExplicitSessionIdentifier >> sessionIn: aGtGemStoneSessionRegistry [

	^ aGtGemStoneSessionRegistry sessionNamed: sessionName
]

{ #category : #accessing }
GtGemStoneExplicitSessionIdentifier >> sessionName [
	^ sessionName
]

{ #category : #accessing }
GtGemStoneExplicitSessionIdentifier >> sessionName: aString [

	sessionName := aString
]
