Class {
	#name : #GtGemStoneMethodCoderViewModel,
	#superclass : #GtGemStoneSourceCoderViewModel,
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> computeHeaderBreadcrumbModel [
	^ GtGemStoneMethodCoderHeaderModel new 
		initializeForCoderViewModel: self.
]

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> computeReceiverObject [
	^ super computeReceiverObject ifNil: [
		self coderModel gsBehavior asGtProxyObject gtSession == self session
			ifTrue: [ self coderModel gsBehavior ]
			ifFalse: [ nil ] ]
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

{ #category : #printing }
GtGemStoneMethodCoderViewModel >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		self coder printDescriptionOn: aStream ]
]

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> save [
	<return: #Boolean>
	| aSaveResult |
	
	self isSaveEnabled
		ifFalse: [ ^ false ].

	aSaveResult := self coderModel saveInContext: self evaluationContext.
	"aSaveResult ifTrue: [ self notifySaved: self compiledMethod ]."

	^ aSaveResult
]

{ #category : #accessing }
GtGemStoneMethodCoderViewModel >> session [

	^ self coderModel session
]
