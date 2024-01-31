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

	^ self gtSession
		evaluate: aString
		for: self
		bindings: Dictionary new.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluate: aString autoCommit: aBoolean [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ self gtSession
		evaluate: aString
		for: self
		bindings: Dictionary new
		autoCommit: aBoolean.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluate: aString serializationStrategy: aSymbol [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ self gtSession
		evaluate: aString
		for: self
		bindings: Dictionary new
		serializationStrategy: aSymbol.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluate: aString serializationStrategy: aSymbol autoCommit: aBoolean [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ self gtSession
		evaluate: aString
		for: self
		bindings: Dictionary new
		serializationStrategy: aSymbol
		autoCommit: aBoolean.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWait: aString [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ self gtSession
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWait: aString autoCommit: aBoolean [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ self gtSession
		evaluateAndWait: aString
		for: self
		bindings: Dictionary new
		autoCommit: aBoolean
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWait: aString serializationStrategy: aSymbol [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ (self evaluate: aString serializationStrategy: aSymbol) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWait: aString serializationStrategy: aSymbol autoCommit: aBoolean [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ (self evaluate: aString 
		serializationStrategy: aSymbol
		autoCommit: aBoolean) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWaitReturnProxy: aString [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ (self evaluateReturnProxy: aString) wait
		gtPharoProxyInitializeWithSession: self gtSession
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWaitReturnProxy: aString autoCommit: aBoolean [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ (self evaluateReturnProxy: aString
		autoCommit: aBoolean) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateAndWaitReturnStonSerialized: aString [
	"Evaluate the supplied string with `self` bound to the receiver and answer the result by value (transferred with STON serialisation)"

	^ self 
		evaluateAndWait: aString
		serializationStrategy: #GtRsrStonSerializationStrategy
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateReturnProxy: aString [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ gtSession
		evaluateReturnProxy: aString
		for: self
		bindings: Dictionary new.
]

{ #category : #performing }
GtRsrProxyServiceClient >> evaluateReturnProxy: aString autoCommit: aBoolean [
	"Evaluate the supplied string with `self` bound to the receiver"

	^ self gtSession
		evaluateReturnProxy: aString
		for: self
		bindings: Dictionary new
		autoCommit: aBoolean.
]

{ #category : #'private-accessing' }
GtRsrProxyServiceClient >> getGtSession [
	"Attempt to get the GT session based on the _connection"

	gtSession ifNotNil: [ ^ gtSession ].

	^ GtGemStoneSessionRegistry default 
		sessionWithConnection: _connection
		ifAbsent: [ nil ].
]

{ #category : #'gt inspector' }
GtRsrProxyServiceClient >> getViewProxy [
	"Answer a GtViewedProxy on the receiver"

	^ (self gtSession scriptEvaluation
			script: 'GtRemotePhlowViewedObject object: self';
			receiver: self;
			returnLegacy;
			evaluate) wait
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtActionBrowseFor: anAction [
	<gtAction>

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons browse;
		tooltip: 'Inspect GemStone Class';
		action: [ :button |
			button phlow spawnObject: (self proxyPerform: #class autoCommit: false) ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtActionBrowseLocalClassFor: anAction [
	<gtAction>

	(self class environment classOrTraitNamed: remoteClass asSymbol) ifNil:
		[ ^ anAction noAction ].
	^ anAction button
		priority: 1.1;
		label: 'Local';
		icon: BrGlamorousVectorIcons browse;
		tooltip: 'Inspect Local Class';
		action: [ :button |
			button phlow spawnTool: (GtClassCoderTool forClass: (self class environment classOrTraitNamed: remoteClass asSymbol)) ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtActionDownloadFor: anAction [
	<gtAction>

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons down;
		tooltip: 'Download a copy of the remote instance locally using STON';
		action: [ :button |
			button phlow spawnObject: 
				(self proxyPerform: #yourself
					serializationStrategy: #GtRsrStonSerializationStrategy) ].
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtBasicDisplayOn: aStream [
	| gtDisplayString |

	self isProxyObjectActive ifFalse:
		[ aStream << '<not connected>'.
		^ self ].

	gtDisplayString := [
		(self performEvaluation
			selector: #gtDisplayString;
			returnPrimitiveOnly;
			evaluate) wait ]
				on: Error
				do: [ :ex | 'Error printing bare proxy' ].
	aStream << gtDisplayString.
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtDisplayOn: aStream [

	aStream << 'Service Client Proxy: '.
	self gtBasicDisplayOn: aStream.
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtInspectSessionFor: anAction [
	<gtAction>

	^ anAction button
		label: 'GS';
		priority: 10;
		icon: BrGlamorousVectorIcons inspect;
		tooltip: 'Inspect GemStone Session';
		action: [ :button |
			button phlow spawnObject: gtSession ].
]

{ #category : #printing }
GtRsrProxyServiceClient >> gtInspectorRemoteSideTitleStringOn: aStream [

	self gtBasicDisplayOn: aStream.
	
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
	self gtDisplayOn: aStream.
	
	self gtSession ifNotNil:
		[ :aGtSession | aStream
			<< ' [';
			<< aGtSession name;
			<< ']' ]
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

{ #category : #'gt - extensions' }
GtRsrProxyServiceClient >> gtRemoteMetaFor: aView [
	<gtView>

	^ aView explicit 
		title: 'Meta';
		priority: 250;
		stencil: [
			| methodSpecifications |
			methodSpecifications := self evaluateAndWaitReturnProxy: 'GtGemStoneMethodsSpecification 
	forGsMethods: ((self class theNonMetaClass methodDictForEnv: 0) values 
		asSortedCollection: [ :a :b | a selector < b selector ]).'.
		
		GtGemStoneMethodCodersModel 
			forMethodSpecifications: (GtGemStoneMethodsSpecification 
				fromJsonString: (methodSpecifications
					proxyPerform: #asJsonForExport) )
			inSession: methodSpecifications gtSession ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtRsrProxyServiceClient >> gtRemoteSideInitialPlaygroundSnippet [
	^ LeGemStoneSnippet new
]

{ #category : #accessing }
GtRsrProxyServiceClient >> gtSession [
	^ gtSession ifNil: [ gtSession := self getGtSession ]
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

{ #category : #accessing }
GtRsrProxyServiceClient >> performEvaluation [

	^ GtRsrPerformEvaluation new
		receiver: self;
		gtSession: self gtSession
]

{ #category : #printing }
GtRsrProxyServiceClient >> printOn: aStream [

	self isProxyObjectActive 
		ifTrue: [
			aStream 
				<< 'Service Client Proxy on: ';
				<< ([self proxyPerform: #gtDisplayString autoCommit: false]
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

	^ self proxyPerform: aSymbol 
		autoCommit: self gtSession autoCommitEnabled
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol autoCommit: autoCommit [

	^ (self performEvaluation
		selector: aSymbol;
		returnLegacy;
		autoCommit: autoCommit;
		evaluate) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol serializationStrategy: serializationSymbol [

	^ self proxyPerform: aSymbol
		serializationStrategy: serializationSymbol
		autoCommit: self gtSession autoCommitEnabled
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol serializationStrategy: serializationSymbol autoCommit: aBoolean [

	^ (self performEvaluation
		selector: aSymbol;
		serialisationStrategy: serializationSymbol;
		autoCommit: aBoolean;
		evaluate) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [

	^ self proxyPerform: aSymbol
		withArguments: anArray
		autoCommit: self gtSession autoCommitEnabled
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray autoCommit: autoCommit [

	^ (self performEvaluation
		selector: aSymbol;
		arguments: anArray;
		returnLegacy;
		autoCommit: autoCommit;
		evaluate) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray serializationStrategy: serializationSymbol [

	^ (self performEvaluation
		selector: aSymbol;
		arguments: anArray;
		serialisationStrategy: serializationSymbol;
		autoCommit: self gtSession autoCommitEnabled;
		evaluate) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray serializationStrategy: serializationSymbol autoCommit: aBoolean [

	^ (self performEvaluation
		selector: aSymbol;
		arguments: anArray;
		serialisationStrategy: serializationSymbol;
		autoCommit: aBoolean;
		evaluate) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerformReturnProxy: aSymbol [

	^ self proxyPerformReturnProxy: aSymbol
		withArguments: #()
		autoCommit: self gtSession autoCommitEnabled
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerformReturnProxy: aSymbol autoCommit: aBoolean [

	^ self proxyPerformReturnProxy: aSymbol
		withArguments: #()
		autoCommit: aBoolean
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerformReturnProxy: aSymbol withArguments: anArray [

	^ self proxyPerformReturnProxy: aSymbol
		withArguments: anArray
		autoCommit: self gtSession autoCommitEnabled
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerformReturnProxy: aSymbol withArguments: anArray autoCommit: aBoolean [

	^ (self performEvaluation
		selector: aSymbol;
		arguments: anArray;
		returnProxy;
		autoCommit: aBoolean;
		evaluate) wait
]

{ #category : #performing }
GtRsrProxyServiceClient >> proxyPerformStonSerialized: aSymbol withArguments: anArray [

	^ self 
		proxyPerform: aSymbol 
		withArguments: anArray 
		serializationStrategy: #GtRsrStonSerializationStrategy.
]

{ #category : #private }
GtRsrProxyServiceClient >> remoteSelf [

	^ remoteSelf
]

{ #category : #'gt inspector' }
GtRsrProxyServiceClient >> remoteViewsFor: aView inContext: aContext [
	"Should be all views, but just get Raw and Print views for now"

	^ self isProxyObjectActive
		ifTrue: [ self declarativeViews collect: [ :declarativeView | 
			declarativeView viewFor: aView ] ]
		ifFalse: [ #() ].
]

{ #category : #accessing }
GtRsrProxyServiceClient >> scriptEvaluation [

	^ GtRsrScriptEvaluation new
		receiver: self;
		gtSession: self gtSession
]
