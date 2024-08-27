Class {
	#name : #GtGemStoneClassDefinitionTool,
	#superclass : #Object,
	#instVars : [
		'session',
		'targetClassName',
		'gsProxy',
		'gsDefinitionString',
		'gtDefinitionString',
		'retrievedGsProxy'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneClassDefinitionTool class >> targetClassName: aSymbol [

	^ self new targetClassName: aSymbol
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool class >> targetClassName: aSymbol session: aGtGemStoneSession [

	^ self new 
		targetClassName: aSymbol;
		session: aGtGemStoneSession
]

{ #category : #testing }
GtGemStoneClassDefinitionTool >> bothExistAndDefinitionsDiffer [
	"Answer a boolean indicating whether the classes exists in both locations and definitions differ between Gt and Gs.
	Currently this means that the class exists and the GS definition strings are different."

	^ self gsClassExists and: [ self gtClassExists and:
		[ self gtDefinitionString ~= self gtDefinitionStringFromGs ] ]
]

{ #category : #'private - actions' }
GtGemStoneClassDefinitionTool >> compileGs: code [
	| result |

	result := self session evaluateAndWait: code.
	retrievedGsProxy := false.
	gsProxy := nil.
	^ result
]

{ #category : #'private - actions' }
GtGemStoneClassDefinitionTool >> compileGt: definitionCode [
	| evaluationCode |

	evaluationCode := String streamContents: [ :stream |
		stream
			<< definitionCode;
			nextPut: $.;
			cr; cr;
			<< targetClassName ].
	^ self class compiler evaluate: evaluationCode.
]

{ #category : #testing }
GtGemStoneClassDefinitionTool >> definitionsDiffer [
	"Answer a boolean indicating whether the class definitions differ between Gt and Gs.
	Currently this means that the GS definition strings are different."

	^ self gtDefinitionString ~= self gtDefinitionStringFromGs
]

{ #category : #'private - accessing' }
GtGemStoneClassDefinitionTool >> getGsClassProxy [
	| script |

	script := String streamContents: [ :stream |
		stream
			<< 'Globals at: #';
			<< targetClassName;
			<< ' ifAbsent: [ | classCollection | ';
			<< 'classCollection := Object allSubclasses select: [ :each | each name = #';
			<< targetClassName;
			<< ' ]. ';
			<< 'classCollection isEmpty ifTrue: [ nil ] ifFalse: [ classCollection at: 1 ] ].' ].
	^ self session evaluateAndWait: script.
]

{ #category : #testing }
GtGemStoneClassDefinitionTool >> gsClassExists [
	"Answer a boolean indicating whether the class exists in GemStone"

	^ retrievedGsProxy
		ifTrue: [ gsProxy isNotNil ]
		ifFalse: [ self gsProxy isNotNil ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> gsDefinitionString [

	^ self gsProxy 
		ifNil: [ '<none>' ]
		ifNotNil: [ :proxy | proxy definitionString ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> gsDefinitionStringFromGt [
	"Answer the GS class definition string based on the current GT definition.
	Use the existing GS definition (if it is available) to determine the globals dictionary and options."

	^ self gtClass gemstoneDefinitionStringBasedOn: self gsProxy
]

{ #category : #testing }
GtGemStoneClassDefinitionTool >> gsExistsAndDefinitionsDiffer [
	"Answer a boolean indicating whether the classes exists in both locations and definitions differ between Gt and Gs.
	Currently this means that the class exists and the GS definition strings are different."

	^ self gsClassExists and:
		[ self gtDefinitionString ~= self gtDefinitionStringFromGs ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> gsProxy [

	^ gsProxy ifNil: [ retrievedGsProxy ifTrue:
		[ nil ]
	ifFalse:
		[ retrievedGsProxy := true.
		gsProxy := self getGsClassProxy ] ].
]

{ #category : #ui }
GtGemStoneClassDefinitionTool >> gtActionBrowseFor: anAction [
	<gtAction>

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons browse;
		label: 'GS';
		tooltip: 'Inspect GemStone Class';
		action: [ :button |
			button phlow spawnObject: (self session evaluateAndWait: targetClassName) ].
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> gtClass [

	^ self class environment classOrTraitNamed: targetClassName
]

{ #category : #testing }
GtGemStoneClassDefinitionTool >> gtClassExists [
	"Answer a boolean indicating whether the class exists in this image"

	^ (self class environment classOrTraitNamed: targetClassName) isNotNil
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> gtDefinitionString [

	^ String streamContents: [ :stream |
		stream
			<< (self class environment classOrTraitNamed: targetClassName) definitionString;
			nextPut: $.;
			cr; cr;
			<< (self class environment classOrTraitNamed: targetClassName, ' class') definitionString ].
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> gtDefinitionStringFromGs [
	"Answer the GT class definition string based on the current GS definition.
	Use the existing GT definition (if it is available) to determine the package name."

	^ self gsProxy 
		ifNil: [ '<none>' ]
		ifNotNil: [ :proxy | proxy pharoEquivalentDefinitionString ]
]

{ #category : #testing }
GtGemStoneClassDefinitionTool >> gtExistsAndDefinitionsDiffer [
	"Answer a boolean indicating whether the classes exists in both locations and definitions differ between Gt and Gs.
	Currently this means that the class exists and the GS definition strings are different."

	^ self gtClassExists and:
		[ self gtDefinitionString ~= self gtDefinitionStringFromGs ]
]

{ #category : #ui }
GtGemStoneClassDefinitionTool >> gtGtMigratedDefinitionFor: aView [
	<gtView>

	gtDefinitionString ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'GS -> GT Definition';
		priority: 5;
		text: [ gtDefinitionString ];
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: BrRBTextStyler new;
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Compile' 
			action: [ :aButton :aTab :aButtonModel | 
				self compileGtDefinitionFromTab: aTab.
				aTab viewContentElement phlow update ]
]

{ #category : #ui }
GtGemStoneClassDefinitionTool >> gtLiveFor: aView [
	<gtView>

	^ aView explicit
		title: 'Editor';
		priority: 5;
		stencil: [ GtGemStoneClassDefinitionWidget new 
			classDefinitionTool: self ]
]

{ #category : #initialize }
GtGemStoneClassDefinitionTool >> initialize [

	super initialize.
	retrievedGsProxy := false.
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> session [
	^ session ifNil: [ 
		session := GtGemStoneSessionRegistry default defaultSession ifNil:
			[ self error: 'No default session in GtGemStoneSessionRegistry default' ] ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> session: anObject [
	session := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtGemStoneClassDefinitionTool >> targetClassName: aSymbol [

	self assert: (aSymbol includes: Character space) not
		description: 'Class must not be meta: ', aSymbol.
	targetClassName := aSymbol
]
