Class {
	#name : #GtGemStoneExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#instVars : [
		'stackIndexList',
		'stackFrames'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneExpandableStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	| context |
	super actOnCoderInFocusFor: aContextCoderUIModel.
	context := aContextCoderUIModel context.
	self updateStackIndexListTo: context.
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> buildStackIndex [
	| indexList labelBlock |
	indexList := BrColumnedList new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude new beRight;
			background: BrGlamorousColors neutralBackgroundColor;
			rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
			matchParent.
	labelBlock := [ BrLabel new
			margin: (BlInsets right: 10);
			aptitude: BrGlamorousLabelAptitude;
			beSmallSize;
			hMatchParent;
			vFitContent ].
	indexList column
		title: 'Class';
		matchParent;
		cellStencil: labelBlock;
		dataBinder: [ :element :context | element text: (self contextClassText: context) ].
	indexList column
		title: 'Method';
		matchParent;
		cellStencil: labelBlock;
		dataBinder: [ :element :context | element text: (self contextMethodText: context) ].
	indexList column
		title: 'Package';
		cellStencil: labelBlock;
		width: 100;
		dataBinder: [ :element :context | 
			element
				text: (context frameSpecification packageName ifNil: [ '' ]) ].
	indexList
		addAptitude: (BrColumnedListHeaderAptitude new
				labelStencil: [ :column | 
					| label |
					label := BrLabel new
							aptitude: BrLabelAptitude;
							margin: (BlInsets right: 8);
							text: (column title asRopedText
									glamorousRegularFont;
									fontSize: 12;
									foreground: Color gray).
					column columnWidth applyOn: label.
					label ]).
	indexList
		when: BrSelectionChanged
		do: [ :anEvent | self onStackIndexSelectionChanged ].
	^ indexList
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> contextClassText: aContext [
	^ aContext frameSpecification printBehaviorName.
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> contextMethodText: aContext [
	^ aContext displayString
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> initialize [
	super initialize.
	self layout: BlLinearLayout horizontal.
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> initializeStackList [
	| stackFramesList stackPane sidebarElement tabGroup stackTab |
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self
		addAptitude: (GtPhlowToolDetailAptitude new
				normal: [ :aStyle | aStyle do: [ sidebarElement hide ] ];
				detailed: [ :aStyle | aStyle do: [ sidebarElement show ] ]).
	stackIndexList := self buildStackIndex.
	
	tabGroup := BrTabGroup new aptitude: BrGlamorousTabGroupAptitude new.
	stackTab := BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: 'Stack';
			stencil: [ stackIndexList ].

	tabGroup addTab: stackTab.
	sidebarElement addChild: tabGroup.
	self addChild: sidebarElement.
	
	stackPane := BrVerticalPane new.
	stackPane matchParent.
	stackPane padding: (BlInsets all: 10).
	
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	stackPane addChild: stackFramesList as: #expandableFrames.
	
	self addChild: stackPane
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> onStackIndexSelectionChanged [
	self
		inUIProcessDo: [ self stackIndexList
				selectedItemDo: [ :context :index | self selectContext: context ] ]
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> selectContext: aContext [
	super selectContext: aContext.
	
	self updateStackIndexListTo: aContext.
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> stackIndexList [
	^ stackIndexList
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateForSession: aDebuggingSession [

	stackFrames := aDebuggingSession debuggerClient stackFrames.

	self inUIProcessDo: [ | currentCallFrame |

		currentCallFrame ifNil: 
			[ currentCallFrame := stackFrames first ].
		
		self stackFramesList items: (stackFrames collect: [ :aGsFrame |
			(GtGemStoneContextCoderModel fromStackFrame: aGsFrame) 
		 		debuggingSession: aDebuggingSession;
		 		asCoderViewModel ]).

		self selectContext:  currentCallFrame ].

	self updateStackIndex.
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateStackIndex [
	self
		inUIProcessDo: [ 
			self stackIndexList items: stackFrames.
			self stackIndexList scrollToIndex: self selectedContext ordinal ]
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateStackIndexListTo: aContext [
	| selected |
	
	self stackIndexList selectedItemDo: [ :context | selected := context ].
	selected ~~ aContext
		ifTrue: [ (self stackIndexList scrollToItemSuchThat: [ :each | each == aContext ])
				then: [ :v | 
					self stackIndexList
						inUIProcessDo: [ | index |
							index := self stackIndexList items indexOf: aContext.
							index > 0 ifTrue: [ self stackIndexList selectOne: index ] ] ] ]
]
