Class {
	#name : #GtpoGtDeclarativeColumnedListView,
	#superclass : #GtRsrProxyServiceClient,
	#traits : 'TGlpoGtDeclarativeListingView',
	#classTraits : 'TGlpoGtDeclarativeListingView classTrait',
	#category : 'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtDeclarativeColumnedListView class >> remoteClassName [
	^ #GtPhlowDeclarativeColumnedListView
]

{ #category : #accessing }
GtpoGtDeclarativeColumnedListView >> retriveSpawnedObjectAtRow: aRowIndex column: aColumnIndex [	
	^ self
		proxyPerform: #retriveSpawnedObjectAtRow:column:
		withArguments: { aRowIndex . aColumnIndex }
]
