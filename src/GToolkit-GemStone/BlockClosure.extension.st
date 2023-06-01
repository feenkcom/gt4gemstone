Extension { #name : #BlockClosure }

{ #category : #'*GToolkit-GemStone' }
BlockClosure >> storeOn: aStream [

	GtGsStoreStringFlag value == true
		ifTrue: [ self printOn: aStream ]
		ifFalse: [ super storeOn: aStream ]
]
