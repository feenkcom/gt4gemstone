Class {
	#name : #GtGemStoneMethodCodersViewModel,
	#superclass : #GtPharoMethodsCoderViewModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCodersViewModel >> coderUIModelFor: aCoder [
	^ aCoder asCoderViewModel
		expanded: false;
		withoutHeader";
		selfObject: self coder object"
]
