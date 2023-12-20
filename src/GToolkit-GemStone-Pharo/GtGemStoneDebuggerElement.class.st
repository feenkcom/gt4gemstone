Class {
	#name : #GtGemStoneDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'toolbar',
		'variableList',
		'callFramesList',
		'currentCallFrame',
		'stdout',
		'stderr',
		'breakpoints',
		'variablesContainer',
		'modules',
		'summary',
		'sourceCodeEditorElement',
		'debuggerMessageEditor'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
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
	| result |
	
	result := aContext method hasPragmaNamed: #gemstoneDebuggerSignal.
	^ result.
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

	^ GtGemStoneDebuggerSession 
]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> actOnDebugSessionChanged [

	sourceCodeEditorElement ifNotNil: [ :anEditor | 		
		anEditor styler: self debuggerClient sourceStyler ].
	toolbar actOnDebugSessionChanged.
	
	self scheduleUpdateUI.
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> actOnSelectedContextChanged: aGtGemStoneStackFrame [ 
	self updateVariables.
	self updateSource.
	self updateStdout.
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> actOnSelectedStackFrameIndexChangedEvent: anEvent [ 
	anEvent indices
		ifNotEmpty: [ :theIndices | 
			| aWidgetElement gemStoneStackFrame |
			aWidgetElement := anEvent currentTarget.
			gemStoneStackFrame := aWidgetElement viewModel itemAt: theIndices first.
			self selectStackFrame: gemStoneStackFrame ]
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

{ #category : #initialization }
GtGemStoneDebuggerElement >> buildLeftPane [
	| cfContainer sourceContainer leftPane |
	leftPane := BrVerticalPane new
			matchParent;
			constraintsDo: [ :c | c linear weight: 1.0 ].
	callFramesList := self newCallFramesList.
	cfContainer := BlElement new
			aptitude: BrShadowAptitude;
			margin: (BlInsets all: self defaultMargin);
			constraintsDo: [ :c | 
				c vertical matchParent.
				c horizontal matchParent.
				c linear weight: 0.3 ];
			addChild: callFramesList.
	sourceCodeEditorElement := self newSourceEditor.
	sourceContainer := BlElement new.
	sourceContainer
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1.0 ];
		addChild: sourceCodeEditorElement.
	leftPane
		addChild: cfContainer;
		addChild: sourceContainer.
	^ leftPane
]

{ #category : #initialization }
GtGemStoneDebuggerElement >> buildMainContent [
	| container mainPane |
	container := BrVerticalPane new matchParent.
	mainPane := self buildPanesStructure.
	toolbar := self newToolbar.
	
	container
		addChild: toolbar;
		addChild: mainPane.
	
	^ container.
]

{ #category : #initialization }
GtGemStoneDebuggerElement >> buildPanesStructure [
	| rightPane mainPane leftPane |
	mainPane := BrHorizontalPane new matchParent.
	leftPane := self buildLeftPane.
	rightPane := self buildRightPane.
	mainPane
		addChild: leftPane;
		addChild: rightPane.
	^ mainPane
]

{ #category : #initialization }
GtGemStoneDebuggerElement >> buildRightPane [
	| rightPane rightTabGroup |
	rightPane := BrVerticalPane new
			matchParent;
			constraintsDo: [ :c | c linear weight: 0.7 ].
	rightTabGroup := self newRightTabGroup.
	debuggerMessageEditor := self newExceptionMessageEditor.
	rightPane
		addChild: debuggerMessageEditor;
		addChild: rightTabGroup.
	^ rightPane
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
			transformation: [ :variableNode :index | (self currentFrameVariableNamed: variableNode value first) asGtBareProxyObject ]).

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
			aCellElement text: anAssociation first asRopedText ].
	tree column
		title: 'Value';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :anAssociation |
			aCellElement text: anAssociation second asRopedText ].

	^ tree
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> cellSpacing [ 

	^ 10
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> currentCallFrame [
	^ currentCallFrame
]

{ #category : #actions }
GtGemStoneDebuggerElement >> currentCallFrame: aStackFrame [

	currentCallFrame := aStackFrame "or nil"
]

{ #category : #private }
GtGemStoneDebuggerElement >> currentFrameVariableNamed: aSymbol [

	^ self debuggerProxy
		proxyPerform: #variable:atFrameLevel:
		withArguments: { aSymbol. self currentCallFrame ordinal. }
		autoCommit: false.
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> debuggerClient [ 

	^ debuggingSession debuggerClient 
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> debuggerProxy [

	^ self debuggerClient debuggerProxy
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> defaultMargin [ 

	^ 5
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> displayStackFrame: aGtGemStoneStackFrame [
	"Set the supplied frame as the current frame and update the rest of the UI"

	currentCallFrame := aGtGemStoneStackFrame.
	toolbar updateUI.
	self updateDisplay.
]

{ #category : #'private - accessing' }
GtGemStoneDebuggerElement >> exception [

	^ self debuggerClient exception
]

{ #category : #actions }
GtGemStoneDebuggerElement >> gsRestartFrame [

	self debuggerClient gsRestartFrameLevel: currentCallFrame ordinal.
	currentCallFrame := nil.
	self scheduleUpdateUI.
]

{ #category : #actions }
GtGemStoneDebuggerElement >> gsResume [

	self debuggerClient gsResume.
	currentCallFrame := nil.
	(ResumeDebugAction forDebugger: self) executeAction.
]

{ #category : #actions }
GtGemStoneDebuggerElement >> gsStepInto [

	self debuggerClient gsStepIntoFrameLevel: currentCallFrame ordinal.
	currentCallFrame := nil.
	self scheduleUpdateUI.
]

{ #category : #actions }
GtGemStoneDebuggerElement >> gsStepOut [

	self debuggerClient gsStepOverFrameLevel: currentCallFrame ordinal + 1.
	currentCallFrame := nil.
	self scheduleUpdateUI.
]

{ #category : #actions }
GtGemStoneDebuggerElement >> gsStepOver [

	self debuggerClient gsStepOverFrameLevel: self currentCallFrame ordinal.
	self currentCallFrame: nil.
	self scheduleUpdateUI.
]

{ #category : #actions }
GtGemStoneDebuggerElement >> gsStepThrough [

	self debuggerClient gsStepThroughFrameLevel: currentCallFrame ordinal.
	currentCallFrame := nil.
	self scheduleUpdateUI.
]

{ #category : #initialization }
GtGemStoneDebuggerElement >> initialize [
	super initialize.
	
	self
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	self userData at: #debuggerContainer put: #debuggerElement.
	
	self addChild: self buildMainContent.
	self
		addChild: (BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: BrGlamorousColors errorBackgroundColor;
				yourself)
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
		when: BrSelectionChanged
			do: [ :anEvent | 
				self actOnSelectedStackFrameIndexChangedEvent: anEvent ];
		yourself.

	list column 
		title: 'Depth';
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hExact: 30;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aGtGemStoneStackFrame |
			aCellElement text: aGtGemStoneStackFrame ordinal asString asRopedText ].
	list column
		title: 'Frame';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aGtGemStoneStackFrame |
			aCellElement text: aGtGemStoneStackFrame gtDisplayString asRopedText ].

	^ list
]

{ #category : #'instance creation' }
GtGemStoneDebuggerElement >> newExceptionMessageEditor [

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
		"addTab: self breakpointsTab;"
		addTab: self stdoutTab.
]

{ #category : #'private - element creation' }
GtGemStoneDebuggerElement >> newSourceEditor [

	^ BrEditor new
		aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new;
		margin: (BlInsets all: self defaultMargin);
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

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> selectStackFrame: aGtGemStoneStackFrame [
	"Set the supplied frame as the current frame and update the rest of the UI"

	currentCallFrame := aGtGemStoneStackFrame.
	toolbar updateUI.
	
	self actOnSelectedContextChanged: aGtGemStoneStackFrame
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

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateBreakpoints [

	breakpoints ifNotNil:
		[ breakpoints items: (self debuggerClient breakpoints values sorted: [ :a :b | a id < b id ]) ]

]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateCallFrame [
	| stackFrames |

	stackFrames := self debuggerClient stackFrames.
	currentCallFrame ifNil:
		[ currentCallFrame := stackFrames first ].
	callFramesList items: stackFrames.
	callFramesList selectOne: (stackFrames indexOf: currentCallFrame).
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateDisplay [ 

	self updateCallFrame.
	self updateVariables.
	self updateSource.
	self updateStdout.
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateModules [

	modules ifNotNil:
		[ modules items: (self debuggerClient modules values sorted: [ :a :b | a name < b name ]) ]

]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateSource [ 

	sourceCodeEditorElement text: self sourceText.
	"self lineNumber > 5 ifTrue:
		[ StringSignal emit: 'Scrolling to line: ', self lineNumber asString.
		sourceCode scrollToPosition: self lineNumber + 5 ]."

]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> updateStdout [

	stdout ifNil: [ ^ self ].
	stdout text: self debuggerClient stdout asRopedText
]

{ #category : #accessing }
GtGemStoneDebuggerElement >> updateSummary [

	summary text: self debuggerClient summaryString
]

{ #category : #callbacks }
GtGemStoneDebuggerElement >> updateUI [

	debuggerMessageEditor text: self debuggerClient messageText.
	self updateDisplay.
	toolbar updateUI.
]

{ #category : #'private - update ui' }
GtGemStoneDebuggerElement >> updateVariables [ 

	variableList ifNil: [ ^ self ].
	variableList 
		items: (self currentCallFrame
			ifNil: [ #() ]
			ifNotNil: [ self currentCallFrame variablesAssociations ])
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
