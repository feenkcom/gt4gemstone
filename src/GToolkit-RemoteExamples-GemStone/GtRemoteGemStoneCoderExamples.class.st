Class {
	#name : #GtRemoteGemStoneCoderExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

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
	| coder specifications |
	coder := GtGemStoneMethodCoderModel new session: self runningServer.
	specifications := coder gemStoneImplementorsOf: #printString.
	self assert: specifications size > 0.
	^ specifications
]
