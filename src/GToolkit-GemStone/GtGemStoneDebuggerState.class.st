"
GtGemStoneDebuggerInitialState holds the information required to open the GS debugger in GT:

- display information for the call stack
- exception displayString
"
Class {
	#name : #GtGemStoneDebuggerState,
	#superclass : #Object,
	#instVars : [
		'summary',
		'isResumable',
		'isSuspended',
		'isTerminated',
		'messageText',
		'remoteMetadata',
		'callStackSpecification'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneDebuggerState class >> fromJsonString: aString [
	^ self new 
		initializeFromJsonString: aString
]

{ #category : #'instance creation' }
GtGemStoneDebuggerState class >> process: aGsProcess exception: anException [
	"Create a new instance of the receiver populated for the supplied process and exception"

	^ self new 
		initializeProcess: aGsProcess 
		exception: anException
]

{ #category : #'instance creation' }
GtGemStoneDebuggerState class >> process: aGsProcess exception: anException callStack: aCallStack [
	"Create a new instance of the receiver populated for the supplied process and exception"

	^ self new 
		initializeProcess: aGsProcess 
		exception: anException
		callStack: aCallStack
]

{ #category : #converting }
GtGemStoneDebuggerState >> asDictionaryForExport [

	^ Dictionary new
		at: 'messageText' put: messageText;
		at: 'isSuspended' put: isSuspended;
		at: 'isResumable' put: isResumable;
		at: 'isTerminated' put: isTerminated;
		at: 'summary' put: summary;
		at: 'callStack' put: callStackSpecification asDictionaryForExport;
		addAll: self localMetadata asMetadataAttributesForExport;
		yourself
]

{ #category : #converting }
GtGemStoneDebuggerState >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #accessing }
GtGemStoneDebuggerState >> callStack [

	^ callStackSpecification
]

{ #category : #accessing }
GtGemStoneDebuggerState >> callStackSpecification [

	^ callStackSpecification
]

{ #category : #'gt - extensions' }
GtGemStoneDebuggerState >> gtViewCallFrameSpecificationsFor: aView [ 
	<gtView>
	
	^ aView forward 
		title: 'Frame specifications';
		object: [ self callStackSpecification ];
		view: #gtViewCallFrameSpecificationsFor: 
]

{ #category : #converting }
GtGemStoneDebuggerState >> initializeFromJSONDictionary: aDictionary [
	
	messageText := aDictionary at: 'messageText'.
	isResumable := aDictionary at: 'isResumable'.
	isSuspended := aDictionary at: 'isSuspended'.
	isTerminated := aDictionary at: 'isTerminated'.
	summary := aDictionary at: 'summary'.
	
	callStackSpecification := GtGemStoneProcessSpecification 
		fromJSONDictionary:  (aDictionary at: 'callStack').
		
	self initializeMetadataFromJSONDictionary: aDictionary.
]

{ #category : #converting }
GtGemStoneDebuggerState >> initializeFromJsonString: aString [
	| dictionary |

	dictionary := STON fromString: aString.
	
	self initializeFromJSONDictionary: dictionary.
]

{ #category : #converting }
GtGemStoneDebuggerState >> initializeMetadataFromJSONDictionary: aDictionary [ 
	remoteMetadata := GtGemStoneSpecificationMedatada 
		fromObjectDictionary: aDictionary
]

{ #category : #initialize }
GtGemStoneDebuggerState >> initializeProcess2: aGsProcess exception: anException [

	messageText := [ anException messageText ifNil: [ anException printString ] ]
		on: Error
		do: [ :ex | 'Error while attempting to obtain messageText' ].
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', messageText ]
		ifFalse: [ messageText ].

	callStackSpecification := aGsProcess gtAllFrames collect: [ :frameArray |
		| homeMethod |
		homeMethod := frameArray first homeMethod.
		{ homeMethod inClass ifNotNil: [ :cls | cls name ].
		homeMethod selector.
		frameArray first isMethodForBlock. } ].
]

{ #category : #initialize }
GtGemStoneDebuggerState >> initializeProcess: aGsProcess exception: anException [

	messageText := [ anException messageText ifNil: [ anException printString ] ]
		on: Error
		do: [ :ex | 'Error while attempting to obtain messageText' ].
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', messageText ]
		ifFalse: [ messageText ].

	callStackSpecification := (GtGemStoneLocalCallStack forProcess: aGsProcess) createSpecification
]

{ #category : #initialize }
GtGemStoneDebuggerState >> initializeProcess: aGsProcess exception: anException callStack: aCallStack [

	messageText := [ anException messageText ifNil: [ anException printString ] ]
		on: Error
		do: [ :ex | 'Error while attempting to obtain messageText' ].
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', messageText ]
		ifFalse: [ messageText ].

	callStackSpecification := aCallStack createSpecification
]

{ #category : #accessing }
GtGemStoneDebuggerState >> isResumable [

	^ isResumable
]

{ #category : #accessing }
GtGemStoneDebuggerState >> isSuspended [

	^ isSuspended
]

{ #category : #accessing }
GtGemStoneDebuggerState >> isTerminated [

	^ isTerminated
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerState >> localApiVersion [
	^ GtGemStoneSemanticVersionNumber oneZeroZero
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerState >> localMetadata [
	^ GtGemStoneSpecificationMedatada new 
		apiVersion: self localApiVersion;
		schemaVersion: self localSchemaVersion
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerState >> localSchemaVersion [
	^ GtGemStoneSemanticVersionNumber oneZeroZero
]

{ #category : #accessing }
GtGemStoneDebuggerState >> messageText [

	^ messageText
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerState >> remoteMetadata [
	^ remoteMetadata
]

{ #category : #accessing }
GtGemStoneDebuggerState >> summary [

	^ summary
]
