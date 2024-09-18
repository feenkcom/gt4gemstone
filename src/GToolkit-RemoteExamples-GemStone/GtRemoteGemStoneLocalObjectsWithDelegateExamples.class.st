Class {
	#name : #GtRemoteGemStoneLocalObjectsWithDelegateExamples,
	#superclass : #Object,
	#instVars : [
		'server'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertObjectNewStoreStringForBareProxy: aBareProxy [ 
	self assert: (aBareProxy storeString includesSubstring: 'PassiveObject').

	self 
		assertStoreOnFor: aBareProxy
		equals: '(Object basicNew yourself)'.
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertObjectNewStoreStringForDelegate: anObjectWithDelegate [ 
	self assert: anObjectWithDelegate storeString equals: '(Object basicNew yourself)'.
	self 
		assertStoreOnFor: anObjectWithDelegate
		equals: '(Object basicNew yourself)'.
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreOnFor: anObject equals: aString [ 
	| storeString |
	storeString := String streamContents: [ :aStream |
		anObject storeOn: aStream ].
		
	self assert: storeString equals: aString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForProxyObjectWithArrayVariable: aBareProxy [ 
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString := storeString := '(GtGemStoneExampleObjectForLocalDelegate basicNew instVarAt: 1 put: ((Array new: 2) at: 1 put: (Object basicNew yourself); at: 2 put: (Object basicNew yourself); yourself); instVarAt: 2 put: nil; instVarAt: 3 put: nil; yourself)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForProxyObjectWithDictionaryWithObjects: aBareProxy [ 
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString := storeString := '(GtGemStoneExampleObjectForLocalDelegate basicNew instVarAt: 1 put: ((Dictionary new) add: (''two''->(Object basicNew yourself)); add: (''one''->(Object basicNew yourself)); yourself); instVarAt: 2 put: nil; instVarAt: 3 put: nil; yourself)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForProxyObjectWithObjectVariables: aBareProxy [ 
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString := storeString := '(GtGemStoneExampleObjectForLocalDelegate basicNew instVarAt: 1 put: (Object basicNew yourself); instVarAt: 2 put: ''a string''; instVarAt: 3 put: nil; yourself)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForProxyObjectWithOrderedCollectionVariable: aBareProxy [ 
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString := storeString := '(GtGemStoneExampleObjectForLocalDelegate basicNew instVarAt: 1 put: ((OrderedCollection new) add: (Object basicNew yourself); add: (Object basicNew yourself); yourself); instVarAt: 2 put: nil; instVarAt: 3 put: nil; yourself)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForProxyObjectWithPrimitiveVariables: aBareProxy [
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString := self storeString_serviceClientProxyForObjectWithPrimitiveVariables.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForSmallFractionProxy: aBareProxy [ 
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString :='(10/31)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

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
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithArrayVariableWithObjects [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ 
		GtGemStoneExampleObjectForLocalDelegate new 
			targetValueOne: (Array 
				with: Object new
				with: Object new ) ;
			targetValueTwo: nil ].
	self assert: result remoteClass equals: #GtGemStoneExampleObjectForLocalDelegate.
	self assert: result class name equals: #GtRsrProxyServiceClient.
	
	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithDictionaryVariableWithObjects [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ 
		GtGemStoneExampleObjectForLocalDelegate new 
			targetValueOne: (Dictionary  new
				at: 'one' put: Object new;
				at: 'two' put: Object new ;
				yourself) ;
			targetValueTwo: nil ].
	self assert: result remoteClass equals: #GtGemStoneExampleObjectForLocalDelegate.
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
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithOrderedCollectionVariableWithObjects [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ 
		GtGemStoneExampleObjectForLocalDelegate new 
			targetValueOne: (OrderedCollection 
				with: Object new
				with: Object new ) ;
			targetValueTwo: nil ].
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

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForSmallFraction [
	<gtExample>
	| session result |

	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ 
		Fraction numerator: 10 denominator: 31  ].
	self assert: result remoteClass equals: #SmallFraction.
	self assert: result class name equals: #GspoSmallFraction.
	
	^ result
]

{ #category : #'setup & teardown' }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> stopServer [ 

	server ifNotNil: 
		[ server stop.
		server := nil ].

]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> storeString_serviceClientProxyForObjectWithPrimitiveVariables [
	^'(GtRemotePhlowDeclarativeTestInspectable basicNew instVarAt: 1 put: ''hello world''; instVarAt: 2 put: ((Array new: 3) at: 1 put: 42; at: 2 put: ''Hello World''; at: 3 put: (DateAndTime basicNew instVarAt: 1 put: 45830; instVarAt: 2 put: (Duration seconds: 0 nanoSeconds: 0); instVarAt: 3 put: 2459311; instVarAt: 4 put: 123456000; yourself); yourself); yourself)'.
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testBasicObjectWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForBasicObject.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	
	self assert: localObjectWithDelegate class name equals: #Object.
	
	self assertObjectNewStoreStringForBareProxy: bareProxy.
	self assertObjectNewStoreStringForDelegate: localObjectWithDelegate.
	
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
	self assertObjectNewStoreStringForDelegate: localObjectWithDelegate.
	
	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
	
	self assert: localDelegate proxyObject == serviceClientProxy.
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithArrayVariableWithObjectsWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForObjectWithArrayVariableWithObjects.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	
	self assert: localObjectWithDelegate class name equals: #GtGemStoneExampleObjectForLocalDelegate.
	
	self 
		assert: localObjectWithDelegate targetValueTwo 
		equals: nil.
	self 
		assert: localObjectWithDelegate targetValueOne class 
		equals: Array.
	self 
		assert: localObjectWithDelegate targetValueOne first class 
		equals: GtGsBareProxy.
	self 
		assert: localObjectWithDelegate targetValueOne second class 
		equals: GtGsBareProxy.
		
	self assertStoreStringForProxyObjectWithArrayVariable: bareProxy.

	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
	
	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithDictionaryWithObjectsWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForObjectWithDictionaryVariableWithObjects.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	
	self assert: localObjectWithDelegate class name equals: #GtGemStoneExampleObjectForLocalDelegate.
	
	self 
		assert: localObjectWithDelegate targetValueTwo 
		equals: nil.
	self 
		assert: localObjectWithDelegate targetValueOne class 
		equals: Dictionary.
	self 
		assert: localObjectWithDelegate targetValueOne keys sorted
		equals: #('one' 'two').
	self 
		assert: (localObjectWithDelegate targetValueOne values
			collect: [ :each | each class ])  
		equals: {GtGsBareProxy . GtGsBareProxy}.
		
	self assertStoreStringForProxyObjectWithDictionaryWithObjects: bareProxy.

	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
	
	^ localObjectWithDelegate
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
		
	self assertStoreStringForProxyObjectWithObjectVariables: bareProxy.

	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
	
	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithOrderedCollectionVariableWithObjectsWithProxyDelegate_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForObjectWithOrderedCollectionVariableWithObjects.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	
	self assert: localObjectWithDelegate class name equals: #GtGemStoneExampleObjectForLocalDelegate.
	
	self 
		assert: localObjectWithDelegate targetValueTwo 
		equals: nil.
	self 
		assert: localObjectWithDelegate targetValueOne class 
		equals: OrderedCollection.
	self 
		assert: localObjectWithDelegate targetValueOne first class 
		equals: GtGsBareProxy.
	self 
		assert: localObjectWithDelegate targetValueOne second class 
		equals: GtGsBareProxy.
		
	self assertStoreStringForProxyObjectWithOrderedCollectionVariable: bareProxy.

	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
	
	^ localObjectWithDelegate
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
		
	self assertStoreStringForProxyObjectWithPrimitiveVariables: bareProxy.
	
	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
	
	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testSmallFractionObject_onBareProxy [
	<gtExample>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |

	serviceClientProxy := self serviceClientProxyForSmallFraction.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.
	
	self assert: localObjectWithDelegate class name equals: #Fraction.
	
	self 
		assert: localObjectWithDelegate numerator 
		equals: 10.
	self 
		assert: localObjectWithDelegate denominator
		equals: 31.
		
	self assertStoreStringForSmallFractionProxy: bareProxy.

	localDelegate := GtRsrProxyServiceClient 
		bareProxyObjectAt: localObjectWithDelegate 
		ifAbsent: [nil].
		
	self assert: localDelegate == bareProxy.
	
	^ localObjectWithDelegate
]
