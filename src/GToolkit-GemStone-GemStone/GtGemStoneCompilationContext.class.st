Class {
	#name : #GtGemStoneCompilationContext,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'frame',
		'frameIdentifier',
		'frameLevel',
		'evaluationContext',
		'clientBindings',
		'frameBindings'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneCompilationContext class >> receiver: anObject  frameIdentifierIndex: aFrameIdentifierIndex evaluationContext: aTargetEvaluationContext clientBindings: aDictionary [ 
	^ self new 
			setReceiver: anObject  
			frameIdentifierIndex: aFrameIdentifierIndex 
			evaluationContext: aTargetEvaluationContext 
			clientBindings: aDictionary
]

{ #category : #accessing }
GtGemStoneCompilationContext >> allBindings [
	| allBindings |
	allBindings := GsCurrentSession currentSession symbolList
		, (Array with: clientBindings).

	^ frame
		ifNil: [allBindings ]
		ifNotNil: [ allBindings, (Array with: frameBindings) ]
]

{ #category : #bindings }
GtGemStoneCompilationContext >> createClientBindingsFrom: aDictionary [
	| newBindings |

	newBindings := SymbolDictionary new
		name: #'Explicit client bindings'.
	aDictionary keysAndValuesDo: [ :key :value |
		newBindings at: key put: value asGtGsArgument ].

	^ newBindings
]

{ #category : #bindings }
GtGemStoneCompilationContext >> createFrameBindignsForFrame: aCallFrame ofEvaluationContext: aTargetEvaluationContext [
	^ aCallFrame createFrameBindings
			name: ('Frame bindings for frame index ' 
				, frame frameIdentifier identityIndex printString
				,  ' in process with oop '
				,  aTargetEvaluationContext processOop printString) asSymbol;
			yourself
]

{ #category : #accessing }
GtGemStoneCompilationContext >> currentReceiver [
	^ frame 
		ifNil: [ receiver ]
		ifNotNil: [ frame receiver ]
]

{ #category : #private }
GtGemStoneCompilationContext >> initializeFrameWithFrameIdentifierIndex: aFrameIdentifierIndex [
	frame := evaluationContext frameForIdentifierIndex: aFrameIdentifierIndex.
	frameIdentifier := frame frameIdentifier.
	frameLevel := evaluationContext frameLevelForIdentifier: frameIdentifier.
	frameBindings := self 
		createFrameBindignsForFrame: frame 
		ofEvaluationContext: evaluationContext
]

{ #category : #private }
GtGemStoneCompilationContext >> setReceiver: anObject  frameIdentifierIndex: aFrameIdentifierIndex evaluationContext: aTargetEvaluationContext clientBindings: aDictionary [
	receiver := anObject.
	clientBindings := self createClientBindingsFrom: aDictionary.

	(aFrameIdentifierIndex notNil and: [
		aTargetEvaluationContext notNil]) ifTrue: [
			evaluationContext := aTargetEvaluationContext.
			self initializeFrameWithFrameIdentifierIndex: aFrameIdentifierIndex ]
]

{ #category : #updating }
GtGemStoneCompilationContext >> updatedFrameBindings [
	frame ifNil: [ ^ self ].

	evaluationContext 
			updateBindingsForFrame: frame
			atLevel: frameLevel
			with: frameBindings
]
