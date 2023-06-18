Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneCompileMethodFromFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 103>

	(anAST methodNode isNil or: 
		[ GtGemStoneSessionRegistry hasUniqueInstance not or: [
		GtGemStoneSessionRegistry default hasConnectors not ] ]) ifTrue: 
			[ ^ self ].
	coderAddOns
		addContextMenuItem: 'Compile from GemStone' translated
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName source session cmd |
			clsName := self compiledMethod methodClass name.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default GemStone session available' ].
			cmd := String streamContents: [ :stream |
				stream
					<< '(';
					<< clsName;
					<< ' compiledMethodAt: #';
					<< selector;
					<< ') sourceString' ].
			source := session evaluateAndWait: cmd.
			self compiledMethod methodClass
				compile: source
				classified: (self compiledMethod category) ]
		id: nil
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneCompileMethodToFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 103>

	(anAST methodNode isNil or: 
		[ GtGemStoneSessionRegistry hasUniqueInstance not or: [
		GtGemStoneSessionRegistry default hasConnectors not ] ]) ifTrue: 
			[ ^ self ].
	coderAddOns
		addContextMenuItem: 'Compile to GemStone' translated
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName source session category cmd gsMethod |
			clsName := self compiledMethod methodClass name.
			source := anAST source.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default GemStone session available' ].
			category := self compiledMethod category.
			cmd := String streamContents: [ :stream |
				stream
					<< clsName;
					<< ' compileMethod: ';
					print: source; cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
					<< 'category: #'''; << category; << ''''; cr;
					<< 'environmentId: 0' ].
			gsMethod := session evaluateAndWait: cmd.
			self notifyObjectSpawn: gsMethod ]
		id: nil
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneInspectMethodFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>

	(anAST methodNode isNil or: 
		[ GtGemStoneSessionRegistry hasUniqueInstance not or: [
		GtGemStoneSessionRegistry default hasConnectors not ] ]) ifTrue: 
			[ ^ self ].
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
