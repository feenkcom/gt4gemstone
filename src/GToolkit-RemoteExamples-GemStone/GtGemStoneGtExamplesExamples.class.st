"
I provide live GemStone acceptance examples for gtExample discovery and execution. These examples belong to the dedicated remote GemStone CI suite.
"
Class {
	#name : #GtGemStoneGtExamplesExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - remote execution' }
GtGemStoneGtExamplesExamples >> allDummyExamplesRunSuccessfully [
	"Requires GtGemStoneGtCodeExporter to have been run"
	<gtExample>
	<after: #stopServer>
	<noTest>
	| outcomes |
	outcomes := self runningServer
		evaluateBlockAndWaitReturnPrimitive: [
			GtDummyExampleWithAssertions gtExamples collect: [ :example |
				| result |
				result := example run.
				{ example selector. result isSuccess. result returnValue } ] ].
	self assert: outcomes size equals: 3.
	self assert: (outcomes allSatisfy: [ :each | each second ]).
	self assert: (outcomes allSatisfy: [ :each | each third = true ]).
	^ outcomes
]

{ #category : #'examples - remote execution' }
GtGemStoneGtExamplesExamples >> corpusExpectedExceptionsAndErrorsAreClassified [
	"Requires GtGemStoneGtCodeExporter to have been run"
	<gtExample>
	<after: #stopServer>
	<noTest>
	| outcomes |
	outcomes := self runningServer
		evaluateBlockAndWaitReturnPrimitive: [
			GtDummyExamplesWithExceptions gtExamples collect: [ :example |
				| result |
				result := example run.
				{ example selector. result isSuccess. result isFailure. result isError } ] ].
	self assert: outcomes size equals: 9.
	self assert: (outcomes detect: [ :each | each first = #a ]) second.
	self assert: (outcomes detect: [ :each | each first = #d ]) second.
	self assert: (outcomes detect: [ :each | each first = #e ]) third.
	self assert: (outcomes detect: [ :each | each first = #g ]) third.
	self assert: (outcomes detect: [ :each | each first = #j ]) fourth.
	^ outcomes
]

{ #category : #'examples - remote execution' }
GtGemStoneGtExamplesExamples >> corpusSubjectsAndAfterRunSuccessfully [
	"Requires GtGemStoneGtCodeExporter to have been run"
	<gtExample>
	<after: #stopServer>
	<noTest>
	| outcomes |
	outcomes := self runningServer
		evaluateBlockAndWaitReturnPrimitive: [
			| collected |
			collected := OrderedCollection new.
			{ GtDummyExamplesWithAfterInstanceSide.
			GtDummyExamplesWithAfterInstanceSideSubclass.
			GtDummyExamplesWithAfterClassSide.
			GtDummyExamplesWithSubjects.
			GtDummyExamplesWithGlobalSubjects.
			GtDummyExamplesWithSubjectsAndGlobalSubjects } do: [ :providerClass |
				providerClass gtExamples do: [ :example |
					collected add: { providerClass name. example selector. example run isSuccess } ] ].
			collected asArray ].
	self assert: outcomes size equals: 15.
	self assert: (outcomes allSatisfy: [ :each | each third ]).
	^ outcomes
]

{ #category : #'examples - remote discovery' }
GtGemStoneGtExamplesExamples >> dummyExamplePragmasAreAvailable [
	"Requires GtGemStoneGtCodeExporter to have been run"
	<gtExample>
	<after: #stopServer>
	<noTest>
	| pragmas |
	pragmas := self runningServer
		evaluateBlockAndWaitReturnPrimitive: [
			(GtDummyExampleWithAssertions compiledMethodAt: #a) pragmas
				collect: [ :each | each keyword ] ].
	self assert: (pragmas includes: #gtExample).
	self assert: (pragmas includes: #return:).
	^ pragmas
]

{ #category : #'examples - remote discovery' }
GtGemStoneGtExamplesExamples >> dummyExamplesAreDiscovered [
	"Requires GtGemStoneGtCodeExporter to have been run"
	<gtExample>
	<after: #stopServer>
	<noTest>
	| selectors |
	selectors := self runningServer
		evaluateBlockAndWaitReturnPrimitive: [
			GtDummyExampleWithAssertions gtExamples
				collect: [ :each | each selector ] ].
	self assert: selectors asSet equals: #(a b c) asSet.
	^ selectors
]

{ #category : #'examples - remote execution' }
GtGemStoneGtExamplesExamples >> exampleTimeoutsAreEnforced [
	<gtExample>
	<after: #stopServer>
	<noTest>
	| outcome |

	outcome := self runningServer evaluateBlockAndWaitReturnPrimitive: [
		| examples slow cleanup fast default slowResult cleanupResult fastResult |
		examples := GtDummyExampleWithTimeout gtExamples.
		slow := examples detect: [ :each | each selector = #slowExample ].
		cleanup := examples detect: [ :each | each selector = #slowWithAfterExample ].
		fast := examples detect: [ :each | each selector = #fastExample ].
		default := examples detect: [ :each | each selector = #defaultLimitExample ].
		GtDummyExampleWithTimeout resetCleanupCount.
		slowResult := slow run.
		cleanupResult := cleanup run.
		fastResult := fast run.
		{ slow timeLimit asMilliseconds. default timeLimit asMilliseconds. slowResult isError. slowResult returnValue class name = #TestTookTooMuchTime. cleanupResult isError. GtDummyExampleWithTimeout cleanupCount = 1. fastResult isSuccess. fastResult returnValue } ].
	self assert: outcome first equals: 100.
	self assert: outcome second equals: 60000.
	self assert: outcome third.
	self assert: outcome fourth.
	self assert: outcome fifth.
	self assert: outcome sixth.
	self assert: outcome seventh.
	self assert: outcome eighth.
	^ outcome
]

{ #category : #'examples - remote execution' }
GtGemStoneGtExamplesExamples >> firstDummyExampleRunsSuccessfully [
	"Requires GtGemStoneGtCodeExporter to have been run"
	<gtExample>
	<after: #stopServer>
	<noTest>
	| outcome |
	outcome := self runningServer
		evaluateBlockAndWaitReturnPrimitive: [
			| result |
			result := GtDummyExampleWithAssertions gtExamples first run.
			{ result isSuccess. result returnValue } ].
	self assert: outcome first.
	self assert: outcome second equals: true.
	^ outcome
]
