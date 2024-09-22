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
					put: aValue asGtProxyObject ]
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
	self assert: remoteBindings notNil.

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
		items: [ self localBindings bindingNames sorted collect: [ :eachName | 
			GtVariableBindingsWithVariable new
				bindings: self localBindings;
				variable: (self localBindings bindingOf: eachName) ] ];
		column: 'Name' text: [ :each | each name ];
		column: 'Value' text: [ :each | 
			(self isBindingValid: each)
				ifTrue: [ each value ]
				ifFalse: [ '<invalid>' ] ];
		column: 'Status' textDo: [ :aColumn |
			aColumn 
				format: [ :aBinding | self statusLabelForBidding: aBinding ];
				background: [ :aBinding | self statusColorForBinding: aBinding ] ];
		send: #value
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewRemoteBindingsFor: aView [ 
	<gtView>
	
	remoteBindings ifNil: [ ^ aView empty ].
		
	^ aView columnedList 
		title: 'Remote bindings';
		priority: 2;
		items: [ self remoteBindings bindingNames sorted collect: [ :eachName | 
			GtVariableBindingsWithVariable new
				bindings: self remoteBindings;
				variable: (self remoteBindings bindingOf: eachName) ] ];
		column: 'Name' text: [ :each | each name ];
		column: 'Value' textDo: [ :aColumn |
			aColumn 
				format: [ :each | self valueLabelForBinding: each variable ];
				background: [ :each | self valueColorForBinding: each variable ] ];
		column: 'Status' textDo: [ :aColumn |
			aColumn 
				format: [ :each | self statusLabelForBidding: each variable ];
				background: [ :each | self statusColorForBinding: each variable ] ];
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
					self valueLabelForBinding: (remoteBindings
						bindingValueOf: aVariableName)];
				background: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBinding | 
							self valueColorForBinding: aBinding ]
						ifAbsent: [ BrGlamorousColors paleErrorBackgroundColor ] ] ];
		column: 'Is Valid' textDo: [ :aColumn |
			aColumn 
				format: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBinding | 
							self statusLabelForBidding: aBinding ]
						ifAbsent: [ 'Missing' ]  ];
				background: [ :aVariableName | 
					localBindings
						bindingValueOf: aVariableName
						ifPresent: [ :aBinding |
							self statusColorForBinding: aBinding ]
						ifAbsent: [ BrGlamorousColors paleErrorBackgroundColor ] ] ];
		send: #value
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> gtViewSourceCodeVariablesSummaryFor: aView [
	<gtView>
	
	visitor ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'AST Variable Details';
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
	| bindingValue |
	bindingValue := aBinding value asGtProxyObject .
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
	^ remoteBindings
]

{ #category : #utils }
GtGemStoneSnippetRemoteExecutionBuilder >> remoteCodeExtraTemporaryNames [
	"As extra temporaries we use assigned variables not 
	already declared as temporaries that do not have any bound value"
	| varNames |
	varNames := visitor assignedUndeclaredVariableNames.
	localBindings ifNotNil: [ 
		localBindings bindingNames do: [ :name |
			varNames remove: name ifAbsent: [ ] ] ].
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

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> statusColorForBinding: aBinding [
	^ (self isBindingValid:  aBinding) 
		ifTrue: [ BrGlamorousColors successBackgroundColor ]
		ifFalse: [BrGlamorousColors failureBackgroundColor]
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> statusLabelForBidding: aBinding [
	^ (self isBindingValid: aBinding)
		ifTrue: ['Valid']
		ifFalse: [ 'Invalid' ] 
]

{ #category : #'accessing - bindings' }
GtGemStoneSnippetRemoteExecutionBuilder >> undeclaredVariableNames [
	^ visitor undeclaredVariableNames
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> valueColorForBinding: aBinding [
	^ (self isBindingValid:  aBinding) 
		ifTrue: [ Color transparent ]
		ifFalse: [BrGlamorousColors failureBackgroundColor]
]

{ #category : #'gt - extensions' }
GtGemStoneSnippetRemoteExecutionBuilder >> valueLabelForBinding: aBinding [
	^ (self isBindingValid:  aBinding) 
		ifTrue: [ aBinding value ]
		ifFalse: [ '<invalid>'] 
]
