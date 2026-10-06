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
		hash: '3a29aac01eec8949c5860660d69d08e1415f9af6ecdc9e66209c600b3baf4bbc';
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
		hash: '7a967548d4401a8d779fee8e2a6b59925eaad191775be8cfa80b7490bf45005a';
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
		hash: 'ef6072b4f84be6b12ecba0308405bd2337b5d72d7f026fa6c7770e85aea932c8';
		source: 'registerDefaultServices
	<gtGsExtension>
	^ self'.
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_runExampleUnderWatchdogUsingEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runExampleUnderWatchdogUsingEvaluator:;
		protocol: #'*GToolkit-Examples-Core';
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: 'c8790ab4d491856631bdaf3a95c51966656a4fe5f53dc4b419f5dc8b591ec837';
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
		hash: '0af9624ddb0d3f9efb1285fa07fea5b07c30f80a909c5c97e8fa2ef5f9897aa2';
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

{ #category : #updating }
GtGemStoneExtensionMethods class >> updateHashOf: aSelector [
	| method extension hashMessages hashArgument source updatedSource |
	(self extensionSelectors includes: aSelector)
		ifFalse: [ self error: 'Unknown extension method: ', aSelector asString ].
	method := self class >> aSelector.
	method protocolName = #extensions
		ifFalse: [ self error: 'Method is not in the extensions protocol: ', aSelector asString ].
	extension := self perform: aSelector.
	extension existingMethod
		ifNil: [ self error: 'Cannot update the hash of a missing target method: ', extension className asString, '>>', extension selector asString ].
	hashMessages := method ast allChildren
		select: [ :node | node isMessage and: [ node selector = #hash: ] ].
	hashMessages size = 1
		ifFalse: [ self error: 'Expected exactly one hash: send in extension method: ', aSelector asString ].
	hashArgument := hashMessages first arguments first.
	hashArgument isLiteralNode
		ifFalse: [ self error: 'Expected a literal hash in extension method: ', aSelector asString ].
	source := method sourceCode.
	updatedSource := (source copyFrom: 1 to: hashArgument start - 1),
		extension existingMethodHash storeString,
		(source copyFrom: hashArgument stop + 1 to: source size).
	updatedSource = source
		ifFalse: [ self class compile: updatedSource classified: method protocolName ].
	^ self perform: aSelector
]
