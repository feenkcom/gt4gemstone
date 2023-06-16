Class {
	#name : #GtRemoteGemStoneInspectionExamples,
	#superclass : #GtProxyRemoteInspectionExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertBothSidesInspectionForProxy: aProxyObject [ 
	| inspectorTool scripter |
	
	inspectorTool := self 
		compositeInspectorToolForBothProxySidesForProxy: aProxyObject 
		withDatabase: self databaseWithMonitor.
		
	scripter := self scripter.
	scripter
		model: inspectorTool object;
		element: inspectorTool asElement.
	
	self assertCompositeInspectorToolUsing: scripter.
	
	^ scripter
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertObjectInspectionFor: codeString [
	| proxyObject |
	
	proxyObject := (self runningServer 
		evaluateAndWait: codeString)
			asGtBareProxyObject.
	
	^ self assertObjectInspectionForProxy: proxyObject.
]

{ #category : #'asserting - inspection' }
GtRemoteGemStoneInspectionExamples >> assertObjectInspectionForProxy: aProxyObject [
	^ self assertBothSidesInspectionForProxy: aProxyObject
]

{ #category : #accessing }
GtRemoteGemStoneInspectionExamples >> currentProxyTypeName [
	^ #GtGsBareProxy
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> dictionaryWithObjectKeysInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self assertObjectInspectionFor: 'Dictionary new
		at: Object new put: 1;
		at: Object new put: 2;
		yourself'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptyOrderedCollectionInspection [
	<gtExample>
	<after: #stopServer>
	
	^ self assertObjectInspectionFor: 'OrderedCollection new'
]

{ #category : #'examples - objects' }
GtRemoteGemStoneInspectionExamples >> emptySetInspection [
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
