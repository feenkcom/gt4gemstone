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
GtRemoteGemstoneExamplesSessionBuilder >> createAndStartSession [
	^ self createSession 
		connect;
		yourself
]

{ #category : #accessing }
GtRemoteGemstoneExamplesSessionBuilder >> createSession [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	| connector libraryDirectory |

	"Connect to the GemStone DB"
	libraryDirectory := FileLocator imageDirectory / 'remote-gemstone'.
	self assert: libraryDirectory isDirectory.
	
	connector := GtGemStoneGciConnector new
		gemstoneVersion: '3.7.0';
		libraryPath: libraryDirectory;
		host: 'localhost';
		netldi: 'gs64ldi';
		stone: 'gs64stone';
		username: 'SystemUser';
		password: 'swordfish'.

	^ GtGemStoneSession new 
		connector: connector
]
