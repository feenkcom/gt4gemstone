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
		subclass: #GtGemStoneCodeSyncExampleClass
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
	| signal cls |

	cls := self class environment classOrTraitNamed: #GtGemStoneCodeSyncExampleClass.
	cls ifNil: [ self error: 'Example class not defined' ].
	cls
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

	GtGemStoneCodeSyncExampleClass comment: 'comment 1'.
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
	classStrategy := GtGemStoneCodeSyncExplicitClassStrategy new.
	classStrategy classes: #(GtGemStoneCodeSyncExampleClass).
	sessionStrategy := GtGemStoneCodeSyncDefaultSessionStrategy new.
	codeSync := GtGemStoneCodeSync new
		classStrategy: classStrategy;
		sessionStrategy: sessionStrategy.
	"session := GtGemStoneTestingSession new.
	session sessionId: '1'.
	session registry: registry."
	registry 
		codeSync: codeSync ";
		addSession: session named: 'default:1'.
	session beDefaultSession".
	codeSync start.

	semaphore := Semaphore new.
	logger := MemoryLogger new startFor: GtGemStoneCodeSyncSignal.
	logger announcer
		when: GtGemStoneCodeSyncSignal
		send: #onBeaconSignal:
		to: self.

	^ codeSync
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> exampleCodeSyncWithSession: session [
	"Answer a code sync configured for testing"
	| registry classStrategy sessionStrategy |

	codeSync ifNotNil: [ self error: 'codeSync already set' ].
	registry := GtGemStoneSessionRegistry new.
	classStrategy := GtGemStoneCodeSyncExplicitClassStrategy new.
	classStrategy classes: #(GtGemStoneCodeSyncExampleClass).
	sessionStrategy := GtGemStoneCodeSyncDefaultSessionStrategy new.
	codeSync := GtGemStoneCodeSync new
		classStrategy: classStrategy;
		sessionStrategy: sessionStrategy.
	sessionId := session sessionId.
	session registry: registry.
	registry 
		codeSync: codeSync;
		addSession: session named: 'default:1'.
	session beDefaultSession.
	codeSync start.

	semaphore := Semaphore new.
	logger := MemoryLogger new startFor: GtGemStoneCodeSyncSignal.
	logger announcer
		when: GtGemStoneCodeSyncSignal
		send: #onBeaconSignal:
		to: self.

	^ codeSync
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
		subclass: #GtGemStoneCodeSyncExampleClass
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
	| signal cls |

	cls := self class environment classOrTraitNamed: #GtGemStoneCodeSyncExampleClass.
	cls ifNil: [ self error: 'Example class not defined' ].
	cls
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

	(self class environment classOrTraitNamed: #GtGemStoneCodeSyncExampleClass) removeFromSystem.
	semaphore wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassDefinitionCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpClassRemoval.
	self assert: signal change behaviorAffectedName equals: #GtGemStoneCodeSyncExampleClass.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> removeMethod [
	| signal cls |

	cls := self class environment classOrTraitNamed: #GtGemStoneCodeSyncExampleClass.
	cls ifNil: [ self error: 'Example class not defined' ].
	cls removeSelector: #method1.
	"Removing a selector generates a method modified event followed by the removed event"
	semaphore wait; wait.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodRemoval.
	self assert: signal change selector equals: #method1.
	self assert: signal change behaviorAffectedName equals: #GtGemStoneCodeSyncExampleClass.
]

{ #category : #examples }
GtGemStoneCodeSyncExamples >> runAllChangesWithDefaultSession [
	"Run the tests against the default GemStone connector."
	<gtExample>
	<noTest>

	self runAllChangesWithSession: self getDefaultSession
]

{ #category : #private }
GtGemStoneCodeSyncExamples >> runAllChangesWithSession: aGtGemStoneSession [
	"All changes are tested in a single example as class addition and removal is (relatively) slow and polutes the epicea log"

	(self class environment classOrTraitNamed: #GtGemStoneCodeSyncExampleClass)
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
]
