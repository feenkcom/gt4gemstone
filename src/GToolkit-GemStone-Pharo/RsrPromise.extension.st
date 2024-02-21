Extension { #name : #RsrPromise }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrPromise >> canHandleSpecificDebugger [
	^ self isResolved and: [
		self isBroken not "or: [
			value class ~= RsrConnectionClosedBeforeReceivingResponse ]" ]
]
