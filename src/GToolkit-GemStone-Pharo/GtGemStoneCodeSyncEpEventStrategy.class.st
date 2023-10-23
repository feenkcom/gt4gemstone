Class {
	#name : #GtGemStoneCodeSyncEpEventStrategy,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> copyClass: anEpNameChange session: session [
	"Create a newclass based on anEpNameChange and copy the methods from the old class"
	| script |

	session evaluateAndWait: anEpNameChange behaviorAffected gemstoneDefinitionScript.

	script := String streamContents: [ :stream |
			stream
				<< anEpNameChange oldName;
					<< ' methodsDo: [ :selector :method | | category |'; cr;
					<< 'category := ';
						<< anEpNameChange oldName;
						<< ' categoryOfSelector: selector.'; cr;
					<< anEpNameChange newName;
					<< ' compileMethod: method sourceString'; cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
					<< 'category: category'; cr;
					<< 'environmentId: 0';
					<< ' ].';
					cr;
				<< anEpNameChange oldName;
					<< ' class methodsDo: [ :selector :method | | category |'; cr;
					<< 'category := ';
						<< anEpNameChange oldName;
						<< ' class categoryOfSelector: selector.'; cr;
					<< anEpNameChange newName;
					<< ' class compileMethod: method sourceString'; cr;
					<< 'dictionaries: GsCurrentSession currentSession symbolList'; cr;
					<< 'category: category'; cr;
					<< 'environmentId: 0';
					<< ' ].';
					cr;
				<< anEpNameChange newName;
					<< ' comment: ';
					<< anEpNameChange oldName;
					<< ' comment.' ].
	session evaluateAndWait: script.
]

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
	"The default action when renaming classes is to copy the class to the new name and leave the old definition untouched (for manual data migration later)"

	self copyClass: anEpChange session: session.
	GtGemStoneClassRenameCodeSyncSignal new
		change: anEpChange;
		session: session;
		emit
]

{ #category : #'event handling' }
GtGemStoneCodeSyncEpEventStrategy >> syncClassRemoval: anEpChange session: session [
	| script removed |

	script := String streamContents: [ :stream |
		stream
			<< '(Globals removeKey: #';
			<< anEpChange behaviorAffectedName;
			<< ' ifAbsent: []) ifNil: [ false ] ifNotNil: [ true ]' ].
	removed  := session evaluateAndWait: script .
	GtGemStoneClassRemovalCodeSyncSignal new
		change: anEpChange;
		session: session;
		removed: removed;
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
