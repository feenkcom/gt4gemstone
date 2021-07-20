Class {
	#name : 'GtRsrProxyServiceClient',
	#superclass : 'GtRsrProxyService',
	#category : 'GToolkit-GemStone-Pharo'
}

{ #category : 'testing' }
GtRsrProxyServiceClient class >> isClientClass [

	^ true
]

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

{ #category : 'accessing' }
GtRsrProxyServiceClient >> becomeProxyRemoteClass [
	"Convert the to the appropriate subclass.
	RSR client service objects are always created using #basicNew and instance variables are populated using #instVarAt:put:, so there isn't an opportunity to intercept the client creation.  Once the remoteClass has been set, we can replace the client proxy object using #becomeForward:"
	| proxyClass newProxy |

	proxyClass := self class subclassForRemoteClass: remoteClass.
	proxyClass ifNil: [ ^ self ].
	newProxy := proxyClass new.
	newProxy _id: _id connection: _connection remoteSelf: remoteSelf.
	self becomeForward: newProxy.
	^ newProxy
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

{ #category : 'introspection' }
GtRsrProxyServiceClient >> instVarAt: anInteger put: anObject [
	"If the receiver's remoteClass has been set, convert the receiver to the specific proxy class.
	WARNING: The index of remoteClass is assumed to be 4.  This must be manually updated if instance variables are inserted before remoteClass"
	| result |

	result := super instVarAt: anInteger put: anObject.
	anInteger = 4 ifTrue: 
		[ self becomeProxyRemoteClass ].
	^ result
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol [

	^ (remoteSelf proxyPerform: aSymbol) wait.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [

	^ remoteSelf proxyPerform: aSymbol withArguments: anArray
]
