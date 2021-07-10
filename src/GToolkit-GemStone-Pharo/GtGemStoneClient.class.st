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
	#category : 'GToolkit-GemStone-Pharo'
}

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
GtGemStoneClient >> evaluate: aScript [

	^ mutex critical:
		[ evaluator evaluate: aScript for: nil ]
]

{ #category : 'actions' }
GtGemStoneClient >> evaluate: aScript for: anObject [

	^ mutex critical:
		[ evaluator evaluate: aScript for: anObject ]
]

{ #category : 'actions' }
GtGemStoneClient >> evaluateAndWait: aScript [

	^ (mutex critical:
		[ evaluator evaluate: aScript for: nil ]) wait
]

{ #category : 'actions' }
GtGemStoneClient >> evaluateAndWait: aScript for: anObject [

	^ (mutex critical:
		[ evaluator evaluate: aScript for: anObject ]) wait
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

{ #category : 'accessing' }
GtGemStoneClient >> port [

	^ port
]

{ #category : 'accessing' }
GtGemStoneClient >> port: anObject [

	port := anObject
]
