Class {
	#name : #GtpoGtRemotePhlowExplicitViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification class >> remoteClassName [
	^#GtRemotePhlowExplicitViewSpecification
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
GtpoGtRemotePhlowExplicitViewSpecification >> retrieveStencilData [
	| dictionary data |
	
	dictionary := self retrievePrimitiveStencilData.
	data := GtRemotePhlowBasicViewData fromDictionary: dictionary.
	data isPhlowErrorData ifTrue: [ data beRemoteException ].
	
	^data
]

{ #category : #accessing }
GtpoGtRemotePhlowExplicitViewSpecification >> retrieveStencilSpecification [
	| dictionary specification stencilData |
	
	dictionary := self retrievePrimitiveStencilSpecificationData.
	specification := GtRemotePhlowAbstractStencilSpecification fromDictionary: dictionary.
	stencilData := self retrieveStencilData.
	stencilData isPhlowErrorData ifTrue: [ 
		stencilData beRemoteException ].
	specification stencilData: stencilData.
	
	^specification
]
