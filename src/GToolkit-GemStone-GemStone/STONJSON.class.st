Class {
	#name : 'STONJSON',
	#superclass : 'Object',
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'other' }
STONJSON class >> fromString: aString [
	^ JsonParser parse: aString
]

{ #category : 'other' }
STONJSON class >> toString: object [
	^ STON toJsonString: object
]

{ #category : 'other' }
STONJSON class >> toStringPretty: object [
	^ STON toJsonStringPretty: object
]
