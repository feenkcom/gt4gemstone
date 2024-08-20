Extension { #name : #RsrPromise }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrPromise >> canHandleSpecificDebugger [
	^ self isResolved and: [
		self isBroken not "or: [
			value class ~= RsrConnectionClosedBeforeReceivingResponse ]" ]
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrPromise >> isGtEvaluationException [
	"Answer a boolean indicating if the result is an evaluation exception"

	^ self isFulfilled and: [ 
		(value class = GtpoGtGemStoneEvaluationContext) or: [ 
			GtGemstoneEvaluationWithExceptionResult isSerializedDataForCurrentClass: value ] ]
]
