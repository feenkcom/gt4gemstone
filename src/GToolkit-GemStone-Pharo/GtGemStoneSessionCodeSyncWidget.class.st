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

	^ session codeSync classStrategy
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> codeSync [

	^ self session ifNotNil: [ :aSession | aSession codeSync ]
]

{ #category : #accessing }
GtGemStoneSessionCodeSyncWidget >> eventStrategy [

	^ session codeSync eventStrategy
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

	^ session isRunning and:
		[ session codeSyncEnabled ]
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

	session codeSync ifNil:
		[ ^ { { #State. self state. self. } } ].
	^ Array streamContents: [ :stream |
		stream
			nextPut: { #State. self state. self. };
			nextPut: { 'Class strategy'. self codeSync classStrategy gtDisplayString. self classStrategy. };
			nextPut: { 'Event strategy'. self codeSync eventStrategy gtDisplayString. self eventStrategy. } ].

]

{ #category : #'private - accessing' }
GtGemStoneSessionCodeSyncWidget >> toggleButtonLabel [

	^ session codeSyncEnabled
		ifTrue: [ 'Stop' ]
		ifFalse: [ 'Start' ]
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
