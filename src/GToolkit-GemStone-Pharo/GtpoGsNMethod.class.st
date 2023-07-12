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
			category := self evaluate:
				'self inClass categoryOfSelector: #', self selector, ' environmentId: ', environmentId.
			script := String streamContents: [ :stream |
				stream 
					<< 'self inClass compileMethod: ';
					print: code; cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
					<< 'category: #'''; << category; << ''''; cr;
					<< 'environmentId: '; << environmentId ].
			result := self evaluate: script. ]
		ifNone: [ result := 'Unable to find editor' ].
	aTab phlow spawnObject: result.
]

{ #category : #accessing }
GtpoGsNMethod >> gtAbortActionFor: anAction [
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

{ #category : #accessing }
GtpoGsNMethod >> gtCommitActionFor: anAction [
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
GtpoGsNMethod >> gtDisplayOn: aStream [
	self isProxyObjectActive ifTrue: 
		[ [ aStream 
				<< self inClassName;
				<< ' >> ';
				<< self selector ]
					on: Error 
					do: [ :e | 'Error printing' ] ]
	ifFalse: 
		[ aStream << 'Service Client Proxy on: <not connected>' ].
]

{ #category : #ui }
GtpoGsNMethod >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Source';
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

{ #category : #accessing }
GtpoGsNMethod >> inClassName [
	"Answer the name of the class the receiver is attached to"

	^ inClassName ifNil: [ inClassName := self evaluateAndWait: 'self inClass ifNil: [ #nil ] ifNotNil: [ :cls | cls name ]' ]
]

{ #category : #private }
GtpoGsNMethod >> removeFromTab: aTab [
	"Compile the receiver's method based on the current editor contents"
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

	^ selector ifNil: [ selector := (self proxyPerform: #selector) ifNil: [ #nil ] ]
]

{ #category : #accessing }
GtpoGsNMethod >> sourceCode [

	^ sourceCode ifNil: [ sourceCode := self proxyPerform: #sourceString ]
]

{ #category : #accessing }
GtpoGsNMethod >> sourceString [

	^ self proxyPerform: #sourceString
]
