Class {
	#name : #GtRsrProxyServiceClient,
	#superclass : #GtRsrProxyService,
	#traits : 'TGtRemoteLanguageProxyViewsAttachment + TGtRemoteLanguageProxySpecificViews',
	#classTraits : 'TGtRemoteLanguageProxyViewsAttachment classTrait + TGtRemoteLanguageProxySpecificViews classTrait',
	#instVars : [
		'gtSession'
	],
	#classVars : [
		'ObjectMap'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtRsrProxyServiceClient class >> bareProxyObjectAt: anObject ifAbsent: absentBlock [

	^ self proxyObjectMap at: anObject ifAbsent: absentBlock
]

{ #category : #testing }
GtRsrProxyServiceClient class >> isClientClass [

	^ true
]

{ #category : #accessing }
GtRsrProxyServiceClient class >> proxyObjectAt: anObject ifAbsent: absentBlock [

	^ self proxyObjectMap at: anObject 
		ifPresent: #asGtProxyObject
		ifAbsent: absentBlock
]

{ #category : #accessing }
GtRsrProxyServiceClient class >> proxyObjectMap [

	^ ObjectMap ifNil: [ ObjectMap := WeakIdentityKeyDictionary new ]
]

{ #category : #private }
GtRsrProxyServiceClient class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | self remoteClassName = aSymbol ]
]

{ #category : #accessing }
GtRsrProxyServiceClient class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ nil
]

{ #category : #private }
GtRsrProxyServiceClient class >> subclassForRemoteClass: aSymbol [
	"Answer the subclass that represents the supplied class name"

	^ self allSubclasses
		detect: [ :each | each remoteClassMatcher value: aSymbol ]
		ifNone: [ nil ].

]

{ #category : #converting }
GtRsrProxyServiceClient >> asGtpoLocalObject [
	"Answer a local copy of the receiver"
	| instVarDict localObject |

	instVarDict := self evaluateAndWait: '| names dict |
names := self class allInstVarNames.
dict := Dictionary new.
1 to: names size do: [ :i |
	dict at: (names at: i) put: (self instVarAt: i) ].
dict.'.
	localObject := (self class environment at: remoteClass) basicNew.
	instVarDict associationsDo: [ :assoc |
		localObject instVarNamed: assoc key put: (assoc value asGtBareProxyObjectInSession: gtSession) ].
	self class proxyObjectMap at: localObject put: (self asGtBareProxyObjectInSession: gtSession).
	^ localObject.
]

{ #category : #private }
GtRsrProxyServiceClient >> becomeProxyRemoteClass [
	"Convert the to the appropriate subclass.
	RSR client service objects are always created using #basicNew and instance variables are populated using #instVarAt:put:, so there isn't an opportunity to intercept the client creation.  Once the remoteClass has been set, we can replace the client proxy object using #becomeForward:"
	| proxyClass newProxy |

	proxyClass := self class subclassForRemoteClass: remoteClass.
	proxyClass ifNil: [ ^ self ].
	newProxy := proxyClass new
		_id: _id 
		connection: _connection 
		remoteSelf: remoteSelf
		remoteClass: remoteClass.
	self becomeForward: newProxy.
	^ newProxy
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluate: aString [
	"Evaluate the supplied string with `self` bound to the receiver"
	| evaluator |

	evaluator := GtRsrEvaluatorServiceClient new registerWith: _connection.
	^ evaluator
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWait: aString [
	"Evaluate the supplied string with `self` bound to the receiver"
	| evaluator |

	evaluator := GtRsrEvaluatorServiceClient new registerWith: _connection.
	^ evaluator
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new.
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtDisplayOn: aStream [
	aStream << ([ self 
		proxyPerform: #gtDisplayString ] 
			on: Error do: [ self class name, ': Unable to retrieve gtDisplayString' ])
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtInspectorTitleString [ 
	^ String streamContents: [ :stream |
		stream
			<< 'Proxy to a(n): ';
			<< (remoteClass ifNil: [ '<None>' ]) ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtRemoteViewsFor: aView [
	"This is the default entry method for retrieving the wrapper view containing all non-proxy views for the object."
	<return: #GtPhlowLabelledView>
	
	^ GtPhlowLabelledViewBuilder new
		object: self;
		view: aView;
		context: GtPhlowContext new;
		viewsSelector: #gtViewsForRemoteSideInContext:;
		titleComputation: [
			String streamContents: [ :stream |
				stream
					<< 'a(n): ';
					<< (self remoteClass ifNil: [ '<None>' ]).
				gtSession ifNotNil:
					[ stream
						<< ' [';
						<< gtSession name;
						<< ']' ]]];
		build 
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtSession [
	^ gtSession
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtSession: anObject [
	gtSession := anObject
]

{ #category : #introspection }
GtRsrProxyServiceClient >> instVarAt: anInteger put: anObject [
	"If the receiver's remoteClass has been set, convert the receiver to the specific proxy class.
	WARNING: The index of remoteClass is assumed to be 4.  This must be manually updated if instance variables are inserted before remoteClass"
	| result |

	result := super instVarAt: anInteger put: anObject.
	anInteger = 4 ifTrue: 
		[ self becomeProxyRemoteClass ].
	^ result
]

{ #category : #accessing }
GtRsrProxyServiceClient >> object [
	"Answer the receiver's object as an immediate"

	(#(Set Dictionary Array OrderedCollection) includes: remoteClass) ifFalse:
		[ self error: 'Unable to return non-immediate object' ].
	^ remoteSelf object wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol [

	^ (remoteSelf proxyPerform: aSymbol) wait.
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [

	^ (remoteSelf proxyPerform: aSymbol withArguments: anArray) wait
]

{ #category : #'gt inspector' }
GtRsrProxyServiceClient >> remoteViewsFor: aView [
	"Should be all views, but just get Raw and Print views for now"

	^ self isProxyObjectActive
		ifTrue: [ self declarativeViews collect: [ :declarativeView | 
			declarativeView viewFor: aView ] ]
		ifFalse: [ #() ].
]

{ #category : #private }
GtRsrProxyServiceClient >> _id: id connection: connection remoteSelf: anObject remoteClass: aString [

	_id := id.
	_connection := connection.
	remoteSelf := anObject.
	remoteClass := aString.
]
