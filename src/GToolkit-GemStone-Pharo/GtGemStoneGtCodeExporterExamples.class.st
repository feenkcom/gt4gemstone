"
I provide examples for the static GemStone export dependency analysis.
"
Class {
	#name : #GtGemStoneGtCodeExporterExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> additionalClassListIgnoresMissingNames [
	<gtExample>
	| exporterClass exporter missingName expectedClasses |
	missingName := #GtGemStoneGtCodeExporterMissingAdditionalClassForExample.
	self assert: (Smalltalk globals includesKey: missingName) not.
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass additionalClassNames: { #Object. missingName. #String }.
	exporter := exporterClass new.
	self assert: exporter additionalClassNames size equals: 3.
	self assert: exporter additionalClassList equals: { Object. String }.
	expectedClasses := OrderedCollection new.
	expectedClasses
		addAll: (GtLlmAbstractFunctionTool withAllSuperclasses first: 3);
		addAll: { Object. String }.
	self assert: exporter additionalClasses equals: expectedClasses.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> additionalClassListUnionsPragmaProviders [
	<gtExample>
	| exporterClass exporter missingName expectedClasses |
	missingName := #GtGemStoneGtCodeExporterMissingAdditionalClassForExample.
	self assert: (Smalltalk globals includesKey: missingName) not.
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass additionalClassNames: { #Object. missingName. #String }.
	exporterClass
		compile: 'moreAdditionalClassNames
	<additionalClassNames>
	^ #(String Array Array)'
		classified: #private.
	exporterClass
		compile: 'unmarkedAdditionalClassNames
	^ #(Symbol)'
		classified: #private.
	exporter := exporterClass new.
	expectedClasses := { Object. String. Array }.
	self assert: exporter additionalClassList asSet equals: expectedClasses asSet.
	self assert: exporter additionalClassList size equals: expectedClasses size.
	self assert: ((exporterClass >> #additionalClassNames) hasPragmaNamed: #additionalClassNames).
	exporterClass addAdditionalClassName: #Array.
	self assert: exporter additionalClassList asSet equals: expectedClasses asSet.
	self assert: exporter additionalClassList size equals: expectedClasses size.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> additionalClassNameUtilities [
	<gtExample>
	| exporterClass originalNames source |
	originalNames := GtGemStoneGtCodeExporter new additionalClassNames.
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass additionalClassNames: #('String' Object 'Object').
	self assert: exporterClass new additionalClassNames equals: #(Object String).
	exporterClass addAdditionalClassName: 'Array'.
	self assert: exporterClass new additionalClassNames equals: #(Array Object String).
	exporterClass addAdditionalClassNames: #('String' Symbol 'Array').
	self assert: exporterClass new additionalClassNames equals: #(Array Object String Symbol).
	exporterClass removeAdditionalClassName: 'Object'.
	self assert: exporterClass new additionalClassNames equals: #(Array String Symbol).
	exporterClass removeAdditionalClassNames: #('Array' Symbol MissingAdditionalClass).
	self assert: exporterClass new additionalClassNames equals: #(String).
	exporterClass removeAdditionalClassName: #String.
	self assert: exporterClass new additionalClassNames isEmpty.
	exporterClass addAdditionalClassNames: #(String Object).
	self assert: exporterClass new additionalClassNames equals: #(Object String).
	source := (exporterClass >> #additionalClassNames) sourceCode.
	self assert: (source includesSubstring: '#Object').
	self assert: (source includesSubstring: '#String').
	self assert: (exporterClass >> #additionalClassNames) protocol name equals: #private.
	self assert: GtGemStoneGtCodeExporter new additionalClassNames equals: originalNames.
	^ exporterClass
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> additionalClassNamesAreSorted [
	<gtExample>
	| exporter names presentNames |
	exporter := GtGemStoneGtCodeExporter new.
	names := exporter additionalClassNames.
	self assert: names isArray.
	self assert: names equals: names sorted.
	self assert: names size equals: names asSet size.
	presentNames := names select: [ :each | Smalltalk globals includesKey: each ].
	self assert: (exporter additionalClassList collect: [ :each | each name ]) equals: presentNames.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> excludedClassListUnionsPragmaProviders [
	<gtExample>
	| exporterClass exporter expectedClasses |
	exporter := GtGemStoneGtCodeExporter new.
	self assert: exporter excludedClasses equals: { GtGemStoneTopazExporterExamples }.
	self assert: exporter excludedClasses equals: exporter excludedClassList.
	self assert: ((GtGemStoneGtCodeExporter >> #excludedClassList) hasPragmaNamed: #excludedClasses).
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass
		compile: 'defaultExcludedClassList
	<excludedClasses>
	^ { Object. String }'
		classified: #private.
	exporterClass
		compile: 'moreExcludedClasses
	<excludedClasses>
	^ { String. Array. Array }'
		classified: #private.
	exporterClass
		compile: 'unmarkedExcludedClasses
	^ { Symbol }'
		classified: #private.
	exporter := exporterClass new.
	expectedClasses := { Object. String. Array }.
	self assert: exporter excludedClasses isArray.
	self assert: exporter excludedClasses asSet equals: expectedClasses asSet.
	self assert: exporter excludedClasses size equals: expectedClasses size.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> excludedMethodsUnionsPragmaProviders [
	<gtExample>
	| exporterClass exporter expectedMethods |
	exporter := GtGemStoneGtCodeExporter new.
	self assert: exporter excludedMethods equals: exporter excludedMethodsList.
	self assert: ((GtGemStoneGtCodeExporter >> #excludedMethodsList) hasPragmaNamed: #excludedMethods).
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass
		compile: 'excludedMethodsList
	<excludedMethods>
	^ { GtGemStoneGtCodeExporter >> #additionalClassList.
		GtGemStoneGtCodeExporter >> #stubClasses }'
		classified: #accessing.
	exporterClass
		compile: 'moreExcludedMethods
	<excludedMethods>
	^ { GtGemStoneGtCodeExporter >> #stubClasses.
		GtGemStoneGtCodeExporter class >> #stubClassNames:.
		GtGemStoneGtCodeExporter class >> #stubClassNames: }'
		classified: #accessing.
	exporterClass
		compile: 'unmarkedExcludedMethods
	^ { GtGemStoneGtCodeExporter >> #excludedClassList }'
		classified: #accessing.
	exporter := exporterClass new.
	expectedMethods := { GtGemStoneGtCodeExporter >> #additionalClassList.
		GtGemStoneGtCodeExporter >> #stubClasses.
		GtGemStoneGtCodeExporter class >> #stubClassNames: }.
	self assert: exporter excludedMethods isArray.
	self assert: exporter excludedMethods asSet equals: expectedMethods asSet.
	self assert: exporter excludedMethods size equals: expectedMethods size.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> exportsGtExampleGemStoneCompatibilityMethods [
	<gtExample>
	| output |
	output := GtGemStoneGtCodeExporter new configuredExporter asTopazString.
	self assert: (output includesSubstring: 'method: Metaclass3').
	self assert: (output includesSubstring: 'gtExamplesFactory').
	self assert: (output includesSubstring: 'method: GsNMethod').
	self assert: (output includesSubstring: 'isGTExampleMethod').
	self assert: (output includesSubstring: 'method: Pragma').
	self assert: (output includesSubstring: 'isGTExamplePragma').
	self assert: (output includesSubstring: 'method: GtExample').
	self assert: (output includesSubstring: 'subclass: ''Metaclass3''') not.
	self assert: (output includesSubstring: 'subclass: ''GsNMethod''') not.
	self assert: (output includesSubstring: 'subclass: ''ExecutionEnvironment''').
	self assert: (output includesSubstring: 'subclass: ''DefaultExecutionEnvironment''').
	self assert: (output includesSubstring: 'subclass: ''TestExecutionEnvironment''').
	self assert: (output includesSubstring: 'subclass: ''TestExecutionService''').
	self assert: (output includesSubstring: 'subclass: ''TestTookTooMuchTime''').
	self assert: (output includesSubstring: '^ DefaultExecutionEnvironment instance runExampleEvaluator: anExampleEvaluator').
	self assert: (output includesSubstring: '^instance ifNil: [ instance := self new ]').
	self assert: (output includesSubstring: 'method: TestExecutionEnvironment
runUnmanagedExampleEvaluator:') not.
	self assert: (output includesSubstring: 'method: TestExecutionEnvironment
processMonitor') not.
	^ output
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> staticAnalysisClassifiesKnownFailures [
	<gtExample>
	| exporter analysis generated stubDifferences |
	exporter := GtGemStoneGtCodeExporter new.
	analysis := exporter staticExportAnalysisForPackageNames: exporter packageNames.
	generated := analysis at: #generated.
	self assert: ((generated at: #additionalClasses) includes: GtLlmError).
	self assert: ((generated at: #stubClasses) includes: GtRBNamespace).
	self assert: ((generated at: #excludedMethods) includes: GtLClassCreationDataExtractor>>#extractSuperclassIfError:).
	self assert: ((generated at: #excludedMethods) includes: GtLDataView>>#documentData).
	self assert: ((generated at: #excludedMethods) includes: GtLMarkdown>>#commentForSmaCC).
	stubDifferences := (analysis at: #differences) at: #stubClasses.
	^ analysis
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> stubClassNameUtilities [
	<gtExample>
	| exporterClass originalNames source |
	originalNames := GtGemStoneGtCodeExporter new stubClassNames.
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass stubClassNames: #('String' Object 'Object').
	self assert: exporterClass new stubClassNames equals: #(Object String).
	exporterClass addStubClassName: 'Array'.
	self assert: exporterClass new stubClassNames equals: #(Array Object String).
	exporterClass addStubClassNames: #('String' Symbol 'Array').
	self assert: exporterClass new stubClassNames equals: #(Array Object String Symbol).
	exporterClass removeStubClassName: 'Object'.
	self assert: exporterClass new stubClassNames equals: #(Array String Symbol).
	exporterClass removeStubClassNames: #('Array' Symbol MissingStubClass).
	self assert: exporterClass new stubClassNames equals: #(String).
	exporterClass removeStubClassName: #String.
	self assert: exporterClass new stubClassNames isEmpty.
	exporterClass addStubClassNames: #(String Object).
	self assert: exporterClass new stubClassNames equals: #(Object String).
	source := (exporterClass >> #stubClassNames) sourceCode.
	self assert: (source includesSubstring: '#Object').
	self assert: (source includesSubstring: '#String').
	self assert: (exporterClass >> #stubClassNames) protocol name equals: #accessing.
	self assert: GtGemStoneGtCodeExporter new stubClassNames equals: originalNames.
	^ exporterClass
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> stubClassNamesAreSorted [
	<gtExample>
	| exporter names presentNames |
	exporter := GtGemStoneGtCodeExporter new.
	names := exporter stubClassNames.
	self assert: names isArray.
	self assert: names equals: names sorted.
	self assert: names size equals: names asSet size.
	self assert: (names includesAny: #(GtExampleWithResult GtExampleResult ConnectionClosed)) not.
	presentNames := names select: [ :each | Smalltalk globals includesKey: each ].
	self assert: (exporter stubClasses collect: [ :each | each name ]) equals: presentNames.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> stubClassesIgnoreMissingNames [
	<gtExample>
	| exporterClass exporter missingName |
	missingName := #GtGemStoneGtCodeExporterMissingStubClassForExample.
	self assert: (Smalltalk globals includesKey: missingName) not.
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass stubClassNames: { #Object. missingName. #String }.
	exporter := exporterClass new.
	self assert: exporter stubClassNames size equals: 3.
	self assert: exporter stubClasses equals: { Object. String }.
	^ exporter
]

{ #category : #examples }
GtGemStoneGtCodeExporterExamples >> stubClassesUnionsPragmaProviders [
	<gtExample>
	| exporterClass exporter missingName expectedClasses |
	missingName := #GtGemStoneGtCodeExporterMissingStubClassForExample.
	self assert: (Smalltalk globals includesKey: missingName) not.
	exporterClass := GtGemStoneGtCodeExporter newAnonymousSubclass.
	exporterClass stubClassNames: { #Object. missingName. #String }.
	exporterClass
		compile: 'moreStubClassNames
	<stubClassNames>
	^ #(String Array Array)'
		classified: #accessing.
	exporterClass
		compile: 'unmarkedStubClassNames
	^ #(Symbol)'
		classified: #accessing.
	exporter := exporterClass new.
	expectedClasses := { Object. String. Array }.
	self assert: exporter stubClasses asSet equals: expectedClasses asSet.
	self assert: exporter stubClasses size equals: expectedClasses size.
	self assert: ((exporterClass >> #stubClassNames) hasPragmaNamed: #stubClassNames).
	exporterClass addStubClassName: #Array.
	self assert: exporter stubClasses asSet equals: expectedClasses asSet.
	self assert: exporter stubClasses size equals: expectedClasses size.
	^ exporter
]
