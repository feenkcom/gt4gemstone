Class {
	#name : #GtGemStoneDebuggerStackModel,
	#superclass : #GtDebuggerAbstractStackModel,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}

{ #category : #accessing }
GtGemStoneDebuggerStackModel >> context: aContext [
	(context isNil or: [ 
		context remoteIdentity ~= aContext remoteIdentity ]) ifTrue: [ 
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
					at: aContext remoteIdentity 
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
	self context: session remoteContext
]
