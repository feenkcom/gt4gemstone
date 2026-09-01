Class {
	#name : #GtpoGtRemotePhlowDataBasedViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtpoGtRemotePhlowDataBasedViewSpecification class >> remoteClassName [
	^#GtRemotePhlowConcreteDataViewSpecification
]

{ #category : #accessing }
GtpoGtRemotePhlowDataBasedViewSpecification >> flushCachedData [
	^ self proxyPerform: #flushCachedData
]

{ #category : #accessing }
GtpoGtRemotePhlowDataBasedViewSpecification >> retrieveData [
	| dictionary data |
	
	dictionary := self retrievePrimitiveData.
	data := GtRemotePhlowBasicViewData fromDictionary: dictionary.
	
	^data
]

{ #category : #accessing }
GtpoGtRemotePhlowDataBasedViewSpecification >> retrievePrimitiveData [
	^ self proxyPerform: #retrievePrimitiveData
]

{ #category : #accessing }
GtpoGtRemotePhlowDataBasedViewSpecification >> retrieveStencilData [
	^ self retrieveData
]
