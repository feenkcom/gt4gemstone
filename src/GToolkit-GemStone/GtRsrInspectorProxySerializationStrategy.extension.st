Extension { #name : #GtRsrInspectorProxySerializationStrategy }

{ #category : #'*GToolkit-GemStone' }
GtRsrInspectorProxySerializationStrategy >> serialize: anObject [
	"Called from GemStone. We defined is also for GT as it does not references GemStone specific classes"
	| inspectorWrapper |
	inspectorWrapper := GtRemotePhlowViewedObject object: anObject.
	^ self serializedDataForInspectorWrapper: inspectorWrapper
]

{ #category : #'*GToolkit-GemStone' }
GtRsrInspectorProxySerializationStrategy >> serializedDataForInspectorWrapper: anInspectorWrapper [
	"Called from GemStone. We defined is also for GT as it does not references GemStone specific classes"
	| dictionaryData proxyData |
	
	dictionaryData := Dictionary new.
	
	dictionaryData 
		at: 'proxyObject'
		put: anInspectorWrapper.
		
	proxyData := anInspectorWrapper getViewsDeclarationsWithPhlowDataSource.
	dictionaryData 
		at: 'proxyData'
		put: proxyData.
	
	^ dictionaryData asGtRsrProxyObjectForConnection: nil
]
