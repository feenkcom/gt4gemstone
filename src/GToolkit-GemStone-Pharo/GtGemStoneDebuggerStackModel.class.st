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

{ #category : #updating }
GtGemStoneDebuggerStackModel >> setCurrentContext: aContext [
	"Preserve logical frame identity, but always retain the latest frame instance
	and rebind cached coders before exposing the refreshed stack."
	| contextChanged |
	contextChanged := currentContext ~= aContext.
	currentContext := aContext.
	self updateFrameContextsInCoderModels.
	^ contextChanged
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateBasedOnCurentContext: aContext [
	"Changes the Context to a given one trying to preserve
	cached coders for each stack frame"
	self setCurrentContext: aContext.
	
	"Here we need to update the PC markers after every action manually"
	self updateTopProgramCounterMarkersInCurrentCache 
]

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> updateBasedOnCurentSession [
	self updateBasedOnCurentContext: session remoteContext
]

{ #category : #updating }
GtGemStoneDebuggerStackModel >> updateFrameContextsInCoderModels [
	"Retain cached view models and editor documents while rebinding fresh frames.
	A suspended caller's PC is a continuation position, so keep its last call-site
	markers until it becomes the active frame again."
	| currentStackFrames |
	session ifNil: [ ^ self ].
	currentStackFrames := session remoteStackFrames.
	coderViewModelCache associations do: [ :association |
		| frameIndex freshFrame viewModel coder oldFrame oldSource oldMarkers |
		coderViewModelCache removeKey: association key ifAbsent: [ ].
		frameIndex := currentStackFrames indexOf: association key.
		frameIndex > 0 ifTrue: [
			freshFrame := currentStackFrames at: frameIndex.
			viewModel := association value.
			coder := viewModel coderModel.
			oldFrame := coder stackFrame.
			oldFrame == freshFrame ifFalse: [
				oldSource := coder sourceCode.
				oldMarkers := oldFrame programCounterMarkers.
				coder updateFromStackFrame: freshFrame.
				coder sourceCode == oldSource ifTrue: [
					freshFrame = session remoteContext
						ifTrue: [
							(oldMarkers ~= freshFrame programCounterMarkers and: [
								oldFrame programCounterRange ~= freshFrame programCounterRange ])
								ifTrue: [ viewModel updateProgramCounterRange ] ]
						ifFalse: [ freshFrame updateProgramCounterMarkers: oldMarkers ] ] ].
			coderViewModelCache at: freshFrame put: viewModel ] ]
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
			aCachedViewModel coderModel stackFrame
				updateProgramCounterMarkers: session remoteContext
					programCounterMarkers  ]
]
