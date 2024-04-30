Extension { #name : #SequenceableCollection }

{ #category : #'*GToolkit-GemStone-Pharo' }
SequenceableCollection >> asGtGsArgumentIn: aGtGemStoneSession [
	"Answer the receiver ready to pass as an argument to a GtGemStone evaluation"
	
	^ self
		collect: [ :each | each asGtGsArgumentIn: aGtGemStoneSession ]
		as: Array
]
