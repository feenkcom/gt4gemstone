Class {
	#name : 'LeGemStoneSettings',
	#superclass : 'LeSubSettings',
	#category : 'GToolkit-GemStone-Lepiter-Settings'
}

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> connectionType [
	"Answer the host name string of the GemStone connection type: 'GCI' or 'direct'"
	<return: #String>

	^ self subProperties at: #connectionType ifAbsent: [ #GCI ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> connectionType: aString [
	"Set the connectionType for the GemStone server"

	(#(GCI direct) includes: aString) ifFalse: 
		[ self error: 'Invalid connectionType: ', aString printString ].
	self updateProperty: #connectionType value: aString
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> gemstoneVersion [
	"Answer the GemStone version string.
	Will be nil if the connection type is direct"
	<return: #String or: nil>

	^ self subProperties at: #gemstoneVersion ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> gemstoneVersion: aStringOrNil [
	"Set the GemStone version for the GemStone server.
	Will be nil if the connection type is direct"

	self updateProperty: #gemstoneVersion value: aStringOrNil
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> host [
	"Answer the host name string of the GemStone server"
	<return: #String or: nil>

	^ self subProperties at: #host ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> host: aStringOrNil [
	"Set the host string of the GemStone server"

	self updateProperty: #host value: aStringOrNil
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> hostPassword [
	"Answer the host password string"
	<return: #String or: nil>

	^ self subProperties at: #hostPassword ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> hostPassword: aStringOrNil [
	"Set the host password for the GemStone server"

	self updateProperty: #hostPassword value: aStringOrNil
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> hostUsername [
	"Answer the host name string.
	Will be nil for direct connections."
	<return: #String or: nil>

	^ self subProperties at: #hostUsername ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> hostUsername: aStringOrNil [
	"Set the host  username for the GemStone server.
	Will be nil for direct connections."

	self updateProperty: #hostUsername value: aStringOrNil
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> libraryPath [
	"Answer the path to the client libraries"
	<return: #String or: nil>

	^ self subProperties at: #libraryPath ifAbsent: [ FileLocator imageDirectory ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> libraryPath: aFileReferenceStringOrNil [
	"Set the path to the GemStone client libraries.
	nil = default.
	Note that GemStone currently expects the path to be:
	/path/to/3.7.0/64bit.
	The '3.7.0/64bit' relative path is automatically added, so the supplied fileReference / string is the parent directory, i.e. the '/path/to' prefix."

	self updateProperty: #libraryPath 
		value: (dbProperties fileReferenceString: aFileReferenceStringOrNil)
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> netldi [
	"Answer the NetLDI service name or port.
	Will be nil if the connection type is direct"
	<return: #String or: nil>

	^ self subProperties at: #netldi ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> netldi: aStringOrNil [
	"Set the NetLDI service name or port for the GemStone server.
	Will be nil for direct connections."

	self updateProperty: #netldi value: aStringOrNil
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> password [
	"Answer the password string.
	Will be nil if the connection type is direct"
	<return: #String or: nil>

	^ self subProperties at: #password ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> password: aStringOrNil [
	"Set the password for the GemStone server.
	Will be nil if the connection type is direct"

	self updateProperty: #password value: aStringOrNil
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> port [
	"Answer the host port number of the GemStone server.
	Will be nil for GCI connections."
	<return: #Integer or: nil>

	^ self subProperties at: #port ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> port: anIntegerOrNil [
	"Set the port number of the GemStone server.
	Will be nil for GCI connections"

	self updateProperty: #port value: anIntegerOrNil 
]

{ #category : 'ui' }
LeGemStoneSettings >> settingsNames [

	^ #(connectionType gemstoneVersion libraryPath host port stone netldi username password hostUsername hostPassword)
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> stone [
	"Answer the stone name string.
	Will be nil for direct connections"
	<return: #String or: nil>

	^ self subProperties at: #stone ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> stone: aStringOrNil [
	"Set the stone name for the GemStone server.
	Will be nil for direct connections."

	self updateProperty: #stone value: aStringOrNil
]

{ #category : 'private - accessing' }
LeGemStoneSettings >> subProperties [

	^ dbProperties gemStone
]

{ #category : 'private - accessing' }
LeGemStoneSettings >> subProperties: aDictionary [

	dbProperties gemStone: aDictionary
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> username [
	"Answer the host name string.
	Will be nil if the connection type is direct"
	<return: #String or: nil>

	^ self subProperties at: #username ifAbsent: [ nil ]
]

{ #category : 'accessing - db properties' }
LeGemStoneSettings >> username: aStringOrNil [
	"Set the username for the GemStone server.
	Will be nil if the connection type is direct"

	self updateProperty: #username value: aStringOrNil
]
