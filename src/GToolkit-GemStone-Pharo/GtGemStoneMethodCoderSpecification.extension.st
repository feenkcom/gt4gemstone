Extension { #name : #GtGemStoneMethodCoderSpecification }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneMethodCoderSpecification class >> forGsMethodProxy: aGsMethodProxy [
	^ self fromJSONDictionary: (aGsMethodProxy gtSession 
		evaluateAndWait: '(GtGemStoneMethodCoderSpecification forGsMethod: self)
			asDictionaryForExport' 
		for: aGsMethodProxy 
		bindings: {} 
		autoCommit: false)
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneMethodCoderSpecification >> gtViewCoderFor: aView [ 
	<gtView>
	
	^ aView explicit 
		title: 'Coder';
		priority: 5;
		stencil: [
			GtGemStoneMethodCoderModel fromCoderSpecification: self ]
]
