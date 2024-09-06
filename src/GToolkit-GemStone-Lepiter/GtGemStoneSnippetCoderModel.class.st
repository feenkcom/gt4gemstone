Class {
	#name : #GtGemStoneSnippetCoderModel,
	#superclass : #GtGemStoneSourceCoderModel,
	#instVars : [
		'pharoBindings',
		'remoteScript',
		'remoteBindings'
	],
	#classVars : [
		'EnableAsyncPlay'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneSnippetCoderModel class >> enableAsyncPlay [
	^ EnableAsyncPlay ifNil: [ true ]
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel class >> enableAsyncPlay: anObject [
	EnableAsyncPlay := anObject
]

{ #category : #'add-ons' }
GtGemStoneSnippetCoderModel >> addEvaluateAddonsTo: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 800>
	self
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDoItShortcut new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel;
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDoItAndInspectAsynchronousShortcut
					new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel;
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderPrintItShortcut new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel;
		addGemStoneExecutionContextMenuItemFrom: GtSourceCoderDebugShortcut new
			withId: nil
			to: coderAddOns
			from: aCoderViewModel
]

{ #category : #converting }
GtGemStoneSnippetCoderModel >> asCoderViewModel [

	^ GtGemStoneSnippetCoderViewModel new coder: self
]

{ #category : #'api - ast' }
GtGemStoneSnippetCoderModel >> implicitVariableReferencesTo: aString do: aBlock [
	self astAwait
		allNodesDo:
			[ :each | (each isVariable and: [ aString = each variableName asString and: [ each whoDefines isNil ] ]) ifTrue: [ aBlock value: each ] ]
]

{ #category : #initialize }
GtGemStoneSnippetCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns .

	self class enableAsyncPlay ifTrue:
		[ addOns
			addGemStoneExecutionAction: 'Inspect asynchronously' translated
			icon: BrGlamorousVectorIcons playInspectAsynchronous 
			action: [ :aCoderUIModel :aButtonElement | 
				GtCoderCodeExecutor doItAndGoAsynchronous
					coderViewModel: aCoderUIModel;
					element: aButtonElement;
					execute ]
			id: GtSourceCoderDoItAndGoAsynchronousActionId ].
			
	addOns
		addGemStoneExecutionAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play 
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doIt
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItActionId.
	addOns
		addGemStoneExecutionAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGo
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoActionId.
	addOns
		addGemStoneExecutionAction: 'Inspect serialized' translated
		icon: BrGlamorousVectorIcons tohere
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGoSerialized
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoSerializedActionId.
	
	addOns
		addGemStoneExecutionAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anElement |
			aCoderUIModel debug ]
		id: GtSourceCoderDebugActionId.
]

{ #category : #initialize }
GtGemStoneSnippetCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns
		addShortcut: GtSourceCoderDoItShortcut new;
		addShortcut: GtSourceCoderDoItAndInspectAsynchronousShortcut new;
		addShortcut: GtSourceCoderDoItAndInspectSerializedShortcut new
]

{ #category : #'private - execution' }
GtGemStoneSnippetCoderModel >> insert: varNames asTemporariesIn: trimmedSource leftBarPosition: leftBar [
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

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> newEvaluationContext [

	^ GtGemStoneSnippetCoderEvaluationContext new
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> pharoBindings [
	^ pharoBindings
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #'private - execution' }
GtGemStoneSnippetCoderModel >> pharoBindingsFrom: visitor [
	"Answer a collection of bindings for variables that aren't declared in the source and are in the snippet's bindings"
	| bindings value |

	bindings := Dictionary new.
	visitor globalVariableNames do: [ :name |
		(pharoBindings hasBindingOf: name) ifTrue: 
			[ value := (pharoBindings bindingOf: name) value asGtProxyObject.
			((value isBlock and: [ value isClean]) or: [GtRsrEvaluatorService isRsrImmediate: value ]) ifTrue:
				[ bindings at: name put: value ] ] ].
	(pharoBindings hasBindingOf: #snippetResult) ifTrue: 
			[ value := (pharoBindings bindingOf: #snippetResult) value asGtProxyObject.
			(GtRsrEvaluatorService isRsrImmediate: value) ifTrue:
				[ bindings at: #snippetResult put: value ] ].
	^ bindings
]

{ #category : #'private - actions' }
GtGemStoneSnippetCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Evaluate the supplied GemStone script."
	| gemstoneSession boundObject |

	gemstoneSession := aGtSourceCoderEvaluationContext session.
	"Ensure the GtgemstoneSession is connected"
	gemstoneSession ifNil:
		 [ self error: 'GemStone session not set.  Does the connector exist?' ].
	gemstoneSession isRunning ifFalse: [ gemstoneSession connect ].
	"Remove any proxies from the pharoBindings that may have become stale since the last evaluation
	(probably because the gemstoneSession has been restarted)"
	pharoBindings bindingNames
		do: [ :name | 
			boundObject := (pharoBindings bindingOf: name) value asGtProxyObject.
			(boundObject isKindOf: RsrService)
				ifTrue: [ (boundObject isProxyObjectActive not
						or: [ gemstoneSession connection ~= boundObject _connection ])
						ifTrue: [ pharoBindings removeBindingOf: name ] ] ].

	self updateRemoteFrom: aSourceString.
	
	^ aGtSourceCoderEvaluationContext executionStrategy
		evaluate: remoteScript
		inSession: gemstoneSession
		context: aGtSourceCoderEvaluationContext
		remoteBindings: remoteBindings
		pharoBindings: pharoBindings
		onFailDo: anEvaluationFailBlock
		coderModel: self
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> remoteBindings [
	^ remoteBindings
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> remoteScript [
	^ remoteScript
]

{ #category : #'private - execution' }
GtGemStoneSnippetCoderModel >> returnExpressionWithNames: varNames [
	"Answer return expression for the remote script"

	^ String streamContents: [ :stream |
		stream
			cr;
			<< 'snippetResult class == GtRsrProxyServiceServer ifFalse: [ snippetResult := GtRsrProxyServiceServer object: snippetResult ].'.
		stream 
			cr
			<< '{ '.
		varNames do: [ :varName |
			stream
				<< '#'; 
				<< varName;
				<< ' -> ';
				<< varName;
				<< '. ' ].
		stream
			<< '#snippetResult -> snippetResult. } asDictionary' ]
]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> startingStateForAstComputation [
	^ GtGemStoneParser startingStateForMethodSequence
]

{ #category : #'private - execution' }
GtGemStoneSnippetCoderModel >> updateRemoteFrom: sourceString [
	"Update remoteScript and remoteBindings based on the supplied source code and the prebuild AST (newAstCache)"
	| trimmedString trimmedSource visitor lastStatement varNames leftBar sourceAst |

	trimmedString := sourceString trimRight.
	trimmedSource := SmaCCString on: trimmedString.
	trimmedString last = $. ifFalse: 
		[ trimmedSource append: '.' ].
	visitor := LeGemStoneVarNodeVisitor new.
	sourceAst := GtPharoParser
		parse: trimmedSource asString
		startingAt: GtPharoParser startingStateForMethodSequence.
	visitor acceptNode: sourceAst.
	lastStatement := sourceAst statements last.
	leftBar := sourceAst leftBar ifNotNil: [ sourceAst leftBar startPosition ].
	varNames := visitor undeclaredVariableNames.
	pharoBindings ifNotNil:
		[ pharoBindings bindingNames do: [ :name |
			varNames remove: name ifAbsent: [] ] ].

	"Construct the script to be evaluated on the remote (GemStone server):
	1. Add any undeclared variables names to the script's list of tempararies"
	self insert: varNames asTemporariesIn: trimmedSource leftBarPosition: leftBar.
	"2. Assign the final statement to snippetResult"
	trimmedSource 
		insert: 'snippetResult := ' 
		at: lastStatement startPosition.
	"3. Answer a dictionary containing the returned variables"
	trimmedSource append: (self returnExpressionWithNames: visitor undeclaredVariableNames).
	remoteScript := trimmedSource asString.

	"Assign the current value to any variables that:
	1. aren't declared,
	2. aren't assigned before use and,
	3. are currently bound in the receiver"
	remoteBindings := self pharoBindingsFrom: visitor.

]

{ #category : #accessing }
GtGemStoneSnippetCoderModel >> variableBindings: aGtSnippetBindings [

	^ self pharoBindings: aGtSnippetBindings
]
