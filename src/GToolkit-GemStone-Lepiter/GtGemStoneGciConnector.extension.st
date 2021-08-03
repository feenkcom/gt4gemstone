Extension { #name : 'GtGemStoneGciConnector' }

{ #category : '*GToolkit-GemStone-Lepiter' }
GtGemStoneGciConnector classSide >> fromLepiterSettings: lepiterSettings [

	lepiterSettings connectionType = #GCI ifFalse: 
		[ self error: 'Invalid GemStone connection type: ', lepiterSettings connectionType printString ].
	^ self new
		gemstoneVersion: lepiterSettings gemstoneVersion;
		host: lepiterSettings host;
		libraryPath: lepiterSettings libraryPath;
		netldi: lepiterSettings netldi;
		stone: lepiterSettings stone;
		username: lepiterSettings username;
		password: lepiterSettings password;
		hostUsername: lepiterSettings hostUsername;
		hostPassword: lepiterSettings hostPassword.
]
