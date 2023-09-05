Class {
	#name : #GspoGtRmGeolife,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #accessing }
GspoGtRmGeolife class >> remoteClassName [
	^ #GtRmGeolife
]

{ #category : #accessing }
GspoGtRmGeolife >> ensureUserWithId: aString [

	^ self proxyPerform: #ensureUserWithId:
		withArguments: { aString }.
]
