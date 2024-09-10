Class {
	#name : #GtGemStoneCoderExecutionAlreadyRunningException,
	#superclass : #Error,
	#instVars : [
		'sessionName'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneCoderExecutionAlreadyRunningException >> description [
	^ messageText ifNil: [ ^ self defaultDescription ].
]

{ #category : #'gt - extensions' }
GtGemStoneCoderExecutionAlreadyRunningException >> gtViewExplanationFor: aView [
	<gtEmbeddedDebuggerView>
	
	^ aView text
		title: 'Explanation';
		text: [ 'A user computation is already running in the session {1}. There cannot be two user computations running at the same time in the same session.'
			format: {sessionName} ]
]

{ #category : #initialization }
GtGemStoneCoderExecutionAlreadyRunningException >> initialize [
	super initialize.
	
	messageText := 'Computation Already Running'.
]

{ #category : #accessing }
GtGemStoneCoderExecutionAlreadyRunningException >> sessionName: aSessionName [
	sessionName := aSessionName
]
