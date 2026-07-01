Class {
	#name : #GtGemStoneRemoteTranscript,
	#superclass : #Object,
	#instVars : [
		'gemStoneSession',
		'transcriptProxy'
	],
	#category : #'GToolkit-GemStone-Pharo-Transcript'
}

{ #category : #'instance creation' }
GtGemStoneRemoteTranscript class >> forGemStoneSession: aGemStoneSession [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> addSessionActionsOnMenu: aMenu [
	aMenu addItemLabel: 'Commit changes'
		action: 
			[:aButton |
			self gemStoneSession commitTransactionWithErrorChecking.
			aButton phlow fireToolUpdateWish].
	aMenu addItemLabel: 'Abort changes'
		action: 
			[:aButton |
			self gemStoneSession abortTransaction.
			aButton phlow fireToolUpdateWish].
	aMenu addItemLabel: 'Inspect session'
		action: 
			[:aButton |
			aButton phlow
				spawnObject: self gemStoneSession ]
]

{ #category : #actions }
GtGemStoneRemoteTranscript >> clearRemoteTranscript [
	^ transcriptProxy proxyPerform: #clearContent autoCommit: false
]

{ #category : #utils }
GtGemStoneRemoteTranscript >> createRemoteTranscriptProxy [
	^ ((self gemStoneSession
		createBlockEvaluationFor: [ GtGemStoneTranscript current ])
			autoCommit: false;
			returnProxy;
			evaluateAndWait) 
]

{ #category : #accessing }
GtGemStoneRemoteTranscript >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> gtActionClearFor: anAction [
	<gtAction>
	<gtToolAction>
		
	self hasTranscriptProxy ifFalse: [ ^ anAction noAction ].

	^(anAction button)
		label: 'Clear';
		icon: BrGlamorousVectorIcons bin;
		tooltip: 'Clear the transcript content';
		priority: 25;
		action: [ :aButton |
			self clearRemoteTranscript.
			aButton phlow fireCurrentToolUpdateWish  ]
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> gtActionInspectProxyFor: anAction [
	<gtAction>
	
	^ anAction button
		priority: 50;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Proxy';
		tooltip: 'Inspect transcript proxy';
		action: [ :aButton |
			aButton phlow 
				spawnObject: self transcriptProxy ];
		primaryModifierAction: [ :aButton |
				aButton phlow 
					showObject: self transcriptProxy ]
			mouseCursor: BlCopyCursor new
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> gtActionToggleFor: anAction [
	<gtAction>
	<gtToolAction>
	| isEnabled | 
		
	self hasTranscriptProxy ifFalse: [ ^ anAction noAction ].
	isEnabled := self isEnabled.

	^(anAction button)
		label: (isEnabled ifTrue: ['Disable'] ifFalse: ['Enable']);
		tooltip: 'Toggle the enable/disable status of the remote transcript';
		priority: 5;
		action: [ :aButton |
			self toggleRemoteTranscript.
			aButton phlow fireCurrentToolUpdateWish ]
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> gtActionUpdateFor: anAction [
	<gtAction>
	<gtToolAction>

	^(anAction button)
		tooltip: 'Update the content of the transcript';
		icon: BrGlamorousVectorIcons refresh;
		priority: 15;
		action: [ :aButton |
			aButton phlow fireCurrentToolUpdateWish ]
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> gtActionsGsSessionFor: anAction [
	<gtAction>
	<gtToolAction>
	
	^(anAction dropdown)
		label: 'GS Session';
		withDropdownIndicator;
		priority: 20;
		items: [ :dropdownButton :aHostElement :aMenu |
			self addSessionActionsOnMenu: aMenu ].
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscript >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
			addTool: (GtGemStoneTranscriptPhlowTool new
				remoteTranscript: self) ;
			addTool: super gtDefaultInspectorTool
]

{ #category : #views }
GtGemStoneRemoteTranscript >> gtViewStatusAttributesFor: aView [
	<gtView>

	self hasTranscriptProxy ifFalse: [ ^ aView empty ].
	
	^ aView columnedList
		title: 'Status';
		priority: 15;
		items: [ self statusAttributes associations];
		column: 'Attribute' text: [ :item | item key ];
		column: 'Value' text: [ :item | item value ];
		send: [ :item | item value ];
		actionUpdateButton
]

{ #category : #views }
GtGemStoneRemoteTranscript >> gtViewTranscriptFor: aView [
	<gtView>
	<gtToolView>
	
	^ aView remoteForward
		title: 'Transcript';
		priority: 10;
		object: [ self transcriptProxy ];
		view: #gtViewContentsFor:
]

{ #category : #testing }
GtGemStoneRemoteTranscript >> hasTranscriptProxy [
	^ self transcriptProxy notNil
]

{ #category : #initialization }
GtGemStoneRemoteTranscript >> initializeForGemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession.
	self isTranscriptSupported ifTrue: [
		self initializeTranscriptProxy ]
]

{ #category : #initialization }
GtGemStoneRemoteTranscript >> initializeTranscriptProxy [
	transcriptProxy := self createRemoteTranscriptProxy
]

{ #category : #testing }
GtGemStoneRemoteTranscript >> isEnabled [
	^ transcriptProxy proxyPerform: #isEnabled autoCommit: false 
]

{ #category : #testing }
GtGemStoneRemoteTranscript >> isTranscriptSupported [
	^ self gemStoneSession isRunning  and: [
		self gemStoneSession currentFeatures hasGemStoneTranscriptV1 ]
]

{ #category : #accessing }
GtGemStoneRemoteTranscript >> statusAttributes [
	| gsAttributes |


	gsAttributes := (gemStoneSession 
		evaluateBlockAndWaitReturnPrimitive: [
			| currentAttributes |
			currentAttributes := Dictionary new.
			
			currentAttributes
				at: 'Transcript class' 
				put: GtGemStoneTranscriptHandler transcriptClassName. 
			currentAttributes
				at: 'Transcript status' 
				put: GtGemStoneTranscriptHandler currentTranscript statusDescription.
			
			currentAttributes ] 
		autoCommit: false).

	^ gsAttributes
]

{ #category : #actions }
GtGemStoneRemoteTranscript >> toggleRemoteTranscript [
	^ transcriptProxy proxyPerform: #toggleStatusWithLogging autoCommit: false 
]

{ #category : #actions }
GtGemStoneRemoteTranscript >> transcriptProxy [
	^ transcriptProxy
]
