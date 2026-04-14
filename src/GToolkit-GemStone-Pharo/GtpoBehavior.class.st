Class {
	#name : #GtpoBehavior,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #initialization }
GtpoBehavior class >> cachedSelectors [
	"Answer the selectors that should be cached by the proxy"

	^ #()
]

{ #category : #initialization }
GtpoBehavior >> initialize [

	super initialize.
	cacheStrategy := GtProxyCacheStrategy forSelectors: self class cachedSelectors.
]
