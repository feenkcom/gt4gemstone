Class {
	#name : #GtGemStoneProcessCoderModel,
	#superclass : #GtGemStoneMethodCodersModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneProcessCoderModel >> newCoderFor: aGsFrame [
	| coder |
	coder := GtGemStoneContextCoderModel fromStackFrame: aGsFrame .
	coder coders: self.
	^ coder
]
