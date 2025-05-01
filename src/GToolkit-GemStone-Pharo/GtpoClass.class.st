Class {
	#name : #GtpoClass,
	#superclass : #GtpoMetaclass3,
	#instVars : [
		'comment'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoClass class >> cachedSelectors [
	"Answer the selectors that should be cached by the proxy"

	^ super cachedSelectors, #(#classHistoryArray #comment)
]

{ #category : #private }
GtpoClass class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | aSymbol endsWith: ' class' ]
]

{ #category : #accessing }
GtpoClass class >> remoteClassName [

	^ #Class
]

{ #category : #accessing }
GtpoClass >> classHistoryArray [
	"Answer the receiver's class history as an Array of proxies"

	^ (gtSession scriptEvaluation
		script: 'self classHistory asArray';
		receiver: self;
		autoCommit: false;
		returnLegacy) evaluateAndWait.
]

{ #category : #'as yet unclassified' }
GtpoClass >> comment [

	^ self proxyPerform: #comment
]

{ #category : #'as yet unclassified' }
GtpoClass >> comment: aString [

	self proxyPerform: #comment: withArguments: { aString }.
	cacheStrategy removeFromCacheMessage: (Message selector: #comment).
]

{ #category : #ui }
GtpoClass >> commentFromTab: aTab [
	"Update the receiver's comment based on the current editor contents"
	| tabGroup |

	"Work our way up to the BrTabGroup and then down to the BrEditor"
	tabGroup := aTab.
	[ tabGroup isKindOf: BrTabGroup ] whileFalse:
		[ tabGroup := tabGroup parent ].
	tabGroup 
		allChildrenBreadthFirstDetect: [ :element | element isKindOf: BrEditor ] 
		ifFound: [ :aBrEditor | self comment: aBrEditor text asString. ]
		ifNone: [ self error: 'Unable to find editor' ].
]

{ #category : #ui }
GtpoClass >> gtClassCommentFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Comment';
		priority: 10;
		text: [ self comment ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Accept' 
			action: [ :aButton :aTab :aButtonModel | 
				self commentFromTab: aTab.
				aTab viewContentElement phlow update ];
		actionUpdateButton
]

{ #category : #ui }
GtpoClass >> gtClassHistoryFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Class History';
		priority: 20;
		items: [ (self classHistoryArray collectWithIndex:
			[ :item :index | index -> item ]) reversed ];
		column: 'Index' text: #key width: 70;
		column: 'Class' text: [ :item | item value name ];
		send: #value
]

{ #category : #ui }
GtpoClass >> gtClassVersionsFor: aView [
	"<gtView>"

	^ aView list
		title: 'Versions';
		priority: 15;
		list: [ self classHistoryArray ];
		actionUpdateButton
]
