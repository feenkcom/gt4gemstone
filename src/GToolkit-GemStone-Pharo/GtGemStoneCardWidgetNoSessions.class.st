Class {
	#name : #GtGemStoneCardWidgetNoSessions,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneCardWidgetNoSessions >> isDefaultSession [

	^ false
]

{ #category : #testing }
GtGemStoneCardWidgetNoSessions >> isRunning [

	^ false
]

{ #category : #accessing }
GtGemStoneCardWidgetNoSessions >> name [

	^ 'No Sessions'
]

{ #category : #testing }
GtGemStoneCardWidgetNoSessions >> needsCommit [

	^ false
]
