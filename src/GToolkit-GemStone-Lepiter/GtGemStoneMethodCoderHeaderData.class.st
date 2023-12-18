Class {
	#name : #GtGemStoneMethodCoderHeaderData,
	#superclass : #GtMethodCoderHeaderData,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Support'
}

{ #category : #accessing }
GtGemStoneMethodCoderHeaderData >> initializeForCoderViewModel: aCoderViewModel [ 
	
	targetBehaviourName := aCoderViewModel coderModel methodBehavior
		behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
	
	packageName := aCoderViewModel coderModel 
		initialMethodCoderSpecification 
		categoryName.
]
