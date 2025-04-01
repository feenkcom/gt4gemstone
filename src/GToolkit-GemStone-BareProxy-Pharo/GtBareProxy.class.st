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

{ #category : #accessing }
GtBareProxy >> asCollectionElement [
	"Added for compatibility with Set"
	
	"Answer an object, which can be put into a Set as element , wrapped
	by one of SetElement instance, if necessary.
	Default implementation is to answer self"
]

{ #category : #transformation }
GtBareProxy >> asGtBareProxyObject [
	^ self
]

{ #category : #accessing }
GtBareProxy >> asGtGsArgumentIn: aGtGemStoneSession [
	"Answer the receiver ready to pass as an argument to a GtGemStone evaluation"
	
	^ proxyObject
]

{ #category : #transformation }
GtBareProxy >> asGtProxyObject [
	^ proxyObject
]

{ #category : #'gt inspector' }
GtBareProxy >> asLink [
	"This is needed in the proxy object, as LinkedLists used by the inspector call #asLink on the objects that they add."

	^ ValueLink value: self
]

{ #category : #'gt inspector' }
GtBareProxy >> buildLocalViewSpecificationFor: aViewSelector [
	^ proxyObject buildLocalViewSpecificationFor: aViewSelector
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

{ #category : #accessing }
GtBareProxy >> enclosedElement [
	"Added for compatibility with Set"
	
	"The receiver is included into a set as an element.
	Since some objects require wrappers (see SetElement) to be able to be included into a Set,
	a set sends this message to its element to make sure it getting real object,
	instead of its wrapper.
	Only SetElement instance or its subclasses allowed to answer something different than receiver itself"
]

{ #category : #'gt inspector' }
GtBareProxy >> gtActionBrowseFor: anAction [
	<gtProxyAction>
	
	^ super gtActionBrowseFor: anAction
]

{ #category : #'gt inspector' }
GtBareProxy >> gtActionInspectFor: anAction [
	<gtProxyAction>
	
	^ super gtActionInspectFor: anAction
]

{ #category : #'gt inspector' }
GtBareProxy >> gtActionsInContext: aPhlowContext [
	| proxyActions localActions collectedActions |

	proxyActions := (proxyObject 
		ifNil: [ #() ]
		ifNotNil: [ 
			proxyObject gtActionsInContext: aPhlowContext ]).
	
	"The inspect and browse actions from the proxy object does make sense in this context as we want to inspect the bare proxy"
	proxyActions := proxyActions reject: [ :action | 
		#(#gtActionInspectFor: #gtActionBrowseFor:) 
			includes: action definingMethod selector   ].
	
	localActions := self gtLocalProxyActionsForLocalSideInContext: aPhlowContext.
	collectedActions := localActions, proxyActions.
	
	GtPhlowUtility sortByPriority: collectedActions.
	
	^ collectedActions
]

{ #category : #printing }
GtBareProxy >> gtBasicDisplayOn: aStream [
	proxyObject ifNil: [ 
		aStream << '<not configured>'.
		^ self ].
	
	proxyObject gtBasicDisplayOn: aStream
]

{ #category : #'gt inspector' }
GtBareProxy >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (self gtRemoteSideInspectorTool
			name: self gtRemoteSideInspectorToolLabel;
			playgroundPageStrategy: (LeInspectorPlaygroundProxyClassPageStrategy
				forRemoteProxySide);
			withLabelAndIconAptitude);
		addTool: (super gtDefaultInspectorTool
			name: 'Proxy';
			playgroundPageStrategy: (LeInspectorPlaygroundProxyClassPageStrategy
				forLocalProxySide);
			withLabelAndIconAptitude)
]

{ #category : #printing }
GtBareProxy >> gtDisplayOn: aStream [

	aStream << 'Bare Proxy on: '.
	self gtBasicDisplayOn: aStream
]

{ #category : #printing }
GtBareProxy >> gtDisplayText [
	^ (String streamContents: [ :aStream |
		self gtDisplayOn:  aStream  ]) asRopedText
]

{ #category : #printing }
GtBareProxy >> gtInspectorConnectionDetailsOn: aStream [
	proxyObject gtSession 
		ifNotNil: [ :gtSession | 
			aStream
				<< ' [';
				<< gtSession name;
				<< ']' ]
]

{ #category : #printing }
GtBareProxy >> gtInspectorRemoteSideTitleStringOn: aStream [
	self gtBasicDisplayOn: aStream.

	self gtInspectorConnectionDetailsOn: aStream
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
	self gtDisplayOn: aStream.
	
	self gtInspectorConnectionDetailsOn: aStream
]

{ #category : #'gt inspector' }
GtBareProxy >> gtLocalProxyActionsForLocalSideInContext: aPhlowContext [ 
	^ GtPhlowActionsCollector new
		fromObject: self;
		context: aPhlowContext;
		pragmaName: #gtProxyAction;
		collect.
]

{ #category : #'gt inspector' }
GtBareProxy >> gtLocalProxyActionsForRemoteSideInContext: aContext [
	"Get from the proxy object only those actions annotated with gtAction."
	| localActions proxyActions |
	
	localActions :=  GtPhlowActionsCollector new
		fromObject: self;
		context: aContext;
		pragmaName: #gtAction;
		collect.
		
	proxyActions := proxyObject 
		ifNil: [ #() ]
		ifNotNil: [ 
			proxyObject gtLocalProxyActionsForRemoteSideInContext: aContext ].
			
	^ localActions, proxyActions
]

{ #category : #'gt inspector' }
GtBareProxy >> gtLocalProxyViewsForLocalSideInContext: aContext [
	"Change the views of the proxy object to only those annotated with gtProxy."
 
	^ GtPhlowViewsCollector new
		fromObject: self;
		context: aContext;
		pragmaName: #gtProxyView;
		collect.
]

{ #category : #'gt inspector' }
GtBareProxy >> gtLocalProxyViewsForRemoteSideInContext: aContext [
	"Change the views of the proxy object to only those annotated with gtProxy."
	| localViews proxyViews |
	
	localViews := GtPhlowViewsCollector new
		fromObject: self;
		context: aContext;
		pragmaName: #gtView;
		collect.
		
	proxyViews := proxyObject 
		ifNil: [ #() ]
		ifNotNil: [ 
			proxyObject gtLocalProxyViewsForRemoteSideInContext: aContext ].
	
	^ localViews, proxyViews
]

{ #category : #'gt inspector' }
GtBareProxy >> gtMetaFor: aView [
	<gtProxyView>

	^ super gtMetaFor: aView
]

{ #category : #'gt inspector' }
GtBareProxy >> gtPrintFor: aView [
	<gtProxyView>
	
	^ aView textEditor
		title: 'Print';
		priority: 110;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ 
			String 	
				streamContents: [ :aStream | 
					self gtDisplayOn: aStream ] 
				limitedTo: 1000 ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRawFor: aView [
	<gtProxyView>

	^ super gtRawFor: aView.
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteSideInspectorObjectHolder [
	^ GtGemStonePhlowInspectorObject new 
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteSideInspectorTool [
	^ GtInspectorTool new 
		objectHolder: (self gtRemoteSideInspectorObjectHolder
			object: self; 
			viewSelector: #gtRemoteInspectorContentFor:)
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteSideInspectorToolLabel [
	^ 'GemStone'
]

{ #category : #'gt inspector' }
GtBareProxy >> gtViewsInContext: aPhlowContext [
	"Change the views of the proxy object to only those annotated with gtProxy."
	| proxyViews localViews collectedViews |
	
	proxyViews := (proxyObject 
		ifNil: [ #() ]
		ifNotNil: [ 
			proxyObject gtViewsInContext: aPhlowContext ]).
	
	"The inspect and browse actions from the proxy object does make sense in this context as we want to inspect the bare proxy"
	proxyViews := proxyViews reject: [ :aPhlowView | 
		#(#gtRawFor: #gtPrintFor: #gtMetaFor:) 
			includes: aPhlowView definingMethod selector   ].
	
	localViews := self gtLocalProxyViewsForLocalSideInContext: aPhlowContext.
	
	collectedViews := localViews, proxyViews.
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
GtBareProxy >> isGtBareProxyObject [

	^ true
]

{ #category : #pinning }
GtBareProxy >> isPinnedInMemory [
	"Copied from Object>>isPinnedInMemory"
	<primitive: 183 error: ec>
	^self primitiveFailed
]

{ #category : #testing }
GtBareProxy >> isProxyObjectActive [
	^ self proxyObject 
		ifNil: [ false ] 
		ifNotNil: [ :aProxyService | 
			aProxyService connection isOpen ] 
]

{ #category : #'gt inspector' }
GtBareProxy >> localProxyInspectorDo: aBlock [
	^ proxyObject ifNotNil: [ :aProxyObject |
		aProxyObject localProxyInspectorDo: aBlock ]
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

{ #category : #printing }
GtBareProxy >> printOn: aStream [
	"Print on is needed as this level, as when it will be called when printing elements in a collection"
	self gtDisplayOn: aStream
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

{ #category : #'gt inspector' }
GtBareProxy >> remoteActionsFor: aView inContext: aContext from: anInspectorProxy [
	^ proxyObject
		ifNil: [ #() ]
		ifNotNil: [ proxyObject 
			remoteActionsFor: aView inContext: aContext from: anInspectorProxy ]
]

{ #category : #accessing }
GtBareProxy >> remoteClass [
	"Answer the name of the class of the remote object"

	^ proxyObject ifNotNil: [ :aProxy | 
		aProxy  remoteClass ]
]

{ #category : #'gt inspector' }
GtBareProxy >> remoteInspectorProxyDo: aBlock [
	^ proxyObject ifNotNil: [ :aProxyObject |
		aProxyObject remoteInspectorProxyDo: aBlock ]
]

{ #category : #'gt inspector' }
GtBareProxy >> remoteViewsFor: aView inContext: aContext from: anInspectorProxy [
	^ proxyObject
		ifNil: [ #() ]
		ifNotNil: [ proxyObject 
			remoteViewsFor: aView inContext: aContext from: anInspectorProxy ]
]

{ #category : #utils }
GtBareProxy >> runComputation: aBlock ifFailure: aFailureBlock [

	^ self isProxyObjectActive
		ifTrue: [ 
			aBlock value  ]
		ifFalse: [ aFailureBlock value ].
]

{ #category : #'memory usage' }
GtBareProxy >> sizeInMemory [
	^ self class byteSizeOfInstance 
]
