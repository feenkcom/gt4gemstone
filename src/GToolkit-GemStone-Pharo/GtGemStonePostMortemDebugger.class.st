Class {
	#name : #GtGemStonePostMortemDebugger,
	#superclass : #Object,
	#instVars : [
		'exception',
		'session',
		'stackFrames'
	],
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStonePostMortemDebugger >> breakpoints [

	^ Dictionary new
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> defaultFrameOrdinalFrom: aCollectionOfStackFrames [
	"Answer the ordinal (level) of the frame that should be displayed in the debugger.
	The stack normally includes a number of frames that relate to a halt or breakpoint, which the user isn't interested in.  Select the first frame that is probably user code."

	aCollectionOfStackFrames size - 1 to: 1 by: -1 do: [ :i |
		(#(halt 
		_signalAsync: 
		doesNotUnderstand: 
		_compileInContext:symbolList:
		signal) 
			includes: (aCollectionOfStackFrames at: i) selector) ifTrue:
				[ ^ i + 1 ] ].
	^ 1
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> exception [

	^ exception
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> exception: anObject [

	exception := anObject
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> messageText [

	^ exception messageText
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> session [
	"Answer the GtGemStoneSession associated with the receiver's exception"
	<return: #GtGemStoneSession>

	^ session ifNil: [ session := exception gtSession ]
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
		[ stackFrames := exception stackFrames ]
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
		ifFalse: [ self session evaluateAndWait: 'System gemLogFileName asFileReference contents' ]
]

{ #category : #accessing }
GtGemStonePostMortemDebugger >> summaryString [
	"Answer a short string summarising the receiver's exception"

	^ self exception summaryString
]
