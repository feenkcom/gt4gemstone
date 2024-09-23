Class {
	#name : #GtGemStoneWorkspaceVariable,
	#superclass : #WorkspaceVariable,
	#instVars : [
		'gemstoneSession'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> gemstoneSession [
	^ gemstoneSession
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> gemstoneSession: anObject [
	gemstoneSession := anObject
]

{ #category : #accessing }
GtGemStoneWorkspaceVariable >> invalidBindingErrorMessage [
	^ '{1} holds an object from another session and cannot be used.'
			format: {self name}
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
