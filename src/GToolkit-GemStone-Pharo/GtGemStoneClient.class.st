Class {
	#name : 'GtGemStoneClient',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'evaluator',
		'connector',
		'mutex'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : 'cleanup' }
GtGemStoneClient class >> cleanUniqueInstance [
	uniqueInstance ifNotNil: [ :anInstance | 
		self onRemoveUniqueInstance: anInstance ].
	uniqueInstance := nil.
]

{ #category : 'cleanup' }
GtGemStoneClient class >> cleanUp [
	self cleanUniqueInstance
]

{ #category : 'cleanup' }
GtGemStoneClient class >> default [
	^ self uniqueInstance
]

{ #category : 'cleanup' }
GtGemStoneClient class >> hasUniqueInstance [

	^ uniqueInstance isNotNil
]

{ #category : 'cleanup' }
GtGemStoneClient class >> instance [
	^ self uniqueInstance
]

{ #category : 'cleanup' }
GtGemStoneClient class >> onRemoveUniqueInstance: anInstance [
	"Close the instance before GC"

	uniqueInstance close.
]

{ #category : 'cleanup' }
GtGemStoneClient class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : 'accessing' }
GtGemStoneClient class >> uniqueInstance: aGtGemStoneClient [

	uniqueInstance := aGtGemStoneClient
]

{ #category : 'actions' }
GtGemStoneClient >> close [

	connection ifNil: [ ^ self ].

	connection close.
	connection := evaluator := nil.
]

{ #category : 'actions' }
GtGemStoneClient >> connect [

	connection ifNotNil: [ ^ self ].

	connection := connector connect.
	evaluator := GtRsrEvaluatorServiceClient new
		registerWith: connection;
		yourself.
]

{ #category : 'accessing' }
GtGemStoneClient >> connector [
	^ connector
]

{ #category : 'accessing' }
GtGemStoneClient >> connector: anObject [
	connector := anObject
]

{ #category : 'actions' }
GtGemStoneClient >> ensureRunning [
	self isRunning
		ifFalse: [ self connect ]
		
]

{ #category : 'actions' }
GtGemStoneClient >> evaluate: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator evaluate: remoteScript for: anObject bindings: remoteBindings
]

{ #category : 'actions' }
GtGemStoneClient >> evaluateAndWait: remoteScript [
	^ self 
		evaluateAndWait: remoteScript
		for: nil 
		bindings: Dictionary new
]

{ #category : 'actions' }
GtGemStoneClient >> evaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ evaluator evaluateAndWait: remoteScript for: anObject bindings: remoteBindings
]

{ #category : 'ui' }
GtGemStoneClient >> gtAbortActionFor: anAction [
	<gtAction>

	self isRunning ifFalse: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Abort Transaction';
		icon: BrGlamorousVectorIcons cancel;
		action: [ :button | 
			self evaluateAndWait: 'System abortTransaction'.
			button phlow spawnObject: 'Aborted transaction' ]
]

{ #category : 'ui' }
GtGemStoneClient >> gtCommitActionFor: anAction [
	<gtAction>

	self isRunning ifFalse: [ ^ anAction noAction ].
	^ anAction button 
		tooltip: 'GemStone Commit Transaction';
		icon: BrGlamorousVectorIcons accept;
		action: [ :button | 
			self evaluateAndWait: 'System commitTransaction'.
			button phlow spawnObject: 'Successfully committed transaction' ]
]

{ #category : 'initialization' }
GtGemStoneClient >> initialize [ 

	super initialize.
	mutex := Mutex new.
]

{ #category : 'testing' }
GtGemStoneClient >> isRunning [ 

	connection ifNil: [ ^ false ].
	^ connection isOpen
]
