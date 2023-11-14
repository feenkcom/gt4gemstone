Class {
	#name : #GtGemStoneSourceCoderModel,
	#superclass : #GtSourceCoder,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'api - ast' }
GtGemStoneSourceCoderModel >> computeAst: theSourceString [
	^ GtGemStoneParser
		parseWithErrors: theSourceString
		startingAt: GtGemStoneParser startingStateForMethodSequence
]

{ #category : #'instance creation' }
GtGemStoneSourceCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]
