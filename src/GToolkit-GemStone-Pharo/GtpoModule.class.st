Class {
	#name : #GtpoModule,
	#superclass : #GtpoBehavior,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtpoModule class >> cachedSelectors [
	"Answer the selectors that should be cached by the proxy"

	^ super cachedSelectors, #(#name)
]

{ #category : #accessing }
GtpoModule >> name [

	^ self proxyPerform: #name
]
