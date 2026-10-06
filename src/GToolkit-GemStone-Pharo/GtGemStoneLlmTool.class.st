"
Abstract superclass for LLM tools that operate through a GemStone session. It provides an explicitly configurable session and falls back to the default registered session.
"
Class {
	#name : #GtGemStoneLlmTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtGemStoneLlmTool >> session [
	^ session ifNil: [ GtGemStoneSessionRegistry defaultSession ]
]

{ #category : #accessing }
GtGemStoneLlmTool >> session: anObject [
	session := anObject
]
