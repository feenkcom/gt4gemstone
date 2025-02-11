Trait {
	#name : #TGtRemoteGemStoneSesionCreator,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'examples - server' }
TGtRemoteGemStoneSesionCreator >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/<GemStone version>"
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #'as yet unclassified' }
TGtRemoteGemStoneSesionCreator >> stopServer [ 

	server ifNotNil: [ 
		server stop.
		server := nil ]
]
