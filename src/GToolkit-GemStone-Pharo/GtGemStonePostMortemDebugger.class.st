Class {
	#name : #GtGemStonePostMortemDebugger,
	#superclass : #Object,
	#instVars : [
		'exception',
		'session',
		'stackFrames'
	],
	#category : 'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStonePostMortemDebugger >> exception [

	^ exception
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> exception: anObject [

	exception := anObject
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> session [
	"Answer the GtGemStoneSession associated with the receiver's exception"
	<return: #GtGemStoneSession>

	^ session ifNil: [ session := GtGemStoneSessionRegistry default 
		sessionWithConnection: exception _connection ]
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> sourceStyler [
	"Answer the styler used by the source code editor for this exception"

	^ BrRBTextStyler new
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> stackFrames [
	"Answer a ordered collection of stack frames.
	This is called many times by the debugger, so cache"

	^ stackFrames ifNil:
		[ stackFrames := exception gtDisplayedStackFrames collectWithIndex:
			[ :each :index | GtGemStonePostMortemStackFrame new
				ordinal: index;
				displayString: each;
				exception: exception ] ]
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> stderr [

	^ '<unavailable>'
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> stdout [
	"Answer the stdout (NetLDI & Transcript) of the receiver's Gem.
	Currently assumes that the Gem and the debugger have access to the same file system."
	| logFile |

	logFile := self session gemLogFileReference.
	^ logFile exists
		ifTrue: [ logFile contents ]
		ifFalse: [ '' ]
]
