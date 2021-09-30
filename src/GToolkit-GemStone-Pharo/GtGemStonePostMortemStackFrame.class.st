Class {
	#name : 'GtGemStonePostMortemStackFrame',
	#superclass : 'Object',
	#instVars : [
		'ordinal',
		'displayString',
		'exception'
	],
	#category : 'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> displayString [

	^ displayString
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> displayString: anObject [

	displayString := anObject
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> exception [

	^ exception
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> exception: anObject [

	exception := anObject
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> line [
	| re |

	re := 'line (\d+)' asRegexIgnoringCase.
	^ (re search: displayString) 
		ifTrue: [ (re subexpression: 2) asNumber ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> ordinal [

	^ ordinal
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> ordinal: anObject [

	ordinal := anObject
]

{ #category : 'printing' }
GtGemStonePostMortemStackFrame >> printOn: aStream [

	displayString
		ifNil: [ super printOn: aStream ]
		ifNotNil: [ aStream << displayString ]
]

{ #category : 'accessing' }
GtGemStonePostMortemStackFrame >> sourceText [
	| source lineNumber text indexes |
	
	source := (exception gtMethodFromStackString: displayString) sourceCode.
	lineNumber := self line.
	text := source asRopedText.
	lineNumber = 0 ifTrue: [ ^ text ].
	indexes := source gtIndexOfLineNumber: lineNumber.
	indexes ifNotNil: 
		[ (text from: indexes key to: indexes value) 
			attribute: (BlTextHighlightAttribute paint: BrGlamorousColors errorBackgroundColor)
				beNotOverwritableByStyler  ].
	^ text
]
