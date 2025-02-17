"
GtGsBareProxy is the bare-proxy object class for GemStone remote objects.
"
Class {
	#name : #GtGsBareProxy,
	#superclass : #GtBareProxy,
	#category : #'GToolkit-GemStone-BareProxy-Pharo-Model'
}

{ #category : #'instance creation' }
GtGsBareProxy class >> forProxyObject: aProxyObject [
	| proxyClass |

	proxyClass := self subclassForRemoteClass: aProxyObject remoteClass.
	^ proxyClass new 
		proxyObject: aProxyObject
]

{ #category : #accessing }
GtGsBareProxy class >> leProxyTypeForPlaygroundPage [
	^ GtGsBareProxy
]

{ #category : #private }
GtGsBareProxy class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | self remoteClassName sameContentAs: aSymbol ]
]

{ #category : #private }
GtGsBareProxy class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ nil
]

{ #category : #private }
GtGsBareProxy class >> subclassForRemoteClass: aSymbol [
	"Answer the subclass that represents the supplied class name"

	^ self subclasses
		detect: [ :each | each remoteClassMatcher value: aSymbol ]
		ifNone: [ self ].

]

{ #category : #converting }
GtGsBareProxy >> asGtpoLocalObject [ 

	"Answer a local copy of the receiver"
	^ proxyObject createGtpoLocalObjectLinkedToBareProxy:  self.
]

{ #category : #printing }
GtGsBareProxy >> gtRemoteSideInitialPlaygroundSnippet [
	^ LeGemStoneSnippet new
]

{ #category : #'literal testing' }
GtGsBareProxy >> shouldBePrintedAsLiteral: alreadyVisited [
	"This is currently needed when printing arrays that contain proxies"
	^ false
]

{ #category : #printing }
GtGsBareProxy >> storeOn: aStream [
	self asGtpoLocalObject storeOn: aStream
]
