Class {
	#name : #GtGemStoneGciConnector,
	#superclass : #GtGemStoneConnector,
	#instVars : [
		'stone',
		'netldi',
		'username',
		'password',
		'hostUsername',
		'hostPassword',
		'libraryPath',
		'gemstoneVersion'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneGciConnector class >> defaultGemStoneVersion [

	^ OSPlatform current isLinux
		ifTrue: [ '3.7.1.4' ]
		ifFalse: [ '3.7.1' ]
]

{ #category : #accessing }
GtGemStoneGciConnector >> computeGsSessionsParameters [
	"Compute sessions prameters as it will be done by GsSession"
	^GsSessionParameters 
		newForStoneName: self stone 
		host: self host 
		netldi: self netldi .
]

{ #category : #connecting }
GtGemStoneGciConnector >> connectionForSession: aGsSession [
	"Answer the RsrConnection associated with the supplied session"
	<return: #RsrConnection>

	^ self setupRsrConnection: aGsSession
]

{ #category : #accessing }
GtGemStoneGciConnector >> gemstoneVersion [
	^ gemstoneVersion
]

{ #category : #accessing }
GtGemStoneGciConnector >> gemstoneVersion: anObject [
	gemstoneVersion := anObject
]

{ #category : #ui }
GtGemStoneGciConnector >> gtLiveFor: aView [
	<gtView>

	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ (GtGemStoneGciConnectorWidget 
			onConnector: self
			propertiesFile: self propertiesFile )
				padding: (BlInsets all: 5) ]
]

{ #category : #accessing }
GtGemStoneGciConnector >> hostPassword [
	^ hostPassword
]

{ #category : #accessing }
GtGemStoneGciConnector >> hostPassword: anObject [
	hostPassword := anObject
]

{ #category : #accessing }
GtGemStoneGciConnector >> hostUsername [
	^ hostUsername
]

{ #category : #accessing }
GtGemStoneGciConnector >> hostUsername: anObject [
	hostUsername := anObject
]

{ #category : #initialization }
GtGemStoneGciConnector >> initialize [

	super initialize.
	stone := 'gs64stone'.
	netldi := 'gs64ldi'.
	username := 'DataCurator'.
	password := 'swordfish'.
	libraryPath := '/path/to/GemStone/client/libraries' asFileReference.
	gemstoneVersion := self class defaultGemStoneVersion.
]

{ #category : #accessing }
GtGemStoneGciConnector >> libraryPath [
	<return: #FileReference>

	^ libraryPath
]

{ #category : #accessing }
GtGemStoneGciConnector >> libraryPath: aFileReference [

	libraryPath := aFileReference
]

{ #category : #private }
GtGemStoneGciConnector >> loggedInSession [
	<return: #GsSession>
	| session |

	session := GsSession
		newForGsVersion: self gemstoneVersion
		threadSafe: true
		stone: self stone
		host: self host
		netldi: self netldi.
	session sessionParameters gemResource 
		name: self serviceName.
		
	session 
		loginWithGsUser: username 
		password: password 
		hostUserId: hostUsername 
		hostPassword: hostPassword.
	
	^ session
]

{ #category : #accessing }
GtGemStoneGciConnector >> netldi [
	^ netldi
]

{ #category : #accessing }
GtGemStoneGciConnector >> netldi: anObject [
	netldi := anObject
]

{ #category : #connecting }
GtGemStoneGciConnector >> newSession [
	"Answer the session defined by the receiver"
	<return: #GsSession>

	GciInterface libraryDirectory: libraryPath fullName.
	^ self loggedInSession. 
]

{ #category : #accessing }
GtGemStoneGciConnector >> password [
	^ password
]

{ #category : #accessing }
GtGemStoneGciConnector >> password: anObject [
	password := anObject
]

{ #category : #private }
GtGemStoneGciConnector >> setupRsrConnection: gsSession [
	<return: #RsrConnection>
	| detailBytes initiator thePort token |

	detailBytes := gsSession executeStringAndFetchResultByteArray:
		'| acceptor port detailBytes |
		acceptor := RsrGciAcceptConnection portRange: (10800 to: 10805).
		acceptor ensureListening.
		SessionTemps current
			at: #PendingConnectionAcceptor
			put: acceptor.
		port := acceptor listeningPort.
		detailBytes := ByteArray new: 18.
		detailBytes unsigned16At: 1 put: port.
		detailBytes
			replaceFrom: 3
			to: 18
			with: acceptor token bytes.
		detailBytes'
			maxResultSize: 1024.
	gsSession executeStringAndDetachNb: '| connection resolverClass |
		connection := (SessionTemps current at: #PendingConnectionAcceptor) waitForConnection.
		SessionTemps current removeKey: #PendingConnectionAcceptor.
		"UNCOMMENT THESE LINES TO ADD TRACING TO RSR"
		"connection log addSink: (RsrCustomSink action: [:message | GsFile gciLogServer: message ]).
		connection log verbosity: connection log levelTrace."
		
		"Add a merker indicating that the GemStone session was started from GT."
		SessionTemps current at: #GT_GEMSTONE_SESSION_MARKER put: true.
		
		GsFile gciLogServer: ''about to waitUntilClose''.
		connection waitUntilClose.'.
	thePort := detailBytes unsignedShortAt: 1 bigEndian: true.
	token := RsrToken bytes: (detailBytes copyFrom: 3 to: 18).
	initiator := RsrGciInitiateConnection host: host port: thePort token: token.
	^ initiator connect
]

{ #category : #accessing }
GtGemStoneGciConnector >> stone [
	^ stone
]

{ #category : #accessing }
GtGemStoneGciConnector >> stone: anObject [
	stone := anObject
]

{ #category : #accessing }
GtGemStoneGciConnector >> username [
	^ username
]

{ #category : #accessing }
GtGemStoneGciConnector >> username: anObject [
	username := anObject
]
