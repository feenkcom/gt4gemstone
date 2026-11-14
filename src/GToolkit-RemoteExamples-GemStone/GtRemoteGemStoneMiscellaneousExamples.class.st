Class {
	#name : #GtRemoteGemStoneMiscellaneousExamples,
	#superclass : #Object,
	#traits : 'TAssertable + TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TAssertable classTrait + TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneMiscellaneousExamples >> remoteExampleExecution [
	"Ensure basic example execution in GemStone.
	Requires GT.gs to be loaded.
	noTest as GT.gs is not loaded by default."
	<gtExample>
	<noTest>
	| aSession aMethod aCoder aViewModel aResult |
	
	aSession := self runningServer.
	aMethod := aSession
			evaluateAndWaitReturnProxy: 'GtLMagritteToolForMethodSourceExamples compiledMethodAt: #methodSourceWithNilDescriptor'.
	aCoder := GtGemStoneMethodCoderModel fromGsMethod: aMethod asGtBareProxyObject.
	aViewModel := aCoder asCoderViewModel.
	self assert: aCoder example == aCoder example description: 'Example is cached'.
	aResult := aCoder playExampleWithRequesterObject: aViewModel.
	self
		assert: (aResult asGtProxyObject proxyPerform: #isSuccess)
		description: 'Remote example succeeds'.
	self
		assert: ((aCoder example asGtProxyObject proxyPerformReturnProxy: #result)
				proxyPerform: #isSuccess)
		description: 'Example retains its result'.
	^ aCoder
]

{ #category : #examples }
GtRemoteGemStoneMiscellaneousExamples >> sameContentAs [
	"Confirm #sameContentAs: operation in GemStone.
	Requires GT.gs to be loaded.
	noTest as GT.gs is not loaded by default."
	<gtExample>
	<noTest>
	| results |
	results := self runningServer
			evaluateAndWait: '
		{ ('''' sameContentAs: '''').
		(''abc'' sameContentAs: ''abc'').
		(''abc'' sameContentAs: #abc).
		(#abc sameContentAs: ''abc'').
		(#abc sameContentAs: #abc).
		(''abc'' sameContentAs: ''Abc'') not.
		(''abc'' sameContentAs: ''abd'') not.
		(''abc'' sameContentAs: ''ab'') not.
		(''abc'' sameContentAs: nil) not.
		(''abc'' sameContentAs: 123) not.
		(''é'' sameContentAs: ''é'').
		(''é'' sameContentAs: ''e'') not.
		(42 sameContentAs: 42).
		(#(1 2) sameContentAs: #(1 2)).
		(Set with: 1 with: 2) sameContentAs: (Set with: 2 with: 1) }
	'.
	self assert: (results allSatisfy: [ :each | each = true ]).
	^ results
]
