Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneCompileMethodFromFor: anAST into: coderAddOns [
	<gtCoderContextMenuAddOns>
	| sessionName |
	(anAST methodNode isNil
		or: [ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not ])
		ifTrue: [ ^ self ].
	sessionName := GtGemStoneSessionRegistry default defaultSession
			ifNotNil: [ :aSession | aSession name ].

	(coderAddOns
		addContextMenuItem: (self
				createLabel: 'Compile from GemStone'
				description: sessionName asString)
		group: BrMenuItemGroupConfiguration gemstone
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName source session cmd |
			clsName := self compiledMethod methodClass name.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default GemStone session available' ].
			session connect.
			cmd := String
					streamContents: [ :stream | 
						stream
							<< '(';
							<< clsName;
							<< ' compiledMethodAt: #';
							<< selector;
							<< ') sourceString' ].
			source := session evaluateAndWait: cmd.
			self compiledMethod methodClass
				compile: source
				classified: self compiledMethod category ]
		id: nil) ifNotNil: [ :anAction | anAction priority: 303 ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneCompileMethodToFor: anAST into: coderAddOns [
	<gtCoderContextMenuAddOns>
	| sessionName |
	(anAST methodNode isNil
		or: [ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not ])
		ifTrue: [ ^ self ].
	sessionName := GtGemStoneSessionRegistry default defaultSession
			ifNotNil: [ :aSession | aSession name ].
	(coderAddOns
		addContextMenuItem: (self
				createLabel: 'Compile to GemStone'
				description: sessionName asString)
		group: BrMenuItemGroupConfiguration gemstone
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
		id: nil) ifNotNil: [ :anAction | anAction priority: 302 ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneInspectMethodFor: anAST into: coderAddOns [
	<gtCoderContextMenuAddOns>
	| sessionName |
	(anAST methodNode isNil
		or: [ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not ])
		ifTrue: [ ^ self ].
	sessionName := GtGemStoneSessionRegistry default defaultSession
			ifNotNil: [ :aSession | aSession name ].

	(coderAddOns
		addContextMenuItem: (self
				createLabel: 'Browse from GemStone'
				description: sessionName asString)
		group: BrMenuItemGroupConfiguration gemstone
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
			gsMethod := [ session evaluateAndWait: cmd autoCommit: false ]
					on: RsrBrokenPromise
					do: [ :ex | ex ].
			self
				notifyObjectSpawn: gsMethod asGtBareProxyObject
				requesterObject: aCoderUIModel ]
		id: nil) ifNotNil: [ :anAction | anAction priority: 304 ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtPharoMethodCoder >> gtGemStoneInspectSelectionFor: anAST into: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	| sessionName |
	aCoderViewModel hasSelection ifFalse: [ ^ self ].
	(anAST methodNode isNil
		or: [ GtGemStoneSessionRegistry hasRegistryWithDefaultSession not ])
		ifTrue: [ ^ self ].
	sessionName := GtGemStoneSessionRegistry default defaultSession
			ifNotNil: [ :aSession | aSession name ].
	(coderAddOns
		addContextMenuItem: (self
				createLabel: 'Do it and inspect from GemStone'
				description: sessionName asString)
		group: BrMenuItemGroupConfiguration gemstone
		hover: nil
		leave: nil
		action: [ :aCoderUIModel :anEvent | 
			| clsName session cmd gsMethod |
			clsName := self compiledMethod methodClass name.
			session := GtGemStoneSessionRegistry default defaultSession.
			session ifNil: [ self error: 'No default session available' ].
			session connect.
			cmd := aCoderViewModel coder currentSourceString
					copyFrom: aCoderViewModel selectedTextInterval first
					to: aCoderViewModel selectedTextInterval last.
			gsMethod := [ session evaluateAndWaitReturnProxy: cmd ]
					on: RsrBrokenPromise
					do: [ :ex | ex ].
			self
				notifyObjectSpawn: gsMethod asGtBareProxyObject
				requesterObject: aCoderUIModel ]
		id: nil) ifNotNil: [ :anAction | anAction priority: 304 ]
]
