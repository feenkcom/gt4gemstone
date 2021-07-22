Class {
	#name : 'GtGemStoneClient',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'evaluator',
		'host',
		'port',
		'mutex'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'GToolkit-GemStone-Pharo'
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
	"Classes may perform some activities on a singleton that is about to be released"
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

	connection := (RsrInitiateConnection host: host port: port) connect.
	evaluator := GtRsrEvaluatorServiceClient new
		registerWith: connection;
		yourself.
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

{ #category : 'accessing' }
GtGemStoneClient >> host [

	^ host
]

{ #category : 'accessing' }
GtGemStoneClient >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
GtGemStoneClient >> initialize [ 

	super initialize.
	host := 'localhost'.
	port := 29299.
	mutex := Mutex new.
]

{ #category : 'testing' }
GtGemStoneClient >> isRunning [ 

	connection ifNil: [ ^ false ].
	^ connection isOpen
]

{ #category : 'accessing' }
GtGemStoneClient >> port [

	^ port
]

{ #category : 'accessing' }
GtGemStoneClient >> port: anObject [

	port := anObject
]
