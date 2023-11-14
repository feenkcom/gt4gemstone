Class {
	#name : #GtGemStoneSourceCoderModel,
	#superclass : #GtSourceCoder,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'api - ast' }
GtGemStoneSourceCoderModel >> computeAst: theSourceString [
	^ GtGemStoneParser
		parseWithErrors: theSourceString
		startingAt: self startingStateForAstComputation
]

{ #category : #initialization }
GtGemStoneSourceCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

	addOns addStyler: GtGemStoneStyler new.
]

{ #category : #'instance creation' }
GtGemStoneSourceCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #accessing }
GtGemStoneSourceCoderModel >> startingStateForAstComputation [
	self subclassResponsibility
]
