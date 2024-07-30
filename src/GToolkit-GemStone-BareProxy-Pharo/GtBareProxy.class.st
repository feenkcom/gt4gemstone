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

{ #category : #'gt inspector' }
GtBareProxy >> filterLocalProxyActions: localActions [ 
	"When showing local actions for the object, we remove all actions where the method is annotated with #gtProxyAction. Those actions will only be shown for the proxy object."
	^ localActions reject: [ :each |
		each definingMethod compiledMethod 
			hasPragmaNamed: #gtProxyAction ].
]

{ #category : #'gt inspector' }
GtBareProxy >> filterLocalProxyViews: localViews [ 
	"When showing local views for the object, we remove all views where the method is annotated with gtProxy. Those views will only be shown for the proxy object."
	^ localViews reject: [ :each |
		each definingMethod compiledMethod hasPragmaNamed: #gtProxy ].
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
GtBareProxy >> gtActionsForRemoteSideInContext: aContext [
	"This collects all actions for the current object. This excludes the proxy-specific actions (annotated with #gtProxyAction), and includes all remote actions for the object, as well as all custom actions defined locally"
 
	| localActions collectedActions |
	
	"Get the actions using the super call. 
	This will use #gtAction to compute the list of actions for the local object."
	localActions := self gtLocalProxyActionsForRemoteSideInContext: aContext.
	
	collectedActions := OrderedCollection new
		addAll: (self filterLocalProxyActions: localActions);
		yourself.
	proxyObject ifNotNil: [
		collectedActions addAll: (proxyObject 
			gtActionsForRemoteSideInContext: aContext) ].
		
	GtPhlowUtility sortByPriority: collectedActions.
	
	^ collectedActions
]

{ #category : #'gt inspector' }
GtBareProxy >> gtActionsInContext: aPhlowContext [
	| proxyActions |

	proxyActions := (proxyObject 
			ifNil: [ #() ]
			ifNotNil: [ proxyObject gtActionsInContext: aPhlowContext ]).
	
	"The inspect and browse actions from the proxy object does make sense in this context as we want to inspect the bare proxy"
	proxyActions := proxyActions reject: [ :action | 
		#(#gtActionInspectFor: #gtActionBrowseFor:) 
			includes: action definingMethod selector   ].
	
	^ (self gtLocalProxyActionsForLocalSideInContext: aPhlowContext), proxyActions
]

{ #category : #'gt inspector' }
GtBareProxy >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (self gtRemoteSideInspectorTool
			name: 'Remote';
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
	proxyObject ifNil: [ 
		aStream << 'Bare Proxy on: <not configured>'.
		^ self ].
	
	proxyObject isProxyObjectActive ifFalse: [ 
		aStream << 'Bare Proxy on: <not connected>'.
		^ self ].
	
	aStream 
		<< 'Bare Proxy on: ';
		<< ([ proxyObject proxyPerform: #gtDisplayString autoCommit: false]
				on: Error 
				do: [ :e | 'Error printing'  ]) 
]

{ #category : #printing }
GtBareProxy >> gtDisplayText [
	^ (String streamContents: [ :aStream |
		self gtDisplayOn:  aStream  ]) asRopedText
]

{ #category : #printing }
GtBareProxy >> gtInspectorRemoteSideTitleStringOn: aStream [
	proxyObject ifNil: [ 
		aStream << 'a GtBareProxy'.
		^ self ].
	
	proxyObject isProxyObjectActive ifFalse: [ 
		aStream << 'Bare Proxy on: <not connected>'.
		^ self ].
	
	aStream 
		<< ([ proxyObject proxyPerform: #gtDisplayString autoCommit: false]
				on: Error 
				do: [ :e | 'Error printing'  ]) 
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
	self gtDisplayOn: aStream
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
	
	^ GtPhlowActionsCollector new
		fromObject: self;
		context: aContext;
		pragmaName: #gtAction;
		collect.
]

{ #category : #'gt inspector' }
GtBareProxy >> gtLocalProxyViewsForRemoteSideInContext: aContext [
	"Change the views of the proxy object to only those annotated with gtProxy."
 
	^ GtPhlowViewsCollector new
		fromObject: self;
		context: aContext;
		pragmaName: #gtView;
		collect.
]

{ #category : #'gt inspector' }
GtBareProxy >> gtMetaFor: aView [
	<gtProxy>

	^ super gtMetaFor: aView
]

{ #category : #'gt inspector' }
GtBareProxy >> gtPrintFor: aView [
	<gtProxy>
	
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
	"Provide a basic view of the proxy object.
	This is simpler than the standard Raw view, but avoids many methods that are implemented in Object"
	<gtProxy>

	^ super gtRawFor: aView.
	
	"^ aView columnedList
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
		actionUpdateButton"
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteActionSpecificationsFor: aView [
	<gtProxy>
	
	proxyObject ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Remote action specifications';
		priority: 10002;
		object: [ proxyObject ];
		view: #gtRemoteActionSpecificationsFor:
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteInspectorSpecificationsFor: aView [
	<gtProxy>
	
	proxyObject ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Remote specification';
		priority: 10002;
		object: [ proxyObject ];
		view: #gtRemoteInspectorSpecificationsFor: 
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteSideInspectorTool [
	^ GtInspectorTool 
		forObject: self 
		viewSelector: #gtRemoteViewsFor: 
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteViewSpecificationsFor: aView [
	<gtProxy>
	
	proxyObject ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Remote view specifications';
		priority: 10001;
		object: [ proxyObject ];
		view: #gtRemoteViewSpecificationsFor:
]

{ #category : #'gt inspector' }
GtBareProxy >> gtRemoteViewsFor: aView [
	"This is the default entry method for retrieving the wrapper view containing all non-proxy views for the object."
	<return: #GtPhlowLabelledView>
	
	^ GtPhlowLabelledViewBuilder new
		object: (GtRemotePhlowViewedObjectInspectorAdaptor
			forTargetObject: self);
		view: aView;
		context: GtPhlowContext new;
		viewsSelector: #gtViewsForRemoteSideInContext:;
		actionsSelector: #gtActionsForRemoteSideInContext:;
		titleComputation: [
			String streamContents: [ :aStream |
				self gtInspectorRemoteSideTitleStringOn: aStream] ];
		build
]

{ #category : #'gt inspector' }
GtBareProxy >> gtViewsForRemoteSideInContext: aContext [

	| localViews collectedViews |
	
	"Get the actions using the super call. 
	This will use #gtAction to compute the list of actions for the local object."
	localViews := self gtLocalProxyViewsForRemoteSideInContext: aContext.
	
	collectedViews := OrderedCollection new
		addAll: (self filterLocalProxyViews: localViews);
		yourself.
	proxyObject ifNotNil: [
		collectedViews addAll: (proxyObject 
			gtViewsForRemoteSideInContext: aContext) ].
	
	GtPhlowUtility sortByPriority: collectedViews.
	
	^ collectedViews
]

{ #category : #'gt inspector' }
GtBareProxy >> gtViewsInContext: aContext [
	"Change the views of the proxy object to only those annotated with gtProxy."
 
	^ GtPhlowViewsCollector new
		fromObject: self;
		context: aContext;
		pragmaName: #gtProxy;
		collect.
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

{ #category : #accessing }
GtBareProxy >> remoteClass [
	"Answer the name of the class of the remote object"

	^ proxyObject ifNotNil: [ :aProxy | 
		aProxy  remoteClass ]
]

{ #category : #'memory usage' }
GtBareProxy >> sizeInMemory [
	^ self class byteSizeOfInstance 
]
