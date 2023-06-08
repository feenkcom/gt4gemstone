Class {
	#name : #GtpoGtPhlowColumnedListViewSpecification,
	#superclass : #GtRsrProxyServiceClient,
	#traits : 'TGlpoGtPhlowListingViewSpecification',
	#classTraits : 'TGlpoGtPhlowListingViewSpecification classTrait',
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtPhlowColumnedListViewSpecification class >> remoteClassName [
	^ #GtPhlowColumnedListViewSpecification
]

{ #category : #accessing }
GtpoGtPhlowColumnedListViewSpecification >> retriveSpawnedObjectAtRow: aRowIndex column: aColumnIndex [	
	^ self
		proxyPerform: #retriveSpawnedObjectAtRow:column:
		withArguments: { aRowIndex . aColumnIndex }
]
