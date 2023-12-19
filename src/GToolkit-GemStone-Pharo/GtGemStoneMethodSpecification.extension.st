Extension { #name : #GtGemStoneMethodSpecification }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneMethodSpecification class >> forGsMethodProxy: aGsMethodProxy [
	"Creation method on the GT side starting from a proxy to a GemStone method"
	
	^ self fromJSONDictionary: (aGsMethodProxy asGtProxyObject gtSession 
		evaluateBlockAndWait: [ :currentMethod |
			(GtGemStoneMethodSpecification forGsMethod: currentMethod)
				asDictionaryForExport ]
		withArguments: {aGsMethodProxy asGtProxyObject}
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
