Extension { #name : 'Object' }

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> gtDisplayString [
  ^ self gtGsDisplayString
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> gtDo: gtoolkitBlock gemstoneDo: gemstoneBlock [
	"Evaluate the supplied platform specific block"

	^ gemstoneBlock value
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> gtGsDisplayString [
  | ws contents |
  ws := PrintStream printingOn: String new "maxSize: 100".

  [ self gtGsPrintOn: ws ] 
	on: Error 
	do: [ :error | ^ '<error printing>' ].
  contents := ws _collection.

  ^ contents size > 200
    ifTrue: [ (contents copyFrom: 1 to: 200) , '...' ]
    ifFalse: [ contents ]
]

{ #category : '*GToolkit-GemStone-GemStone' }
Object >> gtGsPrintOn: writeStream [
	self printOn: writeStream
]
