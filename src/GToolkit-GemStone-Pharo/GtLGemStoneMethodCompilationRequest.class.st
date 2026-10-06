"
A GemStone method compilation request that optionally identifies the GemStone environment in which the method is compiled. The default environment is 0.
"
Class {
	#name : #GtLGemStoneMethodCompilationRequest,
	#superclass : #GtLMethodCompilationRequest,
	#instVars : [
		'environmentId'
	],
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtLGemStoneMethodCompilationRequest >> environmentId [
	^ environmentId ifNil: [ 0 ]
]

{ #category : #accessing }
GtLGemStoneMethodCompilationRequest >> environmentId: anInteger [
	environmentId := anInteger
]

{ #category : #'magritte descriptions' }
GtLGemStoneMethodCompilationRequest >> environmentIdDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Environment ID';
		accessor: #environmentId;
		beInteger;
		default: 0;
		yourself
]
