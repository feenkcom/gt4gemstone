Class {
	#name : #GtpoGtRemotePhlowDeclarativeBlockActionDataSource,
	#superclass : #GtpoGtRemotePhlowDeclarativeActionDataSource,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowDeclarativeBlockActionDataSource class >> remoteClassName [
	^ #GtRemotePhlowDeclarativeBlockActionDataSource
]

{ #category : #accessing }
GtpoGtRemotePhlowDeclarativeBlockActionDataSource >> executeRemoteActionWithPhlowResult [
	^ self proxyPerform: #executeRemoteActionWithPhlowResult
]
