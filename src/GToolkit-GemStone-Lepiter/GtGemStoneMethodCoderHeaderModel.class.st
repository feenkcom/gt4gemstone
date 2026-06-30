Class {
	#name : #GtGemStoneMethodCoderHeaderModel,
	#superclass : #GtMethodCoderHeaderModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder-Support'
}

{ #category : #initialization }
GtGemStoneMethodCoderHeaderModel >> initializeForCoderViewModel: aCoderViewModel [ 
	| coderSpecification |
	coderSpecification := aCoderViewModel coderModel initialMethodCoderSpecification.
	
	coderSpecification explicitProviderBehaviourDetails ifNil:
		[ providerBehaviourName := aCoderViewModel coderModel methodBehavior
			behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
		providerBehaviourIconName := coderSpecification coderClassIconName.
		]
	ifNotNil: [ :aProviderDetails |
			methodBehaviourName := aCoderViewModel coderModel methodBehavior
				behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
			methodBehaviourIconName := coderSpecification coderClassIconName.
			providerBehaviourName := aProviderDetails targetClassName.
			providerBehaviourIconName := aProviderDetails targetClassIconName ].

	packageName := coderSpecification categoryName.
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnMethodBehaviorFor: aCoderViewModel from: anElement [
	aCoderViewModel coderModel methodBehavior realBehaviorDo: [ :aGsBehavior |
		anElement phlow spawnObject:  aGsBehavior ]
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnPackageFor: aCoderViewModel from: anElement [
	"No package spawning supported at the moment"
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnProviderBehaviorFor: aCoderViewModel  from: anElement [
	aCoderViewModel coderModel explicitProviderBehaviour realBehaviorDo: [ :aGsBehavior |
		anElement phlow spawnObject:  aGsBehavior ]
]
