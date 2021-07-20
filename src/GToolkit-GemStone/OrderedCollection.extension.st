Extension { #name : 'OrderedCollection' }

{ #category : '*GToolkit-GemStone' }
OrderedCollection >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver with unsupported objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	^ self collect: [ :each | each asGtRsrProxyObjectForConnection: aRsrConnection ]
]
