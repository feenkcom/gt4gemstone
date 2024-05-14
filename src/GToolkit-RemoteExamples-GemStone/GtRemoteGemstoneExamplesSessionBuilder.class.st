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
GtRemoteGemstoneExamplesSessionBuilder >> createConnector [
	^ self createConnectorNamed: nil
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createConnectorNamed: aConnectorName [
	| connector libraryDirectory netldi |

	"Connect to the GemStone DB"
	libraryDirectory := FileLocator imageDirectory / 'remote-gemstone'.
	netldi := 'gs64ldi'.
	libraryDirectory isDirectory ifFalse:
		[ | aConnector |
		aConnector := GtGemStoneSessionRegistry default propertiesFile allConnectors anyOne.
		libraryDirectory := aConnector libraryPath.
		netldi := aConnector netldi ].
	self assert: libraryDirectory isDirectory.
	
	connector := GtGemStoneGciConnector new
		gemstoneVersion: '3.7.1';
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
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	| connector |
	
	connector := self createConnector.
	
	^ GtGemStoneSession new 
		connector: connector
]
