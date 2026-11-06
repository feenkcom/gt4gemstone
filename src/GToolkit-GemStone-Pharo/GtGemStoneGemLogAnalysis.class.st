Class {
	#name : #GtGemStoneGemLogAnalysis,
	#superclass : #Object,
	#instVars : [
		'gemStoneSessionId',
		'loginTime',
		'logoutTime',
		'stackPrints',
		'ending'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneGemLogAnalysis class >> fromContents: aString [

	^ self new setLines: aString lines

]

{ #category : #accessing }
GtGemStoneGemLogAnalysis >> attributes [
	| attributes |

	attributes := OrderedCollection new.
	attributes addAll: ending attributes.
	gemStoneSessionId ifNotNil: [ :anId | attributes add: 'GemStone session' -> anId ].
	loginTime ifNotNil: [ :aTime | attributes add: 'Logged in' -> aTime ].
	stackPrints do: [ :each | attributes add: 'Stack printed' -> each description ].
	logoutTime ifNotNil: [ :aTime | attributes add: 'Logged out' -> aTime ].
	^ attributes

]

{ #category : #accessing }
GtGemStoneGemLogAnalysis >> ending [

	^ ending

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> endingIn: aCollection [
	| fatalIndex |

	fatalIndex := aCollection findFirst: [ :each |
		(each beginsWith: 'GemStone: Error') and: [ each endsWith: 'Fatal' ] ].
	^ fatalIndex > 0
		ifTrue: [ self fatalErrorEndingAt: fatalIndex in: aCollection ]
		ifFalse: [ logoutTime
			ifNil: [ GtGemStoneGemLogNoEnding new ]
			ifNotNil: [ GtGemStoneGemLogLogout new ] ]

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> errorNumberIn: aString [
	| tokens |

	tokens := aString substrings: ' '.
	^ (tokens includes: 'Number:')
		ifTrue: [ tokens at: (tokens indexOf: 'Number:') + 1 ifAbsent: [ '' ] ]
		ifFalse: [ '' ]

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> fatalErrorEndingAt: anIndex in: aCollection [
	| categoryIndex |

	categoryIndex := (anIndex + 1 to: aCollection size)
		detect: [ :each | (aCollection at: each) beginsWith: 'Error Category:' ]
		ifNone: [ aCollection size + 1 ].
	^ GtGemStoneAbstractGemLogFatalErrorEnding
		errorNumber: (self errorNumberIn: (aCollection at: categoryIndex ifAbsent: [ '' ]))
		text: (' ' join: (aCollection copyFrom: anIndex + 1 to: categoryIndex - 1))

]

{ #category : #accessing }
GtGemStoneGemLogAnalysis >> gemStoneSessionId [

	^ gemStoneSessionId

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> gemStoneSessionIdIn: aCollection [
	| prefix |

	prefix := '[Info]: Session ID: '.
	^ (aCollection
		detect: [ :each | each beginsWith: prefix ]
		ifNone: [ nil ])
			ifNotNil: [ :aLine | ((aLine allButFirst: prefix size) substrings: ' ') first ]

]

{ #category : #ui }
GtGemStoneGemLogAnalysis >> gtAttributesFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Analysis';
		priority: 10;
		items: [ self attributes ];
		column: 'Attribute' text: #key;
		column: 'Value' text: #value;
		send: #value

]

{ #category : #testing }
GtGemStoneGemLogAnalysis >> isTerminatedByGemStone [

	^ ending isTerminatedByGemStone

]

{ #category : #accessing }
GtGemStoneGemLogAnalysis >> loginTime [

	^ loginTime

]

{ #category : #accessing }
GtGemStoneGemLogAnalysis >> logoutTime [

	^ logoutTime

]

{ #category : #printing }
GtGemStoneGemLogAnalysis >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: ending description ]

]

{ #category : #initialization }
GtGemStoneGemLogAnalysis >> setLines: aCollection [

	gemStoneSessionId := self gemStoneSessionIdIn: aCollection.
	loginTime := self timeInLineEndingWith: ' Login' in: aCollection.
	logoutTime := self timeInLineEndingWith: ' Logging out' in: aCollection.
	stackPrints := self stackPrintsIn: aCollection.
	ending := self endingIn: aCollection

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> signalLineAfter: anIndex in: aCollection [

	^ (aCollection copyFrom: anIndex + 1 to: (anIndex + 5 min: aCollection size))
		detect: [ :each | each beginsWith: 'Signal ' ]
		ifNone: [ '' ]

]

{ #category : #accessing }
GtGemStoneGemLogAnalysis >> stackPrints [

	^ stackPrints

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> stackPrintsIn: aCollection [
	| prints |

	prints := OrderedCollection new.
	aCollection withIndexDo: [ :eachLine :anIndex |
		(eachLine beginsWith: 'Begin attempt to print C-level stack') ifTrue: [
			prints add: (GtGemStoneGemLogStackPrint
				line: eachLine
				signalLine: (self signalLineAfter: anIndex in: aCollection)) ] ].
	^ prints

]

{ #category : #private }
GtGemStoneGemLogAnalysis >> timeInLineEndingWith: aSuffix in: aCollection [

	^ (aCollection
		detect: [ :each | (each beginsWith: '--- ') and: [ each endsWith: aSuffix ] ]
		ifNone: [ nil ])
			ifNotNil: [ :aLine | (aLine allButFirst: 4) allButLast: aSuffix size ]

]
