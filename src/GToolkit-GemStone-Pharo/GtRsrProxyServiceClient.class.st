Class {
	#name : 'GtRsrProxyServiceClient',
	#superclass : 'GtRsrProxyService',
	#category : 'GToolkit-GemStone-Pharo'
}

{ #category : 'accessing' }
GtRsrProxyServiceClient class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ nil
]

{ #category : 'private' }
GtRsrProxyServiceClient class >> subclassForRemoteClass: aSymbol [
	"Answer the subclass that represents the supplied class name"

	^ self subclasses
		detect: [ :each | each remoteClassName = aSymbol ]
		ifNone: [ nil ].

]

{ #category : 'private' }
GtRsrProxyServiceClient >> _id: id connection: connection remoteSelf: anObject [

	_id := id.
	_connection := connection.
	remoteSelf := anObject.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> evaluate: aString [
	"Evaluate the supplied string with `self` bound to the receiver"
	| evaluator |

	evaluator := GtRsrEvaluatorServiceClient new
		selfInstance: self;
		script: aString;
		registerWith: _connection.
	^ evaluator doItAndWait.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol [

	^ (remoteSelf proxyPerform: aSymbol) wait.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [

	^ remoteSelf proxyPerform: aSymbol withArguments: anArray
]

{ #category : 'accessing' }
GtRsrProxyServiceClient >> remoteClass: aSymbol [
	"Set the name of the class of the remote object and convert to the appropriate subclass.
	RSR client service objects are always created using #new, so there isn't an opportunity to intercept the client creation.  Once the remoteClass has been set, we can replace the client proxy object using #becomeForward:"
	| proxyClass newProxy |

	remoteClass := aSymbol.
	proxyClass := self class subclassForRemoteClass: aSymbol.
	proxyClass ifNil: [ ^ self ].
	newProxy := proxyClass new.
	newProxy _id: _id connection: _connection remoteSelf: remoteSelf.
	self becomeForward: newProxy.
	^ newProxy
]
