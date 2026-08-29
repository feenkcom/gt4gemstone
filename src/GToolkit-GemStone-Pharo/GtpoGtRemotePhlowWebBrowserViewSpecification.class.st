"
GemStone proxy for a remote web browser view specification.
"
Class {
	#name : #GtpoGtRemotePhlowWebBrowserViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowWebBrowserViewSpecification class >> remoteClassName [
	^ #GtRemotePhlowWebBrowserViewSpecification
]

{ #category : #updating }
GtpoGtRemotePhlowWebBrowserViewSpecification >> flushCachedData [
	^ self proxyPerform: #flushCachedData
]

{ #category : #retrieving }
GtpoGtRemotePhlowWebBrowserViewSpecification >> retrieveContent [
	^ GtRemotePhlowBasicViewData fromDictionary: self retrievePrimitiveContent
]

{ #category : #retrieving }
GtpoGtRemotePhlowWebBrowserViewSpecification >> retrieveDynamicHeaders [
	| dictionary |
	dictionary := self proxyPerform: #retrievePrimitiveDynamicHeaders.
	^ GtRemotePhlowBasicViewData fromDictionary: dictionary
]

{ #category : #retrieving }
GtpoGtRemotePhlowWebBrowserViewSpecification >> retrievePrimitiveContent [
	^ self proxyPerform: #retrievePrimitiveContent
]
