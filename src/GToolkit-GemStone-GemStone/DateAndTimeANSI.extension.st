Extension { #name : 'DateAndTimeANSI' }

{ #category : '*GToolkit-GemStone-GemStone' }
DateAndTimeANSI class >> readFrom: aStream [
	"Basic compatibility with Pharo DateAndTime>>readFrom:.	
	Assumes that the DateAndTime is the last thing in the stream."

	^ self fromString: aStream upToEnd
]
