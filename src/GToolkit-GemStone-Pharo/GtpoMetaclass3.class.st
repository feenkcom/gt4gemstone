Class {
	#name : #GtpoMetaclass3,
	#superclass : #GtpoModule,
	#classVars : [
		'DefaultDictionary'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoMetaclass3 class >> cachedSelectors [
	"Answer the selectors that should be cached by the proxy"

	^ super cachedSelectors, #(#definitionString #globalsDictionaryName)
]

{ #category : #accessing }
GtpoMetaclass3 class >> defaultDictionary [
	"Answer a BlockClosure that provides the default dictionary name given the supplied GT class (or nil)"
	<return: #BlockClosure>

	^ DefaultDictionary ifNil: [ [ :gtClass | 'Globals' ] ]
]

{ #category : #accessing }
GtpoMetaclass3 class >> defaultDictionary: aBlock [

	DefaultDictionary := aBlock
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
GtpoMetaclass3 >> compiledMethodAt: selector [

	^ self proxyPerform: #compiledMethodAt:
		withArguments: { selector }.
]

{ #category : #accessing }
GtpoMetaclass3 >> definitionString [
	^ self proxyPerform: #definition
]

{ #category : #accessing }
GtpoMetaclass3 >> globalsDictionaryName [

	^ self evaluateAndWait: 'self _dictionaryNameForFileout: System myUserProfile'
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
		text: [ self definitionString ];
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
			gtSession commitTransactionWithErrorChecking.
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
			<< ast receiver name;
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
			<< 'package: '''.
		(self class environment classOrTraitNamed: remoteClass) ifNotNil: [ :gtClass |
			stream << gtClass package name.
			gtClass tags do: [ :tagName |
				stream
					nextPut: $-;
					<< tagName ] ].
		stream
			<< '''.';
			cr; cr.
		stream
			<< arguments first;
			<< ' class';
			cr; tab;
			<< 'instanceVariableNames: '''.
		arguments fourth
			do: [ :arg | stream << arg ]
			separatedBy: [ stream space ].
		stream
			<< '''' ].
]

{ #category : #accessing }
GtpoMetaclass3 >> poolDictionaries [

	^ self proxyPerform: #_poolDictionaries
		autoCommit: false
]

{ #category : #printing }
GtpoMetaclass3 >> printOn: aStream [

	[ aStream << (self proxyPerform: #printString autoCommit: false) ]
		on: Error 
		do: [ :ex | super printOn: aStream ]
]
