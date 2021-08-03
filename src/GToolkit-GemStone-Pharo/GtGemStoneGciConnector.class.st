Class {
	#name : 'GtGemStoneGciConnector',
	#superclass : 'GtGemStoneConnector',
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
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : 'actions' }
GtGemStoneGciConnector >> connect [
	"Connect to the server and answer the connection"
	<return: #RsrConnection>

	GciInterface libraryDirectory: libraryPath.
	^ self setupRsrConnection: self loggedInSession.

]

{ #category : 'accessing' }
GtGemStoneGciConnector >> gemstoneVersion [
	^ gemstoneVersion
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> gemstoneVersion: anObject [
	gemstoneVersion := anObject
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> hostPassword [
	^ hostPassword
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> hostPassword: anObject [
	hostPassword := anObject
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> hostUsername [
	^ hostUsername
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> hostUsername: anObject [
	hostUsername := anObject
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> libraryPath [
	^ libraryPath
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> libraryPath: anObject [
	libraryPath := anObject
]

{ #category : 'private' }
GtGemStoneGciConnector >> loggedInSession [
	<return: #GsSession>
	| session |

	session := GsSession
		           newForGsVersion: gemstoneVersion
		           threadSafe: true
		           stone: stone
		           host: host
		           netldi: netldi.
	session loginWithGsUser: username password: password hostUserId: hostUsername hostPassword: hostPassword.
	^ session
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> netldi [
	^ netldi
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> netldi: anObject [
	netldi := anObject
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> password [
	^ password
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> password: anObject [
	password := anObject
]

{ #category : 'private' }
GtGemStoneGciConnector >> setupRsrConnection: gsSession [
	<return: #RsrConnection>
	| detailBytes initiator thePort token |

	detailBytes := gsSession executeStringAndFetchResultByteArray:
		'| acceptor port detailBytes |
		acceptor := RsrGciAcceptConnection port: RsrAcceptConnection wildcardPort.
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
	gsSession executeStringNb: '| connection |
		connection := (SessionTemps current at: #PendingConnectionAcceptor) waitForConnection.
		SessionTemps current removeKey: #PendingConnectionAcceptor.
		connection waitUntilClose.'.
	thePort := detailBytes unsignedShortAt: 1 bigEndian: true.
	token := RsrToken bytes: (detailBytes copyFrom: 3 to: 18).
	initiator := RsrGciInitiateConnection host: host port: thePort token: token.
	^ initiator connect
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> stone [
	^ stone
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> stone: anObject [
	stone := anObject
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> username [
	^ username
]

{ #category : 'accessing' }
GtGemStoneGciConnector >> username: anObject [
	username := anObject
]
