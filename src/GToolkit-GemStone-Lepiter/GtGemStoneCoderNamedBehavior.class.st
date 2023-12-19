Class {
	#name : #GtGemStoneCoderNamedBehavior,
	#superclass : #GtGemStoneCoderBehavior,
	#instVars : [
		'behaviorName',
		'isMeta',
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> behaviorName [
	^ behaviorName
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> behaviorName: aBehaviorName [
	behaviorName := aBehaviorName
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> behaviorNameDo: aBlock [
	^ aBlock value: self printBehaviorName
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> computeRealBehaviour [
	^ session evaluateAndWait: ('(GsCurrentSession currentSession symbolList objectNamed: #{1})' format: {self behaviorName} ).
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> isMeta [
	^ isMeta
]

{ #category : #initialization }
GtGemStoneCoderNamedBehavior >> isMeta: aBoolean [
	isMeta := aBoolean 
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> printBehaviorName [
	self behaviorName ifNil: [ ^ '<none>' ].
	
	^ self isMeta 
		ifTrue: [ self behaviorName, ' class' ] 
		ifFalse: [ self behaviorName ]
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> realBehaviorDo: aBlock [
	self computeRealBehaviour
		ifNotNil: [ :aGsBehaviour | ^ aBlock value: aGsBehaviour ]
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> session: anObject [
	session := anObject
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> theNonMetaClassOrUndefinedDo: aBlock [
	| behaviourOrUndefined |
	
	behaviourOrUndefined := session evaluateAndWait: ('(GsCurrentSession currentSession symbolList objectNamed: #{1}) 
		ifNil: [ UndefinedObject ]' format: {self behaviorName} ).

	^ aBlock value: behaviourOrUndefined asGtBareProxyObject
]
