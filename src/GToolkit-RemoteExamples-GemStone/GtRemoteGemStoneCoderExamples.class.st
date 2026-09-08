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
