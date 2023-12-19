"
GtGemStoneDebuggerInitialState holds the information required to open the GS debugger in GT:

- display information for the call stack
- exception displayString
"
Class {
	#name : #GtGemStoneDebuggerState,
	#superclass : #Object,
	#instVars : [
		'callStack',
		'summary',
		'isResumable',
		'isSuspended',
		'isTerminated',
		'messageText',
		'remoteMetadata'
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

{ #category : #converting }
GtGemStoneDebuggerState >> asDictionaryForExport [

	^ Dictionary new
		at: #messageText put: messageText;
		at: #isSuspended put: isSuspended;
		at: #isResumable put: isResumable;
		at: #isTerminated put: isTerminated;
		at: #summary put: summary;
		at: #callStack put: callStack asDictionaryForExport;
		addAll: self asMetadataAttributesForExport;
		yourself
]

{ #category : #converting }
GtGemStoneDebuggerState >> asJsonForExport [ 
	"Answer the receiver serialised in JSON format"

	^STON toJsonString: self asDictionaryForExport
]

{ #category : #converting }
GtGemStoneDebuggerState >> asMetadataAttributesForExport [
	^ {'__meta' -> self localMetadata asDictionaryForExport}
]

{ #category : #accessing }
GtGemStoneDebuggerState >> callStack [

	^ callStack
]

{ #category : #'gt - extensions' }
GtGemStoneDebuggerState >> gtViewCallFrameSpecificationsFor: aView [ 
	<gtView>
	
	^ aView forward 
		title: 'Frame specifications';
		object: [ self callStack ];
		view: #gtViewCallFrameSpecificationsFor: 
]

{ #category : #converting }
GtGemStoneDebuggerState >> initializeFromJSONDictionary: aDictionary [
	
	messageText := aDictionary at: 'messageText'.
	isResumable := aDictionary at: 'isResumable'.
	isSuspended := aDictionary at: 'isSuspended'.
	isTerminated := aDictionary at: 'isTerminated'.
	summary := aDictionary at: 'summary'.
	
	callStack := GtGemStoneProcessSpecification 
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
	remoteMetadata := aDictionary 
		at: '__metadata' 
		ifPresent: [ :metadataDictionary |
			GtGemStoneSpecificationMedatada fromJSONDictionary: metadataDictionary ]
		ifAbsent: [ GtGemStoneSpecificationMedatada new
			apiVersion: 0;
			schemaVersion: 0 ].
]

{ #category : #initialize }
GtGemStoneDebuggerState >> initializeProcess2: aGsProcess exception: anException [

	messageText := anException messageText.
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', anException messageText ]
		ifFalse: [ anException messageText ].

	callStack := aGsProcess gtAllFrames collect: [ :frameArray |
		| homeMethod |
		homeMethod := frameArray first homeMethod.
		{ homeMethod inClass ifNotNil: [ :cls | cls name ].
		homeMethod selector.
		frameArray first isMethodForBlock. } ].
]

{ #category : #initialize }
GtGemStoneDebuggerState >> initializeProcess: aGsProcess exception: anException [

	messageText := anException messageText.
	isResumable := anException isResumable.
	isSuspended := aGsProcess _isSuspended.
	isTerminated := aGsProcess _isTerminated.
	summary := aGsProcess _isTerminated
		ifTrue: [ 'Terminated: ', anException messageText ]
		ifFalse: [ anException messageText ].

	callStack := (GtGemStoneLocalCallStack forProcess: aGsProcess) createSpecification
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
	^ 1.0
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerState >> localMetadata [
	^ GtGemStoneSpecificationMedatada new 
		apiVersion: self localApiVersion;
		schemaVersion: self localSchemaVersion
]

{ #category : #'accessing - metadata' }
GtGemStoneDebuggerState >> localSchemaVersion [
	^ 1.0
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
