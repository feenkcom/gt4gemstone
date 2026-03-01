Class {
	#name : #GtGemStoneSessionAutoCommitWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'session',
		'toggleButton',
		'statusList'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #intialization }
GtGemStoneSessionAutoCommitWidget >> initialize [

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
GtGemStoneSessionAutoCommitWidget >> isRunning [

	^ session isRunning and:
		[ session autoCommitEnabled ]
]

{ #category : #'private - ui' }
GtGemStoneSessionAutoCommitWidget >> newStatusList [
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
GtGemStoneSessionAutoCommitWidget >> newToggleButton [
	"Answer the button used to toggle code sync on and off in the receiver"

	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		label: 'starting';
		fitContent;
		action: [ :aButton | self toggleAutoCommit ]
]

{ #category : #accessing }
GtGemStoneSessionAutoCommitWidget >> registry [

	^ session registry
]

{ #category : #accessing }
GtGemStoneSessionAutoCommitWidget >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneSessionAutoCommitWidget >> session: aGtGemStoneSession [

	session := aGtGemStoneSession.
	self updateContent.
]

{ #category : #accessing }
GtGemStoneSessionAutoCommitWidget >> state [

	^ self isRunning
		ifTrue: [ #running ]
		ifFalse: [ #stopped ]
]

{ #category : #'private - accessing' }
GtGemStoneSessionAutoCommitWidget >> statusAttributes [

	^ Array streamContents: [ :stream |
		stream
			nextPut: { #State. self state. self. } ].

]

{ #category : #private }
GtGemStoneSessionAutoCommitWidget >> toggleAutoCommit [

	session autoCommitEnabled
		ifTrue: [ session clearAutoCommit ]
		ifFalse: [ session setAutoCommit ].
	self updateContent.
]

{ #category : #'private - accessing' }
GtGemStoneSessionAutoCommitWidget >> toggleButtonLabel [

	^ session autoCommitEnabled
		ifTrue: [ 'Disable' ]
		ifFalse: [ 'Enable' ]
]

{ #category : #'private - ui' }
GtGemStoneSessionAutoCommitWidget >> updateContent [

	toggleButton label: self toggleButtonLabel.
	statusList items: self statusAttributes.
]
