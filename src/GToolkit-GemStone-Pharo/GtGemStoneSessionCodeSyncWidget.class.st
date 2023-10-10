Class {
	#name : #GtGemStoneSessionCodeSyncWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'session',
		'toggleButton',
		'statusList'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> classStrategy [

	^ self registry codeSync defaultClassStrategy
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> codeSync [

	^ self registry ifNotNil: [ :registry | registry codeSync ]
]

{ #category : #intialization }
GtGemStoneSessionCodeSyncWidget >> initialize [

	super initialize.
	toggleButton := self newToggleButton.
	statusList := self newStatusList.
	self
		matchParent;
		margin: (BlInsets top: 10 left: 10);
		addChild: toggleButton;
		addChild: statusList.
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> isRunning [

	^ self codeSync
		ifNil: [ false ]
		ifNotNil: [ :codeSync |
			codeSync isRunning and:
			[ session enableCodeSync ] ]
]

{ #category : #'private - ui' }
GtGemStoneSessionCodeSyncWidget >> newStatusList [
	| list |

	list := BrColumnedList new
		background: Color white;
		margin: (BlInsets top: 10).

	list column
		title: 'Attribute' ;
		width: 100;
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vExact: 20 ];
		dataBinder: [ :aCellElement :anArray |
			aCellElement text: anArray first gtDisplayString ].

	list column
		title: 'Value';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vExact: 20 ];
		dataBinder: [ :aCellElement :anArray |
			aCellElement text: anArray second gtDisplayString ].

	^ list.
]

{ #category : #'private - ui' }
GtGemStoneSessionCodeSyncWidget >> newToggleButton [
	"Answer the button used to toggle code sync on and off in the receiver"

	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		label: 'starting';
		fitContent;
		action: [ :aButton | self toggleCodeSync ]
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> registry [

	^ session registry
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> session: aGtGemStoneSession [

	session := aGtGemStoneSession.
	self updateContent.
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> state [

	^ self isRunning
		ifTrue: [ #running ]
		ifFalse: [ #stopped ]
]

{ #category : #'private - accessing' }
GtGemStoneSessionCodeSyncWidget >> statusAttributes [

	self registry codeSync ifNil:
		[ ^ { { #State. self state. self. } } ].
	^ Array streamContents: [ :stream |
		stream
			nextPut: { #State. self state. self. };
			nextPut: { 'Class strategy'. self classStrategy gtDisplayString. self classStrategy. } ].

]

{ #category : #'private - accessing' }
GtGemStoneSessionCodeSyncWidget >> toggleButtonLabel [

	^ session isCodeSyncEnabled
		ifTrue: [ 'Disable' ]
		ifFalse: [ 'Enable' ]
]

{ #category : #private }
GtGemStoneSessionCodeSyncWidget >> toggleCodeSync [

	session toggleCodeSync.
	self updateContent.
]

{ #category : #'private - ui' }
GtGemStoneSessionCodeSyncWidget >> updateContent [

	toggleButton label: self toggleButtonLabel.
	statusList items: self statusAttributes.
]
