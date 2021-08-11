Class {
	#name : 'GspoGtRemotePhlowDeclarativeTestInspectable',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-RemoteExamples-GemStone'
}

{ #category : 'accessing' }
GspoGtRemotePhlowDeclarativeTestInspectable class >> remoteClassName [

	^ #GtRemotePhlowDeclarativeTestInspectable
]

{ #category : 'accessing' }
GspoGtRemotePhlowDeclarativeTestInspectable >> collectionOfObjects [ 

	^ self proxyPerform: #collectionOfObjects
]

{ #category : 'accessing' }
GspoGtRemotePhlowDeclarativeTestInspectable >> string [ 

	^ self proxyPerform: #string
]
