Class {
	#name : 'GtGsBareProxy',
	#superclass : 'Object',
	#instVars : [
		'serviceClient'
	],
	#category : 'GToolkit-GemStone-BareProxy-Pharo'
}

{ #category : 'instance creation' }
GtGsBareProxy class >> forServiceClient: aServiceClient [
	^ self new
		serviceClient: aServiceClient
]

{ #category : 'comparing' }
GtGsBareProxy >> = anObject [ 
	^ self == anObject
]

{ #category : 'reflective operations' }
GtGsBareProxy >> doesNotUnderstand: aMessage [ 
	"In case the proxy has no remote client or the client is not logged in
	do not propagate the message to the remote object. If the return value 
	is not a primitive type I convert it to a bare proxy."
	
	^ self isProxyObjectActive 
		ifFalse: [ super doesNotUnderstand: aMessage  ]
		ifTrue: [ self performRemotely: aMessage selector withArguments: aMessage arguments ]
]

{ #category : 'transformation' }
GtGsBareProxy >> gtGsAsBareProxy [
	^ self
]

{ #category : 'transformation' }
GtGsBareProxy >> gtGsBareProxyAsClientService [
	^ self serviceClient
]

{ #category : 'comparing' }
GtGsBareProxy >> hash [
	^ self identityHash
]

{ #category : 'testing' }
GtGsBareProxy >> isProxyObjectActive [
	^ self serviceClient 
		ifNil: [ false ] 
		ifNotNil: [ :aProxyService | 
			aProxyService connection isOpen ] 
]

{ #category : 'actions - proxy' }
GtGsBareProxy >> performRemotely: aSelector [
	^ self performRemotely: aSelector withArguments: #()
]

{ #category : 'actions - proxy' }
GtGsBareProxy >> performRemotely: aSelector with: anArgument [
	^ self performRemotely: aSelector withArguments: { anArgument }
]

{ #category : 'actions - proxy' }
GtGsBareProxy >> performRemotely: aSelector withArguments: argumentsArray [
	"Perform remotely aSelector with the given arguments and create a proxy object 
	if the remote call returned a reference to a remote object. If the remote call 
	returned a primitive value return it directly without creating a proxy object.
	Primitive arguments are pased by value. Proxy arguments are passed based on their
	proxy service, meaning that the actual remote object will be passed to the remote method."
	| result transfomedArguments |
		
	transfomedArguments := argumentsArray collect: [ :anObject |
		anObject gtGsBareProxyAsClientService ].
	result := self 
		rawPerformRemotely: aSelector 
		withArguments: transfomedArguments.
	^ result gtGsAsBareProxy
]

{ #category : 'actions - proxy' }
GtGsBareProxy >> rawPerformRemotely: aSelector [
	^ self rawPerformRemotely: aSelector withArguments: #()
]

{ #category : 'actions - proxy' }
GtGsBareProxy >> rawPerformRemotely: aSelector with: anArgument [
	^ self rawPerformRemotely: aSelector withArguments: { anArgument }
]

{ #category : 'actions - proxy' }
GtGsBareProxy >> rawPerformRemotely: aSelector withArguments: anArgumentsArrayOfServices [
	^ self serviceClient 
		proxyPerform: aSelector 
		withArguments: anArgumentsArrayOfServices
]

{ #category : 'accessing' }
GtGsBareProxy >> serviceClient [
	^ serviceClient 
]

{ #category : 'accessing' }
GtGsBareProxy >> serviceClient: aServiceClient [
	serviceClient ifNotNil: [ 
		Error signal: 'Cannot change the service client associated with a proxy object.' ].
	serviceClient := aServiceClient
]
