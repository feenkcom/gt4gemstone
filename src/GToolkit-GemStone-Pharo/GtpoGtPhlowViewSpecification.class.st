Class {
	#name : #GtpoGtPhlowViewSpecification,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtPhlowViewSpecification >> definingMethod [
	self halt.
	^ self proxyPerform: #definingMethod
]
