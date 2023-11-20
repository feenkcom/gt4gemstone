Class {
	#name : #GtGemStoneDebuggerToolbar,
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
	{ restartFrameButton. resumeButton. stepIntoButton. stepOverButton. } do: [ :button |
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
		action: [ :aButton | dapDebugElement inspect ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newRestartFrameButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons restart;
		label: 'Restart Frame';
		action: [ :aButton | dapDebugElement gsRestartFrame ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newResumeButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons play;
		label: 'Resume';
		action: [ :aButton | dapDebugElement gsResume ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepIntoButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons into;
		label: 'Step Into';
		action: [ :aButton | dapDebugElement gsStepInto ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepOutButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons down;
		label: 'Step Out';
		action: [ :aButton | dapDebugElement gsStepOut ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepOverButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons over;
		label: 'Step Over';
		action: [ :aButton | dapDebugElement gsStepOver ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerToolbar >> newStepThroughButton [

	^ BrButton new 
		aptitude: BrGlamorousButtonWithIconAptitude;
		margin: (BlInsets left: 5);
		icon: BrGlamorousIcons through;
		label: 'Step Through';
		action: [ :aButton | dapDebugElement gsStepThrough ]
]

{ #category : #private }
GtGemStoneDebuggerToolbar >> updateUI [ 
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
