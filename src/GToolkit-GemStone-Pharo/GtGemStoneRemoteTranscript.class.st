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
GtGemStoneRemoteTranscript >> gtActionInspectProxyFor: anAction [
	<gtAction>
	
	^ anAction button
		priority: 10;
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

	self hasTranscriptProxy ifFalse: [ ^ aView empty ].
	
	^ aView remoteForward
		title: 'Transcript';
		priority: 10;
		object: [ self transcriptProxy ];
		view: #gtViewContentsFor:;
		actionUpdateButton;
		actionButtonLabel: 'Toggle' 
			tooltip: 'Toggle the enable/disable status of the remote transcript'
			action: [ :aButton :aTab |
				self toggleRemoteTranscript.
				aTab viewContentElement phlow update ];
		actionButtonIcon: BrGlamorousVectorIcons bin 
			 tooltip: 'Clear the transcript content'
			 action: [:aButton :aTab |
			 	self clearRemoteTranscript.
			 	aTab viewContentElement phlow update ]
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
