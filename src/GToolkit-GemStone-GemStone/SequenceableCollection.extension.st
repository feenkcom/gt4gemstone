Extension { #name : #SequenceableCollection }

{ #category : #'*GToolkit-GemStone-GemStone' }
SequenceableCollection >> allButFirstDo: block [

	2 to: self size do:
		[ :index | block value: (self at: index) ]
]
