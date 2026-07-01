Class {
	#name : #GtGemStoneTranscriptPhlowTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'remoteTranscript'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'instance creation' }
GtGemStoneTranscriptPhlowTool class >> forRemoteTranscript: aTranscript [
	^ self new 	
			remoteTranscript: aTranscript
]

{ #category : #'api - converting' }
GtGemStoneTranscriptPhlowTool >> asElementDo: aBlock [
	| toolContentModel contentElement |
	
	toolContentModel := GtPhlowMultipleViewsToolContentElementModel forPhlowTool: self.
	toolContentModel headerTitleComputation: [ 
		self remoteTranscript gemStoneSession name
			, '  '
			, self remoteTranscript gemStoneSession statusDescription  ].
	
	contentElement := GtPhlowMultipleViewsContentElement new.
	contentElement toolContentModel: toolContentModel.
	
	^ aBlock cull: contentElement cull: self
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> icon [
	^ BrGlamorousVectorIcons transcript
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> name [
	^ 'GemStone Transcript'
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> object [
	^ self remoteTranscript
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> object: aMethodDefinition [
	self remoteTranscript: aMethodDefinition
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> remoteTranscript [
	^ remoteTranscript
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> remoteTranscript: aTranscript [
	remoteTranscript := aTranscript
]

{ #category : #'testing ' }
GtGemStoneTranscriptPhlowTool >> supportsSelectionHandling [
	"Composite tools know how to extract and restore the selected tool"
	^ true
]

{ #category : #accessing }
GtGemStoneTranscriptPhlowTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconAptitude
]
