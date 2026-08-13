Extension { #name : 'GsProcess' }

{ #category : '*GToolkit-GemStone-GemStone' }
GsProcess class >> gtAllFrames [
	| level frame result |

	result := OrderedCollection new.
	level := 2.
	[ frame := self _frameContentsAt: level.
	frame ~~ nil and: [ (frame at: 1) ~~ nil ] ] whileTrue:
		[ result add: frame.
		level := level + 1. ].
	^ result asArray.
]

{ #category : '*GToolkit-GemStone-GemStone' }
GsProcess >> gtAllFrames [

	^ (1 to: self stackDepth) collect: [ :i |
		self _frameContentsAt: i ]
]
