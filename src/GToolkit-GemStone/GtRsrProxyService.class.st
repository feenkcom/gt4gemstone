Class {
	#name : 'GtRsrProxyService',
	#superclass : 'RsrService',
	#instVars : [
		'remoteClass'
	],
	#category : 'GToolkit-GemStone'
}

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
