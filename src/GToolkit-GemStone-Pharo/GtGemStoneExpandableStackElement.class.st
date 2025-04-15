Class {
	#name : #GtGemStoneExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#instVars : [
		'stackIndexList'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #callbacks }
GtGemStoneExpandableStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	| context |
	super actOnCoderInFocusFor: aContextCoderUIModel.
	
	context := aContextCoderUIModel context.
	self updateStackIndexListTo: context.
]

{ #category : #'building - widgets' }
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

{ #category : #initialization }
GtGemStoneExpandableStackElement >> createStackModelOnSession: aDebuggingSession [
	^ GtGemStoneDebuggerStackModel onSession: aDebuggingSession
]

{ #category : #initialization }
GtGemStoneExpandableStackElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.
]

{ #category : #initialization }
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
	stackPane addChild: stackFramesList as: #expandableFrames.
	
	self addChild: stackPane
]

{ #category : #callbacks }
GtGemStoneExpandableStackElement >> onStackChanged [
	super onStackChanged.
	
	self updateStackIndex
]

{ #category : #callbacks }
GtGemStoneExpandableStackElement >> onStackIndexSelectionChanged [
	"Is executed in a UI process when selection in the index list changes.
	When that happens we should update the selected context in the coders list"
	
	self stackIndexList
		selectedItemDo: [ :context :index | self selectCoderForContext: context ]
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> stackIndexList [
	^ stackIndexList
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateExistingStackModelFor: aDebuggingSession [ 
	stackModel setCurrentContext: aDebuggingSession remoteContext.
	stackModel updateTopProgramCounterMarkersInCurrentCache
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateForSession: aDebuggingSession [
	super updateForSession: aDebuggingSession.
	
	self updateStackIndex
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateStackIndex [
	self
		inUIProcessDo: [ 
			self stackIndexList stream: stackModel contextStream.
			self stackIndexList scrollToIndex: 1 "self selectedContext ordinal" ]
]

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateStackIndexListTo: aContext [
	"Must be sent from a UI process"
	| alreadySelectedContext |

	self stackIndexList selectedItemDo: [ :context | alreadySelectedContext := context ].
	alreadySelectedContext = aContext
		ifTrue: [ ^ self ].

	self stackIndexList
		itemSuchThat: [ :each | each = aContext ]
		ifFound:  [ :anIndex |
			self stackIndexList
				scrollToIndex: anIndex;
				selectOne: anIndex ]
]
