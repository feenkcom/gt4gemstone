Class {
	#name : #GtRemoteGemStoneInspectionExamples,
	#superclass : #GtProxyRemoteInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertBothSidesInspectionForProxy: aProxyObject [ 
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertLocalSideInspectionForProxy: aProxyObject [ 
	| inspectorTool scripter |
	inspectorTool := self 
		inspectorToolForLocalProxySideForProxy: aProxyObject 
		withDatabase: self databaseWithMonitor.
		
	scripter := self scripter.
	scripter
		model: inspectorTool object;
		element: inspectorTool asElement.
	
	self assertInspectorTabLabelsFor: scripter.
	
	^ scripter
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertObjectInspectionFor: codeString [
	| proxyObject |
	
	proxyObject := self runningServer evaluateAndWait: 'Set new'.
	self assertObjectInspectionForProxy: proxyObject.
	"^ self assertRemoteSideInspectionForProxy: proxyObject."
	
	^ proxyObject
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertObjectInspectionForProxy: aProxyObject [
	
	self assertRemoteSideInspectionForProxy: aProxyObject.
	self assertLocalSideInspectionForProxy: aProxyObject.
	self assertBothSidesInspectionForProxy: aProxyObject.
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertRemoteSideInspectionForProxy: aProxyObject [ 
	| inspectorTool scripter |
	inspectorTool := self 
		inspectorToolForRemoteProxySideForProxy: aProxyObject 
		withDatabase: self databaseWithMonitor.
		
	scripter := self scripter.
	scripter
		model: inspectorTool object;
		element: inspectorTool asElement.
	
	self assertInspectorTabLabelsFor: scripter.
	"self assertInspectorTabContentsFor: scripter."
	
	^ scripter
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> currentProxyTypeName [
	^ #GtGsBareProxy
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptySetObjectInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self assertObjectInspectionFor: 'Set new'
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteCodeSnippetType [
	^ LeGemStoneSnippet
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self remoteObjectTypeName, ' new'
]

{ #category : #'examples - server' }
GtRemoteGemStoneInspectionExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #examples }
GtRemoteGemStoneInspectionExamples >> targetProxyObjectForInspection [
	<gtExample>
	
	^ (self runningServer evaluateAndWait: self remoteObjectCommand)
		asGtBareProxyObject
]
