Class {
	#name : #GtRsrInspectorProxyDataSerializationStrategy,
	#superclass : #GtRsrSerializationStrategy,
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrInspectorProxyDataSerializationStrategy >> deserialize: anObject [
	
	^ anObject
]

{ #category : #accessing }
GtRsrInspectorProxyDataSerializationStrategy >> serialize: anObject [
	"Called from GemStone. We defined is also for GT as it does not references GemStone specific classes"
	| inspectorWrapper |
	inspectorWrapper := GtRemotePhlowViewedObject object: anObject.
	^ self serializedDataForInspectorWrapper: inspectorWrapper
]

{ #category : #accessing }
GtRsrInspectorProxyDataSerializationStrategy >> serializedDataForInspectorWrapper: anInspectorWrapper [
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
