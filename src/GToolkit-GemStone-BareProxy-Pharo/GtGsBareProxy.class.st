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

	^ [ :aSymbol | self remoteClassName = aSymbol ]
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

{ #category : #printing }
GtGsBareProxy >> gtDisplayOn: aStream [
	proxyObject ifNil: [ 
		aStream << 'Bare Proxy on: <not configured>'.
		^ self ].
	
	proxyObject isProxyObjectActive ifFalse: [ 
		aStream << 'Bare Proxy on: <not connected>'.
		^ self ].
	
	aStream << 'Bare Proxy on: '.
	proxyObject gtDisplayOn: aStream
]

{ #category : #printing }
GtGsBareProxy >> gtInspectorRemoteSideTitleStringOn: aStream [
	proxyObject ifNil: [ 
		aStream << 'a GtGsBareProxy'.
		^ self ].
	
	proxyObject isProxyObjectActive ifFalse: [ 
		aStream << 'Bare Proxy on: <not connected>'.
		^ self ].

	proxyObject gtDisplayOn: aStream.

	proxyObject gtSession ifNotNil:
		[ :gtSession | aStream
			<< ' [';
			<< gtSession name;
			<< ']' ]
]

{ #category : #printing }
GtGsBareProxy >> gtInspectorTitleStringOn: aStream [
	super gtInspectorTitleStringOn: aStream.
	
	proxyObject gtSession ifNotNil:
		[ :gtSession | aStream
			<< ' [';
			<< gtSession name;
			<< ']' ]
]

{ #category : #printing }
GtGsBareProxy >> gtRemoteSideInitialPlaygroundSnippet [
	^ LeGemStoneSnippet new
]
