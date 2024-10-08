Class {
	#name : #GtRsrDirectLocalObjectSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrDirectLocalObjectSerializationStrategy >> serialize: anObject [ 
	| names instVarDictionary |
	
	"This code that sets the attributes be delegated through the class of the object"
	names := anObject class allInstVarNames.
	instVarDictionary := Dictionary new.
	1 to: names size do: [ :i |
		instVarDictionary at: (names at: i) put: (self instVarAt: i) ].
	
	^ Dictionary new 	
		at: 'instanceVariables' put: instVarDictionary;
		at: 'remoteInstance' put: (anObject asGtRsrProxyObjectForConnection: nil);
		at: 'remoteClassName' put: anObject class name;
		yourself
]
