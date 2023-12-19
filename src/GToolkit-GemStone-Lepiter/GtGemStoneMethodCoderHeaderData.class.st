Class {
	#name : #GtGemStoneMethodCoderHeaderData,
	#superclass : #GtMethodCoderHeaderData,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Support'
}

{ #category : #initialization }
GtGemStoneMethodCoderHeaderData >> initializeForCoderViewModel: aCoderViewModel [ 
	
	targetBehaviourName := aCoderViewModel coderModel methodBehavior
		behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
	
	packageName := aCoderViewModel coderModel 
		initialMethodCoderSpecification 
		categoryName.
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderData >> spawnBehaviorFor: aCoderViewModel  from: anElement [
	aCoderViewModel coderModel methodBehavior realBehaviorDo: [ :aGsBehavior |
		anElement phlow spawnObject:  aGsBehavior ]
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderData >> spawnPackageFor: aCoderViewModel from: anElement [
	"No package spawning supported at the moment"
]
