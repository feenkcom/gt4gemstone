Class {
	#name : #GtGemStoneSessionIdentifier,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'lepiter-store' }
GtGemStoneSessionIdentifier class >> leJsonV4AttributeMapping [
	"Answer the Array of attribute to store keys.
	Subclasses should override this with their attributes.
	This is an array as it is normally cached."

	^ OrderedCollection new.
]

{ #category : #'lepiter-store' }
GtGemStoneSessionIdentifier class >> leJsonV4Name [

	^ nil
]

{ #category : #converting }
GtGemStoneSessionIdentifier >> asGemStoneSessionIdentifier [

	^ self
]

{ #category : #accessing }
GtGemStoneSessionIdentifier >> displayNameIn: aGtGemStoneSessionRegistry [

	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneSessionIdentifier >> identifierLabel [

	^ self subclassResponsibility
]

{ #category : #testing }
GtGemStoneSessionIdentifier >> isExplicitSessionIdentifier [

	^ false
]

{ #category : #testing }
GtGemStoneSessionIdentifier >> isSessionIdentifier [

	^ true
]

{ #category : #accessing }
GtGemStoneSessionIdentifier >> sessionIn: aGtGemStoneSessionRegistry [

	^ self subclassResponsibility
]
