Class {
	#name : #GtGemStoneMethodCoderModel,
	#superclass : #GtGemStoneSourceCoderModel,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCoderModel >> initializeForClassName: aClassName selector: aSelector sourceString: aSourceCode protocol: aProtocol [
	self methodBehavior:(GtPharoCoderBehavior explicit: aClassName).
	self selector: aSelector.
	self sourceCode: (GtCoderExplicitStringSource new source: aSourceCode).
	self protocol: aProtocol
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> methodBehavior [
	^ methodBehavior
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> methodBehavior: aGtMethodCoderBehavior [
	self
		assert: [ aGtMethodCoderBehavior isKindOf: GtPharoCoderBehavior ]
		description: [ 'Behavior must be reifined as an object' ].
	
	methodBehavior == aGtMethodCoderBehavior ifFalse: [ 
		methodBehavior := aGtMethodCoderBehavior. 
		self announce: (GtCoderBehaviorChanged new 
			newBehavior: aGtMethodCoderBehavior;
			coder: self) ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> protocol [
	<return: #String or: nil>

	^ self
		attributeNamed: #category
		ifAbsent: [
			Error signal: 'FIX ME' ]
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> protocol: aSymbol [
	^ self attributeNamed: #category put: aSymbol
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> selector [
	"Assign an original selector which changes when the compiled method is assigned.
	The selector of the new method is undefined (nil).
	See #currentSelector if you need to take the source code into account"
	<return: #Symbol or: nil>

	^ selector
]

{ #category : #accessing }
GtGemStoneMethodCoderModel >> selector: aSelector [
	selector := aSelector
]
