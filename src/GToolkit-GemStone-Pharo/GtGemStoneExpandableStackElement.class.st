Class {
	#name : #GtGemStoneExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneExpandableStackElement >> updateForSession: aDebuggingSession [
	self
		inUIProcessDo: [ 
			| stackFrames currentCallFrame |

			stackFrames := aDebuggingSession debuggerClient stackFrames.
			currentCallFrame ifNil: [ 
				currentCallFrame := stackFrames 
					at: aDebuggingSession debuggerClient defaultFrameOrdinal ].
		
			self stackFramesList items: (stackFrames collect: [ :aGsFrame |
		 		(GtGemStoneContextCoderModel 
		 			fromStackFrame: aGsFrame) asCoderViewModel ]).
		 			
			self selectContext:  currentCallFrame ]
]
