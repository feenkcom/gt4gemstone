Class {
	#name : #GtGemStoneMethodCoderViewModel,
	#superclass : #GtGemStoneSourceCoderViewModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> elementClass [
	^ GtExpandableMethodCoderElement
]

{ #category : #testing }
GtGemStoneMethodCoderViewModel >> hasDeclaredGlobalNamed: aVariableName [
	"TODO: implement"
	^ false
]

{ #category : #testing }
GtGemStoneMethodCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	"TODO: implement"
	^ false
]

{ #category : #testing }
GtGemStoneMethodCoderViewModel >> isMeta [
	"Return true if the method is implemented in a GemStone metaclass (~ class side)"
	<return: #Boolean>

	^ self coderModel isMeta
]
