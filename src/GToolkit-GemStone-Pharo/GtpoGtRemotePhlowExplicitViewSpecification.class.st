Class {
	#name : #GtpoGtRemotePhlowExplicitViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#instVars : [
		'q'
	],
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification class >> remoteClassName [
	^#GtRemotePhlowExplicitViewSpecification
]

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification >> flushCachedData [
	^ self proxyPerform: #flushCachedData
]

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification >> retrievePrimitiveStencilData [
	^ self proxyPerform: #retrievePrimitiveStencilData
]

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification >> retrievePrimitiveStencilSpecificationData [
	^ self proxyPerform: #retrievePrimitiveStencilSpecificationData
]

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification >> retrieveStencilDataWithSerializerNamed: aDataSerializationStrategyClassName [
	^ (self 
		proxyPerform: #retrieveStencilData 
		serializationStrategy: aDataSerializationStrategyClassName)
				asGtBareProxyObject
]

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification >> retrieveStencilSpecification [
	| dictionary specification |
	
	dictionary := self retrievePrimitiveStencilSpecificationData.
	specification := GtRemotePhlowAbstractStencilSpecification 
		fromDictionary: dictionary.
	
	^specification
]
