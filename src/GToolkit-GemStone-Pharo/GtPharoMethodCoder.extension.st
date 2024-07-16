Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneCompileMethodFromFor: anAST into: coderAddOns [
	<gtCoderContextMenuAddOns: 303>
	| sessionName |
	
	(anAST methodNode isNil or: 
		[ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not]) 
			ifTrue: [ ^ self ].
	sessionName := GtGemStoneSessionRegistry default defaultSession
		ifNotNil: [ :aSession | aSession name ].
		
	coderAddOns
		addContextMenuItem: (self
				createLabel: 'Compile from GemStone'
				description: sessionName asString)
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName source session cmd |
			clsName := self compiledMethod methodClass name.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default GemStone session available' ].
			session connect.
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
	<gtCoderContextMenuAddOns: 302>
	| sessionName |
	(anAST methodNode isNil
		or: [ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not ])
		ifTrue: [ ^ self ].

	sessionName := GtGemStoneSessionRegistry default defaultSession
			ifNotNil: [ :aSession | aSession name ].
	coderAddOns
		addContextMenuItem: (self
				createLabel: 'Compile to GemStone'
				description: sessionName asString)
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName source session category cmd |
			clsName := self compiledMethod methodClass name.
			source := anAST source.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default GemStone session available' ].
			session connect.
			category := self compiledMethod category.
			cmd := String
					streamContents: [ :stream | 
						stream
							<< clsName;
							<< ' compileMethod: ';
							print: source;
							cr;
							<< 'dictionaries: GsCurrentSession currentSession symbolList';
							cr;
							<< 'category: #''';
							<< category;
							<< '''';
							cr;
							<< 'environmentId: 0' ].
			session evaluateAndWait: cmd ]
		id: nil
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneInspectMethodFor: anAST into: coderAddOns [
	<gtCoderContextMenuAddOns: 304>
	| sessionName |
	(anAST methodNode isNil
		or: [ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not ])
		ifTrue: [ ^ self ].
	sessionName := GtGemStoneSessionRegistry default defaultSession
			ifNotNil: [ :aSession | aSession name ].

	coderAddOns
		addContextMenuItem: (self
				createLabel: 'Inspect from GemStone'
				description: sessionName asString)
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName session cmd gsMethod |
			clsName := self compiledMethod methodClass name.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default session available' ].
			session connect.
			cmd := String
					streamContents: [ :stream | 
						stream
							<< '(';
							<< clsName;
							<< ' methodDictForEnv: 0) at: #';
							<< selector ].
			gsMethod := [ session evaluateAndWait: cmd ]
					on: RsrBrokenPromise
					do: [ :ex | ex ].
			self notifyObjectSpawn: gsMethod asGtBareProxyObject requesterObject: aCoderUIModel ]
		id: nil
]
