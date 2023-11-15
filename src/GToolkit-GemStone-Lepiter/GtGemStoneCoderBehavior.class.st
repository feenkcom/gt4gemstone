Class {
	#name : #GtGemStoneCoderBehavior,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderBehavior class >> named: aBehaviorName [
	^ self named: aBehaviorName isMeta: false 
]

{ #category : #initialization }
GtGemStoneCoderBehavior class >> named: aBehaviorName isMeta: aBoolean [ 

	^ GtGemStoneCoderNamedBehavior new 
		behaviorName: aBehaviorName;
		isMeta: aBoolean 
]

{ #category : #initialization }
GtGemStoneCoderBehavior class >> named: aBehaviorName isMeta: aBoolean inSession: aSession [

	^ GtGemStoneCoderNamedBehavior new 
		behaviorName: aBehaviorName;
		isMeta: aBoolean ;
		session: aSession
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> behaviorNameDo: aBlock [
	^ self subclassResponsibility
]

{ #category : #testing }
GtGemStoneCoderBehavior >> isMeta [
	self subclassResponsibility
]

{ #category : #printing }
GtGemStoneCoderBehavior >> printBehaviorName [
	self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> realBehaviorDo: aBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> realBehaviorDo: aBlock ifAbsent: anAbsentBlock [
	self realBehaviorDo: [ :aBehavior | ^ aBlock value: aBehavior ].
	^ anAbsentBlock value
]

{ #category : #accessing }
GtGemStoneCoderBehavior >> theNonMetaClassorUndefinedDo: aBlock [
	^ self subclassResponsibility
]
