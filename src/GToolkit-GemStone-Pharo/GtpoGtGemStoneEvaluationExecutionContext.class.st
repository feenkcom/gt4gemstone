Class {
	#name : #GtpoGtGemStoneEvaluationExecutionContext,
	#superclass : #GtpoGtGemStoneEvaluationContext,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtGemStoneEvaluationExecutionContext class >> remoteClassName [
	^ #GtGemStoneEvaluationExecutionContext
]

{ #category : #accessing }
GtpoGtGemStoneEvaluationExecutionContext >> wait [
	^ self proxyPerform: #wait
]
