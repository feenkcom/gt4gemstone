Extension { #name : 'Symbol' }

{ #category : '*GToolkit-GemStone-GemStone' }
Symbol >> asMutator [
	^ self, ':'
]

{ #category : '*GToolkit-GemStone-GemStone' }
Symbol >> cull: anObject [

	^ anObject perform: self
]

{ #category : '*GToolkit-GemStone-GemStone' }
Symbol >> cull: anObject cull: arg2 [

	^ anObject perform: self
]

{ #category : '*GToolkit-GemStone-GemStone' }
Symbol >> cull: anObject cull: arg2 cull: arg3 [

	^ anObject perform: self
]

{ #category : '*GToolkit-GemStone-GemStone' }
Symbol >> cull: anObject cull: arg2 cull: arg3 cull: arg4 [

	^ anObject perform: self
]

{ #category : '*GToolkit-GemStone-GemStone' }
Symbol >> value: anObject [

	^ anObject perform: self
]
