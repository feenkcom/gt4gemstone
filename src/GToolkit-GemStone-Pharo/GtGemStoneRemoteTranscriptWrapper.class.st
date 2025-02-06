Class {
	#name : #GtGemStoneRemoteTranscriptWrapper,
	#superclass : #Object,
	#instVars : [
		'gemStoneSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Transcript'
}

{ #category : #'instance creation' }
GtGemStoneRemoteTranscriptWrapper class >> forGemStoneSession: aGemStoneSession [
	^ self new
		initializeForGemStoneSession: aGemStoneSession
]

{ #category : #actions }
GtGemStoneRemoteTranscriptWrapper >> clearRemoteTranscript [
	^ self gemStoneSession
		evaluateBlockAndWaitReturnPrimitive: [
			GtGemStoneTranscript current clearContent. nil ]
		autoCommit: false
]

{ #category : #accessing }
GtGemStoneRemoteTranscriptWrapper >> gemStoneSession [
	^ gemStoneSession
]

{ #category : #'gt - extensions' }
GtGemStoneRemoteTranscriptWrapper >> gtActionInspectProxyFor: anAction [
	<gtAction>
	
	^ anAction button
		priority: 10;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Proxy';
		tooltip: 'Inspect transcript proxy';
		action: [ :aButton |
			aButton phlow 
				spawnObject: self remoteTranscriptProxy ];
		primaryModifierAction: [ :aButton |
				aButton phlow 
					showObject: self remoteTranscriptProxy ]
			mouseCursor: BlCopyCursor new
]

{ #category : #views }
GtGemStoneRemoteTranscriptWrapper >> gtViewTranscriptFor: aView [
	<gtView>

	self gemStoneSession currentFeatures hasGemStoneTranscriptV1 
		ifFalse: [ ^ aView empty ].
	self gemStoneSession isRunning ifFalse: [ ^ aView empty ].
	
	^ aView remoteForward
		title: 'Transcript';
		priority: 10;
		object: [ self remoteTranscriptProxy ];
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
			 	self gemStoneSession clearRemoteTranscript.
			 	aTab viewContentElement phlow update ]
]

{ #category : #initialization }
GtGemStoneRemoteTranscriptWrapper >> initializeForGemStoneSession: aGemStoneSession [
	gemStoneSession := aGemStoneSession
]

{ #category : #actions }
GtGemStoneRemoteTranscriptWrapper >> remoteTranscriptProxy [
	^ self gemStoneSession
		evaluateBlockAndWaitReturnProxy: [
			GtGemStoneTranscript current ]
		autoCommit: false
]

{ #category : #actions }
GtGemStoneRemoteTranscriptWrapper >> toggleRemoteTranscript [
	^ self gemStoneSession
		evaluateBlockAndWaitReturnPrimitive: [
			GtGemStoneTranscript current toggleStatusWithLogging ]
		autoCommit: false
]
