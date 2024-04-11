Class {
	#name : #GtRemoteGemStoneLocalObjectsWithDelegateExamples,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'setup & teardown' }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> runningServer [
	"Answer a running server.
	This assumes:
	- The GemStone server is running with Gt loaded
	- Default usernames and passwords
	- The library is available in {imageDirectory}/remote-gemstone/3.7.0"
	<gtExample>
	<after: #stopServer>
	
	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForBasicObject [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ Object new ].
	self assert: result remoteClass equals: #Object.
	self assert: result class name equals: #GtRsrProxyServiceClient.
	
	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithObjectVariables [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ 
		GtGemStoneExampleObjectForLocalDelegate new 
			targetValueOne: Object new;
			targetValueTwo: 'a string'].
	self assert: result remoteClass equals: #GtGemStoneExampleObjectForLocalDelegate.
	self assert: result class name equals: #GtRsrProxyServiceClient.
	
	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithPrimitiveVariables [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ 
		GtRemotePhlowDeclarativeTestInspectable new ].
	self assert: result remoteClass equals: #GtRemotePhlowDeclarativeTestInspectable.
	self assert: result class name equals: #GspoGtRemotePhlowDeclarativeTestInspectable.
	
	^ result
]

{ #category : #'setup & teardown' }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].

]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testBasicObjectWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForBasicObject.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	self assert: localObjectWithDelegate class name equals: #Object.
	
	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testBasicObjectWithProxyDelegate_onServiceClient [
	<gtExample>
	| serviceClientProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForBasicObject.
	
	localObjectWithDelegate := serviceClientProxy asGtpoLocalObject.
	self assert: localObjectWithDelegate class name equals: #Object.
	
	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
	
	self assert: localDelegate proxyObject == serviceClientProxy.
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithObjectVariablesWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForObjectWithObjectVariables.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	self assert: localObjectWithDelegate class name equals: #GtGemStoneExampleObjectForLocalDelegate.
	
	self 
		assert: localObjectWithDelegate targetValueTwo 
		equals: 'a string'.
	self 
		assert: localObjectWithDelegate targetValueOne class 
		equals: GtGsBareProxy.

	
	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithPrimitiveVariablesWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForObjectWithPrimitiveVariables.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	self assert: localObjectWithDelegate class name equals: #GtRemotePhlowDeclarativeTestInspectable.
	self 
		assert: localObjectWithDelegate string 
		equals: GtRemotePhlowDeclarativeTestInspectable new string.
	self 
		assert: localObjectWithDelegate collectionOfObjects 
		equals: GtRemotePhlowDeclarativeTestInspectable new collectionOfObjects.
	
	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
]
