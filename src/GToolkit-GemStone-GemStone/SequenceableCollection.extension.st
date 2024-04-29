Extension { #name : 'SequenceableCollection' }

{ #category : '*GToolkit-GemStone-GemStone' }
SequenceableCollection >> allButFirstDo: block [

	2 to: self size do:
		[ :index | block value: (self at: index) ]
]

{ #category : '*GToolkit-GemStone-GemStone' }
SequenceableCollection >> asGtGsArgument [
	"Answer the the local object of the receiver"

	^ self collect: [ :each | each asGtGsArgument ]
]
