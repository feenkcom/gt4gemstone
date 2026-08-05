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
		[ methodReceiverBehaviorName := aCoderViewModel coderModel methodBehavior
			behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
		methodReceiverBehaviourIconName := coderSpecification coderClassIconName.
		]
	ifNotNil: [ :aProviderDetails |
			methodDefiningBehaviourName := aCoderViewModel coderModel methodBehavior
				behaviorNameDo: [ :aBehaviourName | aBehaviourName ].
			methodDefiningBehaviourIconName := coderSpecification coderClassIconName.
			methodReceiverBehaviorName := aProviderDetails targetClassName.
			methodReceiverBehaviourIconName := aProviderDetails targetClassIconName ].

	packageName := coderSpecification categoryName.
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnMethodDefiningBehaviorFor: aCoderViewModel from: anElement [
	aCoderViewModel coderModel methodBehavior realBehaviorDo: [ :aGsBehavior |
		anElement phlow spawnObject:  aGsBehavior ]
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnMethodReceiverBehaviorFor: aCoderViewModel  from: anElement [
	aCoderViewModel coderModel explicitProviderBehaviour realBehaviorDo: [ :aGsBehavior |
		anElement phlow spawnObject:  aGsBehavior ]
]

{ #category : #'actions - spawning' }
GtGemStoneMethodCoderHeaderModel >> spawnPackageFor: aCoderViewModel from: anElement [
	"No package spawning supported at the moment"
]
