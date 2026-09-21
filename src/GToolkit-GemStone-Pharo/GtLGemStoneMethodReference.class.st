"
A value object describing a GemStone method by class name, selector, class-side flag, and optional environment ID. The default environment is 0.
"
Class {
	#name : #GtLGemStoneMethodReference,
	#superclass : #Object,
	#instVars : [
		'methodClassName',
		'methodName',
		'classSide',
		'environmentId'
	],
	#category : #'GToolkit-GemStone-Pharo-MCP'
}

{ #category : #accessing }
GtLGemStoneMethodReference >> classSide [
	^ classSide ifNil: [ false ]
]

{ #category : #accessing }
GtLGemStoneMethodReference >> classSide: aBoolean [
	classSide := aBoolean
]

{ #category : #magritte }
GtLGemStoneMethodReference >> classSideDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		default: false;
		beRequired
]

{ #category : #accessing }
GtLGemStoneMethodReference >> environmentId [
	^ environmentId ifNil: [ 0 ]
]

{ #category : #accessing }
GtLGemStoneMethodReference >> environmentId: anInteger [
	environmentId := anInteger
]

{ #category : #magritte }
GtLGemStoneMethodReference >> environmentIdDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Environment ID';
		accessor: #environmentId;
		beInteger;
		default: 0;
		yourself
]

{ #category : #accessing }
GtLGemStoneMethodReference >> isClassSide [
	^ self classSide
]

{ #category : #accessing }
GtLGemStoneMethodReference >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLGemStoneMethodReference >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #magritte }
GtLGemStoneMethodReference >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #methodClassName;
		beRequired
]

{ #category : #accessing }
GtLGemStoneMethodReference >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLGemStoneMethodReference >> methodName: anObject [
	methodName := anObject
]

{ #category : #magritte }
GtLGemStoneMethodReference >> methodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]
