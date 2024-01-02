"
GtRsrLiteralAndProxySerializationStrategy answers nil, numbers and booleans by value and everything else by proxy (including strings).
"
Class {
	#name : #GtRsrLiteralAndProxySerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #converting }
GtRsrLiteralAndProxySerializationStrategy >> deserialize: anObject [
	"Deserialize the supplied object"
	
	^ anObject
]
