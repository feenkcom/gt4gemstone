"
GtGemStoneTestingSession provides enough of the same interface as {{gtClass:GtGemStoneSession}}, but doesn't actually perform any operations on GemStone.  It keeps a history of the operations for testing purposes.
"
Class {
	#name : #GtGemStoneTestingSession,
	#superclass : #GtGemStoneSession,
	#instVars : [
		'commandHistory',
		'state'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #actions }
GtGemStoneTestingSession >> abortTransaction [

	^ self
]

{ #category : #actions }
GtGemStoneTestingSession >> close [

	state := #disconnected.
	self announce: (GtGemStoneSessionDisconnectedAnnouncement session: self).
]

{ #category : #'test - accessing' }
GtGemStoneTestingSession >> commandHistory [

	^ commandHistory
]

{ #category : #accessing }
GtGemStoneTestingSession >> connect [

	state := #connected.
	connectionTime := DateAndTime now.
	self runPostConnectActions.
	self announce: (GtGemStoneSessionConnectedAnnouncement session: self).
]

{ #category : #accessing }
GtGemStoneTestingSession >> dbSize [

	super dbSize.
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
GtGemStoneTestingSession >> evaluateReturnProxy: remoteScript [

	^ self recordMessageSend
]

{ #category : #actions }
GtGemStoneTestingSession >> evaluateReturnProxy: remoteScript for: anObject bindings: remoteBindings [

	^ self recordMessageSend
]

{ #category : #accessing }
GtGemStoneTestingSession >> gt4gemstoneVersion [

	super gt4gemstoneVersion.
	^ '3.7.1'
]

{ #category : #initialize }
GtGemStoneTestingSession >> initialize [

	super initialize.
	commandHistory := OrderedCollection new.
	state := #disconnected.
	"The connector only needs to answer whether code sync is allowed"
	connector := GtGemStoneConnector new.
	"We want all changes propagated to the test session"
	self codeSync eventStrategy: GtGemStoneCodeSyncEpEventStrategy new.
]

{ #category : #accessing }
GtGemStoneTestingSession >> isRunning [

	^ state = #connected
]

{ #category : #accessing }
GtGemStoneTestingSession >> name [

	^ (self isDefaultSession ifTrue: [ 'default:' ] ifFalse: [ 'session:' ]),
		sessionId
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

{ #category : #'test - accessing' }
GtGemStoneTestingSession >> state [

	^ state
]
