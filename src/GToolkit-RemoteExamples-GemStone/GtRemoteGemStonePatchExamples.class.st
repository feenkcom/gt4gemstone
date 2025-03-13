Class {
	#name : #GtRemoteGemStonePatchExamples,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'private - helpers' }
GtRemoteGemStonePatchExamples >> runningServer [
	"Answer a connected session.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/<GemStone version>"
	<gtExample>
	<return: #GtGemStoneSession>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #examples }
GtRemoteGemStonePatchExamples >> stonQuoteEncoding [
	<gtExample>
	| encodedString session |

	session := self runningServer.
	(session gt4gemstoneVersion isZero not and:
		[ session gt4gemstoneVersion <= GtGemStoneSemanticVersionNumber v1_0_1501 ]) ifTrue: [ ^ self ].

	encodedString := session
		evaluateAndWait: 'STONJSON toString: ''a''''b'''
		serializationStrategy: #GtRsrWireSerializationStrategy.
	self assert: encodedString equals: '"a''b"'.
]

{ #category : #'private - helpers' }
GtRemoteGemStonePatchExamples >> stopServer [ 

	server ifNotNil: [ 
		server stop.
		server := nil ]
]
