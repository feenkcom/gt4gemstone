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
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassDefinitionCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpClassAddition.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> addClassMethod [
	| signal |

	self exampleClass class
		compile: 'classMethod1 ^ 1'
		classified: 'class category 1'.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodAddition.
	self assert: signal change selector equals: #classMethod1.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> addMethod [
	| signal |

	self exampleClass
		compile: 'method1 ^ 1'
		classified: 'category 1'.
	self forPharo12AndNewer: 
		[ self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 1'.
		self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 2'. ] 
	forPharo11: [ self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'. ].
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodAddition.
	self assert: signal change selector equals: #method1.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> changeClassCategory [
	| signal |

	self exampleClass category: 'GtGemStoneExamples2'.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassCategoryChangeCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self 
		forPharo12AndNewer: [self assert: signal change isEpBehaviorRepackagedChange] 
		forPharo11: [
			self assert: signal change isEpBehaviorCategoryChange ]
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> checkRenamedClassComment [
	| source |

	source := self session evaluateAndWait: (String streamContents: [ :stream |
		stream
			<< self renamedExampleClassName;
			<< ' comment' ]).
	self assert: source equals: 'comment 1'.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> checkRenamedMethodDefinitions [
	| source |

	source := self session evaluateAndWait: (String streamContents: [ :stream |
		stream
			<< '((';
			<< self renamedExampleClassName;
			<< ' methodDictForEnv: 0) at: #method1) sourceString' ]).
	self assert: source equals: 'method1 ^ 2'.

	source := self session evaluateAndWait: (String streamContents: [ :stream |
		stream
			<< '((';
			<< self renamedExampleClassName;
			<< ' class methodDictForEnv: 0) at: #classMethod1) sourceString' ]).
	self assert: source equals: 'classMethod1 ^ 2'.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> commentClass [
	| signal |

	self exampleClass comment: 'comment 1'.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassCommentCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpBehaviorCommentChange.
]

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> ensureCodeSync [
	"Answer a code sync configured for testing"
	| registry classStrategy sessionStrategy |

	codeSync ifNotNil: [ ^ codeSync ].
	registry := GtGemStoneSessionRegistry new.
	classStrategy := GtGemStoneCodeSyncCategoriesStrategy new.
	classStrategy categories: #(GtGemStoneExamples GtGemStoneExamples2).
	sessionStrategy := GtGemStoneCodeSyncDefaultSessionStrategy new.
	codeSync := GtGemStoneCodeSync new
		defaultClassStrategy: classStrategy;
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

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> getDefaultSession [
	"Connect the receiver's registry to the default properties file and use the default connector"

	self registry propertiesFilename: LeDatabasesRegistry defaultPrimaryDatabase 
			properties gemStonePropertiesFile.
	^ self registry newSessionWithConnectorNamed: 'default'.
]

{ #category : #'private - execution' }
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
	self forPharo12AndNewer: 
		[ self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 1'.
		self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 2'. ] 
	forPharo11: [ self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'. ].
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassDefinitionCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	
	self assert: signal change isEpClassModification
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> modifyClassMethod [
	| signal |

	self exampleClass class
		compile: 'classMethod1 ^ 2'
		classified: 'class category 1'.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodModification.
	self assert: signal change selector equals: #classMethod1.
	self assert: signal change sourceCode equals: 'classMethod1 ^ 2'.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> modifyMethod [
	| signal |

	self exampleClass
		compile: 'method1 ^ 2'
		classified: 'category 1'.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodModification.
	self assert: signal change selector equals: #method1.
	self assert: signal change sourceCode equals: 'method1 ^ 2'.
]

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> onBeaconSignal: aSignal [

	semaphore signal.
]

{ #category : #accessing }
GtGemStoneCodeSyncExamples >> registry [

	^ self ensureCodeSync registry
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> removeClass [
	"The default event strategy ignores class removal.
	Just check that the class is gone from the local image."

	self renamedExampleClass removeFromSystem.
	self deny: (self class environment includesKey: self renamedExampleClassName).
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> removeClassMethod [
	| signal |

	self renamedExampleClass class removeSelector: #classMethod1.
	"Removing a selector generates a method modified event followed by the removed event"
	self
		forPharo12AndNewer: [ self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'. ] 
		forPharo11: 
			[ self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 1'.
			self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 2'. ].
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodRemoval.
	self assert: signal change selector equals: #classMethod1.
	self assert: signal change behaviorAffectedName equals: (self renamedExampleClassName, ' class').
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> removeMethod [
	| signal |

	self renamedExampleClass removeSelector: #method1.
	"Removing a selector generates a method modified event followed by the removed event"
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 1'.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal 2'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneMethodCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpMethodRemoval.
	self assert: signal change selector equals: #method1.
	self assert: signal change behaviorAffectedName equals: self renamedExampleClassName.
]

{ #category : #helper }
GtGemStoneCodeSyncExamples >> renameClass [
	"Despite the name, rename class copies the class to the new name and leaves the old class untouched"
	| signal |

	(RBRenameClassRefactoring
		rename: self exampleClassName
		to: self renamedExampleClassName)
			execute.
	self waitOn: semaphore for: 10 description: 'Didn''t receive code change signal'.
	signal := logger recordings last.
	self assert: signal class equals: GtGemStoneClassRenameCodeSyncSignal.
	self assert: signal session identicalTo: codeSync registry defaultSession.
	self assert: signal change isEpBehaviorNameChange.
]

{ #category : #'private - accessing' }
GtGemStoneCodeSyncExamples >> renamedExampleClass [

	^ self class environment classOrTraitNamed: self renamedExampleClassName.
]

{ #category : #'private - accessing' }
GtGemStoneCodeSyncExamples >> renamedExampleClassName [

	^ #GtGemStoneCodeSyncExampleClassRenamed
]

{ #category : #examples }
GtGemStoneCodeSyncExamples >> runAllChangesWithDefaultSession [
	"Run the tests against the default GemStone connector."
	<gtExample>
	<noTest>

	(self class environment classOrTraitNamed: self exampleClassName)
		ifNotNil: [ :cls | cls removeFromSystem ].
	(self class environment classOrTraitNamed: self renamedExampleClassName)
		ifNotNil: [ :cls | cls removeFromSystem ].
	[ self
		ensureCodeSync;
		setSession: self getDefaultSession;
		addClass;
		modifyClass;
		commentClass;
		changeClassCategory;
		addMethod;
		modifyMethod;
		addClassMethod;
		modifyClassMethod;
		renameClass;
		checkRenamedMethodDefinitions;
		checkRenamedClassComment;
		removeMethod;
		removeClassMethod;
		removeClass ] ensure: [ self tidyUp ]
]

{ #category : #examples }
GtGemStoneCodeSyncExamples >> runAllChangesWithSimulatedSession [
	"All changes are tested in a single example as class addition and removal is (relatively) slow and polutes the epicea log"
	<gtExample>
	<return: #GtGemStoneCodeSyncExamples>
	<shouldLogWithEpicea>

	(self class environment classOrTraitNamed: self exampleClassName)
		ifNotNil: [ :cls | cls removeFromSystem ].
	(self class environment classOrTraitNamed: self renamedExampleClassName)
		ifNotNil: [ :cls | cls removeFromSystem ].
	[ self
		ensureCodeSync;
		setSession: self getSimulatedSession;
		addClass;
		modifyClass;
		commentClass;
		changeClassCategory;
		addMethod;
		modifyMethod;
		addClassMethod;
		modifyClassMethod;
		renameClass;
		removeMethod;
		removeClassMethod;
		removeClass ] ensure: [ self tidyUp ]
]

{ #category : #accessing }
GtGemStoneCodeSyncExamples >> session [

	^ self registry defaultSession
]

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> setSession: aGtGemStoneSession [

	aGtGemStoneSession registry: self registry.
	aGtGemStoneSession codeSync enabled: true.
	self registry addSession: aGtGemStoneSession.
	aGtGemStoneSession beDefaultSession.
	
	codeSync start.
]

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> stopCodeSync [

	codeSync ifNil: [ ^ self ].
	codeSync stop.
	self registry defaultSession 
		abortTransaction;
		close.
	codeSync := nil.
]

{ #category : #'private - execution' }
GtGemStoneCodeSyncExamples >> tidyUp [

	logger announcer unsubscribe: self.
	logger stop.
	logger := nil.
	self stopCodeSync.
	self exampleClass ifNotNil: [ :cls | cls removeFromSystem ].
	self renamedExampleClass ifNotNil: [ :cls | cls removeFromSystem ].
]

{ #category : #'private - helpers' }
GtGemStoneCodeSyncExamples >> waitOn: aSemaphore for: anInteger description: descriptionString [

	(aSemaphore waitTimeoutSeconds: anInteger)
		ifTrue: [ self error: descriptionString ]
]
