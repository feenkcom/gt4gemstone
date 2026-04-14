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

{ #category : #private }
GtpoClass >> addClassHistoryContextMenuActionsTo: aView [
	"Call methods with the #gtClassHistoryContextAction pragma in this class to add context menu items to the supplied view"

	self class methods 
		select: [ :each | each hasPragmaNamed: #gtClassHistoryContextAction ]
		thenDo: [ :each |
			each valueWithReceiver: self arguments: { aView } ].
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

{ #category : #accessing }
GtpoClass >> comment [

	^ self proxyPerform: #comment
]

{ #category : #accessing }
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
	| list |

	list := aView columnedList
		title: 'Class History';
		priority: 20;
		items: [ (self classHistoryArray collectWithIndex:
			[ :item :index | index -> item ]) reversed ];
		column: 'Index' text: #key width: 70;
		column: 'Class' text: [ :item | item value name ];
		send: #value.
	self addClassHistoryContextMenuActionsTo: list.
	^ list
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

{ #category : #'menu items' }
GtpoClass >> inspectInstancesMenuItemFor: aView [
	<gtClassHistoryContextAction>

	aView
		contextItemLabel: 'Inspect all instances'
		action: [ :element :assoc |
			element phlow spawnObject: (assoc value asGtBareProxyObject allInstances) ]
]

{ #category : #'menu items' }
GtpoClass >> migrateInstancesMenuItemFor: aView [
	<gtClassHistoryContextAction>

	aView
		contextItemLabel: 'Migrate instances to current version'
		action: [ :element :assoc |
			assoc value migrateInstancesToCurrentIn: element ]
]

{ #category : #'private - ui' }
GtpoClass >> migrateInstancesToCurrent [
	"Migrate all instances of the receiver to it's current version and answer an Array showing any failures.
	See Module>>migrateInstancesTo: in GemStone for an explanation.
	Answer:
	- nil if all instances were migrated.
	- #noInstances if there were no instances.
	- failures if there were instances that weren't migrated."
	| evaluator |

	evaluator := gtSession createBlockEvaluationFor: [ :mySelf |
		| allInstances failures hasFailures |
		allInstances := mySelf allInstances.
		allInstances size = 0 ifTrue:
			[ #noInstances ]
		ifFalse:
			[ failures := mySelf migrateInstances: allInstances to: mySelf currentVersion.
			hasFailures := false.
			failures do: [ :array |
				array size > 0 ifTrue: [ hasFailures := true ] ].
			hasFailures
				ifTrue: [ failures ]
				ifFalse: [ nil ] ] ]
		withArguments: { self }.

	^ evaluator evaluateAndWait.
]

{ #category : #'private - ui' }
GtpoClass >> migrateInstancesToCurrentIn: element [
	"Migrate all instances of the receiver to it's current version and answer an Array showing any failures.
	See Module>>migrateInstancesTo: in GemStone for an explanation."
	| result |

	result := self migrateInstancesToCurrent.
	result ifNil: [ ^ self ].
	result == #noInstances ifTrue: [ ^ UIManager default inform: 'No instances of ', self name asString, ' to migrate' ].
	"If we get here it is an array of instances that couldn't be migrated"
	element phlow spawnObject: result.
]
