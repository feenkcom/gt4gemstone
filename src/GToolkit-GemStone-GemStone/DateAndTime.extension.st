Extension { #name : 'DateAndTime' }

{ #category : '*GToolkit-GemStone-GemStone' }
DateAndTime class >> fromUnixTime: anInteger [
	^ self posixSeconds: anInteger offset: Duration new
]
