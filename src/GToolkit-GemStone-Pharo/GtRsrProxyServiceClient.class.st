Class {
	#name : 'GtRsrProxyServiceClient',
	#superclass : 'GtRsrProxyService',
	#category : 'GToolkit-GemStone-Pharo-Client'
}

{ #category : 'testing' }
GtRsrProxyServiceClient class >> isClientClass [

	^ true
]

{ #category : 'private' }
GtRsrProxyServiceClient class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | self remoteClassName = aSymbol ]
]

{ #category : 'accessing' }
GtRsrProxyServiceClient class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ nil
]

{ #category : 'private' }
GtRsrProxyServiceClient class >> subclassForRemoteClass: aSymbol [
	"Answer the subclass that represents the supplied class name"

	^ self subclasses
		detect: [ :each | each remoteClassMatcher value: aSymbol ]
		ifNone: [ nil ].

]

{ #category : 'private' }
GtRsrProxyServiceClient >> _id: id connection: connection remoteSelf: anObject [

	_id := id.
	_connection := connection.
	remoteSelf := anObject.
]

{ #category : 'accessing' }
GtRsrProxyServiceClient >> becomeProxyRemoteClass [
	"Convert the to the appropriate subclass.
	RSR client service objects are always created using #basicNew and instance variables are populated using #instVarAt:put:, so there isn't an opportunity to intercept the client creation.  Once the remoteClass has been set, we can replace the client proxy object using #becomeForward:"
	| proxyClass newProxy |

	proxyClass := self class subclassForRemoteClass: remoteClass.
	proxyClass ifNil: [ ^ self ].
	newProxy := proxyClass new.
	newProxy _id: _id connection: _connection remoteSelf: remoteSelf.
	self becomeForward: newProxy.
	^ newProxy
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> declarativeViews [
	"Answer the views for the receiver"
	| viewSelectors rawViews |

	self viewProxyDo: [ :remoteInspectorProxy |
		viewSelectors := remoteInspectorProxy getDeclarativeViewMethodNames.
		rawViews := viewSelectors collect: [ :viewSelector |
			| viewDictionary declarativeView |
			viewDictionary := remoteInspectorProxy getViewDeclaration: viewSelector.
			declarativeView := GtPhlowDeclarativeView fromDictionary: viewDictionary.
			declarativeView
				methodSelector: viewSelector;
				initializeFromInspector: remoteInspectorProxy.
			declarativeView ] ].

	^ rawViews
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> evaluate: aString [
	"Evaluate the supplied string with `self` bound to the receiver"
	| evaluator |

	evaluator := GtRsrEvaluatorServiceClient new registerWith: _connection.
	^ evaluator
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new.
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> getViewProxy [
	"Answer a GtViewedProxy on the receiver"

	^ self evaluate: 'GtRemotePhlowViewedObject object: self'
]

{ #category : 'as yet unclassified' }
GtRsrProxyServiceClient >> gtDisplayOn: aStream [
	aStream << ([ self 
		proxyPerform: #gtDisplayString ] 
			on: Error do: [ self gtDisplayString ])
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> gtLocalViewsFor: aView inContext: aContext [
	| title resultingView |

	title := String streamContents: [ :stream |
				stream
					<< 'Proxy to a(n): ';
					<< (remoteClass ifNil: [ '<None>' ]) ].
	resultingView := ((aView composite
		views: (self gtViewsInContext: aContext))
		labelled: title).
	^ resultingView
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> gtProxyFor: aView [
	<gtProxy>

	^(self gtRawFor: aView)
		title: 'Proxy' translated;
		priority: 10000.
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> gtProxyRawFor: aView [

	^ aView columnedList 
		title: 'Raw';
		priority: 15;
		items: [ self viewProxyDo: [ :viewProxy |
				viewProxy proxyPerform:  #rawViewData ] ];
		column: 'Icon' icon: [ :aNode | aNode third iconNamed: aNode first ];
		column: 'Variable' text: [ :aNode | aNode second asRopedText ];
		column: 'Value' text: [ :aNode | 
					[ aNode third gtDisplayString asRopedText ]
						on: Error 
						do: [ :ex | ex messageText asRopedText foreground: Color red ] ];
		send: [ :aNode | aNode third ]
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> gtProxyViewsFor: aView [
	<gtView>
	^ aView list
		title: 'Proxy views' translated;
		priority: 10001;
		items: [ self declarativeViews ];
		itemText: [ :aViewAccessor | aViewAccessor title ];
		send: [ :aDeclarativeView | aDeclarativeView ]
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> gtViewsFor: aView inContext: aContext [
	"Add the declarative views from the inspectors object to the inspectors views"

	| resultingView inspectorViews |

	resultingView := self gtLocalViewsFor: aView inContext: aContext.
	inspectorViews := resultingView originalView views.

	"Add the explicitly declarative views from the inspected object"
	inspectorViews addAll: (self viewsFor: aView).

	"Re-sort by priority"
	inspectorViews := inspectorViews sorted: [ :a :b | a priority < b priority ].
	resultingView originalView views: inspectorViews.
	^resultingView
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> gtViewsInContext: aContext [
	"This collects all views for the current object.
	For a proxy we just want the Raw view renamed as 'Proxy'"
	| views proxyRaw proxyPrint |

	views := super gtViewsInContext: aContext.
	"Retitle the original Raw view to Proxy and lower priority"
	proxyRaw := views detect: [ :each | each title = #Raw ].
	proxyRaw
		title: #Proxy;
		priority: 10000.
	"Remove the default Print view, the remote can supply it later"
	proxyPrint := views detect: [ :each | each title = #Print ].
	views remove: proxyPrint.
	
	"views add: (self gtProxyRawFor: GtPhlowEmptyView new)."
	^ views.
]

{ #category : 'introspection' }
GtRsrProxyServiceClient >> instVarAt: anInteger put: anObject [
	"If the receiver's remoteClass has been set, convert the receiver to the specific proxy class.
	WARNING: The index of remoteClass is assumed to be 4.  This must be manually updated if instance variables are inserted before remoteClass"
	| result |

	result := super instVarAt: anInteger put: anObject.
	anInteger = 4 ifTrue: 
		[ self becomeProxyRemoteClass ].
	^ result
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol [

	^ (remoteSelf proxyPerform: aSymbol) wait.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [

	^ (remoteSelf proxyPerform: aSymbol withArguments: anArray) wait
]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> viewProxyDo: aBlock [
	"Evaluate the supplied block ensuring that the receiver is a GtViewedObject"

	| viewProxy |

	viewProxy := (#(GtViewedObject GtRemotePhlowViewedObject) includes: remoteClass)
		ifTrue: [ self ]
		ifFalse: [ self getViewProxy ].
	^ aBlock value: viewProxy.

]

{ #category : 'gt inspector' }
GtRsrProxyServiceClient >> viewsFor: aView [
	"Should be all views, but just get Raw and Print views for now"

	^ self declarativeViews collect: [ :declarativeView | declarativeView viewFor: aView ].

]
