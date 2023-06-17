Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneCompileMethodFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 103>

	anAST methodNode ifNil: [ ^ self ].
	coderAddOns
		addContextMenuItem: 'Compile on GemStone' translated
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName source session category environmentId cmd gsMethod |
			clsName := self compiledMethod methodClass name.
			source := anAST source.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default GemStone session available' ].
			category := self compiledMethod category.
			"Where to get the environmentId from?  Only a method seems to know its environment"
			environmentId := '0'.
			session ifNil: [ self error: 'No default session available' ].
			cmd := String streamContents: [ :stream |
				stream
					<< clsName;
					<< ' compileMethod: ';
					print: source; cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
					<< 'category: #'''; << category; << ''''; cr;
					<< 'environmentId: '; << environmentId ].
			gsMethod := session evaluateAndWait: cmd.
			self notifyObjectSpawn: gsMethod.
			 ]
		id: nil
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneInspectMethodFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>

	anAST methodNode ifNil: [ ^ self ].
	coderAddOns
		addContextMenuItem: 'Inspect from GemStone' translated
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName session cmd gsMethod |
			clsName := self compiledMethod methodClass name.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default session available' ].
			cmd := String streamContents: [ :stream |
				stream 
					<< '(';
					<< clsName;
					<< ' methodDictForEnv: 0) at: #';
					<< selector ].
			gsMethod := [ session evaluateAndWait: cmd ]
				on: RsrBrokenPromise
				do: [ :ex | ex ].
			self notifyObjectSpawn: gsMethod ]
		id: nil
]
