"
Models the complete classChangeRequest accepted by the GemStone class definition change tool. Its JSON fields match the GemStone class lookup response.
"
Class {
	#name : #GtGemStoneLlmClassChangeRequest,
	#superclass : #Object,
	#instVars : [
		'name',
		'superclassName',
		'comment',
		'instVarNames',
		'classVarNames',
		'classInstVarNames',
		'poolDictionaries',
		'instanceMethodNames',
		'classMethodNames',
		'dictionary',
		'options',
		'packageName'
	],
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> classInstVarNames [
	^ classInstVarNames
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> classInstVarNames: anObject [
	classInstVarNames := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> classInstVarNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #classInstVarNames; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> classMethodNames [
	^ classMethodNames
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> classMethodNames: anObject [
	classMethodNames := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> classMethodNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #classMethodNames; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> classVarNames [
	^ classVarNames
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> classVarNames: anObject [
	classVarNames := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> classVarNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #classVarNames; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> comment [
	^ comment
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> comment: anObject [
	comment := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new accessor: #comment; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> dictionary [
	^ dictionary
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> dictionary: anObject [
	dictionary := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> dictionaryDescription [
	<magritteDescription>
	^ MAStringDescription new accessor: #dictionary; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> instVarNames [
	^ instVarNames
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> instVarNames: anObject [
	instVarNames := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> instVarNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #instVarNames; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> instanceMethodNames [
	^ instanceMethodNames
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> instanceMethodNames: anObject [
	instanceMethodNames := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> instanceMethodNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #instanceMethodNames; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> name [
	^ name
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> name: anObject [
	name := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new accessor: #name; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> options [
	^ options
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> options: anObject [
	options := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> optionsDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #options; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> packageName [
	^ packageName
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> packageName: anObject [
	packageName := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new accessor: #packageName; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> poolDictionaries [
	^ poolDictionaries
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> poolDictionaries: anObject [
	poolDictionaries := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> poolDictionariesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new accessor: #poolDictionaries; classes: { String }; beRequired
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtGemStoneLlmClassChangeRequest >> superclassName: anObject [
	superclassName := anObject
]

{ #category : #magritte }
GtGemStoneLlmClassChangeRequest >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new accessor: #superclassName; beRequired
]
