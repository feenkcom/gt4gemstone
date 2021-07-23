Class {
	#name : 'GtRsrProxyServiceServer',
	#superclass : 'GtRsrProxyService',
	#instVars : [
		'object'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : 'other' }
GtRsrProxyServiceServer class >> object: anObject [

	^ self new object: anObject
]

{ #category : 'accessing' }
GtRsrProxyServiceServer >> object [
	"Answer the object being proxied"

	^ object
]

{ #category : 'accessing' }
GtRsrProxyServiceServer >> object: anObject [
	"Set the object being proxied"

	object := anObject.
	remoteClass := anObject class name.
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerform: aSymbol [

	^ (object perform: aSymbol) asGtRsrProxyObjectForConnection: _connection
]

{ #category : 'performing' }
GtRsrProxyServiceServer >> proxyPerform: aSymbol withArguments: anArray [

	^ (object perform: aSymbol withArguments: anArray) asGtRsrProxyObjectForConnection: _connection
]
