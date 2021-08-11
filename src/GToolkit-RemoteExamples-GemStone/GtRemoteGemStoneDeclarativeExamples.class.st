Class {
	#name : 'GtRemoteGemStoneDeclarativeExamples',
	#superclass : 'GtRemoteDeclarativeExamples',
	#category : 'GToolkit-RemoteExamples-GemStone'
}

{ #category : 'private' }
GtRemoteGemStoneDeclarativeExamples >> getRemoteObject [

	^ self runningServer evaluateAndWait: self remoteObjectCommand
]

{ #category : 'private' }
GtRemoteGemStoneDeclarativeExamples >> getViewedObjectProxy [
	"Answer the GtViewedObject proxy for the remote object"
	
	self remoteObject viewProxyDo: [ :aProxy | ^ aProxy ].

]

{ #category : 'private - commands' }
GtRemoteGemStoneDeclarativeExamples >> listViewDisplayArray [
	"Answer the command Array returned by the remote's list view"

	^ #('42' 'Hello World' '2021-04-06T14:43:49.623384+02:00')
]

{ #category : 'private - commands' }
GtRemoteGemStoneDeclarativeExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self testInspectableName, ' new'
]

{ #category : 'private' }
GtRemoteGemStoneDeclarativeExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	<gtExample>
	<after: #stopServer>
	| connector libraryDirectory |

	server ifNotNil: [ ^ server ].
	"Connect to the GemStone DB"
	libraryDirectory := FileLocator imageDirectory / 'remote-gemstone'.
	self assert: libraryDirectory isDirectory.
	connector := GtGemStoneGciConnector new
		gemstoneVersion: '3.7.0';
		libraryPath: libraryDirectory fullName;
		host: 'localhost';
		netldi: 'gs64ldi';
		stone: 'gs64stone';
		username: 'SystemUser';
		password: 'swordfish'.
	server := GtGemStoneClient new connector: connector.
	^ server connect.
]

{ #category : 'tests' }
GtRemoteGemStoneDeclarativeExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ #GtRemotePhlowDeclarativeTestInspectable
]
