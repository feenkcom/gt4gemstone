Class {
	#name : #GtRemoteGemStoneProxyServiceExamples,
	#superclass : #Object,
	#traits : 'TAssertable + TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TAssertable classTrait + TGtRemoteGemStoneSesionCreator classTrait',
	#instVars : [
		'connector'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemoteGemStoneProxyServiceExamples >> getRemoteObject [

	^ self runningServer evaluateAndWait: self remoteObjectCommand
]

{ #category : #private }
GtRemoteGemStoneProxyServiceExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self testInspectableName, ' new'
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testEvaluateReturnProxy [
	<gtExample>
	<return: #AssertionFailure>
	| proxy result |
	proxy := self runningServer evaluateAndWaitReturnProxy: 'Object new'.
	self assert: proxy remoteClass equals: #Object.	"Test #evaluateAndWaitReturnProxy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy evaluateAndWaitReturnProxy: 'self printString'.
	self assert: result remoteClass equals: #String.	"Ensure that a non-primitive return value is returned as a proxy"
	result := proxy evaluateAndWaitReturnProxy: 'self'.
	self assert: result remoteClass equals: #Object.	"Test #evaluateReturnProxy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy evaluateReturnProxy: 'self printString'.
	self assert: result wait remoteClass equals: #String.	"Ensure that a non-primitive return value is returned as a proxy"
	result := proxy evaluateReturnProxy: 'self'.
	self assert: result wait remoteClass equals: #Object
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testEvaluateReturnProxyInspector [
	<gtExample>
	<return: #AssertionFailure>
	| session proxy result |
	session := self runningServer.
	proxy := session evaluateAndWaitReturnProxy: 'Object new'.

	result := proxy evaluateProxyInspector: 'self'.

	self assert: result remoteClass equals: #GtRemotePhlowViewedObject.
	self assert: result hasCachedViewSpecifications.
	self assert: result rawViewSpecificationsBySelector size equals: 2.
	self assert: result rawActionSpecificationsBySelector size equals: 2
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testEvaluateReturnSerializedPrimitive [
	<gtExample>
	<return: #AssertionFailure>
	| proxy result |
	proxy := self runningServer evaluateAndWaitReturnProxy: 'Object new'.
	self assert: proxy remoteClass equals: #Object.	"Test #evaluateAndWait:serializationStrategy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			evaluateAndWait: 'self printString'
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: result class equals: ByteString.	"Ensure that a non-primitive return value raises the appropriate exception"
	self
		should: [ proxy
				evaluateAndWait: 'self'
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
		raise: RsrBrokenPromise.	"Test #evaluate:serializationStrategy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			evaluate: 'self printString'
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: result wait class equals: ByteString.	"Ensure that a non-primitive return value raises the appropriate exception"
	result := proxy
			evaluate: 'self'
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	result waitForResolution.
	self assert: result isBroken
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testEvaluateReturnStonSerialized [
	<gtExample>
	<return: #AssertionFailure>
	| proxy result |
	proxy := self runningServer evaluateAndWaitReturnProxy: 'Object new'.
	self assert: proxy remoteClass equals: #Object.	"Test #evaluateAndWait:serializationStrategy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			evaluateAndWait: 'self printString'
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: ByteString.	"Ensure that a non-primitive return value raises the appropriate exception"
	result := proxy
			evaluateAndWait: 'self'
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: Object.	"Test #evaluate:serializationStrategy:"
	result := proxy
			evaluate: 'self printString'
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result wait class equals: ByteString.
	result := proxy
			evaluate: 'self'
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result wait class equals: Object
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ #GtRemotePhlowDeclarativeTestInspectable
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testIntegerParameterAsArgument [
	<gtExample>
	<return: #AssertionFailure>
	| proxy value |
	proxy := self runningServer
			evaluateAndWait: 'GtRemotePhlowDeclarativeTestInspectable new'.

	value := proxy proxyPerform: #printStringFor: withArguments: {1}.
	self assert: value equals: '1'.

	^ proxy
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testOrderedCollectionProxyMessageSends [
	<gtExample>
	<return: #AssertionFailure>
	| collectionProxy size |
	collectionProxy := self runningServer
			evaluateAndWaitReturnProxy: 'OrderedCollection withAll: #(1 6 3 4)'.

	size := collectionProxy proxyPerform: #size.
	self assert: size equals: 4.

	self
		assert: (#('anOrderedCollection [4 items] (1 6 3 4)' 'anOrderedCollection( 1, 6, 3, 4)')
				includes: (collectionProxy proxyPerform: #gtDisplayString)).

	self assert: (collectionProxy proxyPerform: #includes: withArguments: {1}).
	self assert: (collectionProxy proxyPerform: #includes: withArguments: {5}) not.

	self assert: (collectionProxy proxyPerform: #at: withArguments: {2}) equals: 6.

	^ collectionProxy
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testPerformReturnProxy [
	<gtExample>
	<return: #AssertionFailure>
	| proxy result |
	proxy := self runningServer evaluateAndWaitReturnProxy: 'Object new'.
	self assert: proxy remoteClass equals: #Object.	"Test #proxyPerformReturnProxy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy proxyPerformReturnProxy: #printString.
	self assert: result remoteClass equals: #String.	"Ensure that a non-primitive return value is returned as a proxy"
	result := proxy proxyPerformReturnProxy: #yourself.
	self assert: result remoteClass equals: #Object.	"Test #proxyPerformReturnProxy:withArguments:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy proxyPerformReturnProxy: #_refersToLiteral: withArguments: {1}.
	self assert: result remoteClass equals: #Boolean.	"Ensure that a non-primitive return value is returned as a proxy"
	result := proxy proxyPerformReturnProxy: #'->' withArguments: {1}.
	self assert: result remoteClass equals: #Association
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testPerformReturnSerializedPrimitive [
	<gtExample>
	<return: #AssertionFailure>
	| proxy result |
	proxy := self runningServer evaluateAndWaitReturnProxy: 'Object new'.
	self assert: proxy remoteClass equals: #Object.	"Test #proxyPerformReturnProxy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			proxyPerform: #printString
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: result class equals: ByteString.	"Ensure that a non-primitive return value raises the appropriate exception"
	self
		should: [ proxy
				proxyPerform: #copy
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
		raise: RsrBrokenPromise.	"Test #proxyPerformReturnProxy:withArguments:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			proxyPerform: #_refersToLiteral:
			withArguments: {1}
			serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy.
	self assert: result class equals: False.	"Ensure that a non-primitive return value is returned as a proxy"
	self
		should: [ proxy
				proxyPerform: #'->'
				withArguments: {1}
				serializationStrategy: #GtRsrPrimitiveOnlySerializationStrategy ]
		raise: RsrBrokenPromise
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testPerformReturnStonSerialized [
	<gtExample>
	<return: #AssertionFailure>
	| proxy result |
	proxy := self runningServer evaluateAndWaitReturnProxy: 'Object new'.
	self assert: proxy remoteClass equals: #Object.	"Test #proxyPerformReturnProxy:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			proxyPerform: #printString
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: ByteString.
	self assert: result equals: 'anObject'.	"Ensure that a non-primitive return value returns the appropriate class"
	result := proxy
			proxyPerform: #yourself
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: Object.	"Test #proxyPerformReturnProxy:withArguments:"	"Ensure that a primitive return value is returned as a proxy"
	result := proxy
			proxyPerform: #_refersToLiteral:
			withArguments: {1}
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: False.
	self assert: result equals: false.	"Ensure that a non-primitive return value returns the appropriate class"
	result := proxy
			proxyPerform: #'->'
			withArguments: {1}
			serializationStrategy: #GtRsrStonSerializationStrategy.
	self assert: result class equals: Association.
	self assert: result value equals: 1
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testSetProxyMessageSends [
	<gtExample>
	<return: #AssertionFailure>
	| setProxy size |
	setProxy := self runningServer evaluateAndWait: 'Set withAll: #(1 2 3 4)'.

	size := setProxy proxyPerform: #size.
	self assert: size equals: 4.

	self
		assert: (setProxy proxyPerform: #gtDisplayString)
		equals: 'aSet( 3, 1, 4, 2)'.

	self assert: (setProxy proxyPerform: #includes: withArguments: {1}).
	self assert: (setProxy proxyPerform: #includes: withArguments: {5}) not.

	^ setProxy
]

{ #category : #tests }
GtRemoteGemStoneProxyServiceExamples >> testWithProxyObjectAsParameterAsArgument [
	<gtExample>
	<return: #AssertionFailure>
	| argumentProxy proxy value |
	argumentProxy := self runningServer
			evaluateAndWait: 'GtRemotePhlowDeclarativeTestInspectable new'.
	proxy := self runningServer
			evaluateAndWait: 'GtRemotePhlowDeclarativeTestInspectable new'.

	value := proxy proxyPerform: #printStringFor: withArguments: {argumentProxy}.
	self assert: value equals: 'aGtRemotePhlowDeclarativeTestInspectable'.

	^ proxy
]
