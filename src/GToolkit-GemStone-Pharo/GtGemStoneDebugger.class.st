Class {
	#name : #GtGemStoneDebugger,
	#superclass : #GtGemStonePostMortemDebugger,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebugger >> debuggerProxy [

	^ exception debuggerProxy
]

{ #category : #actions }
GtGemStoneDebugger >> gsRestartFrameLevel: anInteger [

	exception gsRestartFrameLevel: anInteger.
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsResume [

	exception debugResult: exception gsResume.
	exception hasDebugResult: true.
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepIntoFrameLevel: anInteger [

	exception gsStepIntoFrameLevel: anInteger.
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepOverFrameLevel: anInteger [

	exception gsStepOverFrameLevel: anInteger.
	self resetState.
]

{ #category : #actions }
GtGemStoneDebugger >> gsStepThroughFrameLevel: anInteger [

	exception gsStepThroughFrameLevel: anInteger.
	self resetState.
]

{ #category : #accessing }
GtGemStoneDebugger >> gtViewStackFramesFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'GemStone stack frames';
		items: [ self stackFrames ];
		column: 'Index' 
			text: [ :aStackFrame |
				aStackFrame ordinal ]
			width: 75;
		column: 'Method' text: [ :aStackFrame |
			aStackFrame printString ]
]

{ #category : #private }
GtGemStoneDebugger >> resetState [

	stackFrames := nil.
]

{ #category : #accessing }
GtGemStoneDebugger >> stackFrames [
	"Answer a ordered collection of stack frames.
	This is called many times by the debugger, so cache"

	stackFrames ifNil:
		[ stackFrames := exception debuggerState callStack collectWithIndex: [ :frameData :index |
			GtGemStoneStackFrame new
				className: frameData first;
				selector: frameData second;
				inBlock: frameData third;
				exception: exception;
				ordinal: index ] ].
	^ stackFrames
]

{ #category : #accessing }
GtGemStoneDebugger >> summaryString [

	^ exception debuggerState summary
]
