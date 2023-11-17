Extension { #name : #GtGemStoneMethodSpecification }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneMethodSpecification class >> forGsMethodProxy: aGsMethodProxy [
	^ self fromJSONDictionary: (aGsMethodProxy gtSession 
		evaluateAndWait: '(GtGemStoneMethodCoderSpecification forGsMethod: self)
			asDictionaryForExport' 
		for: aGsMethodProxy 
		bindings: {} 
		autoCommit: false)
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneMethodSpecification >> gtViewCoderFor: aView [ 
	<gtView>
	
	^ aView explicit 
		title: 'Coder';
		priority: 5;
		stencil: [
			GtGemStoneMethodCoderModel fromCoderSpecification: self ]
]
