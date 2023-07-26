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
GtRsrProxyServiceClient class >> leProxyTypeForPlaygroundPage [
	^ GtRsrProxyServiceClient
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

{ #category : #private }
GtRsrProxyServiceClient >> _id: id connection: connection remoteSelf: anObject remoteClass: aString [

	_id := id.
	_connection := connection.
	remoteSelf := anObject.
	remoteClass := aString.
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
		localObject instVarNamed: assoc key put: assoc value ].
	self class proxyObjectMap at: localObject put: self asGtBareProxyObject.
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
	| computedProxy |

	computedProxy := gtSession evaluator
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new.
	computedProxy gtPharoProxyInitializeWithSession: self gtSession.	
	^ computedProxy
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWait: aString [
	"Evaluate the supplied string with `self` bound to the receiver"
	| computedProxy |

	computedProxy := gtSession evaluator
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new.
	computedProxy gtPharoProxyInitializeWithSession: self gtSession.	
	^ computedProxy
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtActionBrowseFor: anAction [
	<gtAction>

	(self class environment classOrTraitNamed: remoteClass asSymbol) ifNil:
		[ ^ anAction noAction ].
	^ anAction button
		icon: BrGlamorousVectorIcons browse;
		tooltip: 'Inspect Local Class';
		action: [ :button |
			button phlow spawnTool: (GtClassCoderTool forClass: (self class environment classOrTraitNamed: remoteClass asSymbol)) ].
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtDisplayOn: aStream [
	self isProxyObjectActive ifTrue: 
		[ aStream << ([self proxyPerform: #gtDisplayString]
			on: Error 
			do: [ :e | 'Error printing'  ]) ]
	ifFalse: 
		[ aStream << 'Service Client Proxy on: <not connected>' ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtInspectClassFor: anAction [
	<gtAction>

	^ anAction button
		label: 'GS';
		icon: BrGlamorousVectorIcons browse;
		tooltip: 'Inspect GemStone Class';
		action: [ :button |
			button phlow spawnObject: (self proxyPerform: #class) ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtInspectProxyClassFor: anAction [
	<gtAction>

	(self class environment classOrTraitNamed: remoteClass asSymbol) ifNil:
		[ ^ anAction noAction ].
	^ anAction button
		label: 'Proxy';
		icon: BrGlamorousVectorIcons browse;
		tooltip: 'Inspect Local Class';
		action: [ :button |
			button phlow spawnTool: (GtClassCoderTool forClass: self class) ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtInspectSessionFor: anAction [
	<gtAction>

	^ anAction button
		label: 'GS';
		icon: BrGlamorousVectorIcons inspect;
		tooltip: 'Inspect GemStone Session';
		action: [ :button |
			button phlow spawnObject: gtSession ].
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtInspectorRemoteSideTitleStringOn: aStream [
	self isProxyObjectActive 
		ifTrue: [
			aStream 
				<< ([self proxyPerform: #gtDisplayString]
					on: Error 
					do: [ :e | 'Error printing'  ]) ]
		ifFalse: [ aStream << 'Service Client Proxy on: <not connected>' ].
	
	gtSession ifNotNil:[ 
		aStream
			<< ' [';
			<< gtSession name;
			<< ']' ]
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtInspectorTitleString [
	| limitedString limit |
	limit := 1000.
	limitedString := String 	
		streamContents: [ :s | self gtInspectorTitleStringOn: s ] 
		limitedTo: limit.
	limitedString size < limit ifTrue: [^ limitedString].
	^ limitedString , ' ...'
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtInspectorTitleStringOn: aStream [
	self gtDisplayOn: aStream
]

{ #category : #initialization }
GtRsrProxyServiceClient >> gtPharoProxyInitializeWithSession: aSession [
	"Update the session from the given context".
	
	gtSession := aSession
]

{ #category : #'gt - extensions' }
GtRsrProxyServiceClient >> gtPrintFor: aView [
	<gtProxy>
	
	^ aView textEditor
		title: 'Print';
		priority: 110;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self gtDisplayString asRopedText ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtRsrProxyServiceClient >> gtRemoteSideInitialPlaygroundSnippet [
	^ LeGemStoneSnippet new
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

{ #category : #printing }
GtRsrProxyServiceClient >> printOn: aStream [

	self isProxyObjectActive 
		ifTrue: [
			aStream 
				<< 'Service Client Proxy on: ';
				<< ([self proxyPerform: #gtDisplayString]
					on: Error 
					do: [ :e | 'Error printing'  ]) ]
		ifFalse: [ aStream << 'Service Client Proxy on: <not connected>' ].
	
	gtSession ifNotNil: [ 
		aStream
			<< ' [';
			<< gtSession name;
			<< ']' ]
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol [
	| computedProxy |
	computedProxy := (remoteSelf proxyPerform: aSymbol) wait.
	computedProxy gtPharoProxyInitializeWithSession: self gtSession.
	^ computedProxy
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [
	| computedProxy |
	computedProxy := (remoteSelf 
		proxyPerform: aSymbol withArguments: anArray) wait.
	computedProxy gtPharoProxyInitializeWithSession: self gtSession.
	^ computedProxy
]

{ #category : #'gt inspector' }
GtRsrProxyServiceClient >> remoteViewsFor: aView inContext: aContext [
	"Should be all views, but just get Raw and Print views for now"

	^ self isProxyObjectActive
		ifTrue: [ self declarativeViews collect: [ :declarativeView | 
			declarativeView viewFor: aView ] ]
		ifFalse: [ #() ].
]
