"
Holds a GemStone class description returned by the GemStone class lookup tool.
"
Class {
	#name : #GtLGemStoneClassDescription,
	#superclass : #GtLClassDescription,
	#instVars : [
		'classVariableNames',
		'poolDictionaryNames',
		'options',
		'inDictionary'
	],
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #'instance creation' }
GtLGemStoneClassDescription class >> fromDictionary: aDictionary [
	^ self new
		currentClassName: (aDictionary at: 'name');
		superclassName: (aDictionary at: 'superclassName');
		comment: (aDictionary at: 'comment');
		packageName: (aDictionary at: 'packageName');
		packageTagName: nil;
		instanceSlotNames: (aDictionary at: 'instVarNames');
		classSlotNames: (aDictionary at: 'classInstVarNames');
		allInstanceMethodNames: (aDictionary at: 'instanceMethodNames');
		allClassMethodNames: (aDictionary at: 'classMethodNames');
		classVariableNames: (aDictionary at: 'classVarNames');
		poolDictionaryNames: (aDictionary at: 'poolDictionaries');
		options: (aDictionary at: 'options');
		inDictionary: (aDictionary at: 'dictionary');
		yourself
]

{ #category : #accessing }
GtLGemStoneClassDescription >> classVariableNames [
	^ classVariableNames
]

{ #category : #accessing }
GtLGemStoneClassDescription >> classVariableNames: aCollection [
	classVariableNames := aCollection
]

{ #category : #magritte }
GtLGemStoneClassDescription >> classVariableNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class variables';
		accessor: #classVariableNames;
		classes: { String };
		beRequired;
		yourself
]

{ #category : #accessing }
GtLGemStoneClassDescription >> inDictionary [
	^ inDictionary
]

{ #category : #accessing }
GtLGemStoneClassDescription >> inDictionary: anObject [
	inDictionary := anObject
]

{ #category : #accessing }
GtLGemStoneClassDescription >> options [
	^ options
]

{ #category : #accessing }
GtLGemStoneClassDescription >> options: aCollection [
	options := aCollection
]

{ #category : #magritte }
GtLGemStoneClassDescription >> optionsDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Options';
		accessor: #options;
		classes: { String };
		beRequired;
		yourself
]

{ #category : #accessing }
GtLGemStoneClassDescription >> poolDictionaryNames [
	^ poolDictionaryNames
]

{ #category : #accessing }
GtLGemStoneClassDescription >> poolDictionaryNames: aCollection [
	poolDictionaryNames := aCollection
]

{ #category : #magritte }
GtLGemStoneClassDescription >> poolDictionaryNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Pool dictionaries';
		accessor: #poolDictionaryNames;
		classes: { String };
		beRequired;
		yourself
]
