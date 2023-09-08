Extension { #name : #BlockClosure }

{ #category : #'*GToolkit-GemStone-Pharo' }
BlockClosure >> storeOn: aStream [

	GtGsStoreStringFlag value == true
		ifTrue: [ self printOn: aStream ]
		ifFalse: [ super storeOn: aStream ]
]
