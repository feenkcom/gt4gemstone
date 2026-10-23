Class {
	#name : #GtGemStoneExpandableDebuggerToolbar,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'dapDebugElement',
		'restartFrameButton',
		'resumeButton',
		'stepIntoButton',
		'stepOverButton',
		'stepThroughButton',
		'stepOutButton'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #callbacks }
GtGemStoneExpandableDebuggerToolbar >> actOnBrowserClosing: ann [
	"No action required at the moment"
]

{ #category : #'event handling' }
GtGemStoneExpandableDebuggerToolbar >> actOnDebugSessionChanged [
	| visibility |

	visibility := self isResumable
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ].
	{ restartFrameButton. resumeButton. stepIntoButton. stepOverButton. } do: [ :button |
		button visibility: visibility ].

	dapDebugElement debugSession exception gtSession
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_617
		do: [
			self
				childWithId: #runToCursor
				ifFound: [ :btn | btn visibility: BlVisibility gone ]
				ifNone: [ ] ].
]

{ #category : #initialization }
GtGemStoneExpandableDebuggerToolbar >> addExtraActionsButton [
	| phlowAction |
	phlowAction := GtPhlowAction new dropdown
		tooltip: 'Inspect';
		icon: BrGlamorousVectorIcons hamburger;
		content: [ :aButton | 
			| actions |
			actions := OrderedCollection new.
			dapDebugElement debugSession exception ifNotNil: [
				actions add: ('Inspect Exception' -> [ :anElement | 
					anElement phlow spawnObject: dapDebugElement debugSession exception.
					aButton dispatchEvent: BrDropdownHideWish new])].
			actions add: ('Inspect Debugging Session' -> [ :anElement | 
				anElement phlow spawnObject: dapDebugElement debugSession.
				aButton dispatchEvent: BrDropdownHideWish new ]).
			BrGlamorousSimpleContextMenuContent new
				items:actions;
				yourself ].
	phlowAction 
		asElement: [ :actionElement | 
			 actionElement margin: (BlInsets left: 5).
			 self addChild: actionElement ]				
		withHostElement: self 
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerToolbar >> dapDebugElement [
	^ dapDebugElement
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerToolbar >> dapDebugElement: aDAPDebugElement [

	dapDebugElement := aDAPDebugElement.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerToolbar >> debuggerClient [
	^ dapDebugElement debuggerClient
]

{ #category : #initialization }
GtGemStoneExpandableDebuggerToolbar >> initialize [

	super initialize.
	self vFitContent.
	resumeButton := self newResumeButton.
	restartFrameButton := self newRestartFrameButton.
	stepIntoButton := self newStepIntoButton.
	stepOverButton := self newStepOverButton.
	stepThroughButton := self newStepThroughButton.
	self addChildren: { resumeButton. restartFrameButton. stepIntoButton. stepOverButton. stepThroughButton. self newRunToCursorButton  }.
	
	stepOutButton := self newStepOutButton.
	self addChild: stepOutButton.
	self addExtraActionsButton.
]

{ #category : #testing }
GtGemStoneExpandableDebuggerToolbar >> isResumable [

	^ self debuggerClient exception isResumable
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newRestartFrameButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons restart;
		id: #restart;
		label: 'Restart';
		action: [ :aButton | dapDebugElement gsRestartFrame ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newResumeButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons run;
		label: 'Proceed';
		id: #resume;
		action: [ :aButton | dapDebugElement gsResume ]
]

{ #category : #initialization }
GtGemStoneExpandableDebuggerToolbar >> newRunToCursorButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons tohere;
		id: #runToCursor;
		label: 'Run to cursor';
		action: [ :aButton | dapDebugElement gsRunToCursor ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepIntoButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons into;
		id: #stepInto;
		label: 'Step into';
		action: [ :aButton | dapDebugElement gsStepInto ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepOutButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons down;
		id: #stepOut;
		label: 'Step out';
		action: [ :aButton | dapDebugElement gsStepOut ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepOverButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons over;
		id: #stepOver;
		label: 'Step over';
		action: [ :aButton | dapDebugElement gsStepOver ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepThroughButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons through;
		id: #stepThrough;
		label: 'Step through';
		action: [ :aButton | dapDebugElement gsStepThrough ]
]

{ #category : #private }
GtGemStoneExpandableDebuggerToolbar >> updateUI [ 
	"Update the button state to reflect the current debugger state.
	The buttons should only be active if the debugger is stopped and the top call frame is being displayed."
	| actionsAllowed |

	actionsAllowed := true.
	restartFrameButton enabled: actionsAllowed.
	resumeButton enabled: actionsAllowed.
	stepIntoButton enabled: actionsAllowed.
	stepOverButton enabled: actionsAllowed.
	stepThroughButton enabled: actionsAllowed.
]
