Class {
	#name : #GtGemStoneCodeSyncExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'codeSync',
		'semaphore',
		'logger',
		'sessionId'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #helper }
GtGemStoneCodeSyncExamples >> addClass [
	| signal |

	Object 
		subclass: self exampleClassName
		instanceVariableNames: '' 
		classVariableNames: '' 
		package: 'GtGemStoneExamples'.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassDefinitionCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpClassAddition.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> addMethod [
	| signal |

	self exampleClass
		compile: 'method1 ^ 1'
		classified: 'category 1'.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodAddition.
	self assert: signal change selector equals: #method1.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> commentClass [
	| signal |

	self exampleClass comment: 'comment 1'.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassCommentCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpBehaviorCommentChange.
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> ensureCodeSync [
	"Answer a code sync configured for testing"
	| registry classStrategy sessionStrategy |

	codeSync ifNotNil: [ ^ codeSync ].
	registry := GtGemStoneSessionRegistry new.
	classStrategy := GtGemStoneCodeSyncCategoriesStrategy new.
	classStrategy categories: #(GtGemStoneExamples).
	sessionStrategy := GtGemStoneCodeSyncDefaultSessionStrategy new.
	codeSync := GtGemStoneCodeSync new
		classStrategy: classStrategy;
		sessionStrategy: sessionStrategy.
	registry codeSync: codeSync.
	codeSync start.

	semaphore := Semaphore new.
	logger := MemoryLogger new startFor: GtGemStoneCodeSyncSignal.
	logger announcer
		when: GtGemStoneCodeSyncSignal
		send: #onBeaconSignal:
		to: self.

	^ codeSync
]

{ #category : #'private - accessing' }
GtGemStoneCodeSyncExamples >> exampleClass [

	^ (self class environment classOrTraitNamed: self exampleClassName).
]

{ #category : #'private - accessing' }
GtGemStoneCodeSyncExamples >> exampleClassName [
	"Answer the example class name.
	Note that we can't use a symbol directly as it would be modified by the example."

	^ 'GtGemStoneCodeSyncExampleClass' asSymbol
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> getDefaultSession [
	"Connect the receiver's registry to the default properties file and use the default connector"

	self registry propertiesFilename: LeDatabasesRegistry defaultPrimaryDatabase 
			properties gemStonePropertiesFile.
	^ self registry newSessionWithConnectorNamed: 'default'.
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> getSimulatedSession [
	^ GtGemStoneTestingSession new sessionId: '1'
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> modifyClass [
	| signal |

	Object 
		subclass: self exampleClassName
		instanceVariableNames: 'iVar1' 
		classVariableNames: '' 
		package: 'GtGemStoneExamples'.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassDefinitionCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpClassModification.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> modifyMethod [
	| signal |

	self exampleClass
		compile: 'method1 ^ 2'
		classified: 'category 1'.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodModification.
	self assert: signal change selector equals: #method1.
	self assert: signal change sourceCode equals: 'method1 ^ 2'.
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> onBeaconSignal: aSignal [

	semaphore signal.
]

{ #category : #accessing }
GtGemStoneCodeSyncExamples >> registry [

	^ self ensureCodeSync registry
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> removeClass [
	| signal |

	self renamedExampleClass removeFromSystem.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassDefinitionCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpClassRemoval.
	self assert: signal change behaviorAffectedName equals: self renamedClassName.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> removeMethod [
	| signal |

	self exampleClass removeSelector: #method1.
	"Removing a selector generates a method modified event followed by the removed event"
	semaphore wait; wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodRemoval.
	self assert: signal change selector equals: #method1.
	self assert: signal change behaviorAffectedName equals: self exampleClassName.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> renameClass [
	| signal |

	(RBRenameClassRefactoring
		rename: self exampleClassName
		to: self renamedClassName)
			execute.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassRenameCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpBehaviorNameChange.
]

{ #category : #'private - accessing' }
GtGemStoneCodeSyncExamples >> renamedClassName [

	^ #GtGemStoneCodeSyncExampleClassRenamed
]

{ #category : #'private - accessing' }
GtGemStoneCodeSyncExamples >> renamedExampleClass [

	^ self class environment classOrTraitNamed: self renamedClassName.
]

{ #category : #examples }
GtGemStoneCodeSyncExamples >> runAllChangesWithDefaultSession [
	"Run the tests against the default GemStone connector."
	<gtExample>
	<noTest>

	self runAllChangesWithSession: self getDefaultSession
]

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> runAllChangesWithSession: aGtGemStoneSession [
	"All changes are tested in a single example as class addition and removal is (relatively) slow and polutes the epicea log"

	(self class environment classOrTraitNamed: self exampleClassName)
		ifNotNil: [ :cls | cls removeFromSystem ].
	(self class environment classOrTraitNamed: self renamedClassName)
		ifNotNil: [ :cls | cls removeFromSystem ].
	[ self
		ensureCodeSync;
		setSession: aGtGemStoneSession;
		addClass;
		modifyClass;
		commentClass;
		addMethod;
		modifyMethod;
		removeMethod;
		renameClass;
		removeClass ] ensure: [ self tidyUp ]
]

{ #category : #examples }
GtGemStoneCodeSyncExamples >> runAllChangesWithSimulatedSession [
	"All changes are tested in a single example as class addition and removal is (relatively) slow and polutes the epicea log"
	<gtExample>
	
	self runAllChangesWithSession: self getSimulatedSession
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> setSession: aGtGemStoneSession [

	aGtGemStoneSession registry: self registry.
	self registry addSession: aGtGemStoneSession named: aGtGemStoneSession name.
	aGtGemStoneSession beDefaultSession.
	codeSync start.
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> stopCodeSync [

	codeSync ifNil: [ ^ self ].
	codeSync stop.
	codeSync := nil.
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> tidyUp [

	logger announcer unsubscribe: self.
	logger stop.
	logger := nil.
	self stopCodeSync.
	self exampleClass ifNotNil: [ :cls | cls removeFromSystem ].
	self renamedExampleClass ifNotNil: [ :cls | cls removeFromSystem ].
]
