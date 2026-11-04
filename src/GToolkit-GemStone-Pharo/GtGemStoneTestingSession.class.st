"
GtGemStoneTestingSession provides enough of the same interface as {{gtClass:GtGemStoneSession}}, but doesn't actually perform any operations on GemStone.  It keeps a history of the operations for testing purposes.
"
Class {
	#name : #GtGemStoneTestingSession,
	#superclass : #GtGemStoneSession,
	#instVars : [
		'commandHistory',
		'state',
		'currentTime',
		'hasChanges',
		'busy',
		'keepAliveChecksFail'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #actions }
GtGemStoneTestingSession >> abortTransaction [

	self isRunning ifFalse: [ ^ self ].
	^ super abortTransaction

]

{ #category : #utils }
GtGemStoneTestingSession >> advanceTimeBy: aDuration [

	currentTime := currentTime + aDuration

]

{ #category : #utils }
GtGemStoneTestingSession >> attachRsrConnection: anRsrConnection [

	connection := anRsrConnection.
	self subscribeToConnection

]

{ #category : #actions }
GtGemStoneTestingSession >> basicAbortTransaction [

	hasChanges := false.
	self recordMessageSend.

]

{ #category : #actions }
GtGemStoneTestingSession >> basicCommitTransaction [

	hasChanges := false.
	self recordMessageSend.
	^ true

]

{ #category : #utils }
GtGemStoneTestingSession >> beBusy [

	busy := true

]

{ #category : #utils }
GtGemStoneTestingSession >> beIdle [

	busy := false

]

{ #category : #actions }
GtGemStoneTestingSession >> closeBecause: aDisconnectionReason [

	self unsubscribeFromConnection.
	self recordDisconnectionReason: aDisconnectionReason.
	self markAsDisconnected.
	hasChanges := false.
	(registry notNil and: [ self isBookmarked not ]) ifTrue: [
		registry removeSession: self ].

	self announceDisconnection.


]

{ #category : #'test - accessing' }
GtGemStoneTestingSession >> commandHistory [

	^ commandHistory
]

{ #category : #accessing }
GtGemStoneTestingSession >> connect [
	self isRunning ifTrue: [ ^ self ].
	self resetSessionData.
	transactionMode := #autoBegin.
	connectionTime := self currentTime.
	self startConnectionRecord.
	state := #connected.
	self runPostConnectActions.

	registry ifNotNil: [ registry addSession: self ].
	self announce: (GtGemStoneSessionConnectedAnnouncement session: self)
]

{ #category : #accessing }
GtGemStoneTestingSession >> currentTime [

	^ currentTime

]

{ #category : #accessing }
GtGemStoneTestingSession >> dbSize [

	^ 0

]

{ #category : #actions }
GtGemStoneTestingSession >> evaluate: remoteScript [

	self recordMessageSend.
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluate: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluate: remoteScript for: anObject inFrame: aFrameIdentifier bindings: remoteBindings serializationStrategy: aSymbol [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluate: remoteScript serializationStrategy: aSymbol [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndCollect: aString [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndWait: remoteScript [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings serializationStrategy: aSymbol [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndWait: remoteScript serializationStrategy: aSymbol [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndWaitReturnProxy: remoteScript [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAndWaitReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateAsRemoteStream: aString [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateBlockAndWait: aBlock [

	^ self recordMessageSend

]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateBlockAndWait: aBlock autoCommit: aBoolean [

	^ self recordMessageSend

]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateReturnProxy: remoteScript [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ self recordMessageSend
]

{ #category : #utils }
GtGemStoneTestingSession >> failKeepAliveChecks [

	keepAliveChecksFail := true

]

{ #category : #accessing }
GtGemStoneTestingSession >> gt4gemstoneVersion [

	^ GtGemStoneSemanticVersionNumber zero
]

{ #category : #initialize }
GtGemStoneTestingSession >> initialize [

	super initialize.
	commandHistory := OrderedCollection new.
	state := #disconnected.
	currentTime := DateAndTime now.
	hasChanges := false.
	busy := false.
	keepAliveChecksFail := false.
	transactionMode := #autoBegin.
	"The connector only needs to answer whether code sync is allowed"
	connector := GtGemStoneConnector new.
	"We want all changes propagated to the test session"
	self codeSync eventStrategy: GtGemStoneCodeSyncEpEventStrategy new.


]

{ #category : #accessing }
GtGemStoneTestingSession >> isBusy [

	^ busy

]

{ #category : #accessing }
GtGemStoneTestingSession >> isRunning [

	^ state = #connected
]

{ #category : #'test - accessing' }
GtGemStoneTestingSession >> keepAliveAbortCount [

	^ (commandHistory select: [ :each |
			each value selector = #needsCommitAbortingIfClean ]) size

]

{ #category : #accessing }
GtGemStoneTestingSession >> loseConnection [

	self markAsDisconnected.
	hasChanges := false.
	self recordConnectionLostOf: connectionRecord

]

{ #category : #utils }
GtGemStoneTestingSession >> markAsDisconnected [
	state := #disconnected.
]

{ #category : #utils }
GtGemStoneTestingSession >> modifyObjects [

	hasChanges := true

]

{ #category : #accessing }
GtGemStoneTestingSession >> name [
	^ connector 
		ifNil: [
	 	(self isDefaultSession 
	 		ifTrue: [ 'default:' ] 
	 		ifFalse: [ 'session:' ]),
				sessionId ]
		ifNotNil: [
			super name ]
]

{ #category : #accessing }
GtGemStoneTestingSession >> needsCommit [

	^ self isRunning and: [ hasChanges ]

]

{ #category : #actions }
GtGemStoneTestingSession >> needsCommitAbortingIfClean [

	keepAliveChecksFail ifTrue: [
		self error: 'Simulated failure of a keep alive check' ].
	hasChanges ifFalse: [ self recordMessageSend ].
	^ hasChanges


]

{ #category : #private }
GtGemStoneTestingSession >> recordCommand: anObject [ 

	commandHistory add: DateAndTime now -> anObject
]

{ #category : #accessing }
GtGemStoneTestingSession >> recordMessageSend [
	| message |

	message := thisContext sender message.
	self recordCommand: message.
]

{ #category : #ui }
GtGemStoneTestingSession >> remoteStatusAttributes [

	^ OrderedCollection new
		add: 'Simulated gem' -> true;
		add: 'Connection time' -> connectionTime;
		add: 'Current time' -> currentTime;
		add: 'Busy' -> busy;
		add: 'Transaction mode' -> transactionMode;
		add: 'Uncommitted changes' -> hasChanges;
		yourself
]

{ #category : #'test - accessing' }
GtGemStoneTestingSession >> state [

	^ state
]

{ #category : #accessing }
GtGemStoneTestingSession >> transactionMode [

	^ transactionMode

]

{ #category : #accessing }
GtGemStoneTestingSession >> transactionMode: aSymbol [

	transactionMode := aSymbol

]
