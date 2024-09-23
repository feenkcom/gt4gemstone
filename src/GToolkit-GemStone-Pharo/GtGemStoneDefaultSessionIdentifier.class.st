Class {
	#name : #GtGemStoneDefaultSessionIdentifier,
	#superclass : #GtGemStoneSessionIdentifier,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'lepiter-store' }
GtGemStoneDefaultSessionIdentifier class >> leJsonV4Name [

	^ #gtGemStoneDefaultSessionIdentifier
]

{ #category : #accessing }
GtGemStoneDefaultSessionIdentifier >> displayNameIn: aGtGemStoneSessionRegistry [

	^ aGtGemStoneSessionRegistry defaultSession
		ifNil: [ '<not selected>' ]
		ifNotNil: #displayName
]

{ #category : #'as yet unclassified' }
GtGemStoneDefaultSessionIdentifier >> identifierLabel [

	^ 'Default'
]

{ #category : #accessing }
GtGemStoneDefaultSessionIdentifier >> sessionIn: aGtGemStoneSessionRegistry [

	^ aGtGemStoneSessionRegistry defaultSession
]
