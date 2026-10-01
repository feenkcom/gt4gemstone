"
I provide examples for the static GemStone export dependency analysis.
"
Class {
	#name : #GtGemStoneGtCodeExporterExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

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
	self assert: (output includesSubstring: '^ super new initialize').
	self assert: (output includesSubstring: 'subclass: ''Metaclass3''') not.
	self assert: (output includesSubstring: 'subclass: ''GsNMethod''') not.
	self assert: (output includesSubstring: 'subclass: ''ExecutionEnvironment''').
	self assert: (output includesSubstring: 'subclass: ''DefaultExecutionEnvironment''').
	self assert: (output includesSubstring: 'subclass: ''TestExecutionEnvironment''').
	self assert: (output includesSubstring: 'subclass: ''TestExecutionService''').
	self assert: (output includesSubstring: 'subclass: ''TestTookTooMuchTime''').
	self assert: (output includesSubstring: 'subclass: ''ProcessMonitorTestService''') not.
	self assert: (output includesSubstring: 'waitForMilliseconds: maxTimeForTest asMilliseconds').
	self assert: (output includesSubstring: '^ DefaultExecutionEnvironment instance runExampleEvaluator: anExampleEvaluator').
	self assert: (output includesSubstring: 'SessionTemps current at: #DefaultExecutionEnvironment_instance ifAbsentPut: [ self new ]').
	self assert: (output includesSubstring: 'ext_DefaultExecutionEnvironment_instance').
	self assert: (output includesSubstring: '^instance ifNil: [ instance := self new ]').
	self assert: (output includesSubstring: 'ext_DefaultExecutionEnvironment_runExampleEvaluator_').
	self assert: (output includesSubstring: 'ext_TestExecutionEnvironment_registerDefaultServices').
	self assert: (output includesSubstring: 'ext_TestExecutionEnvironment_watchDogLoop').
	self assert: (output includesSubstring: 'ext_TestExecutionEnvironment_runExampleUnderWatchdogUsingEvaluator_').
	self assert: (output includesSubstring: 'ext_TestExecutionEnvironment_runUnmanagedExampleEvaluator_').
	self assert: (output includesSubstring: 'ext_TestExecutionEnvironment_processMonitor').
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
	self assert: (stubDifferences at: #missingFromExisting) equals: (Set with: ProcessMonitorTestService).
	^ analysis
]
