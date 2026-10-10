Class {
	#name : #GtRemoteGemStoneCoderExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneCoderExamples >> compileAllOnGemStone [
	<gtExample>
	<noTest>
	"Requires a connected default GemStone session. Verify every descriptor's source and protocol after recompiling twice."
	| session script result |
	session := self runningServer.
	GtGemStoneExtensionMethods compileAllOnGemStone.
	script := String streamContents: [ :stream |
		stream nextPutAll: '{'; cr.
		GtGemStoneExtensionMethods extensionSelectors
			do: [ :selector |
				| method |
				method := GtGemStoneExtensionMethods class >> selector.
				stream
					nextPutAll: '((GtGemStoneExtensionMethods class compiledMethodAt: ';
					print: selector;
					nextPutAll: ') sourceString = ';
					print: method sourceCode;
					nextPutAll: ') & ((GtGemStoneExtensionMethods class categoryOfSelector: ';
					print: selector;
					nextPutAll: ') asString = ';
					print: method protocolName asString;
					nextPutAll: ')' ]
			separatedBy: [ stream nextPutAll: '.'; cr ].
		stream cr; nextPutAll: '} allSatisfy: [ :each | each ]' ].
	result := session evaluateAndWait: script.
	self assert: result equals: true.
	^ GtGemStoneExtensionMethods extensions
]

{ #category : #examples }
GtRemoteGemStoneCoderExamples >> computeRealBehaviour [
	<gtExample>
	| session coderNamedBehavior classProxy printString |

	session := self runningServer.
	coderNamedBehavior := GtGemStoneCoderNamedBehavior new
		session: session;
		behaviorName: #Dictionary;
		isMeta: false.

	classProxy := coderNamedBehavior computeRealBehaviour.
	printString := classProxy proxyPerform: #printString.
	self assert: (printString includesSubstring: 'Dictionary').
	self assert: (printString includesSubstring: 'class') not.

	coderNamedBehavior isMeta: true.
	classProxy := coderNamedBehavior computeRealBehaviour.
	printString := classProxy proxyPerform: #printString.
	self assert: (printString includesSubstring: 'Dictionary class').
]

{ #category : #examples }
GtRemoteGemStoneCoderExamples >> gemStoneImplementors [
	<gtExample>
	<return: #GtGemStoneMethodsSpecification>
	| coder specifications minimumVersion |
	
	"Skip this example if the server version is below v1.1.597"
	minimumVersion := GtGemStoneSemanticVersionNumber major: 1 minor: 1 patch: 597.
	(self runningServer gt4gemstoneVersion
		exBetween: GtGemStoneSemanticVersionNumber zero
		and: minimumVersion) ifTrue: 
			[ ^ self ].

	coder := GtGemStoneMethodCoderModel new session: self runningServer.
	specifications := coder gemStoneImplementorsOf: #printString.
	self assert: specifications size > 0.
	^ specifications
]
