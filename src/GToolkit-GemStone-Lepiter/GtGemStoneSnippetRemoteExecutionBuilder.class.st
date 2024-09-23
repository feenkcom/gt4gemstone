Class {
	#name : #GtGemStoneSnippetRemoteExecutionBuilder,
	#superclass : #Object,
	#instVars : [
		'sourceString',
		'localBindings',
		'remoteBindings',
		'visitor',
		'sourceAst',
		'gemstoneSession'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #'accessing - bindings' }
GtGemStoneSnippetRemoteExecutionBuilder >> accessedFirstUndeclaredVariableNames [
	^ visitor accessedFirstUndeclaredVariableNames
]

{ #category : #actions }
GtGemStoneSnippetRemoteExecutionBuilder >> analyseSourceString [
	| trimmedString |

	trimmedString := sourceString trimRight.
		
	visitor := LeGemStoneVarNodeVisitor new.
	sourceAst := GtPharoParser
		parse: trimmedString
		startingAt: GtPharoParser startingStateForMethodSequence.
	visitor acceptNode: sourceAst.
]

{ #category : #'accessing - bindings' }
GtGemStoneSnippetRemoteExecutionBuilder >> assignFirstUndeclaredVariablesName [
	^ visitor assignFirstUndeclaredVariablesName
]

{ #category : #converting }
GtGemStoneSnippetRemoteExecutionBuilder >> convertBindingToGemstone: aBinding [
	^ (GtGemStoneWorkspaceVariable new
		gemstoneSession: gemstoneSession;
		name: aBinding name;
		value: aBinding value asGtProxyObject)
]

{ #category : #converting }
GtGemStoneSnippetRemoteExecutionBuilder >> createGemStoneBingingName: aBindingName  value: aBindingValue [
	^ (GtGemStoneWorkspaceVariable new
		gemstoneSession: gemstoneSession;
		name: aBindingName;
		value: aBindingValue asGtProxyObject)
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> errorPositionForBingingNamed: aBindingName [
	^ (self 
		stopPositionForVariableNamed: aBindingName) 
			ifNil: [ 1 ]
			ifNotNil: [ :anInteger | anInteger ]
]

{ #category : #api }
GtGemStoneSnippetRemoteExecutionBuilder >> extractRemoteBindings [
	self analyseSourceString.
	
	remoteBindings := GtLocalVariablesBindings new.
	visitor requiredVariableNames do: [ :aVariableName |
		localBindings 
			bindingValueOf: aVariableName 
			ifPresent: [ :aValue | 
				remoteBindings 
					localAt: aVariableName
					putVariable: (GtGemStoneWorkspaceVariable new
						gemstoneSession: gemstoneSession;
						name: aVariableName;
						value: aValue asGtProxyObject)  ]
			ifAbsent: [ ] ].
	
	^ remoteBindings
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> gemstoneSession: aGemStoneSession [
	gemstoneSession := aGemStoneSession
]

{ #category : #api }
GtGemStoneSnippetRemoteExecutionBuilder >> generateRemoteScript [
	| trimmedString targetSource lastStatement leftBar extraTemporaries |
	remoteBindings ifNil: [
		self extractRemoteBindings ].

	trimmedString := sourceString trimRight.
	targetSource := SmaCCString on: trimmedString.
	trimmedString last = $. ifFalse: [ 
		targetSource append: '.' ].
		
	lastStatement := sourceAst statements last.
	leftBar := sourceAst leftBar ifNotNil: [ sourceAst leftBar startPosition ].
	extraTemporaries := self remoteCodeExtraTemporaryNames.
	
	"Construct the script to be evaluated on the remote (GemStone server):
	1. Add any undeclared variables names to the script's list of temporaries"
	self insert: extraTemporaries asTemporariesIn: targetSource leftBarPosition: leftBar.
	"2. Assign the final statement to snippetResult"
	targetSource 
		insert: 'snippetResult := ' 
		at: lastStatement startPosition.
	"3. Answer a dictionary containing the returned variables"
	targetSource append: (self 
		returnExpressionWithNames: visitor assignedUndeclaredVariableNames).
	
	^ targetSource asString.
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewLocalBindingsFor: aView [ 
	<gtView>
	self localBindings ifNil: [ ^ aView empty ].
	
	^ aView columnedList 
		title: 'Local bindings';
		priority: 10;
		items: [ self localBindings gtBindingsWithVariable ];
		column: 'Name' text: [ :each | each name ];
		column: 'Value' textDo: [ :aColumn |
			aColumn  
				format: [ :each | 
					(self convertBindingToGemstone: each ) valueLabel ];
				background: [ :each |  
					(self convertBindingToGemstone: each ) valueColor ] ];
		column: 'Status' textDo: [ :aColumn |
			aColumn 
				format: [ :each | 
					(self convertBindingToGemstone: each ) statusLabel ];
				background: [ :each | 
					(self convertBindingToGemstone: each ) statusColor ] ];
		send: #value
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewRemoteBindingsFor: aView [ 
	<gtView>
	
	remoteBindings ifNil: [ ^ aView empty ].
		
	^ aView columnedList 
		title: 'Remote bindings';
		priority: 2;
		items: [ self remoteBindings gtBindingsWithVariable ];
		column: 'Name' text: [ :each | each name ];
		column: 'Value' textDo: [ :aColumn |
			aColumn 
				format: [ :each | each variable  valueLabel ];
				background: [ :each |  each variable valueColor ] ];
		column: 'Status' textDo: [ :aColumn |
			aColumn 
				format: [ :each | each variable statusLabel ];
				background: [ :each | each variable statusColor ] ];
		send: #value
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewRemoteScriptFor: aView [ 
	<gtView>
	
	^ aView textEditor
		title: 'Remote Script';
		priority: 3;
		text: [ self generateRemoteScript ];
		aptitude: BrGlamorousCodeEditorAptitude;
		styler:  (BrRBTextStyler new
			isForWorkspace: true;
			yourself)
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewRequiredBindingsFor: aView [ 
	<gtView>
	
	(remoteBindings isNil or: [ visitor isNil ]) 
		ifTrue: [ ^ aView empty ].
	
	^ aView columnedList 
		title: 'Required bindings';
		priority: 5;
		items: [ visitor requiredVariableNames sorted ];
		column: 'Name' text: [ :each | each printString ];
		column: 'Value' textDo: [ :aColumn |
			aColumn 
				format: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBindingValue |  
							(self 
								createGemStoneBingingName: aVariableName 
								value: aBindingValue) valueLabel ]
						ifAbsent: [ '<missing>' ] ];
				background: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBindingValue | 
							(self 
								createGemStoneBingingName: aVariableName 
								value: aBindingValue) valueColor ]
						ifAbsent: [ BrGlamorousColors paleErrorBackgroundColor ] ] ];
		column: 'Is Valid' textDo: [ :aColumn |
			aColumn 
				format: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBindingValue | 
							(self 
								createGemStoneBingingName: aVariableName 
								value: aBindingValue) statusLabel ]
						ifAbsent: [ 'Missing' ]  ];
				background: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBindingValue |
							(self 
								createGemStoneBingingName: aVariableName 
								value: aBindingValue) statusColor ]
						ifAbsent: [ BrGlamorousColors paleErrorBackgroundColor ] ] ];
		send: #value
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewSourceCodeDefinedVariablesFor:  aView [
	<gtView>
	
	visitor ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Defined variables';
		priority: 41;
		object: [ visitor ];
		view: #gtViewDefinedVariablesFor: 
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewSourceCodeVariablesSummaryFor: aView [
	<gtView>
	
	visitor ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'AST variable details';
		priority: 40;
		object: [ visitor ];
		view: #gtViewVariablesSummaryFor:
]

{ #category : #'code generation' }
GtGemStoneSnippetRemoteExecutionBuilder >> insert: varNames asTemporariesIn: trimmedSource leftBarPosition: leftBar [
	| temporaries index |

	temporaries := String streamContents: [ :stream |
		leftBar 
			ifNil: [ stream << '| ' ]
			ifNotNil: [ stream space ].
		varNames do: [ :name |
			stream 
				<< name;
				space ].
		(varNames includes: #snippetResult) ifFalse:
			[ stream << 'snippetResult ' ].
		leftBar ifNil: 
			[ stream 
				<< '|';
				cr ] ].

	index := leftBar
		ifNil: [ 1 ]
		ifNotNil: [ leftBar + 1 ].
	trimmedSource insert: temporaries at: index.
]

{ #category : #testing }
GtGemStoneSnippetRemoteExecutionBuilder >> isBindingValid: aBinding [
	^ self isBindingValueValid: aBinding value
]

{ #category : #testing }
GtGemStoneSnippetRemoteExecutionBuilder >> isBindingValueValid: aValue [
	| bindingValue |
	bindingValue := aValue asGtProxyObject .
	^ (bindingValue isKindOf: RsrService) not or: [ 
		bindingValue isProxyObjectActive and: [ 
			gemstoneSession connection = bindingValue _connection ] ]
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> localBindings [
	^ localBindings
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> localBindings: variablesBindings [
	localBindings := variablesBindings
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> remoteBindings [
	remoteBindings ifNil: [
		self extractRemoteBindings].
	^ remoteBindings
]

{ #category : #api }
GtGemStoneSnippetRemoteExecutionBuilder >> remoteBindingsDictionary [
	^ (self remoteBindings bindings values
		collect: [ :aBinding |
			aBinding  name -> aBinding value]) asDictionary
]

{ #category : #utils }
GtGemStoneSnippetRemoteExecutionBuilder >> remoteCodeExtraTemporaryNames [
	"As extra temporaries we use variables that are assigned first,
	as in that case we do not send a value for the binding."
	| varNames |
	varNames := visitor assignFirstUndeclaredVariablesName.
	"localBindings ifNotNil: [ 
		localBindings bindingNames do: [ :name |
			varNames remove: name ifAbsent: [ ] ] ]."
	^ varNames
]

{ #category : #'accessing - bindings' }
GtGemStoneSnippetRemoteExecutionBuilder >> requiredVariableNames [
	^ visitor requiredVariableNames
]

{ #category : #'code generation' }
GtGemStoneSnippetRemoteExecutionBuilder >> returnExpressionWithNames: varNames [
	"Answer return expression for the remote script"

	^ String streamContents: [ :stream |
		stream 
			cr
			<< '({ '.
		varNames do: [ :varName |
			stream
				<< '#'; 
				<< varName;
				<< ' -> ';
				<< varName;
				<< '. ' ].
		stream
			<< '#snippetResult -> snippetResult } collect: [ :___each |'; 
			cr; tab;
			<< '___each  key -> (___each value class == GtRsrProxyServiceServer';
			cr; tab;
			<< 'ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' ]
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtGemStoneSnippetRemoteExecutionBuilder >> sourceString: aString [
	sourceString := aString
]

{ #category : #api }
GtGemStoneSnippetRemoteExecutionBuilder >> stopPositionForVariableNamed: aVariableName [
	^ visitor stopPositionForVariableNamed: aVariableName
]

{ #category : #'accessing - bindings' }
GtGemStoneSnippetRemoteExecutionBuilder >> undeclaredVariableNames [
	^ visitor undeclaredVariableNames
]

{ #category : #api }
GtGemStoneSnippetRemoteExecutionBuilder >> withFirstInvalidRemoteBinding: aBlock [
	| invalidBindings sortedInvalidBindings |
	invalidBindings := self remoteBindings bindings 
		select: [ :aBinding | aBinding isInvalidBinding ].
			
	invalidBindings ifEmpty: [ ^ self ].
	sortedInvalidBindings := invalidBindings 
		sorted: [ :aBinding | 
			self 
				stopPositionForVariableNamed: aBinding name ] ascending.
	aBlock value: sortedInvalidBindings first
]
