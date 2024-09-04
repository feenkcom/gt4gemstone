Extension { #name : #GtCoderAction }

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtCoderAction >> isGemStoneExecutionAction [
	^ self propertyAt: #gemStoneExecutionAction ifAbsent: [ false ]
]

{ #category : #'*GToolkit-GemStone-Lepiter' }
GtCoderAction >> markAsGemStoneExecutionAction [
	self propertyAt: #gemStoneExecutionAction put: true
]
