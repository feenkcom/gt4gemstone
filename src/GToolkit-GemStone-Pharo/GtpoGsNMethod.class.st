Class {
	#name : #GtpoGsNMethod,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'sourceCode',
		'selector',
		'inClassName'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGsNMethod class >> remoteClassName [

	^ #GsNMethod
]

{ #category : #private }
GtpoGsNMethod >> compileFromTab: aTab [
	"Compile the receiver's method based on the current editor contents"
	| tabGroup code script result category environmentId |

	"Work our way up to the BrTabGroup and then down to the BrEditor"
	tabGroup := aTab.
	[ tabGroup isKindOf: BrTabGroup ] whileFalse:
		[ tabGroup := tabGroup parent ].
	tabGroup 
		allChildrenBreadthFirstDetect: [ :element | element isKindOf: BrEditor ] 
		ifFound: [ :aBrEditor |
			code := aBrEditor text asString.
			environmentId := (self proxyPerform: #environmentId) asString.
			category := self evaluateAndWait:
				'self inClass categoryOfSelector: #', self selector, ' environmentId: ', environmentId.
			script := String streamContents: [ :stream |
				stream 
					<< 'self inClass compileMethod: ';
					print: code; cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
					<< 'category: #'''; << category; << ''''; cr;
					<< 'environmentId: '; << environmentId ].
			result := self evaluateAndWait: script. ]
		ifNone: [ result := 'Unable to find editor' ].
	aTab phlow spawnObject: result.
]

{ #category : #ui }
GtpoGsNMethod >> gtAbortActionFor: anAction [
	<gtAction>

	(gtSession isNil or: [ gtSession isRunning not ]) ifTrue: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Abort Transaction';
		label: 'Abort';
		icon: BrGlamorousVectorIcons cancel;
		priority: 25;
		action: [ :button | 
			gtSession abortTransaction ]
]

{ #category : #ui }
GtpoGsNMethod >> gtBrowseLocalFor: anAction [
	"Browse the local definition of the receiver"
	<gtAction>
	| cls |

	cls := self class environment at: self inClassName ifAbsent: [].
	(cls isNil or: [ (cls includesSelector: self selector) not ]) ifTrue: 
		[ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons browse;
		tooltip: 'Browse local definition';
		name: 'Fred';
		action: [ :aButton | aButton phlow spawnTool: (GtMethodCoderTool compiledMethod:
			(self class environment at: self inClassName) >> selector) ]
]

{ #category : #ui }
GtpoGsNMethod >> gtCommitActionFor: anAction [
	<gtAction>

	(gtSession isNil or: [ gtSession isRunning not ]) ifTrue: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Commit Transaction';
		label: 'Commit';
		icon: BrGlamorousVectorIcons accept;
		priority: 20;
		action: [ :button | 
			gtSession commitTransactionWithErrorChecking ]
]

{ #category : #accessing }
GtpoGsNMethod >> gtDisplayOn: aStream [
	aStream << 'Service Client Proxy: '.
	
	self isProxyObjectActive ifTrue: 
		[ [ aStream 
				<< self inClassName;
				<< ' >> ';
				<< self selector ]
					on: Error 
					do: [ :e | 'Error printing' ] ]
	ifFalse: 
		[ aStream << '<not connected>' ].
]

{ #category : #ui }
GtpoGsNMethod >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Source string';
		priority: 10;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: BrRBTextStyler new;
		text: [ self sourceString ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Compile' 
			action: [ :aButton :aTab :aButtonModel | 
				self compileFromTab: aTab.
				aTab viewContentElement phlow update ];
		actionButtonIcon: BrGlamorousVectorIcons remove
			tooltip: 'Remove'
			action: [ :aButton :aTab :aButtonModel | 
				self removeFromTab: aTab. ];
		actionUpdateButton
]

{ #category : #accessing }
GtpoGsNMethod >> gtTwoPanesDiffFor: aView [
	<gtView>
	| cls |

	cls := self class environment at: self inClassName ifAbsent: [].
	(cls isNil or: [ (cls includesSelector: self selector) not ]) ifTrue: 
		[ ^ aView empty ].

	^ aView explicit
		title: 'Diff';
		priority: 19;
		stencil: [ | gsSource gtSource |
			gsSource := self sourceCode.
			gtSource := ((self class environment at: self inClassName) >> self selector) sourceCode.
			GtDiffElementWithLabelStencil new
				fromLabelText: 'GemStone:';
				toLabelText: 'Gt (local):';
				change: (GtDiffBuilder
					computeDifferencesFrom: gsSource
					to: gtSource
					using: GtSmaCCDiffSplitter forPharo);
				styler: (GtCodeDiffRBTextStyler new
					isForWorkspace: true;
					yourself) ];
		"in: [ :currentView | ];"
		yourself
]

{ #category : #ui }
GtpoGsNMethod >> gtViewCoderFor: aView [
	<gtView>

	^ aView explicit 
		title: 'Source';
		priority: 5;
		stencil: [
			GtGemStoneMethodCoderModel fromGsMethod: self ];
		actionUpdateButton
]

{ #category : #accessing }
GtpoGsNMethod >> inClassName [
	"Answer the name of the class the receiver is attached to"

	^ inClassName ifNil: [ inClassName := self evaluateAndWait: 'self inClass ifNil: [ #nil ] ifNotNil: [ :cls | cls name ]' ]
]

{ #category : #accessing }
GtpoGsNMethod >> methodCoderSpecification [ 
	^ GtGemStoneMethodSpecification forGsMethodProxy: self
]

{ #category : #private }
GtpoGsNMethod >> removeFromTab: aTab [
	"Remove the receiver's method"
	| tabGroup |

	"Work our way up to the BrTabGroup and then down to the BrEditor"
	tabGroup := aTab.
	[ tabGroup isKindOf: BrTabGroup ] whileFalse:
		[ tabGroup := tabGroup parent ].
	tabGroup 
		allChildrenBreadthFirstDetect: [ :element | element isKindOf: BrEditor ] 
		ifFound: [ :aBrEditor |
			self evaluateAndWait: 'self inClass removeSelector: #', self selector.
			aBrEditor text: '"<Removed>"' asRopedText ]
		ifNone: [ self error: 'Unable to find editor' ].
]

{ #category : #accessing }
GtpoGsNMethod >> selector [

	^ selector ifNil: [ selector := (self proxyPerform: #selector autoCommit: false) ifNil: [ #nil ] ]
]

{ #category : #accessing }
GtpoGsNMethod >> sourceCode [

	^ sourceCode ifNil: [ sourceCode := self proxyPerform: #sourceString autoCommit: false ]
]

{ #category : #accessing }
GtpoGsNMethod >> sourceString [

	^ self sourceCode
]
