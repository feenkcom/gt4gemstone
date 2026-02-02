Class {
	#name : #GtRemoteGemStoneLocalObjectsWithDelegateExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
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
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForForDictionaryWithObjectKeysAndDataProxy: aBareProxy [ 
	| localObjectWithDelegate storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	storeString :='((Dictionary new) add: ((Object basicNew yourself)->(Object basicNew yourself)); add: ((Object basicNew yourself)->(Object basicNew yourself)); add: ((Object basicNew yourself)->(Object basicNew yourself)); yourself)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> assertStoreStringForForDictionaryWithPrimiteKeysAndDataProxy: aBareProxy [
	"Confirm that the store strings for the dictionary evaluate to the expected value.
	Don't compare the strings directly as hashing can result in comparison failures due to different ordering."
	| localObjectWithDelegate expectedDictionary storeString |
	localObjectWithDelegate := aBareProxy asGtpoLocalObject.
	expectedDictionary := Dictionary new
			add: 'one' -> 1;
			add: 'two' -> 2;
			add: 'three' -> 3;
			yourself.
	storeString := String
			streamContents: [ :aStream | aBareProxy storeOn: aStream ].
	self
		assert: (self class compiler evaluate: storeString)
		equals: expectedDictionary.
	self
		assert: (self class evaluate: localObjectWithDelegate storeString)
		equals: expectedDictionary.
	storeString := String
			streamContents: [ :aStream | localObjectWithDelegate storeOn: aStream ].
	self assert: (self class evaluate: storeString) equals: expectedDictionary
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
	storeString :='(1/3)'.

	self assertStoreOnFor: aBareProxy equals: storeString.
	self assert: localObjectWithDelegate storeString equals: storeString.
	self assertStoreOnFor: localObjectWithDelegate equals: storeString
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForBasicObject [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session evaluateBlockAndWaitReturnProxy: [ Object new ].
	self assert: result remoteClass equals: #Object.
	self assert: result class name equals: #GtRsrProxyServiceClient.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForDictionaryWithObjectKeysAndData [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ Dictionary new
					at: Object new put: Object new;
					at: Object new put: Object new;
					at: Object new put: Object new;
					yourself ].
	self assert: result remoteClass equals: #Dictionary.
	self assert: result class name equals: #GspoDictionary.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForDictionaryWithObjectKeysAndData_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self serviceClientProxyForDictionaryWithObjectKeysAndData.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self assert: localObjectWithDelegate class name equals: #Dictionary.

	self assert: localObjectWithDelegate size equals: 3.
	self assert: localObjectWithDelegate keys anyOne class equals: Object.
	self assert: localObjectWithDelegate values anyOne class equals: GtGsBareProxy.

	self assertStoreStringForForDictionaryWithObjectKeysAndDataProxy: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForDictionaryWithPrimiteKeysAndData [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ Dictionary new
					at: 'one' put: 1;
					at: 'two' put: 2;
					at: 'three' put: 3;
					yourself ].
	self assert: result remoteClass equals: #Dictionary.
	self assert: result class name equals: #GspoDictionary.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForDictionaryWithPrimiteKeysAndData_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self
			serviceClientProxyForDictionaryWithPrimiteKeysAndData.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self assert: localObjectWithDelegate class name equals: #Dictionary.

	self assert: localObjectWithDelegate size equals: 3.
	self
		assert: localObjectWithDelegate
		equals: (Dictionary new
				at: 'one' put: 1;
				at: 'two' put: 2;
				at: 'three' put: 3;
				yourself).

	self assertStoreStringForForDictionaryWithPrimiteKeysAndDataProxy: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithArrayVariableWithObjects [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ GtGemStoneExampleObjectForLocalDelegate new
					targetValueOne: (Array with: Object new with: Object new);
					targetValueTwo: nil ].
	self
		assert: result remoteClass
		equals: #GtGemStoneExampleObjectForLocalDelegate.
	self assert: result class name equals: #GtRsrProxyServiceClient.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithDictionaryVariableWithObjects [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ GtGemStoneExampleObjectForLocalDelegate new
					targetValueOne: (Dictionary new
							at: 'one' put: Object new;
							at: 'two' put: Object new;
							yourself);
					targetValueTwo: nil ].
	self
		assert: result remoteClass
		equals: #GtGemStoneExampleObjectForLocalDelegate.
	self assert: result class name equals: #GtRsrProxyServiceClient.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithObjectVariables [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ GtGemStoneExampleObjectForLocalDelegate new
					targetValueOne: Object new;
					targetValueTwo: 'a string' ].
	self
		assert: result remoteClass
		equals: #GtGemStoneExampleObjectForLocalDelegate.
	self assert: result class name equals: #GtRsrProxyServiceClient.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithOrderedCollectionVariableWithObjects [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ GtGemStoneExampleObjectForLocalDelegate new
					targetValueOne: (OrderedCollection with: Object new with: Object new);
					targetValueTwo: nil ].
	self
		assert: result remoteClass
		equals: #GtGemStoneExampleObjectForLocalDelegate.
	self assert: result class name equals: #GtRsrProxyServiceClient.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForObjectWithPrimitiveVariables [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ GtRemotePhlowDeclarativeTestInspectable new ].
	self
		assert: result remoteClass
		equals: #GtRemotePhlowDeclarativeTestInspectable.
	self
		assert: result class name
		equals: #GspoGtRemotePhlowDeclarativeTestInspectable.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForSmallFraction [
	<gtExample>
	<return: #AssertionFailure>
	| session result |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ Fraction numerator: 1 denominator: 3 ].
	self assert: result remoteClass equals: #SmallFraction.
	self assert: result class name equals: #GspoSmallFraction.

	^ result
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> serviceClientProxyForSmallFraction_anotherOne [
	<gtExample>
	<return: #AssertionFailure>
	| session result localObjectWithDelegate |
	session := self runningServer.
	result := session
			evaluateBlockAndWaitReturnProxy: [ Fraction numerator: 20 denominator: 41 ].
	self assert: result remoteClass equals: #SmallFraction.
	self assert: result class name equals: #GspoSmallFraction.

	localObjectWithDelegate := result asGtpoLocalObject.
	self assert: localObjectWithDelegate numerator equals: 20.
	self assert: localObjectWithDelegate denominator equals: 41.

	^ result
]

{ #category : #assertions }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> storeString_serviceClientProxyForObjectWithPrimitiveVariables [
	^'(GtRemotePhlowDeclarativeTestInspectable basicNew instVarAt: 1 put: ''hello world''; instVarAt: 2 put: ((Array new: 3) at: 1 put: 42; at: 2 put: ''Hello World''; at: 3 put: (DateAndTime basicNew instVarAt: 1 put: 45830; instVarAt: 2 put: (Duration seconds: 0 nanoSeconds: 0); instVarAt: 3 put: 2459311; instVarAt: 4 put: 123456000; yourself); yourself); yourself)'.
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testBasicObjectWithProxyDelegate_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self serviceClientProxyForBasicObject.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self assert: localObjectWithDelegate class name equals: #Object.

	self assertObjectNewStoreStringForBareProxy: bareProxy.
	self assertObjectNewStoreStringForDelegate: localObjectWithDelegate.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testBasicObjectWithProxyDelegate_onServiceClient [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self serviceClientProxyForBasicObject.

	localObjectWithDelegate := serviceClientProxy asGtpoLocalObject.
	self assert: localObjectWithDelegate class name equals: #Object.
	self assertObjectNewStoreStringForDelegate: localObjectWithDelegate.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate proxyObject == serviceClientProxy
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithArrayVariableWithObjectsWithProxyDelegate_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self
			serviceClientProxyForObjectWithArrayVariableWithObjects.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self
		assert: localObjectWithDelegate class name
		equals: #GtGemStoneExampleObjectForLocalDelegate.

	self assert: localObjectWithDelegate targetValueTwo equals: nil.
	self assert: localObjectWithDelegate targetValueOne class equals: Array.
	self
		assert: localObjectWithDelegate targetValueOne first class
		equals: GtGsBareProxy.
	self
		assert: localObjectWithDelegate targetValueOne second class
		equals: GtGsBareProxy.

	self assertStoreStringForProxyObjectWithArrayVariable: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithDictionaryWithObjectsWithProxyDelegate_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self
			serviceClientProxyForObjectWithDictionaryVariableWithObjects.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self
		assert: localObjectWithDelegate class name
		equals: #GtGemStoneExampleObjectForLocalDelegate.

	self assert: localObjectWithDelegate targetValueTwo equals: nil.
	self assert: localObjectWithDelegate targetValueOne class equals: Dictionary.
	self
		assert: localObjectWithDelegate targetValueOne keys sorted
		equals: #('one' 'two').
	self
		assert: (localObjectWithDelegate targetValueOne values collect: [ :each | each class ] as: Array)
		equals: {GtGsBareProxy.
				GtGsBareProxy}.

	self assertStoreStringForProxyObjectWithDictionaryWithObjects: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithObjectVariablesWithProxyDelegate_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self serviceClientProxyForObjectWithObjectVariables.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self
		assert: localObjectWithDelegate class name
		equals: #GtGemStoneExampleObjectForLocalDelegate.

	self assert: localObjectWithDelegate targetValueTwo equals: 'a string'.
	self assert: localObjectWithDelegate targetValueOne class equals: GtGsBareProxy.

	self assertStoreStringForProxyObjectWithObjectVariables: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithOrderedCollectionVariableWithObjectsWithProxyDelegate_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self
			serviceClientProxyForObjectWithOrderedCollectionVariableWithObjects.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self
		assert: localObjectWithDelegate class name
		equals: #GtGemStoneExampleObjectForLocalDelegate.

	self assert: localObjectWithDelegate targetValueTwo equals: nil.
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
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testObjectWithPrimitiveVariablesWithProxyDelegate_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self serviceClientProxyForObjectWithPrimitiveVariables.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self
		assert: localObjectWithDelegate class name
		equals: #GtRemotePhlowDeclarativeTestInspectable.

	self
		assert: localObjectWithDelegate string
		equals: GtRemotePhlowDeclarativeTestInspectable new string.
	self
		assert: localObjectWithDelegate collectionOfObjects
		equals: GtRemotePhlowDeclarativeTestInspectable new collectionOfObjects.

	self assertStoreStringForProxyObjectWithPrimitiveVariables: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]

{ #category : #tests }
GtRemoteGemStoneLocalObjectsWithDelegateExamples >> testSmallFractionObject_onBareProxy [
	<gtExample>
	<return: #AssertionFailure>
	| serviceClientProxy bareProxy localObjectWithDelegate localDelegate |
	serviceClientProxy := self serviceClientProxyForSmallFraction.
	bareProxy := serviceClientProxy asGtBareProxyObject.
	localObjectWithDelegate := bareProxy asGtpoLocalObject.

	self assert: localObjectWithDelegate class name equals: #Fraction.

	self assert: localObjectWithDelegate numerator equals: 1.
	self assert: localObjectWithDelegate denominator equals: 3.

	self assertStoreStringForSmallFractionProxy: bareProxy.

	localDelegate := GtRsrProxyServiceClient
			bareProxyObjectAt: localObjectWithDelegate
			ifAbsent: [ nil ].

	self assert: localDelegate == bareProxy.

	^ localObjectWithDelegate
]
