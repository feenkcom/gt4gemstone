"
Magritte-based tool for looking up class descriptions in a GemStone database.
"
Class {
	#name : #GtGemStoneLlmToolForClassLookup,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #magritte }
GtGemStoneLlmToolForClassLookup >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForClassLookup >> description [
	^ 'Get the details of a class from a GemStone database as JSON.

Arguments:
- className: string

Example JSON arguments:
{
  "className": "Collection"
}

Example JSON response:
{
  "name": "Collection",
  "superclassName": "SequenceableCollection",
  "comment": "a comment",
  "instVarNames": ["array"],
  "classVarNames": [],
  "classInstVarNames": ["classInstVar1"],
  "poolDictionaries": [],
  "instanceMethodNames": ["at:", "size"],
  "classMethodNames": ["withAll:"],
  "dictionary": "Globals",
  "options": [],
  "packageName": "Collections-Sequenceable"
}'
]

{ #category : #accessing }
GtGemStoneLlmToolForClassLookup >> name [
	^ 'gemstoneLookupClass'
]

{ #category : #private }
GtGemStoneLlmToolForClassLookup >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| className details |
	className := aToolCall arguments at: 'className'.
	self session ifNil: [ self error: 'No default GemStone session has been set' ].

	details := self session
		evaluateBlockAndWait: [ :aClassName |
			| cls resolution |
			cls := GsSession currentSession objectNamed: aClassName asSymbol.
			(cls notNil and: [ cls isBehavior ])
				ifFalse: [ nil ]
				ifTrue: [
					resolution := System myUserProfile symbolResolutionOf: cls name.
					{
						'name' -> cls name.
						'superclassName' -> (cls superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
						'comment' -> cls comment.
						'instVarNames' -> cls instVarNames.
						'classVarNames' -> cls classVarNames.
						'classInstVarNames' -> cls class instVarNames.
						'poolDictionaries' -> (cls sharedPools collect: [ :each | each name ]).
						'instanceMethodNames' -> cls selectors.
						'classMethodNames' -> cls class selectors.
						'dictionary' -> resolution subStrings second.
						"Options is a placeholder for now"
						'options' -> #().
						'packageName' -> cls category.
					} asDictionary ] ]
		withArguments: { className }
		serializationStrategy: GtRsrWireSerializationStrategy.

	details ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
	^ GtLGemStoneClassDescription fromDictionary: details
]
