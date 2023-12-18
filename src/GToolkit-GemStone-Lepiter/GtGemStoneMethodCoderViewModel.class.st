Class {
	#name : #GtGemStoneMethodCoderViewModel,
	#superclass : #GtGemStoneSourceCoderViewModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> computeHeaderBreadcrumbData [
	^ GtGemStoneMethodCoderHeaderData new 
		initializeForCoderViewModel: self.
]

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> elementClass [
	^ GtExpandableMethodCoderElement
]

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> gsMethod [
	^ self coderModel gsMethod
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

{ #category : #'api - header' }
GtGemStoneMethodCoderViewModel >> headerElementClass [
	^ GtPharoMethodCoderHeaderElement
]

{ #category : #testing }
GtGemStoneMethodCoderViewModel >> isMeta [
	"Return true if the method is implemented in a GemStone metaclass (~ class side)"
	<return: #Boolean>

	^ self coderModel isMeta
]

{ #category : #testing }
GtGemStoneMethodCoderViewModel >> isSaveEnabled [
	^ true
]

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> save [
	| aSaveResult |
	<return: #Boolean>
	
	self isSaveEnabled
		ifFalse: [ ^ false ].

	aSaveResult := self coderModel saveInContext: self evaluationContext.
	"aSaveResult ifTrue: [ self notifySaved: self compiledMethod ]."

	^ aSaveResult
]
