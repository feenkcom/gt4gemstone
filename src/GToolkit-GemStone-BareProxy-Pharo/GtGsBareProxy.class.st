"
GtGsBareProxy is the bare-proxy object class for GemStone remote objects.
"
Class {
	#name : 'GtGsBareProxy',
	#superclass : 'GtBareProxy',
	#category : 'GToolkit-GemStone-BareProxy-Pharo-Model'
}

{ #category : 'instance creation' }
GtGsBareProxy class >> forProxyObject: aProxyObject [
	| proxyClass |

	proxyClass := self subclassForRemoteClass: aProxyObject remoteClass.
	^ proxyClass new proxyObject: aProxyObject
]

{ #category : 'private' }
GtGsBareProxy class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | self remoteClassName = aSymbol ]
]

{ #category : 'private' }
GtGsBareProxy class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ nil
]

{ #category : 'private' }
GtGsBareProxy class >> subclassForRemoteClass: aSymbol [
	"Answer the subclass that represents the supplied class name"

	^ self subclasses
		detect: [ :each | each remoteClassMatcher value: aSymbol ]
		ifNone: [ self ].

]
