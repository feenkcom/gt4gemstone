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
GtGemStoneRemoteTranscript >> gtViewTranscriptFor: aView [
	<gtView>

	self transcriptProxy ifNil: [ ^ aView empty ].
	
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
		actionButtonIcon: BrGlamorousIcons trash 
			 tooltip: 'Clear the transcript content'
			 action: [:aButton :aTab |
			 	self clearRemoteTranscript.
			 	aTab viewContentElement phlow update ]
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
GtGemStoneRemoteTranscript >> isTranscriptSupported [
	^ self gemStoneSession isRunning  and: [
		self gemStoneSession currentFeatures hasGemStoneTranscriptV1 ]
]

{ #category : #actions }
GtGemStoneRemoteTranscript >> toggleRemoteTranscript [
	^ transcriptProxy proxyPerform: #toggleStatusWithLogging autoCommit: false 
]

{ #category : #actions }
GtGemStoneRemoteTranscript >> transcriptProxy [
	^ transcriptProxy
]
