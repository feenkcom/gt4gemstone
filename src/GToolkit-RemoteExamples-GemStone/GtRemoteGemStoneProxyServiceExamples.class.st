Class {
	#name : 'GtRemoteGemStoneProxyServiceExamples',
	#superclass : 'Object',
	#instVars : [
		'server',
		'connector'
	],
	#category : 'GToolkit-RemoteExamples-GemStone'
}

{ #category : 'private' }
GtRemoteGemStoneProxyServiceExamples >> getRemoteObject [

	^ self runningServer evaluateAndWait: self remoteObjectCommand
]

{ #category : 'private' }
GtRemoteGemStoneProxyServiceExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self testInspectableName, ' new'
]

{ #category : 'private' }
GtRemoteGemStoneProxyServiceExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	<gtExample>
	<after: #stopServer>
	| libraryDirectory |

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

{ #category : 'server - basic' }
GtRemoteGemStoneProxyServiceExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].
	connector ifNotNil: [ 
		connector currentSession logout ]
]

{ #category : 'tests' }
GtRemoteGemStoneProxyServiceExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ #GtRemotePhlowDeclarativeTestInspectable
]

{ #category : 'tests' }
GtRemoteGemStoneProxyServiceExamples >> testOrderedCollectionProxyMessageSends [
	<gtExample>
	| collectionProxy size |
	
	collectionProxy := self runningServer 
		evaluateAndWait: 'OrderedCollection withAll: #(1 6 3 4)'.
	
	size := collectionProxy proxyPerform: #size.
	self assert: size equals: 4.
	
	self 
		assert: (collectionProxy proxyPerform: #gtDisplayString)
		equals: 'anOrderedCollection( 1, 6, 3, 4)'.
		
	self 
		assert: (collectionProxy proxyPerform: #includes: withArguments: {1}).
	self 
		assert: (collectionProxy proxyPerform: #includes: withArguments: {5}) not.
		
	self 
		assert: (collectionProxy proxyPerform: #at: withArguments: {2})
		equals: 6.
	
	^ collectionProxy
]

{ #category : 'tests' }
GtRemoteGemStoneProxyServiceExamples >> testSetProxyMessageSends [
	<gtExample>
	| setProxy size |
	
	setProxy := self runningServer 
		evaluateAndWait: 'Set withAll: #(1 2 3 4)'.
	
	size := setProxy proxyPerform: #size.
	self assert: size equals: 4.
	
	self 
		assert: (setProxy proxyPerform: #gtDisplayString)
		equals: 'aSet( 3, 1, 4, 2)'.
		
	self 
		assert: (setProxy proxyPerform: #includes: withArguments: {1}).
	self 
		assert: (setProxy proxyPerform: #includes: withArguments: {5}) not.
	
	^ setProxy
]
