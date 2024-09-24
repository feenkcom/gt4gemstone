Class {
	#name : #GtGemStoneWorkspaceVariable,
	#superclass : #WorkspaceVariable,
	#instVars : [
		'gemstoneSession'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> currentSessionName [
	^ gemstoneSession name
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> defaultErrorMessage [
	^ '{1} holds an object from another session and cannot be used.'
			format: {self name}
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> fromNamedSessionsErrorMessage [
	| valueSessionState|
	valueSessionState := value gtSession isRunning 
		ifTrue: [ 'running' ]
		ifFalse: ['disconnected'].
	
	^ '{1} cannot be used because it holds an object from another {2} {3} session instance'
		format: {
			self name.
			valueSessionState.
			value gtSession displayName}
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> gemstoneSession [
	^ gemstoneSession
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> gemstoneSession: anObject [
	gemstoneSession := anObject
]

{ #category : #testing }
GtGemStoneWorkspaceVariable >> hasBothNamedSessions [
	value gtSession ifNil: [ ^ false ].
	
	^ self currentSessionName notNil and: [
		self valueSessionName notNil ]
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> invalidBindingErrorMessage [
	self hasBothNamedSessions ifTrue: [
		^ self fromNamedSessionsErrorMessage].
	
	^ self defaultErrorMessage
]

{ #category : #testing }
GtGemStoneWorkspaceVariable >> isInvalidBinding [
	^ self isValidBinding not
]

{ #category : #testing }
GtGemStoneWorkspaceVariable >> isValidBinding [
	| bindingValue |
	bindingValue := self value asGtProxyObject .
	^ (bindingValue isKindOf: RsrService) not or: [ 
		bindingValue isProxyObjectActive and: [ 
			gemstoneSession connection = bindingValue _connection ] ]
]

{ #category : #'gt - extensions' }
GtGemStoneWorkspaceVariable >> statusColor [
	^ self isValidBinding
		ifTrue: [ BrGlamorousColors successBackgroundColor ]
		ifFalse: [ BrGlamorousColors failureBackgroundColor ]
]

{ #category : #'gt - extensions' }
GtGemStoneWorkspaceVariable >> statusLabel [
	^ self isValidBinding
		ifTrue: ['Valid']
		ifFalse: [ 'Invalid' ] 
]

{ #category : #'gt - extensions' }
GtGemStoneWorkspaceVariable >> valueColor [
	^ self isValidBinding
		ifTrue: [ Color transparent ]
		ifFalse: [BrGlamorousColors failureBackgroundColor]
]

{ #category : #'gt - extensions' }
GtGemStoneWorkspaceVariable >> valueLabel [
	^ self isValidBinding
		ifTrue: [ self value ]
		ifFalse: [ '<invalid>'] 
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> valueSessionName [
	^ value gtSession name
]
