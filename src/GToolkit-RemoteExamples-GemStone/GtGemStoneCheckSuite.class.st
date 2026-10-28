Class {
	#name : #GtGemStoneCheckSuite,
	#superclass : #Object,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GtGemStoneCheckSuite >> coreTests [

	^ OrderedDictionaryTest suite tests,
	RectangleTest suite tests
]

{ #category : #accessing }
GtGemStoneCheckSuite >> examples [

	^ GtExampleGroup withAll:
		self llmToolExamples examples,
		self magritteExamples examples
]

{ #category : #accessing }
GtGemStoneCheckSuite >> llmToolExamples [
	| llmToolExamples |
	
llmToolExamples := 
	GtExplicitExampleGroup withAll:
		GtLMagritteToolForClassLookupExamples gtExamples,
		GtLMagritteToolForClassSearchExamples gtExamples,
		GtLMagritteToolForClassSubclassesExamples gtExamples,
		GtLMagritteToolForClassReferencesExamples gtExamples,
		GtLMagritteToolForMethodReferencesExamples gtExamples,
		GtLMagritteToolForMethodImplementorsExamples gtExamples,
		GtLMagritteToolForMethodsSourceExamples gtExamples,
		GtLMagritteToolForPackageClassesExamples gtExamples,
		GtLMagritteToolForSubstringLiteralSearchExamples gtExamples,
		GtLMagritteToolForClassesCreationExamples gtExamples,
		GtLMagritteToolForClassDefinitionChangeExamples gtExamples,
		GtLMagritteToolForClassCommentChangeExamples gtExamples,
		GtLMagritteToolForMethodsCompilationExamples gtExamples,
		GtLMagritteToolForMethodsRemovalExamples gtExamples,
		GtLToolForExampleMethodRunExamples gtExamples,
		GtLToolForExampleClassesRunExamples gtExamples,
		GtLMagritteToolForSmalltalkCodeEvaluationExamples gtExamples,
		GtLToolForObjectStorageListExamples gtExamples,
		GtLMagritteToolForObjectStorageValueExamples gtExamples,
		GtLMagritteToolForObjectStorageSlotValueExamples gtExamples.

	^ llmToolExamples
]

{ #category : #accessing }
GtGemStoneCheckSuite >> magritteExamples [

	^ GtExplicitExampleGroup withAll: (self
		gtDo: [ 'GToolkit4Magritte-Examples' asPackage gtExamplesAllContained ]
		gemstoneDo: [ (ClassOrganizer gtDefault
	classNamesInClassCategoryNamed: 'GToolkit4Magritte-Examples'
	dictionaryName: nil) flatCollect: [ :clsName |
		(GsSession currentSession objectNamed: clsName) gtExamples ] ]).
]

{ #category : #accessing }
GtGemStoneCheckSuite >> neoJsonTests [
	| classes tests |

	tests := OrderedCollection new.
	classes := self gtDo:
		[ 'Neo-JSON-Tests' asPackage classes ]
	gemstoneDo: 
		[ (ClassOrganizer gtDefault
			classNamesInClassCategoryNamed: 'Neo-JSON-Tests'
			dictionaryName: nil) collect: [ :clsName |
				(GsSession currentSession objectNamed: clsName) ] ].
	classes := classes select: [ :cls |
		cls new isKindOf: TestCase ].
	classes do: [ :cls |
		tests addAll: cls suite tests ].
	^ tests.
]

{ #category : #running }
GtGemStoneCheckSuite >> runAllExamples [

	^ self examples runAll examples
]

{ #category : #running }
GtGemStoneCheckSuite >> runAllTests [

	^ self testSuite run
]

{ #category : #accessing }
GtGemStoneCheckSuite >> testSuite [

	^ TestSuite new addTests:
		self neoJsonTests,
		self coreTests.
]

{ #category : #running }
GtGemStoneCheckSuite >> unsuccessfullAllExamples [

	^ self runAllExamples reject: 
		[ :gtEx | gtEx isSuccess ]
]

{ #category : #running }
GtGemStoneCheckSuite >> unsuccessfullAllTests [

	^ self runAllTests reject: 
		[ :test | test isSuccess ]
]
