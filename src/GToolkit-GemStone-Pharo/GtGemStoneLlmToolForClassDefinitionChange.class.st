"
Changes the definition of an existing class in a GemStone database from a complete GemStone class description.
"
Class {
	#name : #GtGemStoneLlmToolForClassDefinitionChange,
	#superclass : #GtGemStoneLlmTool,
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #magritte }
GtGemStoneLlmToolForClassDefinitionChange >> classChangeRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #classChangeRequest;
		classes: { GtGemStoneLlmClassChangeRequest };
		beRequired
]

{ #category : #accessing }
GtGemStoneLlmToolForClassDefinitionChange >> description [
	^ 'Changes the definition of an existing class in a GemStone database. The classChangeRequest must be a complete class description in the same format returned by gemstoneLookupClass. GemStone creates a new class version when structural changes require it.

Arguments:
- classChangeRequest: object with name, superclassName, comment, instVarNames, classVarNames, classInstVarNames, poolDictionaries, instanceMethodNames, classMethodNames, dictionary, options, and packageName

Example JSON arguments:
{
  "classChangeRequest": {
    "name": "MyClass",
    "superclassName": "Object",
    "comment": "A changed class",
    "instVarNames": ["value"],
    "classVarNames": ["DefaultValue"],
    "classInstVarNames": ["registry"],
    "poolDictionaries": [],
    "instanceMethodNames": [],
    "classMethodNames": [],
    "dictionary": "UserGlobals",
    "options": [],
    "packageName": "My-Classes"
  }
}

Example JSON response:
{
  "name": "MyClass",
  "superclassName": "Object",
  "comment": "A changed class",
  "instVarNames": ["value"],
  "classVarNames": ["DefaultValue"],
  "classInstVarNames": ["registry"],
  "poolDictionaries": [],
  "instanceMethodNames": [],
  "classMethodNames": [],
  "dictionary": "UserGlobals",
  "options": [],
  "packageName": "My-Classes"
}'
]

{ #category : #accessing }
GtGemStoneLlmToolForClassDefinitionChange >> name [
	^ 'gemstoneChangeClassSignature'
]

{ #category : #private }
GtGemStoneLlmToolForClassDefinitionChange >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request details |
	request := aToolCall arguments at: 'classChangeRequest'.
	self session ifNil: [ self error: 'No default GemStone session has been set' ].

	details := self session
		evaluateBlockAndWait: [ :className :superclassName :comment :instVarNames :classVarNames :classInstVarNames :poolDictionaryNames :dictionaryName :options :packageName |
			| oldClass superclass dictionary pools updatedClass resolution |
			oldClass := GsSession currentSession objectNamed: className asSymbol.
			superclass := GsSession currentSession objectNamed: superclassName asSymbol.
			dictionary := GsSession currentSession objectNamed: dictionaryName asSymbol.
			(oldClass isNil or: [ superclass isNil or: [ dictionary isNil ] ])
				ifTrue: [ nil ]
				ifFalse: [
					pools := poolDictionaryNames collect: [ :each | GsSession currentSession objectNamed: each asSymbol ].
					"Rowan doesn't allow the class category to be set, it seems to always be Kernel"
					(GsSession currentSession objectNamed: #Rowan) notNil ifTrue:
						[ updatedClass := superclass
							subclass: className asSymbol
							instVarNames: instVarNames
							classVars: classVarNames
							classInstVars: classInstVarNames
							poolDictionaries: pools
							inDictionary: dictionary
							options: (options collect: #asSymbol) ]
					ifFalse:
						[ updatedClass := superclass
							subclass: className asSymbol
							instVarNames: instVarNames
							classVars: classVarNames
							classInstVars: classInstVarNames
							poolDictionaries: pools
							category: packageName
							inDictionary: dictionary
							options: (options collect: #asSymbol) ].
					updatedClass comment: comment.
					resolution := System myUserProfile symbolResolutionOf: updatedClass name.
					{
						'name' -> updatedClass name.
						'superclassName' -> (updatedClass superclass ifNil: [ nil ] ifNotNil: [ :each | each name ]).
						'comment' -> updatedClass comment.
						'instVarNames' -> updatedClass instVarNames.
						'classVarNames' -> updatedClass classVarNames.
						'classInstVarNames' -> updatedClass class instVarNames.
						'poolDictionaries' -> (updatedClass sharedPools collect: [ :each | each name ]).
						'instanceMethodNames' -> updatedClass selectors.
						'classMethodNames' -> updatedClass class selectors.
						'dictionary' -> resolution subStrings second.
						'options' -> options.
						'packageName' -> updatedClass category
					} asDictionary ] ]
		withArguments: {
			request name.
			request superclassName.
			request comment.
			request instVarNames asArray.
			request classVarNames asArray.
			request classInstVarNames asArray.
			request poolDictionaries asArray.
			request dictionary.
			request options asArray.
			request packageName }
		serializationStrategy: GtRsrWireSerializationStrategy.

	details ifNil: [ ^ GtLMissingDomainObject new objectName: request name ].
	^ GtLGemStoneClassDescription fromDictionary: details
]
