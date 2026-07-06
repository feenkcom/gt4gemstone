Class {
	#name : #GtGemStoneClassDefinitionTab,
	#superclass : #Object,
	#instVars : [
		'tab',
		'toolbar',
		'pane',
		'label',
		'classDefinitionWidget'
	],
	#category : #'GToolkit-GemStone-Pharo-UiClassDefinition'
}

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> classDefinitionTool [

	^ classDefinitionWidget classDefinitionTool
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> classDefinitionWidget [
	^ classDefinitionWidget
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> classDefinitionWidget: aGtGemStoneClassDefinitionWidget [

	classDefinitionWidget := aGtGemStoneClassDefinitionWidget
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> label [
	^ label
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> newPane [

	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> newTab [
	| newTab |

	newTab := BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: label;
		stencil: [ self pane ].
	newTab userData at: #gsDefinitionTab put: self.
	^ newTab
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> newToolbar [

	^ self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> pane [

	^ pane ifNil: [ pane := self newPane ]
]

{ #category : #ui }
GtGemStoneClassDefinitionTab >> setTabVisibility [

	self subclassResponsibility
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> tab [

	^ tab ifNil: [ tab := self newTab ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> toolbar [

	^ toolbar ifNil: [ toolbar := self newToolbar ]
]

{ #category : #accessing }
GtGemStoneClassDefinitionTab >> updateContents [

	self subclassResponsibility
]
