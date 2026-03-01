Class {
	#name : #GtGemStoneCardWidgetNoSessions,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneCardWidgetNoSessions >> displayName [

	^ 'No Sessions'
]

{ #category : #accessing }
GtGemStoneCardWidgetNoSessions >> formatBasedOnStatusText: aText [
	^ aText
]

{ #category : #accessing }
GtGemStoneCardWidgetNoSessions >> iconName [
	^ #empty
]

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

{ #category : #accessing }
GtGemStoneCardWidgetNoSessions >> statusDescription [
	^ ''
]
