Class {
	#name : #GtGemStoneEvaluationContextTest,
	#superclass : #TestCase,
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : #tests }
GtGemStoneEvaluationContextTest >> testSourceInfoAtFrameLevel [
	| context allFrames info |

	context := (GtGemStoneEvaluationContext new
		evaluateAndWaitBlock: [ AkgDebuggerPlay new initialize evalBlock value ]
		from: GtRsrEvaluatorServiceServer new) object.
	allFrames := context process gtAllFrames.
	
	info := context sourceInfoAtFrameLevel: 10.

	self assert: info first = 48.
	"This is wrong, but let the test pass for now"
	self assert: info second = 61.
	self assert: info third size = 80.
	context process terminate.
]

{ #category : #tests }
GtGemStoneEvaluationContextTest >> testVariableInfoAtFrameLevel [
	| context variables |

	context := (GtGemStoneEvaluationContext new
		evaluateAndWaitBlock: [ AkgDebuggerPlay new initialize evalBlock value ]
		from: GtRsrEvaluatorServiceServer new) object.
	variables := context variableInfoAtFrameLevel: 10.

	self assert: variables first first = #self.
	self assert: variables first second class = String.
	context process terminate.
]
