Extension { #name : #GtRsrDirectLocalObjectSerializationStrategy }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtRsrDirectLocalObjectSerializationStrategy >> deserialize: objectDictionaryData [
	"Deserialize the supplied object"
	| localObject bareProxy  |

	localObject := (self class environment at: (objectDictionaryData
		at: '__remoteClassName')) basicNew.
	bareProxy := (objectDictionaryData at: '__remoteInstance') asGtBareProxyObject.
	
	objectDictionaryData associationsDo: [ :assoc |
		(#('__remoteInstance' '__remoteClassName') includes: assoc key)
			ifFalse: [
				localObject 
					instVarNamed: assoc key 
					put: assoc value asGtBareProxyObject ] ].
			
	GtRsrProxyServiceClient proxyObjectMap 
		at: localObject put: bareProxy.
	
	^ localObject.
]
