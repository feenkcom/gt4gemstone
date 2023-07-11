Class {
	#name : #GtGemStoneDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'toolbar',
		'variableList',
		'callFramesList',
		'sourceCode',
		'currentCallFrame',
		'currentThread',
		'debuggerState',
		'stdout',
		'stderr',
		'breakpoints',
		'variablesContainer',
		'modules',
		'debuggerClient',
		'summary'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #testing }
GtGemStoneDebuggerElement class >> availableAutomatically [
	"The GemStone debugger should be displayed automatically when opened
	as the Pharo stack only shows that the server paused signal has been received."
	
	^ true
]

{ #category : #accessing }
GtGemStoneDebuggerElement class >> defaultTitle [ 

	^ 'GemStone Debugger'
]

{ #category : #testing }
GtGemStoneDebuggerElement class >> handlesContext: aContext [ 
	"This is currently determined by checking the class of the receiver and its value, which will be different for each snippet type.  This should be changed to the signalling method having the appropriate pragma (<dapOpenDebugger>)"

	^ aContext method hasPragmaNamed: #gemstoneDebuggerSignal.
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement class >> openOnDebugger: aDAPDebugger [
	| space |

	space := BlSpace new.
	space root addChild: (self new debuggerClient: aDAPDebugger).
	space show.
]

{ #category : #'tools registry' }
GtGemStoneDebuggerElement class >> registerToolsOn: registry [
	"self register"
	registry registerDebugger: self withRank: 900.
]

{ #category : #accessing }
GtGemStoneDebuggerElement class >> sessionClass [

	^ GtPostMortemSession 
]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> actOnBrowserClosing: ann [
	"If the remote debugger is stopped, resume it, otherwise the remote is effectively locked up"

	"Tell the debugger directly to resume, since we are already closing"
	toolbar actOnBrowserClosing: ann.

]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> actOnDebugSessionChanged [

	currentCallFrame := self debuggerClient stackFrames first.
	sourceCode styler: self debuggerClient sourceStyler.
	toolbar actOnDebugSessionChanged.
	self scheduleUpdateUI.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> breakpointsTab [

	^ BrTab new 
		aptitude: BrGlamorousTabAptitude;
		label: 'Breakpoints';
		stencil: 
			[ breakpoints ifNil: 
				[ breakpoints := self newBreakpointsList.
				self scheduleUpdateBreakpoints.
				breakpoints ] ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> buildVariablesHeader [
	| header |

	header := BlElement new
		layout: (BlLinearLayout horizontal alignCenterLeft cellSpacing: self cellSpacing);
		padding: (BlInsets top: 5 bottom: 5);
		labeled: 'Columned Header';
		background: Color white;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
	#(Name Value) do: [ :label |
		header addChild: (BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			alignCenterLeft;
			width: 100;
			text: (label asRopedText foreground: BrGlamorousColors defaultButtonTextColor)) ].
	header children first padding: (BlInsets left: 20).
	^ header
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> buildVariablesTree [
	| tree |

	tree := BrColumnedTree new
		rowStencil: (BrGlamorousColumnedTreeSelectableRowElementStencilBuilder new cellSpacing: self cellSpacing);
		margin: (BlInsets top: 10);
		background: Color white;
		addEventHandler: (GtPhlowListToSelectHandler new 
			transformation: [ :variableNode | variableNode value value asGtBareProxyObject ]).

	tree column 
		title: 'Variable';
		width: 100;
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :anAssociation |
			aCellElement text: anAssociation key asRopedText ].
	tree column
		title: 'Value';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :anAssociation |
			aCellElement text: anAssociation value gtDisplayString asRopedText ].
	^ tree
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> cellSpacing [ 

	^ 10
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> debuggerClient [ 

	^ debuggerClient ifNil: [ debuggerClient := debuggingSession ifNotNil: [ debuggingSession debuggerClient ] ]
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> debuggerClient: aDAPDebugger [

	debuggerClient := aDAPDebugger.
	self actOnDebugSessionChanged.
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> defaultMargin [ 

	^ 5
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> displayStackFrame: aDAPStackFrame [
	"Set the supplied frame as the current frame and update the rest of the UI"

	currentCallFrame := aDAPStackFrame.
	toolbar updateUI.
	self updateDisplay.
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> exception [

	^ self debuggerClient exception
]

{ #category : #initialization }
GtGemStoneDebuggerElement >> initialize [
	| container mainPane leftPane rightTabGroup rightPane cfContainer sourceContainer |

	super initialize.
	self 
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent ].
	container := BrVerticalPane new matchParent.
	mainPane := BrHorizontalPane new matchParent.
	leftPane := BrVerticalPane new
		matchParent;
		constraintsDo: [ :c |
			c linear weight: 1.0 ].
	callFramesList := self newCallFramesList.
	cfContainer := BlElement new 
		aptitude: BrShadowAptitude;
		margin: (BlInsets all: self defaultMargin);
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent.
			c linear weight: 0.3 ];
		addChild: callFramesList.
	sourceCode := self newSourceEditor.
	sourceContainer := BlElement new.
	sourceContainer
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1.0 ];
		addChild: sourceCode.
	leftPane
		addChild: cfContainer;
		addChild: sourceContainer.
	rightPane := BrVerticalPane new
		matchParent;
		constraintsDo: [ :c |
			c linear weight: 0.7 ].
	rightTabGroup := self newRightTabGroup.
	debuggerState := self newDebuggerState.
	toolbar := self newToolbar.
	rightPane
		addChild: debuggerState;
		addChild: rightTabGroup.
	mainPane
		addChild: leftPane;
		addChild: rightPane.
	container 
		addChild: toolbar;
		addChild: mainPane.
	self addChild: container.
	self addChild: (BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: BrGlamorousColors errorBackgroundColor;
				yourself).

]

{ #category : #testing }
GtGemStoneDebuggerElement >> isDisplayingTopFrame [
	"Answer a boolean indicating whether the top call frame is being displayed.
	DAP debuggers only allow stepping and continuing from the top frame."

	^ debuggerClient isStopped and: [ currentCallFrame == debuggerClient stackFrames first ]
]

{ #category : #testing }
GtGemStoneDebuggerElement >> isResumable [

	^ self exception isResumable
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> lineNumber [ 

	^ currentCallFrame
		ifNil: [ 1 ]
		ifNotNil: [ currentCallFrame line ifNil: [ 1 ] ]
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> newBreakpointsList [
	| list |

	list := BrColumnedList new
		margin: (BlInsets top: 10);
		background: Color white;
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		addEventHandler: (GtPhlowListToSelectHandler new 
			transformation: [ :aDAPBreakpoint | aDAPBreakpoint ]);
		yourself.

	list column 
		title: 'Id';
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hExact: 30;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aDAPBreakpoint |
			aCellElement text: aDAPBreakpoint id asString asRopedText ].
	list column 
		title: 'Breakpoint';
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aDAPBreakpoint |
			aCellElement text: aDAPBreakpoint asString asRopedText ].

	^ list
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> newCallFramesList [
	| list |

	list := BrColumnedList new
		margin: (BlInsets top: 10);
		background: Color white;
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		addEventHandler: (GtPhlowListToSelectHandler new 
			transformation: [ :aDAPStackFrame | self displayStackFrame: aDAPStackFrame. aDAPStackFrame ]);
		yourself.

	list column 
		title: 'Depth';
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hExact: 30;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aCDTCallFrame |
			aCellElement text: aCDTCallFrame ordinal asString asRopedText ].
	list column
		title: 'Frame';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aCDTCallFrame |
			aCellElement text: aCDTCallFrame gtDisplayString asRopedText ].

	^ list
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> newDebuggerState [

	^ BrEditor new
		aptitude: BrGlamorousEditorAptitude + BrShadowAptitude;
		margin: (BlInsets all: self defaultMargin);
		background: Color white;
		hMatchParent;
		vFitContent;
		beMode: BrTextEditorReadonlyWithoutSelectionMode new.

]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> newRightTabGroup [

	^ BrTabGroup new 
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		margin: (BlInsets all: self defaultMargin);
		background: Color white;
		addTab: self summaryTab;
		addTab: self variablesTab;
		addTab: self breakpointsTab;
		addTab: self stdoutTab;
		addTab: self stderrTab.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> newSourceEditor [

	^ BrEditor new
		aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new;
		margin: (BlInsets all: self defaultMargin);
		background: Color white.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> newStderrView [

	^ BrEditor new
		aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new;
		background: Color white.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> newStdoutView [

	^ BrEditor new
		aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new;
		background: Color white.
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> newSummaryView [

	^ BrEditor new
		aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new;
		background: Color white.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> newToolbar [ 

	^ GtGemStoneDebuggerToolbar new 
		dapDebugElement: self;
		hMatchParent;
		vFitContent;
		background: BrGlamorousColors defaultHeaderBackgroundColor;
		padding: (BlInsets top: 10 left: 0 bottom: 5 right: 10);
		alignCenterRight;
		yourself
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> newVariablesList [
	| container header tree |

	container := BlElement new
		aptitude: BrShadowAptitude;
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical.
	header := self buildVariablesHeader.
	tree := self buildVariablesTree.
	container 
		addChild: header;
		addChild: tree as: #variablesList.
	^ container
]

{ #category : #private }
GtGemStoneDebuggerElement >> scheduleUpdateBreakpoints [

	breakpoints ifNotNil:
		[ self enqueueTask: (BlTaskAction new action: [ self updateBreakpoints ]) ].

]

{ #category : #private }
GtGemStoneDebuggerElement >> scheduleUpdateModules [

	modules ifNotNil:
		[ self enqueueTask: (BlTaskAction new action: [ self updateModules ]) ].

]

{ #category : #private }
GtGemStoneDebuggerElement >> scheduleUpdateStderr [

	stderr ifNotNil:
		[ self enqueueTask: (BlTaskAction new action: [ self updateStderr ]) ].

]

{ #category : #private }
GtGemStoneDebuggerElement >> scheduleUpdateStdout [

	stdout ifNotNil:
		[ self enqueueTask: (BlTaskAction new action: [ self updateStdout ]) ].

]

{ #category : #accessing }
GtGemStoneDebuggerElement >> scheduleUpdateSummary [

	summary ifNotNil:
		[ self enqueueTask: (BlTaskAction new action: [ self updateSummary ]) ].

]

{ #category : #private }
GtGemStoneDebuggerElement >> scheduleUpdateUI [

	self enqueueTask: (BlTaskAction new action: [ self updateUI ]).

]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> sourceCode [

	^ currentCallFrame sourceCode
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> sourceText [ 
	"Answer the receiver's source code, with the current line highlighted"

	^ currentCallFrame
		ifNil: [ '' ]
		ifNotNil: [ currentCallFrame sourceText ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> stderrTab [

	^ BrTab new 
		aptitude: BrGlamorousTabAptitude;
		label: 'stderr';
		stencil: 
			[ stderr ifNil: 
				[ stderr := self newStderrView.
				self scheduleUpdateStderr.
				stderr ] ]
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> stdoutTab [

	^ BrTab new 
		aptitude: BrGlamorousTabAptitude;
		label: 'stdout';
		stencil: 
			[ stdout ifNil: 
				[ stdout := self newStdoutView.
				self scheduleUpdateStdout.
				stdout ] ]
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> summaryTab [

	^ BrTab new 
		aptitude: BrGlamorousTabAptitude;
		label: 'Summary';
		stencil: 
			[ summary ifNil: 
				[ summary := self newSummaryView.
				self scheduleUpdateSummary.
				summary ] ]
]

{ #category : #actions }
GtGemStoneDebuggerElement >> terminateSession [

	super terminateSession.
	debuggerClient ifNotNil: 
		[ debuggerClient announcer unsubscribe: self ]
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateBreakpoints [

	breakpoints ifNotNil:
		[ breakpoints items: (self debuggerClient breakpoints values sorted: [ :a :b | a id < b id ]) ]

]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateCallFrame [

	callFramesList items: self debuggerClient stackFrames.

]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateDisplay [ 

	self updateCallFrame.
	self updateVariables.
	self updateSource.

]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateModules [

	modules ifNotNil:
		[ modules items: (self debuggerClient modules values sorted: [ :a :b | a name < b name ]) ]

]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateSource [ 

	sourceCode text: self sourceText.
	"self lineNumber > 5 ifTrue:
		[ StringSignal emit: 'Scrolling to line: ', self lineNumber asString.
		sourceCode scrollToPosition: self lineNumber + 5 ]."

]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> updateStderr [

	stderr text: self debuggerClient stderr asRopedText
]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> updateStdout [

	stdout text: self debuggerClient stdout asRopedText
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> updateSummary [

	summary text: self exception summaryString
]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> updateUI [

	debuggerState text: self exception summaryText.
	self updateDisplay.
	toolbar updateUI.
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateVariables [ 

	variableList ifNil: [ ^ self ].
	variableList 
		items: (currentCallFrame
			ifNil: [ #() ]
			ifNotNil: [ currentCallFrame variablesAssociations ])
		immediate: [ :item | 
			item value isDictionary
				ifTrue: [ item value associations ]
				ifFalse: [ (item value isArray and: [ item value allSatisfy: #isDictionary ])
						ifTrue: [ item value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ].
	variableList expandAll.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> variablesTab [

	^ BrTab new 
		aptitude: BrGlamorousTabAptitude;
		label: 'Variables';
		stencil: 
			[ variablesContainer ifNil: 
				[ variablesContainer := self newVariablesList.
				variableList := variablesContainer childNamed: #variablesList.
				self updateVariables.
				variablesContainer ] ]
]
