Class {
	#name : #GtGemStoneDebuggerStateChanged,
	#superclass : #Announcement,
	#instVars : [
		'debugger'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerStateChanged >> debugger [
	^ debugger
]

{ #category : #accessing }
GtGemStoneDebuggerStateChanged >> debugger: anObject [
	debugger := anObject
]
