Class {
	#name : 'GtpoMetaclass3',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : 'private' }
GtpoMetaclass3 class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | aSymbol endsWith: ' class' ]
]

{ #category : 'accessing' }
GtpoMetaclass3 class >> remoteClassName [

	^ #Metaclass3
]

{ #category : 'printing' }
GtpoMetaclass3 >> printOn: aStream [

	[ aStream << (self proxyPerform: #printString) ]
		on: Error 
		do: [ :ex | super printOn: aStream ]
]
