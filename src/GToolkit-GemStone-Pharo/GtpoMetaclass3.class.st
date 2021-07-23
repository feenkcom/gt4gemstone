Class {
	#name : 'GtpoMetaclass3',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo'
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
