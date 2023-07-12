Class {
	#name : #GtGemStoneDebuggerToolbar,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'dapDebugElement',
		'restartFrameButton',
		'resumeButton',
		'stepBackButton',
		'stepIntoButton',
		'stepOverButton',
		'stepOutButton'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #callbacks }
GtGemStoneDebuggerToolbar >> actOnBrowserClosing: ann [
	"No action required at the moment"
]

{ #category : #callbacks }
GtGemStoneDebuggerToolbar >> actOnDebugSessionChanged [
	| visibility |

	visibility := self isResumable
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ].
	{ restartFrameButton. resumeButton. stepBackButton. stepIntoButton. stepOutButton. stepOverButton. } do: [ :button |
		button visibility: visibility ].
]

{ #category : #accessing }
GtGemStoneDebuggerToolbar >> dapDebugElement [
	^ dapDebugElement
]

{ #category : #accessing }
GtGemStoneDebuggerToolbar >> dapDebugElement: aDAPDebugElement [

	dapDebugElement := aDAPDebugElement.

]

{ #category : #accessing }
GtGemStoneDebuggerToolbar >> debuggerClient [
	^ dapDebugElement debuggerClient
]

{ #category : #initialization }
GtGemStoneDebuggerToolbar >> initialize [

	super initialize.
	self vFitContent.
	restartFrameButton := self newRestartFrameButton.
	resumeButton := self newResumeButton.
	stepBackButton := self newStepBackButton.
	stepIntoButton := self newStepIntoButton.
	stepOutButton := self newStepOutButton.
	stepOverButton := self newStepOverButton.
	self addChild: self newInspectButton.
	self addChildren: { restartFrameButton. resumeButton. stepBackButton. stepIntoButton. stepOutButton. stepOverButton. }.

]

{ #category : #testing }
GtGemStoneDebuggerToolbar >> isResumable [

	^ self debuggerClient exception isResumable
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newInspectButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		label: 'Inspect the DAP Debugger';
		icon: BrGlamorousVectorIcons emphasizedInspect;
		action: [ :aButton | self inspect ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newRestartFrameButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons restart;
		label: 'Restart Frame';
		action: [ :aButton | dapDebugElement dapRestartFrame ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newResumeButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons play;
		label: 'Resume';
		action: [ :aButton | dapDebugElement dapResume ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepBackButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons down;
		label: 'Step Back';
		action: [ :aButton | dapDebugElement dapStepBack ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepIntoButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons into;
		label: 'Step Into';
		action: [ :aButton | dapDebugElement dapStepInto ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepOutButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons down;
		label: 'Step Out';
		action: [ :aButton | dapDebugElement dapStepOut ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepOverButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons over;
		label: 'Step Over';
		action: [ :aButton | dapDebugElement dapStepOver ]
]

{ #category : #private }
GtGemStoneDebuggerToolbar >> updateUI [ 
	"Update the button state to reflect the current debugger state.
	The buttons should only be active if the debugger is stopped and the top call frame is being displayed."
	| actionsAllowed |

	actionsAllowed := dapDebugElement isDisplayingTopFrame.
	restartFrameButton enabled: actionsAllowed.
	resumeButton enabled: actionsAllowed.
	stepBackButton enabled: actionsAllowed.
	stepIntoButton enabled: actionsAllowed.
	stepOverButton enabled: actionsAllowed.
	stepOutButton enabled: actionsAllowed.
]
