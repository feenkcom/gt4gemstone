Class {
	#name : #GtGemStoneExpandableDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'variableList',
		'variablesContainer',
		'mainTab',
		'stackElement',
		'stdoutEditor',
		'toolbarElement'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #testing }
GtGemStoneExpandableDebuggerElement class >> availableAutomatically [
	"The GemStone debugger should be displayed automatically when opened
	as the Pharo stack only shows that the server paused signal has been received."
	
	^ true
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement class >> defaultTitle [ 

	^ 'GemStone'
]

{ #category : #testing }
GtGemStoneExpandableDebuggerElement class >> handlesContext: aContext [ 
	"This is currently determined by checking the class of the receiver and its value, which will be different for each snippet type.  This should be changed to the signalling method having the appropriate pragma (<dapOpenDebugger>)"
	
	^ (aContext method hasPragmaNamed: #gemstoneDebuggerSignal) and: [
		aContext receiver canHandleSpecificDebugger ].
]

{ #category : #'instance creation' }
GtGemStoneExpandableDebuggerElement class >> openOnDebugger: aDAPDebugger [
	| space |

	space := BlSpace new.
	space root addChild: (self new debuggerClient: aDAPDebugger).
	space show.
]

{ #category : #'tools registry' }
GtGemStoneExpandableDebuggerElement class >> registerToolsOn: registry [
	"self register"
	registry registerDebugger: self withRank: 901.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement class >> sessionClass [

	^ GtGemStoneDebuggerSession 
]

{ #category : #callbacks }
GtGemStoneExpandableDebuggerElement >> actOnDebugSessionChanged [

	toolbarElement actOnDebugSessionChanged.
	self debuggerClient
		when: GtGemStoneDebuggerStateChanged
		send: #actOnDebuggerStateChanged
		to: self.
	
	self scheduleUpdateUI.
]

{ #category : #callbacks }
GtGemStoneExpandableDebuggerElement >> actOnDebuggerStateChanged [

	self debugSession synchronizeCallStack.
	self currentCallFrame resetState.
	self scheduleUpdateUI.
]

{ #category : #callbacks }
GtGemStoneExpandableDebuggerElement >> actOnSelectedContextChangedFor: aContext [
	self updateVariables.
]

{ #category : #callbacks }
GtGemStoneExpandableDebuggerElement >> actOnSelectedContextChangedWithoutFocusChangeFor: aContext [
	self updateVariables.
]

{ #category : #initialization }
GtGemStoneExpandableDebuggerElement >> buildLeftPane [
	| leftPane |
	leftPane := BrVerticalPane new
		matchParent;
		constraintsDo: [ :c | c linear weight: 2 ].
	stackElement := self buildStackElement.
	leftPane
		addChild: stackElement.
	^ leftPane
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> buildMainContent [
	| mainPane panesTabGroupElement |

	mainPane := self buildPanesStructure.
	toolbarElement := self newToolbar.

	panesTabGroupElement := self
		buildStackTabGroupForElement: mainPane
		withToolbar: toolbarElement.
	
	^ panesTabGroupElement
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> buildPanesStructure [
	| rightPane mainPane leftPane |
	mainPane := BrHorizontalPane new matchParent.
	leftPane := self buildLeftPane.
	rightPane := self buildRightPane.
	mainPane
		addChild: leftPane;
		addChild: rightPane.
	^ mainPane
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> buildRightPane [
	| rightPane rightTabGroup |
	rightPane := BrVerticalPane new
		matchParent.
	rightTabGroup := self newRightTabGroup.
	rightPane
		addChild: rightTabGroup.
	^ rightPane
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtGemStoneExpandableStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> buildStackTabGroupForElement: aStackContainerElement withToolbar: anObject [
	| tabGroup |
	mainTab := BrTab new.
	mainTab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: '';
		stencil: (BrValuableStencil from: aStackContainerElement);
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		toolbarStencil: [ anObject ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude:
			(BrGlamorousTabGroupAptitude new
				headerBackground: self theme header defaultBackgroundColor);
		addTab: mainTab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: self theme status errorBackgroundColor;
				yourself).
	^ tabGroup
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> buildVariablesTree [
	| tree |

	tree := BrColumnedTree new
		rowStencil: (BrGlamorousColumnedTreeSelectableRowElementStencilBuilder new cellSpacing: self cellSpacing);
		margin: (BlInsets top: 10);
		background: Color white;
		addEventHandler: (GtPhlowListToSelectHandler new 
			transformation: [ :variableNode :index | 
				(self currentFrameVariable: variableNode value first
					atIndex: index first) asGtBareProxyObject ]).

	tree column
		title: 'I.';
		width: 32;
		cellStencil: [ BlElement new
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical exact: 16 ] ];
		dataBinder: [ :aCellElement :anArray |
			aCellElement removeChildren.
			anArray fourth ifNotNil:
				[ aCellElement addChild: (Smalltalk ui icons iconNamed:  anArray fourth) asElement ] ].
	tree column 
		title: 'Variable';
		width: 100;
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :anArray |
			aCellElement text: anArray first asRopedText ].
	tree column
		title: 'Value';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :anArray |
			aCellElement text: anArray second asRopedText ].

	^ tree
]

{ #category : #'private - accessing' }
GtGemStoneExpandableDebuggerElement >> cellSpacing [ 

	^ 10
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> currentCallFrame [
	^ stackElement selectedContext
]

{ #category : #private }
GtGemStoneExpandableDebuggerElement >> currentFrameVariable: variableName atIndex: anInteger [

	^ debuggingSession 
		currentFrameVariable: variableName 
		atIndex: anInteger
		frameIndentifier:  self currentCallFrame frameIdentifier
]

{ #category : #'private - accessing' }
GtGemStoneExpandableDebuggerElement >> debuggerClient [ 

	^ debuggingSession debuggerClient 
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> debuggerProxy [

	^ self debuggerClient debuggerProxy
]

{ #category : #'private - accessing' }
GtGemStoneExpandableDebuggerElement >> defaultMargin [ 

	^ 5
]

{ #category : #initialization }
GtGemStoneExpandableDebuggerElement >> defineShortcuts [
	self
		addShortcut: ((BlShortcutWithAction new)
					combination: ((BlKeyCombination builder)
								key: BlKeyboardKey F7;
								build);
					action: [:anEvent :aShortcut | self gsStepOver]);
		addShortcut: ((BlShortcutWithAction new)
					combination: ((BlKeyCombination builder)
								key: BlKeyboardKey F5;
								build);
					action: [:anEvent :aShortcut | self gsStepInto]);
		addShortcut: ((BlShortcutWithAction new)
					combination: ((BlKeyCombination builder)
								key: BlKeyboardKey F6;
								build);
					action: [:anEvent :aShortcut | self gsStepThrough]);
		addShortcut: ((BlShortcutWithAction new)
					combination: ((BlKeyCombination builder)
								key: BlKeyboardKey F9;
								build);
					action: [:anEvent :aShortcut | self gsResume]);
		addShortcut: ((BlShortcutWithAction new)
					combination: ((BlKeyCombination builder)
								key: BlKeyboardKey F8;
								build);
					action: [:anEvent :aShortcut | self gsRestartFrame])
]

{ #category : #'private - accessing' }
GtGemStoneExpandableDebuggerElement >> exception [

	^ self debuggerClient exception
]

{ #category : #actions }
GtGemStoneExpandableDebuggerElement >> gsRestartFrame [

	self debugSession 
		gsRestartFrameIdentifier: self currentCallFrame frameIdentifier.
]

{ #category : #actions }
GtGemStoneExpandableDebuggerElement >> gsResume [

	self debugSession gsResume.
	(ResumeDebugAction forDebugger: self) executeAction.
]

{ #category : #actions }
GtGemStoneExpandableDebuggerElement >> gsStepInto [
	self debugSession 
		gsStepIntoFrameIdentifier:  self currentCallFrame frameIdentifier.
]

{ #category : #actions }
GtGemStoneExpandableDebuggerElement >> gsStepOut [
	self currentCallFrame sender ifNotNil: [ :aSender |
		self debugSession 
			gsStepOverFrameIdentifier:  aSender frameIdentifier ]
]

{ #category : #actions }
GtGemStoneExpandableDebuggerElement >> gsStepOver [
	self debugSession 
		gsStepOverFrameIdentifier:  self currentCallFrame frameIdentifier.
]

{ #category : #actions }
GtGemStoneExpandableDebuggerElement >> gsStepThrough [
	self debugSession 
		gsStepThroughFrameIdentifier: self currentCallFrame frameIdentifier.
]

{ #category : #initialization }
GtGemStoneExpandableDebuggerElement >> initialize [
	super initialize.
	self constraintsDo: 
			[:c |
			c vertical matchParent.
			c horizontal matchParent].
	self userData at: #debuggerContainer put: #debuggerElement.
	self addChild: self buildMainContent.
	self defineShortcuts
]

{ #category : #testing }
GtGemStoneExpandableDebuggerElement >> isResumable [

	^ self exception isResumable
]

{ #category : #'private - accessing' }
GtGemStoneExpandableDebuggerElement >> lineNumber [ 

	^ self currentCallFrame
		ifNil: [ 1 ]
		ifNotNil: [ self currentCallFrame line ifNil: [ 1 ] ]
]

{ #category : #'instance creation' }
GtGemStoneExpandableDebuggerElement >> newBreakpointsList [
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
GtGemStoneExpandableDebuggerElement >> newRightTabGroup [

	^ BrTabGroup new 
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		margin: (BlInsets all: self defaultMargin);
		background: Color white;
		addTab: self variablesTab;
		addTab: self stdoutTab.
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> newStdoutView [

	^ BrEditor new
		aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new;
		background: Color white.
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> newToolbar [ 

	^ GtGemStoneExpandableDebuggerToolbar new 
		dapDebugElement: self;
		hMatchParent;
		vFitContent;
		background: BrGlamorousColors defaultHeaderBackgroundColor;
		padding: (BlInsets top: 10 left: 0 bottom: 5 right: 10);
		alignCenterRight;
		yourself
]

{ #category : #'instance creation' }
GtGemStoneExpandableDebuggerElement >> newVariablesList [
	| container tree |

	container := BlElement new
		aptitude: BrShadowAptitude;
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical.
	tree := self buildVariablesTree.
	container addChild: tree as: #variablesList.
	^ container
]

{ #category : #private }
GtGemStoneExpandableDebuggerElement >> scheduleUpdateStdout [

	stdoutEditor ifNotNil: [ 
		self enqueueTask: (BlTaskAction new action: [ 
			self updateStdout ]) ]
]

{ #category : #private }
GtGemStoneExpandableDebuggerElement >> scheduleUpdateUI [

	self enqueueTask: (BlTaskAction new 
		action: [ self updateUI ]).
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> stdoutTab [

	^ BrTab new 
		aptitude: BrGlamorousTabAptitude;
		label: 'stdout';
		stencil: [ 
			stdoutEditor ifNil: [ 
				stdoutEditor := self newStdoutView.
				self scheduleUpdateStdout.
				stdoutEditor ] ]
]

{ #category : #'private - update ui' }
GtGemStoneExpandableDebuggerElement >> updateCallFrame [
	
	stackElement updateForSession: debuggingSession
]

{ #category : #'private - update ui' }
GtGemStoneExpandableDebuggerElement >> updateDisplay [ 
	self updateMainTabLabel.
	self updateCallFrame.
	"self updateVariables" "Should not be done here as the selected context is not yet changed".
	self updateStdout.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateMainTabLabel [
	mainTab label: self debuggerClient messageText.
]

{ #category : #callbacks }
GtGemStoneExpandableDebuggerElement >> updateStdout [

	stdoutEditor ifNil: [ ^ self ].
	stdoutEditor text: self debuggerClient stdout asRopedText
]

{ #category : #callbacks }
GtGemStoneExpandableDebuggerElement >> updateUI [
	debuggingSession ifNil: [ ^ self ].
	
	self updateDisplay.
	toolbarElement updateUI.
]

{ #category : #'private - update ui' }
GtGemStoneExpandableDebuggerElement >> updateVariables [ 
	| varibleItems|
	
	variableList ifNil: [ ^ self ].
	varibleItems := self currentCallFrame
			ifNil: [ #() ]
			ifNotNil: [ self currentCallFrame safeVariablesAssociationsBasedOnIndex ].
	
	variableList 
		items: varibleItems
		immediate: [ :item | 
			item value isDictionary
				ifTrue: [ item value associations ]
				ifFalse: [ (item value isArray and: [ item value allSatisfy: #isDictionary ])
						ifTrue: [ item value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ].
	variableList expandAll.
]

{ #category : #'private - element creation' }
GtGemStoneExpandableDebuggerElement >> variablesTab [

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
