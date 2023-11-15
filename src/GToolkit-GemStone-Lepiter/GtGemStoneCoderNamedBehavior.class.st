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
GtGemStoneCoderNamedBehavior >> isMeta [
	^ isMeta
]

{ #category : #initialization }
GtGemStoneCoderNamedBehavior >> isMeta: aBoolean [
	isMeta := aBoolean 
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> printBehaviorName [
	^ self isMeta 
		ifTrue: [ self behaviorName, ' class' ] 
		ifFalse: [ self behaviorName ]
]

{ #category : #accessing }
GtGemStoneCoderNamedBehavior >> realBehaviorDo: aBlock [
	self realBehaviour
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
GtGemStoneCoderNamedBehavior >> theNonMetaClassorUndefinedDo: aBlock [
	| behaviourOrUndefined|
	
	behaviourOrUndefined := session evaluateAndWait: ('(GsCurrentSession currentSession symbolList objectNamed: #{1}) 
		ifNil: [ UndefinedObject ]' format: {self behaviorName} ).

	^ aBlock value: behaviourOrUndefined asGtBareProxyObject
]