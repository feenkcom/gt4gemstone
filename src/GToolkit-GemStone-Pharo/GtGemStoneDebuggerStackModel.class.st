Class {
	#name : #GtGemStoneDebuggerStackModel,
	#superclass : #GtDebuggerAbstractStackModel,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> context: aContext [
	(context isNil or: [ 
		context ~= aContext ]) ifTrue: [ 
			"(context notNil and: [ context isDead ])
				ifTrue: [ self resetCoderViewModelCache ]."
			context := aContext.
			self updateContextStreams ]
]

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
GtGemStoneDebuggerStackModel >> getCoderViewModelForContext: aContext [
	^ lock
		critical: [ | entry |
			"method := aContext isBlockContext ifFalse: [ aContext compiledCode ]."
			entry := coderViewModelCache
					at: aContext 
					ifAbsentPut: [ {
						(self createCoderFor: aContext in: session) asCoderViewModel.
						"method" } ].
			"(entry at: 2) ~~ method
				ifTrue: [ 
					entry first coder forMethod: method.
					entry at: 2 put: method ]."
			entry at: 1 ]
		ifError: [ nil ]
]

{ #category : #initialization }
GtGemStoneDebuggerStackModel >> initialize [
	super initialize.
	
	coderViewModelCache := Dictionary new.
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateContent [
	self context: session remoteContext.
	self updateTopProgramCounterMarkersInCurrentCache.
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
		coderViewModelCache removeKey: assoc key.
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
