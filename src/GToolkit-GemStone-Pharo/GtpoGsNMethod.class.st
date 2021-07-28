Class {
	#name : 'GtpoGsNMethod',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : 'accessing' }
GtpoGsNMethod class >> remoteClassName [

	^ #GsNMethod
]

{ #category : 'private' }
GtpoGsNMethod >> compileFromTab: aTab [
	"Compile the receiver's method based on the current editor contents"
	| tabGroup code script result selector category environmentId |

	"Work our way up to the BrTabGroup and then down to the BrEditor"
	tabGroup := aTab.
	[ tabGroup isKindOf: BrTabGroup ] whileFalse:
		[ tabGroup := tabGroup parent ].
	tabGroup 
		allChildrenBreadthFirstDetect: [ :element | element isKindOf: BrEditor ] 
		ifFound: [ :aBrEditor |
			code := aBrEditor text asString.
			environmentId := (self proxyPerform: #environmentId) asString.
			selector := self proxyPerform: #selector.
			category := self evaluate:
				'self inClass categoryOfSelector: #', selector, ' environmentId: ', environmentId.
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

{ #category : 'ui' }
GtpoGsNMethod >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Source';
		priority: 10;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: BrRBTextStyler new;
		text: [ self proxyPerform: #sourceString ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Compile' 
			action: [ :aButton :aTab :aButtonModel | 
				self compileFromTab: aTab.
				aTab viewContentElement phlow update ];
		actionUpdateButton
]
