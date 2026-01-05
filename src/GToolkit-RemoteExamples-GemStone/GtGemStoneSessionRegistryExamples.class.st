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
	<return: #GtGemStoneSessionRegistry>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	"Extension methods allow the registry to be auto-populated with connectors.
	Explicitly set the connectors to prevent the auto-population."
	registry initializeConnectors: Dictionary new.
	self assert: registry activeSessions size equals: 0.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> emptyRegistry_newSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry newSession connector |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	newSession := registry newSessionWithReusageWithConnector: connector.
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
	<return: #AssertionFailure>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	existingSession := registry
			createNewSessionWithConnector: connector
			id: 'default'.
	existingSession connect.

	newSession := registry newSessionWithReusageWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:1'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == existingSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithConnectedNonDefaultSession_newSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	existingSession := registry createNewSessionWithConnector: connector id: '1'.
	existingSession connect.

	newSession := registry newSessionWithReusageWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == existingSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDefaultNotConnectedSecondSessionConnected_newDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry connector sessionDefault sessionOne newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	sessionDefault := registry
			createNewSessionWithConnector: connector
			id: 'default'.
	sessionOne := registry createNewSessionWithConnector: connector id: '1'.
	sessionOne connect.
	sessionOne beDefaultSession.

	newSession := registry
			newConnectedDefaultSessionWithReusageWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == newSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDefaultNotConnectedSecondSessionConnected_newSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry connector sessionDefault sessionOne newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	sessionDefault := registry
			createNewSessionWithConnector: connector
			id: 'default'.
	sessionOne := registry createNewSessionWithConnector: connector id: '1'.
	sessionOne connect.

	newSession := registry newSessionWithReusageWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == sessionOne.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDefaultNotConnectedSecondSessionCurrentNotConnected_newDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry connector sessionDefault sessionOne newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	sessionDefault := registry
			createNewSessionWithConnector: connector
			id: 'default'.
	sessionOne := registry createNewSessionWithConnector: connector id: '1'.
	sessionOne beDefaultSession.

	newSession := registry
			newConnectedDefaultSessionWithReusageWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == newSession.

	^ registry
]

{ #category : #'examples - session creation' }
GtGemStoneSessionRegistryExamples >> registryWithDisconnectedDefaultSession_newSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	existingSession := registry
			createNewSessionWithConnector: connector
			id: 'default'.

	newSession := registry newSessionWithReusageWithConnector: connector.
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
	<return: #AssertionFailure>
	| registry connector existingSession newSession |
	registry := self sessionRegistryWithTestConnector.
	connector := registry connectors anyOne.

	existingSession := registry createNewSessionWithConnector: connector id: '1'.

	newSession := registry newSessionWithReusageWithConnector: connector.
	self assert: newSession isRunning.
	self assert: newSession name equals: 'test:default'.
	self assert: registry sessions size equals: 2.
	self assert: registry defaultSession == newSession.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_addSecondConnectedSession_doesNotChangeDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry firstSession secondSession |
	registry := self registry_oneConnectedSession_setsDefaultSession.

	firstSession := registry activeSessions anyOne.
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.

	secondSession registry: registry.
	self assert: secondSession name equals: 'test:1'.
	registry addSession: secondSession.
	self assert: registry defaultSession == firstSession.
	self assert: registry activeSessions size equals: 2.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneConnectedSession_disconnectOnlySession_removesDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
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
	<return: #AssertionFailure>
	| registry session |
	registry := self sessionRegistry.

	self assert: registry defaultSession isNil.
	session := self createSessionForExampleWithId: 'default'.
	session connect.
	self assert: session isRunning.
	self assert: registry defaultSession isNil.

	session registry: registry.
	registry addSession: session.
	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry |
	registry := self registry_oneConnectedSession_setsDefaultSession.

	self assert: registry defaultSession isNotNil.	"We simulate a disconnect of the default session"
	registry defaultSession connection close.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession_addNewConnectedSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry firstSession secondSession |
	registry := self registry_oneDisconnectedDefaultSession.

	firstSession := registry activeSessions anyOne.
	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.

	secondSession registry: registry.
	registry addSession: secondSession.

	self assert: registry defaultSession == secondSession.
	self assert: registry activeSessions size equals: 2.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedDefaultSession_reconnect [
	<gtExample>
	<return: #AssertionFailure>
	| registry session |
	registry := self registry_oneDisconnectedDefaultSession.

	session := registry defaultSession.
	self assert: session isNotNil.
	self assert: session isRunning not.	"We simulate a disconnect of the default session"
	session connect.

	self assert: registry defaultSession == session.
	self assert: registry activeSessions size equals: 1.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_addSecondConnectedSession_changeDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry secondSession |
	registry := self registry_oneDisconnectedSession_noDefaultSession.

	secondSession := self createSessionForExampleWithId: '1'.
	secondSession connect.
	self assert: secondSession isRunning.

	secondSession registry: registry.
	registry addSession: secondSession.
	self assert: registry defaultSession == secondSession.
	self assert: registry activeSessions size equals: 2.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_addSecondDisconnectedSession_doesNotChangeDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
	| registry secondSession |
	registry := self registry_oneDisconnectedSession_noDefaultSession.

	secondSession := self createSessionForExampleWithId: '1'.
	self assert: secondSession isRunning not.

	secondSession registry: registry.
	registry addSession: secondSession.
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 2.

	^ registry
]

{ #category : #'examples - default session' }
GtGemStoneSessionRegistryExamples >> registry_oneDisconnectedSession_connectInitialDisconnectedSession_setsDefaultSession [
	<gtExample>
	<return: #AssertionFailure>
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
	<return: #AssertionFailure>
	| registry session |
	registry := self sessionRegistry.

	self assert: registry defaultSession isNil.
	session := self createSessionForExampleWithId: 'default'.
	self assert: session isRunning not.

	session registry: registry.
	registry addSession: session.
	self assert: registry defaultSession isNil.
	self assert: registry activeSessions size equals: 1.

	^ registry
]

{ #category : #'examples - sessions context menu' }
GtGemStoneSessionRegistryExamples >> registry_sessionsView_connectedSession_contextMenuActions_abort_clickMenu [
	<gtExample>
	<return: #AssertionFailure>
	| scripter session |
	scripter := self
			registry_sessionsView_connectedSession_contextMenuActions_abort_openMenu.
	session := scripter model activeSessions first.

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert session status: Connected, changed';
				// GtPhlowCellElement;
				@ 2;
				value: [ :aCellElement | aCellElement content text asString ]
					equals: 'Connected, changed' ].

	scripter
		secondaryClickStep: [ :s | 
			s
				label: 'Open context menu';
				// GtPhlowCellElement;
				@ 1 ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click Abort menu';
				onSpaceRoot;
				onDropdown: true;
				// BrLabel;
				@ [ :each | each text asString = 'Abort' ] ].

	self assert: session needsCommit not.
	self assert: session statusDescription equals: 'Connected'.
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert session status: Connected';
				// GtPhlowCellElement;
				@ 2;
				value: [ :aCellElement | aCellElement content text asString ]
					equals: 'Connected' ].

	^ scripter
]

{ #category : #'examples - sessions context menu' }
GtGemStoneSessionRegistryExamples >> registry_sessionsView_connectedSession_contextMenuActions_abort_openMenu [
	<gtExample>
	<return: #AssertionFailure>
	| registry scripter session |
	registry := self registry_oneConnectedSession_setsDefaultSession.

	session := registry activeSessions first.
	self assert: session isRunning.
	self assert: session statusDescription equals: 'Connected'.

	session
		evaluateBlockAndWaitReturnProxy: [ GtGsRelease
				compileMethod: 'forTestingOnly
			^ 1'
				category: #test
				environmentId: 0 ].

	self assert: session statusDescription equals: 'Connected, changed'.
	self assert: session needsCommit.

	scripter := BlScripter new
			model: registry;
			element: registry gtDefaultInspectorTool asElement.

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert session status: Connected, changed';
				// GtPhlowCellElement;
				@ 2;
				value: [ :aCellElement | aCellElement content text asString ]
					equals: 'Connected, changed' ].

	scripter
		secondaryClickStep: [ :s | 
			s
				label: 'Open context menu';
				// GtPhlowCellElement;
				@ 1 ].

	^ scripter
]

{ #category : #'examples - sessions context menu' }
GtGemStoneSessionRegistryExamples >> registry_sessionsView_connectedSession_contextMenuActions_disconnect [
	<gtExample>
	<return: #AssertionFailure>
	| registry scripter session |
	registry := self registry_oneConnectedSession_setsDefaultSession.

	session := registry activeSessions first.
	self assert: session isRunning.
	self assert: session statusDescription equals: 'Connected'.

	scripter := BlScripter new
			model: registry;
			element: registry gtDefaultInspectorTool asElement.

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert session status: Connected';
				// GtPhlowCellElement;
				@ 2;
				value: [ :aCellElement | aCellElement content text asString ]
					equals: 'Connected' ].

	scripter
		secondaryClickStep: [ :s | 
			s
				label: 'Open context menu';
				// GtPhlowCellElement;
				@ 1 ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click disconnect menu';
				onSpaceRoot;
				onDropdown: true;
				// BrLabel;
				@ [ :each | each text asString = 'Disconnect' ] ].

	self assert: session isRunning not.

	self assert: session statusDescription equals: 'Disconnected'.
	scripter
		assertStep: [ :s | 
			s
				notExists;
				label: 'Assert session status: Disconnected';
				// GtPhlowCellElement ].

	^ scripter
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> sessionRegistry [
	"Answer an empty session registry"

	<gtExample>
	<after: #clearGemStoneRegistry>
	<return: #GtGemStoneSessionRegistry>
	^ theSessionRegistry
		ifNil: [ theSessionRegistry := self createSessionRegistry ]
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionRegistryExamples >> sessionRegistryWithTestConnector [
	"Answer an empty session registry"

	<gtExample>
	<return: #AssertionFailure>
	| registry connector |
	registry := self sessionRegistry.
	connector := GtRemoteGemstoneExamplesSessionBuilder
			createConnectorNamed: 'test'.
	registry connectors at: connector name put: connector.
	^ registry
]
