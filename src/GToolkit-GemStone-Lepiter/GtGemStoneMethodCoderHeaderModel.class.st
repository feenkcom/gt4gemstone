Class {
	#name : #GtGemStoneMethodCoderHeaderModel,
	#superclass : #GtMethodCoderHeaderModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Support'
}

{ #category : #initialization }
GtGemStoneMethodCoderHeaderModel >> initializeForCoderViewModel: aCoderViewModel [ 
	| coderSpecification |
	coderSpecification := aCoderViewModel coderModel initialMethodCoderSpecification.
	
	targetBehaviourName := aCoderViewModel coderModel methodBehavior
		behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
	targetBehaviourIconName := coderSpecification coderClassIconName.
	
	coderSpecification explicitProviderBehaviourDetails 
		ifNotNil: [ :aProviderDetails |
			providerBehaviourName := aProviderDetails targetClassName.
			providerBehaviourIconName := aProviderDetails targetClassIconName ].

	packageName := coderSpecification categoryName.
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
