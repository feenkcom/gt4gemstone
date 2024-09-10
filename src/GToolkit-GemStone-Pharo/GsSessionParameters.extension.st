Extension { #name : #GsSessionParameters }

{ #category : #'*GToolkit-GemStone-Pharo' }
GsSessionParameters >> gemService [
	^ self gemNrs
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GsSessionParameters >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	
	aStream parenthesize: [
		aStream << self gemService ]
]
