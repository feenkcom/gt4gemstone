Class {
	#name : #GtRemoteGemstoneForwarderViewExamples,
	#superclass : #GtRemoteForwarderViewInspectionExamples,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GtRemoteGemstoneForwarderViewExamples >> computeObject [
	<gtExample>
	^ self runningServer 
		evaluateAndWait: 'GtRemotePhlowDeclarativeTestInspectable new'
]

{ #category : #'examples - server' }
GtRemoteGemstoneForwarderViewExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'tear down' }
GtRemoteGemstoneForwarderViewExamples >> stopServer [ 

	server ifNotNil: [ 
		server stop.
		server := nil ]
]

{ #category : #accessing }
GtRemoteGemstoneForwarderViewExamples >> targetProxyClass [
	^ GspoGtRemotePhlowDeclarativeTestInspectable
]
