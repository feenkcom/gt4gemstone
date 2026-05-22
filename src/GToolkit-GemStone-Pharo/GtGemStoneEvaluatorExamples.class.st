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
	| evaluator evalFields serviceClient |

	evaluator := GtRsrVersionedEvaluator new.
	serviceClient := GtRsrProxyServiceClient new
		remoteClass: self class name.
	evalFields := evaluator 
		createEvaluationStringForProxyFromBlock: [ 3 + 4 ] 
		withArguments: #()
		receiver: serviceClient.
	self assert: evalFields first
		equals: '[ 3 + 4 ] valueWithArguments: {  }'.
	self assert: evalFields second size equals: 0.

	evaluator := GtRsrVersionedEvaluator new.
	evalFields := evaluator 
		createEvaluationStringForProxyFromBlock: [ self + super ] 
		withArguments: #()
		receiver: serviceClient.
	self assert: evalFields first
		equals: '[ self + super ] valueWithArguments: {  }'.
	self assert: evalFields second size equals: 0.
	
	evalFields := evaluator
		createEvaluationStringForProxyFromBlock: [ :x | x + 1 ] 
		withArguments: #(1)
		receiver: serviceClient.
	self assert: evalFields first
		equals: '[ :x | x + 1 ] valueWithArguments: { x }'.
	self assert: (evalFields second at: #x) equals: 1.
	
	evalFields := evaluator
		createEvaluationStringForProxyFromBlock: [ :x | super + 1 ] 
		withArguments: #(1)
		receiver: serviceClient.
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
		raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator notCleanBlockErrorMessage ].
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ :x | evaluator ] withArguments: #(1) ]
		raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator notCleanBlockErrorMessage ].
]

{ #category : #examples }
GtGemStoneEvaluatorExamples >> proxyWrongBlockReceiver [
	<gtExample>
	| evaluator serviceClient |

	evaluator := GtRsrVersionedEvaluator new.
	serviceClient := GtRsrProxyServiceClient new
		remoteClass: #Array.
	self should: [ evaluator 
		createEvaluationStringForProxyFromBlock: [ self printString ] 
		withArguments: #()
		receiver: serviceClient ]
			raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator notCleanBlockErrorMessage ].

	self should: [ evaluator 
		createEvaluationStringForProxyFromBlock: [ super printString ] 
		withArguments: #()
		receiver: serviceClient ]
			raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator notCleanBlockErrorMessage ].

]

{ #category : #accessing }
GtGemStoneEvaluatorExamples >> selfPrintStringBlock [

	^ [ self printString ]
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
		raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator notCleanBlockErrorMessage ].
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ :x | x ] ]
		raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator expectZeroBlockErrorMessage ].
	self should: [ evaluator createEvaluationStringFromCleanBlock: [ :x | self ] withArguments: #(1) ]
		raise: Error
			withExceptionDo: [ :ex |
				self assert: ex messageText = GtRsrVersionedEvaluator notCleanBlockErrorMessage ].
]
