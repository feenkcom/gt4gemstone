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

{ #category : #callbacks }
GtGemStoneExpandableDebuggerToolbar >> actOnDebugSessionChanged [
	| visibility |

	visibility := self isResumable
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ].
	{ restartFrameButton. resumeButton. stepIntoButton. stepOverButton. } do: [ :button |
		button visibility: visibility ].
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
	stepOutButton := self newStepOutButton.
	self addChildren: { resumeButton. restartFrameButton. stepIntoButton. stepOverButton. stepThroughButton. stepOutButton. }.
	self addChild: self newInspectButton.
]

{ #category : #testing }
GtGemStoneExpandableDebuggerToolbar >> isResumable [

	^ self debuggerClient exception isResumable
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newInspectButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		label: 'Inspect the DAP Debugger';
		icon: BrGlamorousVectorIcons emphasizedInspect;
		action: [ :aButton | dapDebugElement inspect ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newRestartFrameButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons restart;
		label: 'Restart Frame';
		action: [ :aButton | dapDebugElement gsRestartFrame ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newResumeButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons play;
		label: 'Resume';
		action: [ :aButton | dapDebugElement gsResume ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepIntoButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons into;
		label: 'Step Into';
		action: [ :aButton | dapDebugElement gsStepInto ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepOutButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons down;
		label: 'Step Out';
		action: [ :aButton | dapDebugElement gsStepOut ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepOverButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons over;
		label: 'Step Over';
		action: [ :aButton | dapDebugElement gsStepOver ]
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerToolbar >> newStepThroughButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons through;
		label: 'Step Through';
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
