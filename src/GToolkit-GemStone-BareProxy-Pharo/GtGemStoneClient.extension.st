Extension { #name : 'GtGemStoneClient' }

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtGemStoneClient >> proxyEvaluateAndWait: remoteScript [
	^ self 
		proxyEvaluateAndWait: remoteScript
		for: nil 
		bindings: Dictionary new
]

{ #category : '*GToolkit-GemStone-BareProxy-Pharo' }
GtGemStoneClient >> proxyEvaluateAndWait: remoteScript for: anObject bindings: remoteBindings [

	^ (evaluator evaluateAndWait: remoteScript for: anObject bindings: remoteBindings) gtGsAsBareProxy
]
