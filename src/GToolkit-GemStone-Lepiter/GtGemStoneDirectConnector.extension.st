Extension { #name : 'GtGemStoneDirectConnector' }

{ #category : '*GToolkit-GemStone-Lepiter' }
GtGemStoneDirectConnector classSide >> fromLepiterSettings: lepiterSettings [

	lepiterSettings connectionType = #direct ifFalse: 
		[ self error: 'Invalid GemStone connection type: ', lepiterSettings connectionType printString ].
	^ self new
		host: lepiterSettings host;
		port: lepiterSettings port.
]
