Extension { #name : 'Set' }

{ #category : '*GToolkit-GemStone' }
Set >> asGtRsrProxyObjectForConnection: aRsrConnection [
	"Answer the receiver as a proxy object.
	To avoid dealing with equality at the moment, always answer as a proxy object.
	Ideally we would look up objects in the connection and use the same proxy, but that isn't happening yet."

	^ GtRsrProxyServiceServer object: self
]
