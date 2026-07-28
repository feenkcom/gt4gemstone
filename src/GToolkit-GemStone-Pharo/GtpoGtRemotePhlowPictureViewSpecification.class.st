Class {
	#name : #GtpoGtRemotePhlowPictureViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Promises'
}

{ #category : #accessing }
GtpoGtRemotePhlowPictureViewSpecification class >> remoteClassName [
	^#GtRemotePhlowPictureViewSpecification
]

{ #category : #accessing }
GtpoGtRemotePhlowPictureViewSpecification >> retrieveData [
	| dictionary data |
	
	dictionary := self retrievePrimitiveData.
	data := GtRemotePhlowBasicViewData fromDictionary: dictionary.
	data isError ifTrue: [ data beRemoteException ].
	
	^data
]

{ #category : #accessing }
GtpoGtRemotePhlowPictureViewSpecification >> retrievePrimitiveData [
	^ self proxyPerform: #retrievePrimitiveData
]
