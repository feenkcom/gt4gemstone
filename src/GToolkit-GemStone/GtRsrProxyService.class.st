Class {
	#name : 'GtRsrProxyService',
	#superclass : 'RsrService',
	#instVars : [
		'remoteClass'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'accessing' }
GtRsrProxyService class >> templateClassName [

	^ #GtRsrProxyService
]

{ #category : 'testing' }
GtRsrProxyService >> isFunctional [
	"Answer a boolean indicating whether the receiver is expected to be functioning,
	i.e. it has a connection that is open, and it's connection is the current one."

	_connection ifNil: [ ^ false ].
	_connection isOpen ifFalse: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
GtRsrProxyService >> remoteClass [
	"Answer the name of the class of the remote object"

	^ remoteClass
]

{ #category : 'accessing' }
GtRsrProxyService >> remoteClass: aSymbol [
	"Set the name of the class of the remote object"

	remoteClass := aSymbol
]
