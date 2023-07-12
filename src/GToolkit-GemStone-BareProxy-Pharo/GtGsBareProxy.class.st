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

{ #category : #ui }
GtGsBareProxy >> gtAbortActionFor: anAction [
	<gtAction>

	^ proxyObject gtAbortActionFor: anAction
]

{ #category : #ui }
GtGsBareProxy >> gtCommitActionFor: anAction [
	<gtAction>

	^ proxyObject gtCommitActionFor: anAction
]

{ #category : #ui }
GtGsBareProxy >> gtInspectSessionFor: anAction [
	<gtAction>

	^ proxyObject gtInspectSessionFor: anAction
]

{ #category : #printing }
GtGsBareProxy >> gtInspectorRemoteSideTitleStringOn: aStream [
	super gtInspectorRemoteSideTitleStringOn: aStream.
	
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
