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
GspoSmallFraction >> createGtpoLocalObjectLinkedToBareProxy: aBareProxy [
	"Answer a local copy of the receiver and add a mapping between the local copy and the given bare proxy"
	| instVarDict localClass localObject |

	instVarDict := self evaluateAndWait: self extractAttributesForLocalObjectCode.
	
	"GemStone has a SmallFraction class, however, 
	locally we could just have a Fraction class.
	In that case we default and use Fraction to 
	instantiate locally instances of type SmallFraction"
	
	localClass := (self class environment includesKey: #SmallFraction)
		ifTrue: [ remoteClass ]
		ifFalse: [ #Fraction ].
	
	localObject := (self class environment at: localClass) basicNew.
	instVarDict associationsDo: [ :assoc |
		localObject 
			instVarNamed: assoc key 
			put: assoc value asGtBareProxyObject ].
	self class proxyObjectMap at: localObject put: aBareProxy.
	^ localObject.
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
