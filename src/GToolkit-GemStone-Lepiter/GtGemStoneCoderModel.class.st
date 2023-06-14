Class {
	#name : #GtGemStoneCoderModel,
	#superclass : #GtSourceCoder,
	#instVars : [
		'pharoBindings',
		'remoteScript',
		'remoteBindings'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #converting }
GtGemStoneCoderModel >> asCoderViewModel [

	^ GtGemStoneSourceCoderViewModel new coder: self
]

{ #category : #'api - ast' }
GtGemStoneCoderModel >> computeAst: theSourceString [
	^ GtGemStoneParser
		parseWithErrors: theSourceString
		startingAt: GtGemStoneParser startingStateForMethodSequence
]

{ #category : #'api - ast' }
GtGemStoneCoderModel >> implicitVariableReferencesTo: aString do: aBlock [
	self astAwait
		allNodesDo:
			[ :each | (each isVariable and: [ aString = each variableName asString and: [ each whoDefines isNil ] ]) ifTrue: [ aBlock value: each ] ]
]

{ #category : #initialize }
GtGemStoneCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

	addOns addStyler: GtGemStoneStyler new.

	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doIt
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItActionId.
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGo
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoActionId
]

{ #category : #initialize }
GtGemStoneCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns
		addShortcut: GtSourceCoderDoItShortcut new;
		addShortcut: GtSourceCoderDoItAndInspectShortcut new
]

{ #category : #'private - execution' }
GtGemStoneCoderModel >> insert: varNames asTemporariesIn: trimmedSource leftBarPosition: leftBar [
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

{ #category : #'instance creation' }
GtGemStoneCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #accessing }
GtGemStoneCoderModel >> newEvaluationContext [

	^ GtGemStoneSourceCoderEvaluationContext new
]

{ #category : #accessing }
GtGemStoneCoderModel >> pharoBindings [
	^ pharoBindings
]

{ #category : #accessing }
GtGemStoneCoderModel >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #'private - execution' }
GtGemStoneCoderModel >> pharoBindingsFrom: visitor [
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
GtGemStoneCoderModel >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	self flag: #TODO.
]

{ #category : #'private - actions' }
GtGemStoneCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	"Evaluate the supplied GemStone script."
	| result gemstoneSession boundObject |

	"Ensure the GtgemstoneSession is connected"
	gemstoneSession := aGtSourceCoderEvaluationContext session.
	gemstoneSession isRunning ifFalse: [ gemstoneSession connect ].

	"Remove any proxies from the pharoBindings that may have become stale since the last evaluation
	(probably because the gemstoneSession has been restarted)"
	pharoBindings bindingNames do: [ :name |
		boundObject := (pharoBindings bindingOf: name) value asGtProxyObject.
		(boundObject isKindOf: RsrService) ifTrue:
			[ (boundObject isProxyObjectActive not or: 
				[ gemstoneSession connection ~= boundObject _connection ]) ifTrue:
					[ pharoBindings removeBindingOf: name ] ] ].

	self updateRemoteFrom: aSourceString.

	result := gemstoneSession 
		evaluateAndWait: remoteScript 
		for: aGtSourceCoderEvaluationContext receiverObject asGtProxyObject
		bindings: remoteBindings.
	
	result associationsDo: [ :binding |
		binding value gtPharoProxyInitializeWithSession: gemstoneSession.
		(pharoBindings bindingOf: binding key asSymbol) 
			value: (binding value asGtBareProxyObject) ].

	^ (result
		at: 'snippetResult'
		ifAbsent: anEvaluationFailBlock) asGtBareProxyObject
]

{ #category : #accessing }
GtGemStoneCoderModel >> remoteBindings [
	^ remoteBindings
]

{ #category : #accessing }
GtGemStoneCoderModel >> remoteScript [
	^ remoteScript
]

{ #category : #'private - execution' }
GtGemStoneCoderModel >> returnExpressionWithNames: varNames [
	"Answer return expression for the remote script"

	^ String streamContents: [ :stream |
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
			<< ' #snippetResult -> snippetResult. } asDictionary' ]
]

{ #category : #accessing }
GtGemStoneCoderModel >> sessionHolder [
	^ sessionHolder
]

{ #category : #accessing }
GtGemStoneCoderModel >> sessionHolder: anObject [
	sessionHolder := anObject
]

{ #category : #'private - execution' }
GtGemStoneCoderModel >> updateRemoteFrom: sourceString [
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
GtGemStoneCoderModel >> variableBindings: aGtSnippetBindings [

	^ self pharoBindings: aGtSnippetBindings
]
