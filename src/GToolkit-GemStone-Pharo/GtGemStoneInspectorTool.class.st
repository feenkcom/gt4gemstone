Class {
	#name : #GtGemStoneInspectorTool,
	#superclass : #GtRemoteInspectorTool,
	#category : #'GToolkit-GemStone-Pharo-Phlow Tool'
}

{ #category : #accessing }
GtGemStoneInspectorTool >> icon [
	^ BrGlamorousVectorIcons gemStone
]

{ #category : #initialization }
GtGemStoneInspectorTool >> initialize [
	super initialize.
	
	self name: 'GemStone'.
]
