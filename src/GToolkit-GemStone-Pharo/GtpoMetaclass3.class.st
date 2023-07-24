Class {
	#name : #GtpoMetaclass3,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'definitionString'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #private }
GtpoMetaclass3 class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | aSymbol endsWith: ' class' ]
]

{ #category : #accessing }
GtpoMetaclass3 class >> remoteClassName [

	^ #Metaclass3
]

{ #category : #private }
GtpoMetaclass3 >> compileFromTab: aTab [
	"Update the receiver's definition based on the current editor contents"
	| tabGroup code result |

	"Work our way up to the BrTabGroup and then down to the BrEditor"
	tabGroup := aTab.
	[ tabGroup isKindOf: BrTabGroup ] whileFalse:
		[ tabGroup := tabGroup parent ].
	tabGroup 
		allChildrenBreadthFirstDetect: [ :element | element isKindOf: BrEditor ] 
		ifFound: [ :aBrEditor |
			code := aBrEditor text asString.
			result := self evaluateAndWait: code. ]
		ifNone: [ result := 'Unable to find editor' ].
	aTab phlow spawnObject: result.
]

{ #category : #accessing }
GtpoMetaclass3 >> compileMethod: source category: categoryName [
]

{ #category : #accessing }
GtpoMetaclass3 >> definitionString [
	^ definitionString ifNil: [ definitionString := self proxyPerform: #definition ]
]

{ #category : #ui }
GtpoMetaclass3 >> gtAbortActionFor: anAction [
	<gtAction>

	(gtSession isNil or: [ gtSession isRunning not ]) ifTrue: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Abort Transaction';
		icon: BrGlamorousVectorIcons cancel;
		action: [ :button | 
			gtSession abortTransaction.
			button phlow spawnObject: 'Aborted transaction' ]
]

{ #category : #ui }
GtpoMetaclass3 >> gtClassDefinitionFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Definition';
		priority: 5;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: BrRBTextStyler new;
		text: [ self proxyPerform: #definition ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Compile' 
			action: [ :aButton :aTab :aButtonModel | 
				self compileFromTab: aTab.
				aTab viewContentElement phlow update ];
		actionUpdateButton
]

{ #category : #ui }
GtpoMetaclass3 >> gtCommitActionFor: anAction [
	<gtAction>

	(gtSession isNil or: [ gtSession isRunning not ]) ifTrue: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Commit Transaction';
		icon: BrGlamorousVectorIcons accept;
		action: [ :button | 
			gtSession commitTransaction.
			button phlow spawnObject: 'Successfully committed transaction' ]
]

{ #category : #accessing }
GtpoMetaclass3 >> pharoEquivalentDefinitionString [
	"Answer a string that defines an equivalent of the receiver in Pharo."
	| ast arguments |

	ast := StParser parseExpression: self  definitionString.
	self assert: ast isMessage
		description: 'Unable to parse GemStone defintion, unexpected AST'.
	self assert: ast selector == #subclass:instVarNames:classVars:classInstVars:poolDictionaries:inDictionary:options:
		description: 'Unable to parse GemStone definition, unpexected selector'.
	arguments := ast arguments collect: #value.

	^ String streamContents: [ :stream |
		stream
			<< ast receiver value;
			<< ' subclass: #';
			<< arguments first;
			cr; tab;
			<< 'instanceVariableNames: '''.
		arguments second
			do: [ :arg | stream << arg ]
			separatedBy: [ stream space ].
		stream
			<< '''';
			cr; tab;
			<< 'classVariableNames: '''.
		arguments third
			do: [ :arg | stream << arg ]
			separatedBy: [ stream space ].
		stream
			<< '''';
			cr; tab;
			<< 'package: ''';
			<< '''' ].
]

{ #category : #printing }
GtpoMetaclass3 >> printOn: aStream [

	[ aStream << (self proxyPerform: #printString) ]
		on: Error 
		do: [ :ex | super printOn: aStream ]
]
