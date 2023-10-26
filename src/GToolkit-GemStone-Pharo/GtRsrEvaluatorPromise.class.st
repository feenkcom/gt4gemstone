Class {
	#name : #GtRsrEvaluatorPromise,
	#superclass : #Object,
	#instVars : [
		'rsrPromise',
		'serializationStrategy',
		'gtSession'
	],
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #'instance creation' }
GtRsrEvaluatorPromise class >> rsrPromise: aPromise serializationStrategy: aSymbol gtSession: aSession autoCommit: autoCommit [

	^ self new
		setPromise: aPromise
		strategy: aSymbol
		session: aSession
		autoCommit: autoCommit
]

{ #category : #testing }
GtRsrEvaluatorPromise >> isBroken [

	^ rsrPromise isBroken
]

{ #category : #private }
GtRsrEvaluatorPromise >> registerAutoCommit [
	"Register a notification action with the {{gtClass:RsrPromise}} to autoCommit on success"

	AkgContextStackSignal emit.
	rsrPromise
		when: [ :value | gtSession autoCommitPromise: self ]
		catch: [ :value | ].
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> rsrPromise [

	^ rsrPromise
]

{ #category : #initialization }
GtRsrEvaluatorPromise >> setPromise: aPromise strategy: aSymbol session: aSession autoCommit: autoCommit [

	rsrPromise := aPromise.
	serializationStrategy := aSymbol.
	gtSession := aSession.
	autoCommit ifTrue: [ self registerAutoCommit ].
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> value [

	^ self wait
]

{ #category : #accessing }
GtRsrEvaluatorPromise >> wait [
	<gemstoneDebuggerSignal>
	| result |

	result := rsrPromise wait.
	gtSession ifNotNil:
		[ result gtPharoProxyInitializeWithSession: gtSession ].
	(result class = GtpoGtRsrEvaluationExceptionInformation) ifTrue: 
		[ | exception |
		 exception := GtRsrEvaluationException new
			originalException: (result proxyPerform: #exception);
			process: (result proxyPerform: #process).
		exception signal ].
	serializationStrategy ifNotNil:
		[ result := (self class environment at: serializationStrategy) new 
			deserialize: result.
		gtSession ifNotNil:
			[ result gtPharoProxyInitializeWithSession: gtSession ] ].
	^ result
]

{ #category : #testing }
GtRsrEvaluatorPromise >> waitForResolution [

	rsrPromise waitForResolution
]
