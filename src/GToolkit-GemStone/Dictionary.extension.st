Extension { #name : 'Dictionary' }

{ #category : '*GToolkit-GemStone' }
Dictionary >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver with unsupported (non-immediate) objects converted to GtRsrProxyServiceServers.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet.
	For Dictionaries, for now all keys must be immediate."

	^ GtRsrProxyServiceServer object: self
]
