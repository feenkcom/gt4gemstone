Class {
	#name : #GtGemStoneDebuggerStackModel,
	#superclass : #GtDebuggerAbstractStackModel,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> createCoderFor: aContext in: aSession [
	| coder |
	
	coder := (GtGemStoneContextCoderModel fromStackFrame: aContext) 
		 debuggingSession: aSession.
	
	coder announcer weak 
		when: GtCoderRefreshStackAnnouncement send: #forceRefreshStack to: self.
	coder announcer weak 
		when: DebugActionExecuted send: #forceRefreshStack to: self.
	
	^ coder
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> setCurrentContext: aContext [
	"Changes the Context to a given one trying to preserve
	cached coders for each stack frame.
	Return true if the context changed"
	<return: #Boolean>
	currentContext == aContext
		ifTrue: [ ^ false ].

	(currentContext notNil and: [ currentContext isDead ])
		ifTrue: [ "self resetCoderViewModelCache" ].

	currentContext := aContext.
	^ true
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateBasedOnCurentContext: aContext [
	"Changes the Context to a given one trying to preserve
	cached coders for each stack frame"
	(self setCurrentContext: aContext)
		ifTrue: [ self updateTopProgramCounterMarkersInCurrentCache ]
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateBasedOnCurentSession [
	self updateBasedOnCurentContext: session remoteContext
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateFrameContextsInCoderModels [
	"Currently the stack frame objects created locally for remote stack frames are
	recreated after every debugging operation. Because of that, whenever updating
	the stack we update the stack frame objects in the cache and in the coder models.
	
	Ideally we should not have this step."
	| currentStackFrames |
	currentStackFrames := session remoteStackFrames.
	
	coderViewModelCache associations do: [ :assoc |
		| frameIndex |
		coderViewModelCache removeKey: assoc key ifAbsent: [ ].
		
		(frameIndex := currentStackFrames indexOf: assoc key) > 0
			ifTrue: [
				assoc value first coderModel
					initializeFromStackFrame: (currentStackFrames at: frameIndex).
				 coderViewModelCache 
				 	at: (currentStackFrames at: frameIndex)
				 	put: assoc value ] ].
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateProgramCounterMarkersInCurrentCache [
	| currentStackFrames |
	currentStackFrames := session remoteStackFrames.
	
	coderViewModelCache keys do: [ :aCachedStackFrame |
		| frameIndex |
		(frameIndex := currentStackFrames indexOf: aCachedStackFrame) > 0
			ifTrue: [
				aCachedStackFrame
					updateProgramCounterMarkers: (currentStackFrames 
						at: frameIndex) programCounterMarkers ] ].
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateTopProgramCounterMarkersInCurrentCache [
	| currentStackFrames |
	currentStackFrames := session remoteStackFrames.
	
	coderViewModelCache 
		at: session remoteContext
		ifPresent: [ :aCachedViewModel |
			aCachedViewModel first coderModel stackFrame
				updateProgramCounterMarkers: session remoteContext
					programCounterMarkers  ]
]
