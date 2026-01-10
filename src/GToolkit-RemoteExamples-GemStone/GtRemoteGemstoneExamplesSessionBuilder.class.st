Class {
	#name : #GtRemoteGemstoneExamplesSessionBuilder,
	#superclass : #Object,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder class >> createAndStartSession [
	^ self new createAndStartSession
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder class >> createAndStartSessionForConnector: aConnector [
	^ self new 
		createAndStartSessionForConnector: aConnector
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder class >> createConnectorNamed: aConnectorName [
	^ self new 
		createConnectorNamed: aConnectorName
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createAndStartSession [
	^ self createSession 
		connect;
		yourself
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createAndStartSessionForConnector: aConnector [
	^ (GtGemStoneSession new 
		connector: aConnector) 
			connect;
			yourself
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createConnector [
	^ self createConnectorNamed: nil
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createConnectorNamed: aConnectorName [
	| namedConnectors connector libraryDirectory netldi |

	namedConnectors := GtGemStoneSessionRegistry default propertiesFile namedConnectors.
	namedConnectors ifNotEmpty:
		[ | anyOne |
		anyOne := namedConnectors anyOne.
		libraryDirectory := anyOne libraryPath.
		netldi := anyOne netldi]
	ifEmpty:
		[ libraryDirectory := FileLocator imageDirectory / 'remote-gemstone'.
		netldi := 'gs64ldi' ].
	self assert: libraryDirectory isDirectory.
	
	connector := GtGemStoneGciConnector new
		gemstoneVersion: GtGemStoneGciConnector defaultGemStoneVersion;
		libraryPath: libraryDirectory;
		host: 'localhost';
		netldi: netldi;
		stone: 'gs64stone';
		username: 'SystemUser';
		password: 'swordfish'.

	aConnectorName ifNotNil: [
		connector name: aConnectorName ].
		
	^ connector
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createSession [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/{gemstoneVersion}"
	| connector newSession |

	connector := self createConnector.

	newSession := GtGemStoneSession new 
		connector: connector.
	connector registry ifNotNil: [ :registry |
		newSession sessionId: (registry
			nextSessionIdForConnector: connector) ].
	^ newSession
]
