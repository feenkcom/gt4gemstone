Class {
	#name : #GtGemStoneSessionRegistryExamples,
	#superclass : #Object,
	#instVars : [
		'theSessionRegistry'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'tear down' }
GtGemStoneSessionRegistryExamples >> clearGemStoneRegistry [
	theSessionRegistry ifNil: [ ^ self ].
	
	theSessionRegistry sessions copy do: [ :aSession | aSession close ]
]

{ #category : #utils }
GtGemStoneSessionRegistryExamples >> createSessionForExampleWithId: aString [ 
	^ GtGemStoneSession new 
	 	sessionId: aString;
	 	connector: (GtRemoteGemstoneExamplesSessionBuilder 
	 		createConnectorNamed: 'test')
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> createSessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	"registry propertiesFile: self propertiesFile."
	self assert: registry activeSessions size equals: 0.
	
	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> emptyRegistry_newSession [
	<gtExample>
	| registry newSession connector |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 1.
	self assert: registry defaultSession == newSession.
	self assert: registry sessions anyOne == newSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithConnectedDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		createNewSessionWithConnector: connector
		id: 'default'.
	existingSession connect.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:1'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == existingSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithConnectedNonDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		createNewSessionWithConnector: connector
		id: '1'.
	existingSession connect.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == existingSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDisconnectedDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		createNewSessionWithConnector: connector
		id: 'default'.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 1.
	self assert: registry defaultSession == newSession.
	self assert: registry sessions anyOne == newSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDisconnectedNonDefaultSession_newSession [
	<gtExample>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.
	
	existingSession := registry 
		createNewSessionWithConnector: connector
		id: '1'.
	
	newSession := registry newSessionReusedOrDefaultWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == newSession.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_addSecondConnectedSession_doesNotChangeDefaultSession [
	<gtExample>
	| registry firstSession secondSession |
	registry := self registry_oneConnectedSession_setsDefaultSession.
	
	firstSession := registry activeSessions anyOne.
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.
	 
	secondSession registry: registry.
	registry addSession: secondSession named: 'test:1'.
	self assert: registry defaultSession == firstSession.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_disconnectOnlySession_removesDefaultSession [
	<gtExample>
	| registry session |
	registry := self registry_oneConnectedSession_setsDefaultSession.
	
	session := registry activeSessions anyOne.
	session close.
	self assert: session isRunning not.
	 
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 0.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_setsDefaultSession [
	<gtExample>
	| registry session |
	registry := self sessionRegistry.
	
	self assert: registry defaultSession isNil.
	session := self createSessionForExampleWithId: 'default'.
	session connect.
	self assert: session isRunning.
	self assert: registry defaultSession isNil.
	 
	session registry: registry.
	registry addSession: session named: session name.
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession [
	<gtExample>
	| registry |
	registry := self registry_oneConnectedSession_setsDefaultSession.
	
	self assert: registry defaultSession isNotNil.
	"We simulate a disconnect of the default session"
	registry defaultSession connection close.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession_addNewConnectedSession [
	<gtExample>
	| registry firstSession secondSession |
	registry := self registry_oneDisconnectedDefaultSession.
	
	firstSession := registry activeSessions anyOne.
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.
	
	secondSession registry: registry.
	registry addSession: secondSession named: secondSession name.
	
	self assert: registry defaultSession == secondSession.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession_reconnect [
	<gtExample>
	| registry session |
	registry := self registry_oneDisconnectedDefaultSession.
	
	session := registry defaultSession.
	self assert: session isNotNil.
	self assert: session isRunning not.
	
	"We simulate a disconnect of the default session"
	session connect.
	
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_addSecondConnectedSession_changeDefaultSession [
	<gtExample>
	| registry secondSession |
	registry := self registry_oneDisconnectedSession_noDefaultSession.
	
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.
	 
	secondSession registry: registry.
	registry addSession: secondSession named: secondSession name.
	self assert: registry defaultSession == secondSession.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_addSecondDisconnectedSession_doesNotChangeDefaultSession [
	<gtExample>
	| registry secondSession |
	registry := self registry_oneDisconnectedSession_noDefaultSession.
	
	secondSession := self createSessionForExampleWithId: '1'.
	self assert: secondSession isRunning not.
	 
	secondSession registry: registry.
	registry addSession: secondSession named: secondSession name.
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 2.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_connectInitialDisconnectedSession_setsDefaultSession [
	<gtExample>
	| registry session |
	registry := self registry_oneDisconnectedSession_noDefaultSession.
	
	session := registry activeSessions anyOne.
	session connect.
	
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_noDefaultSession [
	<gtExample>
	| registry session |
	registry := self sessionRegistry.
	
	self assert: registry defaultSession isNil.
	session := self createSessionForExampleWithId: 'default'.
	self assert: session isRunning not.
	
	session registry: registry.
	registry addSession: session named: session name.
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 1.
	
	^ registry
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> sessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	<after: #clearGemStoneRegistry>
	
	^ theSessionRegistry ifNil: [
		theSessionRegistry := self createSessionRegistry ]
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> sessionRegistryWithTestConnector [
	"Answer an empty session registry"
	<gtExample>
	
	| registry  connector |
	registry := self sessionRegistry.
	connector := GtRemoteGemstoneExamplesSessionBuilder 
	 	createConnectorNamed: 'test'.
	registry connectors 
		at: connector name
		put: connector.
	^ registry
]
