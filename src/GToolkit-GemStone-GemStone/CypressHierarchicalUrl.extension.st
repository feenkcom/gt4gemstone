Extension { #name : #CypressHierarchicalUrl }

{ #category : #'*GToolkit-GemStone-GemStone' }
CypressHierarchicalUrl >> / aString [
	path addAll: ($/ split: aString)
]
