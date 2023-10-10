Class {
	#name : #GtGemStoneCodeSyncEpEventStrategy,
	#superclass : #Object,
	#instVars : [
		'registry',
		'events',
		'subscription',
		'flusher',
		'announcer',
		'defaultClassStrategy',
		'sessionStrategy'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncClassCategoryChange: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' category: ';
			print: anEpChange newCategory ].
	session evaluateAndWait:  cmd.
	GtGemStoneClassCategoryChangeCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncClassChange: anEpChange session: session [

	session evaluateAndWait: anEpChange behaviorAffected gemstoneDefinitionScript.
	GtGemStoneClassDefinitionCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncClassCommentChange: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' comment: ';
			print: anEpChange newComment ].
	session evaluateAndWait:  cmd.
	GtGemStoneClassCommentCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncClassNameChange: anEpChange session: session [
	"Not yet working: this will fail if attempted"
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< 'self error: ''GtGemStoneCodeSync rename not yet implemented' ].
	session evaluateAndWait:  cmd.
	GtGemStoneClassRenameCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncClassRemoval: anEpChange session: session [

	session evaluateAndWait: 'Globals removeKey: #', anEpChange behaviorAffectedName.
	GtGemStoneClassDefinitionCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncIgnore: anEpChange session: session [

	GtGemStoneIgnoredCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncMethodChange: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' compileMethod: ';
			print: anEpChange methodAffected sourceCode; cr;
			<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
			<< 'category: #'''; << anEpChange protocol; << ''''; cr;
			<< 'environmentId: 0' ].
	session evaluateAndWait: cmd.
	GtGemStoneMethodCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncMethodRemoval: anEpChange session: session [
	| cmd |

	cmd := String streamContents: [ :stream |
		stream
			<< anEpChange behaviorAffectedName;
			<< ' removeSelector: ';
			print: anEpChange selector; cr ].
	session evaluateAndWait: cmd.
	GtGemStoneMethodCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]
