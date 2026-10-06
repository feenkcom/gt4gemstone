Extension { #name : #SequenceableCollection }

{ #category : #'*GToolkit-GemStone-GemStone' }
SequenceableCollection >> allButFirstDo: block [

	2 to: self size do:
		[ :index | block value: (self at: index) ]
]

{ #category : #'*GToolkit-GemStone-GemStone' }
SequenceableCollection >> asGtGsArgument [
	"Answer the the local object of the receiver"

	1 to: self size do: [ :i |
		self at: i put: (self at: i) asGtGsArgument ]
]

{ #category : #'*GToolkit-GemStone-GemStone' }
SequenceableCollection >> flatCollect: aBlock [
	"Evaluate aBlock for each of the receiver's elements and answer the
	list of all resulting values flatten one level. Assumes that aBlock returns some kind
	of collection for each element. optimized version for Sequencable Collection and subclasses
	implementing #writeStream"

	"(#( (2 -3) (4 -5) #(-6)) flatCollect: [ :e | e abs  ]) >>> #(2 3 4 5 6)"

	"(#( (2 -3) #((4 -5)) #(-6)) flatCollect: [ :e | e abs  ]) >>> #(2 3 #(4 5) 6)"

	self isEmpty
		ifTrue: [ ^ self copy ].
	^ self class 
		new: 0
		streamContents: [ :stream | self do: [ :each | stream nextPutAll: (aBlock value: each) ] ]
]
