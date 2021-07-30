Extension { #name : 'String' }

{ #category : '*GToolkit-GemStone-GemStone' }
String >> gtGsPrintOn: writeStream [
	writeStream nextPutAll: self
]
