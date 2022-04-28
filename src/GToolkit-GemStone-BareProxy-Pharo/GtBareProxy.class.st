"
GtBareProxy is a bare-bones proxy object that uses the #doesNotUnderstand: mechanism to forward messages to its remote.

GtBareProxy is a wrapper around a more functional proxy object that performs most of the underlying work.  GtBareProxy implements as few methods as possible to maximise the effectiveness of the the #doesNotUnderstand: mechanism.
"
Class {
	#name : #GtBareProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'proxyObject'
	],
	#category : #'GToolkit-GemStone-BareProxy-Pharo-Model'
}

{ #category : #'instance creation' }
GtBareProxy class >> forProxyObject: aServiceClient [
	^ self new
		proxyObject: aServiceClient
]

{ #category : #'gt - coder' }
GtBareProxy class >> gtSlotNamed: aName ifFound: foundBlock ifNone: exceptionBlock [
	"The proxy hides its only slot (proxyObject), so just evaluate exceptionBlock"

	^ exceptionBlock value
]

{ #category : #'gt - coder' }
GtBareProxy class >> gtSlotNames [
	"Answer the slot names to be bound by GtPharoSourceCoderViewModel.
	Answer an empty Array since we don't want to see the proxy object itself."

	^ #()
]

{ #category : #comparing }
GtBareProxy >> = anObject [
	"If the receiver has a serviceClient, delegate equality to the serviceClient, otherwise use the identity of the receiver"

	^ proxyObject 
		ifNil: [ self == anObject ]
		ifNotNil: [ anObject = proxyObject ]
]

{ #category : #transformation }
GtBareProxy >> asGtBareProxyObject [
	^ self
]

{ #category : #transformation }
GtBareProxy >> asGtProxyObject [
	^ proxyObject
]

{ #category : #'reflective operations' }
GtBareProxy >> doesNotUnderstand: aMessage [ 
	"In case the proxy has no remote client or the client is not logged in
	do not propagate the message to the remote object. If the return value 
	is not a primitive type I convert it to a bare proxy."
	
	^ self isProxyObjectActive 
		ifFalse: [ super doesNotUnderstand: aMessage  ]
		ifTrue: [ self performRemotely: aMessage selector withArguments: aMessage arguments ]
]

{ #category : #printing }
GtBareProxy >> gtInspectorTitleString [
	| limitedString limit |
	limit := 1000.
	limitedString := String 	
		streamContents: [ :s | self gtInspectorTitleStringOn: s ] 
		limitedTo: limit.
	limitedString size < limit ifTrue: [^ limitedString].
	^ limitedString , ' ...'
]

{ #category : #printing }
GtBareProxy >> gtInspectorTitleStringOn: aStream [
	proxyObject ifNil: [ 
		aStream << 'a GtGsBareProxy'.
		^ self ].
	
	proxyObject isProxyObjectActive ifFalse: [ 
		aStream << 'Bare Proxy on: <not connected>'.
		^ self ].
	
	aStream 
		<< 'Bare Proxy on: ';
		<< ([proxyObject proxyPerform: #gtDisplayString]
				on: Error 
				do: [ :e | 'Error printing'  ]) 
		
]

{ #category : #'gt inspector' }
GtBareProxy >> gtMetaFor: aView [
	<gtProxy>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ (GtPharoBehaviorCoder forObject: self) asElement ]
]

{ #category : #'gt inspector' }
GtBareProxy >> gtProxyViewsFor: aView [
	<gtView>
	^ aView composite
		title: 'Proxy';
		priority: 10000;
		collectorDo: [ :aCollector |
			aCollector 
				pragmaName: #gtProxy;
				fromObject: self ]
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRawFor: aView [
	"Provide a basic view of the proxy object.
	This is simpler than the standard Raw view, but avoids many methods that are implemented in Object"
	<gtProxy>

	^ aView columnedList
		title: 'Raw';
		priority: 100;
		items: [ {
			{ #self. self. }.
			{ #proxyObject. proxyObject. } } ];
		column: #Icon
			icon: [ :item | item second class systemIcon ]
			width: 36;
		column: #Variable text: [ :item | item first ];
		column: #Value text: [ :item | 
			item first = #self ifTrue:
				[ self class name ]
			ifFalse:
				[ [ item second printString ]
					on: Error, Halt
					do: [ :ex | ex printString asRopedText foreground: Color red ] ] ];
		send: [ :item | item second ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtBareProxy >> gtViewsInContext: aContext [
	| proxyObjectViews collectedViews |
	"This collects all views for the current object, both local and remote."
	
	proxyObjectViews := proxyObject gtViewsInContext: aContext.
	proxyObjectViews := proxyObjectViews reject: [ :each |
		#(Proxy) includes: each title ].
	
	collectedViews := OrderedCollection new
		addAll: (super gtViewsInContext: aContext);
		addAll: proxyObjectViews;
		yourself.
	GtPhlowUtility sortByPriority: collectedViews.
	^ collectedViews
]

{ #category : #comparing }
GtBareProxy >> hash [

	^ proxyObject 
		ifNil: [ self identityHash ]
		ifNotNil: [ proxyObject hash ]

]

{ #category : #testing }
GtBareProxy >> isProxyObjectActive [
	^ self proxyObject 
		ifNil: [ false ] 
		ifNotNil: [ :aProxyService | 
			aProxyService connection isOpen ] 
]

{ #category : #'actions - proxy' }
GtBareProxy >> performRemotely: aSelector withArguments: argumentsArray [
	"Perform remotely aSelector with the given arguments and create a proxy object 
	if the remote call returned a reference to a remote object. If the remote call 
	returned a primitive value return it directly without creating a proxy object.
	Primitive arguments are pased by value. Proxy arguments are passed based on their
	proxy service, meaning that the actual remote object will be passed to the remote method."
	| result transfomedArguments |
		
	transfomedArguments := argumentsArray collect: [ :anObject |
		anObject asGtProxyObject ].
	result := self 
		rawPerformRemotely: aSelector 
		withArguments: transfomedArguments.
	^ result asGtBareProxyObject
]

{ #category : #accessing }
GtBareProxy >> proxyObject [
	^ proxyObject 
]

{ #category : #accessing }
GtBareProxy >> proxyObject: aServiceClient [
	proxyObject ifNotNil: [ 
		Error signal: 'Cannot change the service client associated with a proxy object.' ].
	proxyObject := aServiceClient
]

{ #category : #'actions - proxy' }
GtBareProxy >> rawPerformRemotely: aSelector withArguments: anArgumentsArrayOfServices [
	^ self proxyObject 
		proxyPerform: aSelector 
		withArguments: anArgumentsArrayOfServices
]
