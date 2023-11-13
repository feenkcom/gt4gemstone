Extension { #name : 'GsProcess' }

{ #category : '*GToolkit-GemStone-GemStone' }
GsProcess >> gtAllFrames [

	^ (1 to: self stackDepth) collect: [ :i |
		self _frameContentsAt: i ]
]
