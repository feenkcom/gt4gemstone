"
I am the registry of GT-managed GemStone extension methods. My class-side methods named ext_* answer extension descriptors; apply discovers and applies all of them.
"
Class {
	#name : #GtGemStoneExtensionMethods,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #applying }
GtGemStoneExtensionMethods class >> apply [
	^ self extensions collect: [ :each | each apply ]
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Behavior___ [
	^ GtGemStoneExtensionMethod new
		selector: #>>;
		protocol: #'*GToolkit-Examples-GemStone';
		meta: false;
		gtVersions: nil;
		className: #Behavior;
		hash: #new;
		source: '>> aSelector
	<gtGsExtension>

	^ self compiledMethodAt: aSelector'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Boolean_isBoolean [
	^ GtGemStoneExtensionMethod new
		selector: #isBoolean;
		protocol: #'*PharoLink';
		meta: false;
		gtVersions: nil;
		className: #Boolean;
		hash: #new;
		source: 'isBoolean
	<gtGsExtension>

	"Answer a boolean indicating whether the receiver is a boolean"

	^ true'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_intersection_ [
	^ GtGemStoneExtensionMethod new
		selector: #intersection:;
		protocol: #enumerating;
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'intersection: aCollection
	<gtGsExtension>

	^ self species withAll: (self asSet intersection: aCollection) asArray'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_CurrentExecutionEnvironment_runUnmanagedExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runUnmanagedExampleEvaluator:;
		protocol: #'*GToolkit-Examples-GemStone';
		meta: true;
		gtVersions: nil;
		className: #CurrentExecutionEnvironment;
		hash: #new;
		source: 'runUnmanagedExampleEvaluator: anExampleEvaluator
	<gtGsExtension>

	"GemStone evaluates unmanaged examples synchronously in the current process."
	^ anExampleEvaluator value'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DefaultExecutionEnvironment_instance [
	^ GtGemStoneExtensionMethod new
		selector: #instance;
		protocol: #accessing;
		meta: true;
		gtVersions: nil;
		className: #DefaultExecutionEnvironment;
		hash: 'ee006edbdf1738a0b555ac2c93913d47379b04ceaa884ae789502a9f3911a696';
		source: 'instance
	<gtGsExtension>

	^ SessionTemps current at: #DefaultExecutionEnvironment_instance ifAbsentPut: [ self new ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DefaultExecutionEnvironment_runExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runExampleEvaluator:;
		protocol: #'*GToolkit-Examples-Core';
		meta: false;
		gtVersions: nil;
		className: #DefaultExecutionEnvironment;
		hash: '2da4154fd656dd3f2b652ea216c60be4b2d3ad77ff44ce24590bc9c0eb72e06d';
		source: 'runExampleEvaluator: anExampleEvaluator
	<gtGsExtension>
	| testEnv |
	testEnv := TestExecutionEnvironment new initialize.
	^ testEnv beActiveDuring: [ testEnv runExampleEvaluator: anExampleEvaluator ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtDummyExamplesWithAfterInstanceSide_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		protocol: #'instance creation';
		meta: true;
		gtVersions: nil;
		className: #GtDummyExamplesWithAfterInstanceSide;
		hash: #new;
		source: 'new
	<gtGsExtension>
	^ super new initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtExampleDependenciesProcessor_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		protocol: #'instance creation';
		meta: true;
		gtVersions: nil;
		className: #GtExampleDependenciesProcessor;
		hash: #new;
		source: 'new
	<gtGsExtension>

	^ self basicNew initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtExampleEvaluator_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		protocol: #'instance creation';
		meta: true;
		gtVersions: nil;
		className: #GtExampleEvaluator;
		hash: #new;
		source: 'new
	<gtGsExtension>

	^ super new initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtExample_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		protocol: #'instance creation';
		meta: true;
		gtVersions: nil;
		className: #GtExample;
		hash: #new;
		source: 'new
	<gtGsExtension>

	^ super new initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_assert_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:;
		protocol: #asserting;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'assert: aBlock
	<gtGsExtension>

	"Throw an assertion error if aBlock does not evaluates to true.
	We check for true explicitly to make the assertion fail for non booleans"

	self assert: aBlock description: ''Assertion failed'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_assert_description_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:description:;
		protocol: #asserting;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'assert: aBlock description: aStringOrBlock
	<gtGsExtension>

	"Throw an assertion error if aBlock does not evaluates to true."

	"we do the == true check to avoid NonBooleanReceiver error for nonBoolean aBlock values"
	aBlock value == true ifFalse: [
		AssertionFailure signal: aStringOrBlock value ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_assert_equals_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:equals:;
		protocol: #asserting;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'assert: actual equals: expected
	<gtGsExtension>
	^ self assert: expected = actual description: [ ''Got '', actual printString, '' instead of '', expected printString ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_class_gtExampleRuntimeContext [
	^ GtGemStoneExtensionMethod new
		selector: #gtExampleRuntimeContext;
		protocol: #accessing;
		meta: true;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'gtExampleRuntimeContext
	<gtGsExtension>
	^ self gtExamplesFactoryClass gtExampleRuntimeContext'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_fullPrintString [
	^ GtGemStoneExtensionMethod new
		selector: #fullPrintString;
		protocol: #printing;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'fullPrintString
	<gtGsExtension>
	^ self printString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_gtExampleRuntimeContext [
	^ GtGemStoneExtensionMethod new
		selector: #gtExampleRuntimeContext;
		protocol: #accessing;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'gtExampleRuntimeContext
	<gtGsExtension>
	^ self class gtExampleRuntimeContext'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_isBoolean [
	^ GtGemStoneExtensionMethod new
		selector: #isBoolean;
		protocol: #'*PharoLink';
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'isBoolean
	<gtGsExtension>

	"Answer a boolean indicating whether the receiver is a boolean"

	^ false'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Set_intersection_ [
	^ GtGemStoneExtensionMethod new
		selector: #intersection:;
		protocol: #enumerating;
		meta: false;
		gtVersions: nil;
		className: #Set;
		hash: #new;
		source: 'intersection: aCollection
	<gtGsExtension>
	"Answer the set theoretic intersection of two collections.
	Optimized version for Sets where no intermediate Set is necessary"

	"(#(1 2 3 4) asSet intersection: #(3 4 5) asSet) >>> #(3 4) asSet"

	"(#(1 2 3 4) asSet intersection: #() asSet) >>> Set new"

	"( #() asSet intersection: #(1 2 3 4) asSet) >>> Set new"

	| outputSet |
	outputSet := self class new.
	aCollection do: [ :each | (self includes: each) ifTrue: [ outputSet add: each ] ].
	^ outputSet'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_processMonitor [
	^ GtGemStoneExtensionMethod new
		selector: #processMonitor;
		protocol: #'accessing';
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: #new;
		source: 'processMonitor
	<gtGsExtension>
	^ nil'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_registerDefaultServices [
	^ GtGemStoneExtensionMethod new
		selector: #registerDefaultServices;
		protocol: #'controlling';
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: 'c84b401effacc600b3ba2813377d2a2153356ae7bbfcb201e158217ae3d9b949';
		source: 'registerDefaultServices
	<gtGsExtension>
	^ self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_runExampleUnderWatchdogUsingEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runExampleUnderWatchdogUsingEvaluator:;
		protocol: #'*GToolkit-Examples-Core';
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: 'd909c56fec7a94f6e728df87b9ebcf7f8f18199637e2e9a4ce063e0f10efda32';
		source: 'runExampleUnderWatchdogUsingEvaluator: anEvaluator
	<gtGsExtension>
	| exampleResult |
	exampleResult := nil.
	[ [ exampleResult := anEvaluator runUnmanaged ] ensure: [ self handleCompletedTest ] ]
		on: Exception
		do: [ :err | self handleException: err ].
	^ exampleResult'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_runUnmanagedExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runUnmanagedExampleEvaluator:;
		protocol: #'*GToolkit-Examples-Core';
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: #new;
		source: 'runUnmanagedExampleEvaluator: anExampleEvaluator
	<gtGsExtension>
	| exampleResult |
	testCase := anExampleEvaluator.
	testCompleted := false.
	[ exampleResult := anExampleEvaluator value ] ensure: [ testCompleted := true ].
	^ exampleResult'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_watchDogLoop [
	^ GtGemStoneExtensionMethod new
		selector: #watchDogLoop;
		protocol: #'controlling';
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: '7782c5f9d02f84a08316dea8714fefa3b38a47a469451dc8a3f82ddded97e7de';
		source: 'watchDogLoop
	<gtGsExtension>
	| timeIsGone |
	[ watchDogSemaphore wait.
	  [ timeIsGone := (watchDogSemaphore waitForMilliseconds: maxTimeForTest asMilliseconds) not.
	    testCompleted ] whileFalse: [
	      timeIsGone ifTrue: [
	        mainTestProcess _isSuspended ifFalse: [
	          mainTestProcess signalException: TestTookTooMuchTime new ] ] ] ] repeat'
]

{ #category : #accessing }
GtGemStoneExtensionMethods class >> extensionSelectors [
	^ ((self class selectors select: [ :each | each asString beginsWith: 'ext_' ])
		asSortedCollection: [ :left :right | left asString < right asString ]) asArray
]

{ #category : #accessing }
GtGemStoneExtensionMethods class >> extensions [
	^ self extensionSelectors collect: [ :each | self perform: each ]
]
