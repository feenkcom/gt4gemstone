Class {
	#name : #GtpoClass,
	#superclass : #GtpoMetaclass3,
	#instVars : [
		'comment'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #'as yet unclassified' }
GtpoClass >> comment [

	^ comment ifNil: [ comment :=  self proxyPerform: #comment ]
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
		ifFound: [ :aBrEditor | | newComment |
			newComment := aBrEditor text asString.
			self evaluateAndWait: 
				[ self proxyPerform: #comment: withArguments: { newComment } ].
			comment := newComment ]
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
