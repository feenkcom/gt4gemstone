Class {
	#name : 'GtGsBareProxy',
	#superclass : 'ProtoObject',
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

{ #category : 'gt - coder' }
GtGsBareProxy class >> gtCoderSlotNames [
	"Answer the slot names to be bound by GtPharoSourceCoderViewModel.
	Answer an empty Array since we don't want to see the proxy object itself."


	^ #()
]

{ #category : 'comparing' }
GtGsBareProxy >> = anObject [ 
	^ self == anObject
]

{ #category : 'transformation' }
GtGsBareProxy >> asGtBareProxy [
	^ self
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
GtGsBareProxy >> gtGsBareProxyAsClientService [
	^ self serviceClient
]

{ #category : 'simulation' }
GtGsBareProxy >> gtLocalViewsFor: aView inContext: aContext [
	| title resultingView |

	title := String streamContents: [ :stream |
				stream
					<< 'Proxy to a(n): ';
					<< (serviceClient
						ifNil: [ '<unknown>' ]
						ifNotNil: [ serviceClient proxyPerform: #printString ]) ].
	resultingView := ((aView composite
		views: (self gtViewsInContext: aContext))
		labelled: title).
	^ resultingView
]

{ #category : 'simulation' }
GtGsBareProxy >> gtViewsFor: aView inContext: aContext [
	| resultingView inspectorViews |

	resultingView := self gtLocalViewsFor: aView inContext: aContext.
	inspectorViews := resultingView originalView views.

	"Add the explicitly declarative views from the inspected object"
	inspectorViews addAll: (serviceClient viewsFor: aView).

	"Re-sort by priority"
	inspectorViews := inspectorViews sorted: [ :a :b | a priority < b priority ].
	resultingView originalView views: inspectorViews.
	^resultingView

]

{ #category : 'simulation' }
GtGsBareProxy >> gtViewsInContext: aContext [
	"This collects all views for the current object.
	For a proxy we just want the Raw view renamed as 'Proxy'"
	| views |

	views := super gtViewsInContext: aContext.
	"Retitle the original Raw view to Proxy and lower priority"
	views 
		detect: [ :each | each title = #Raw ]
		ifFound: [ :proxyRaw |
			proxyRaw
			title: #Proxy;
			priority: 10000 ].
	"Remove the default Print view, the remote can supply it later"
	views 
		detect: [ :each | each title = #Print ]
		ifFound: [ :proxyPrint | views remove: proxyPrint ].
	
	"views add: (self gtProxyRawFor: GtPhlowEmptyView new)."
	^ views.
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
	^ result asGtBareProxy
]

{ #category : 'printing' }
GtGsBareProxy >> printOn: aStream [

	aStream << 'youve got the bare proxy'
]

{ #category : 'printing' }
GtGsBareProxy >> printString [

	^ 'youve got the bare proxy'
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
