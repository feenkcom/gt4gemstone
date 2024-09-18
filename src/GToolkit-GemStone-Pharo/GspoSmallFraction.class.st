Class {
	#name : #GspoSmallFraction,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GspoSmallFraction class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #SmallFraction
]

{ #category : #converting }
GspoSmallFraction >> extractAttributesForLocalObjectCode [
	^ '| fraction |
fraction := Fraction numerator: 10 denominator: 31.
Dictionary new 
	at: ''denominator'' put: fraction denominator;
	at: ''numerator'' put: fraction numerator;
	yourself'
]
