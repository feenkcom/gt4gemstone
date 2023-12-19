Class {
	#name : #GtGemStoneMethodCoderHeaderModel,
	#superclass : #GtMethodCoderHeaderModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Support'
}

{ #category : #initialization }
GtGemStoneMethodCoderHeaderModel >> initializeForCoderViewModel: aCoderViewModel [ 
	
	targetBehaviourName := aCoderViewModel coderModel methodBehavior
		behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
	
	packageName := aCoderViewModel coderModel 
		initialMethodCoderSpecification 
		categoryName.
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnBehaviorFor: aCoderViewModel  from: anElement [
	aCoderViewModel coderModel methodBehavior realBehaviorDo: [ :aGsBehavior |
		anElement phlow spawnObject:  aGsBehavior ]
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnPackageFor: aCoderViewModel from: anElement [
	"No package spawning supported at the moment"
]
