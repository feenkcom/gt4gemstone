Class {
	#name : #GtGemStoneEvaluatorExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtGemStoneEvaluatorExamples >> proxyCleanBlock [
	<gtExample>
	| evaluator evalFields |

	evaluator := GtRsrVersionedEvaluator new.
	evalFields := evaluator createEvaluationStringForProxyFromBlock: [ 3 + 4 ] withArguments: #().
	self assert: evalFields first
		equals: '[ 3 + 4 ] valueWithArguments: {  }'.
	self assert: evalFields second size equals: 0.

	evaluator := GtRsrVersionedEvaluator new.
	evalFields := evaluator createEvaluationStringForProxyFromBlock: [ self + super ] withArguments: #().
	self assert: evalFields first
		equals: '[ self + super ] valueWithArguments: {  }'.
	self assert: evalFields second size equals: 0.
	
	evalFields := evaluator
		createEvaluationStringForProxyFromBlock: [ :x | x + 1 ] 
		withArguments: #(1).
	self assert: evalFields first
		equals: '[ :x | x + 1 ] valueWithArguments: { x }'.
	self assert: (evalFields second at: #x) equals: 1.
	
	evalFields := evaluator
		createEvaluationStringForProxyFromBlock: [ :x | super + 1 ] 
		withArguments: #(1).
	self assert: evalFields first
		equals: '[ :x | super + 1 ] valueWithArguments: { x }'.
	self assert: (evalFields second at: #x) equals: 1.
]

{ #category : #examples }
GtGemStoneEvaluatorExamples >> proxyDirtyBlock [
	<gtExample>
	| evaluator |

	evaluator := GtRsrVersionedEvaluator new.
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ evaluator ] withArguments: #() ]
		raise: Error.
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ :x | evaluator ] withArguments: #(1) ]
		raise: Error.
]

{ #category : #examples }
GtGemStoneEvaluatorExamples >> sessionCleanBlock [
	<gtExample>
	| evaluator evalFields |

	evaluator := GtRsrVersionedEvaluator new.
	self assert: (evaluator createEvaluationStringFromCleanBlock: [ 3 + 4 ])
		equals: '[ 3 + 4 ] value'.

	evalFields := evaluator
		createEvaluationStringFromCleanBlock: [ :x | x + 1 ] 
		withArguments: #(1).
	self assert: evalFields first
		equals: 'self valueWithArguments: { x }'.
	self assert: (evalFields second at: #x) equals: 1.
]

{ #category : #examples }
GtGemStoneEvaluatorExamples >> sessionDirtyBlock [
	<gtExample>
	| evaluator |

	evaluator := GtRsrVersionedEvaluator new.
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ self yourself ] ]
		raise: Error.
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ :x | x ] ]
		raise: Error.
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ :x | self ] withArguments: #(1) ]
		raise: Error.
]
