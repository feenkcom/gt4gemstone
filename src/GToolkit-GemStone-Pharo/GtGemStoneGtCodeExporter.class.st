Class {
	#name : #GtGemStoneGtCodeExporter,
	#superclass : #Object,
	#instVars : [
		'exporter'
	],
	#category : #'GToolkit-GemStone-Pharo-Export'
}

{ #category : #'additional class management' }
GtGemStoneGtCodeExporter class >> addAdditionalClassName: aClassName [
	^ self addAdditionalClassNames: { aClassName }
]

{ #category : #'additional class management' }
GtGemStoneGtCodeExporter class >> addAdditionalClassNames: aCollection [
	^ self additionalClassNames: self new additionalClassNames, aCollection
]

{ #category : #'gs code class management' }
GtGemStoneGtCodeExporter class >> addGsCodeClassName: aClassName [
	^ self addGsCodeClassNames: { aClassName }
]

{ #category : #'gs code class management' }
GtGemStoneGtCodeExporter class >> addGsCodeClassNames: aCollection [
	^ self gsCodeClassNames: self new gsCodeClassList, aCollection
]

{ #category : #'stub class management' }
GtGemStoneGtCodeExporter class >> addStubClassName: aClassName [
	^ self addStubClassNames: { aClassName }
]

{ #category : #'stub class management' }
GtGemStoneGtCodeExporter class >> addStubClassNames: aCollection [
	^ self stubClassNames: self new stubClassNames, aCollection
]

{ #category : #'additional class management' }
GtGemStoneGtCodeExporter class >> additionalClassNames: aCollection [
	| names source |
	names := (aCollection collect: [ :each | each asSymbol ]) asSet asArray sorted.
	source := String streamContents: [ :stream |
		stream
			nextPutAll: 'additionalClassNames';
			cr;
			tab;
			nextPutAll: '<additionalClassNames>';
			cr;
			tab;
			nextPutAll: '^ #('.
		names do: [ :each |
			stream cr; tab; tab.
			each storeOn: stream ].
		stream cr; tab; nextPut: $) ].
	self compile: source classified: (self lookupSelector: #additionalClassNames) protocol name.
	^ names
]

{ #category : #maintenance }
GtGemStoneGtCodeExporter class >> cleanLists [
	"Remove entries from stubClasses and additionalClasses that are now covered by packageNames"
	| instance packageClassNames stubsToRemove additionalToRemove |
	
	instance := self new.
	packageClassNames := instance packageClassNames asSet.
	stubsToRemove := packageClassNames intersection: instance stubClassNames.
	additionalToRemove := packageClassNames intersection: instance additionalClassNames.
	(instance additionalClassNames intersection: instance stubClassNames) ifNotEmpty: [ :toRemove |
		stubsToRemove addAll: toRemove ].
	self removeStubClassNames: stubsToRemove.
	self removeAdditionalClassNames: additionalToRemove.
	^ { stubsToRemove. additionalToRemove. }
]

{ #category : #'gs code class management' }
GtGemStoneGtCodeExporter class >> gsCodeClassNames: aCollection [
	| names source |
	names := (aCollection collect: [ :each | each asSymbol ]) asSet asArray sorted.
	source := String streamContents: [ :stream |
		stream
			nextPutAll: 'gsCodeClassList';
			cr;
			tab;
			nextPutAll: '<gsCodeClasses>';
			cr;
			tab;
			nextPutAll: '^ #('.
		names do: [ :each |
			stream cr; tab; tab.
			each storeOn: stream ].
		stream cr; tab; nextPut: $) ].
	self compile: source classified: (self lookupSelector: #gsCodeClassList) protocol name.
	^ names
]

{ #category : #maintenance }
GtGemStoneGtCodeExporter class >> rebuildGsCodeClassList [
	| gsCodeClasses gsCodeClassNames source |

	gsCodeClasses := #gsCode: gtPragmas result toArray wait
		collect: [ :method | method methodClass ]
		as: Set.
	gsCodeClassNames := (gsCodeClasses collect: #name) sorted.

	source := String streamContents: [ :stream |
		stream
			nextPutAll: 'gsCodeClassList'; cr;
			tab; nextPutAll: '<gsCodeClasses>'; cr;
			cr;
			nextPutAll: '^ #('; cr.
		gsCodeClassNames do: [ :clsName |
			stream
				tab; tab; 
				nextPut: $#;
				nextPutAll: clsName;
				cr ].
		stream
			tab; nextPutAll: ')'; cr. ].
			
	self compile: source classified: (self lookupSelector: #gsCodeClassList) protocol name.
	^ gsCodeClassNames
]

{ #category : #'additional class management' }
GtGemStoneGtCodeExporter class >> removeAdditionalClassName: aClassName [
	^ self removeAdditionalClassNames: { aClassName }
]

{ #category : #'additional class management' }
GtGemStoneGtCodeExporter class >> removeAdditionalClassNames: aCollection [
	| namesToRemove |
	namesToRemove := aCollection collect: [ :each | each asSymbol ].
	^ self additionalClassNames: (self new additionalClassNames reject: [ :each |
		namesToRemove includes: each asSymbol ])
]

{ #category : #'stub class management' }
GtGemStoneGtCodeExporter class >> removeStubClassName: aClassName [
	^ self removeStubClassNames: { aClassName }
]

{ #category : #'stub class management' }
GtGemStoneGtCodeExporter class >> removeStubClassNames: aCollection [
	| namesToRemove |
	namesToRemove := aCollection collect: [ :each | each asSymbol ].
	^ self stubClassNames: (self new stubClassNames reject: [ :each |
		namesToRemove includes: each asSymbol ])
]

{ #category : #'stub class management' }
GtGemStoneGtCodeExporter class >> stubClassNames: aCollection [
	| names source |
	names := (aCollection collect: [ :each | each asSymbol ]) asSet asArray sorted.
	source := String streamContents: [ :stream |
		stream
			nextPutAll: 'stubClassNames';
			cr;
			tab;
			nextPutAll: '<stubClassNames>';
			cr;
			tab;
			nextPutAll: '^ #('.
		names do: [ :each |
			stream cr; tab; tab.
			each storeOn: stream ].
		stream cr; tab; nextPut: $) ].
	self compile: source classified: (self lookupSelector: #stubClassNames) protocol name.
	^ names
]

{ #category : #private }
GtGemStoneGtCodeExporter >> additionalClassList [
	| names |
	names := OrderedCollection new.
	(Pragma allNamed: #additionalClassNames in: self class)
		do: [ :pragma |
			(self perform: pragma methodSelector)
				do: [ :name | names addIfNotPresent: name ] ].
	^ names asArray
		collect: [ :each | Smalltalk globals at: each ifAbsent: [ nil ] ]
		thenReject: [ :each | each isNil ]
]

{ #category : #private }
GtGemStoneGtCodeExporter >> additionalClassNames [
	<additionalClassNames>
	^ #(
		#ArithmeticError
		#AssertionFailure
		#AsyncFutureExecutionError
		#AutomaticRewriting
		#BlDevScripterAssertionFailure
		#ConnectionClosed
		#DefaultExecutionEnvironment
		#Deprecation
		#DeprecationPerformedNotification
		#DomainError
		#ExecutionEnvironment
		#GtExampleComparisonExceptionWithDebuggingViews
		#GtGemStoneExtensionMethod
		#GtGemStoneExtensionMethods
		#GtLAbstractFunctionTool
		#GtLTool
		#KeyNotFound
		#NetworkError
		#NotFound
		#OrderedDictionary
		#OrderedDictionaryTest
		#Point
		#RBRefactoringError
		#Rectangle
		#RectangleTest
		#SmaCCParserError
		#SubscriptOutOfBounds
		#SystemNotification
		#TestExecutionEnvironment
		#TestExecutionService
		#TestSkipped
		#TestTookTooMuchTime
		#ZnDefaultCharacterEncoder
		#ZnMaximumNumberOfDictionaryEntries
		#ZnMultiValueDictionary
		#ZnPercentEncoder
		#ZnPortNotANumber
		#ZnResourceMetaUtils
		#ZnTooManyDictionaryEntries
		#ZnUnknownScheme
		#ZnUrl
		#ZnUrlTest
	)
]

{ #category : #private }
GtGemStoneGtCodeExporter >> additionalClasses [
	"Programatically add to the #additionalClassList.
	But nothing to add at the moment."
	| additionalClasses |
	
	additionalClasses := OrderedCollection withAll: self additionalClassList.
	^ additionalClasses
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> alternateClassDefinitions [
	"Use GemStone dynamic variables for the Zinc URL configuration."
	^ Dictionary new
		at: #ZnDefaultCharacterEncoder put: 'GtGsDynamicVariable subclass: ''ZnDefaultCharacterEncoder'' instVarNames: #() classVars: #() classInstVars: #() poolDictionaries: #() inDictionary: Globals options: #()';
		at: #ZnMaximumNumberOfDictionaryEntries put: 'GtGsDynamicVariable subclass: ''ZnMaximumNumberOfDictionaryEntries'' instVarNames: #() classVars: #() classInstVars: #() poolDictionaries: #() inDictionary: Globals options: #()';
		yourself
]

{ #category : #private }
GtGemStoneGtCodeExporter >> configuredExporter [
	| configuredExporter |
	configuredExporter := GtGemStoneTopazExporter
		packages: self packageNames
		additionalClasses: self additionalClasses
		stubClasses: self stubClasses
		excluding: self excludedClasses.
	configuredExporter
		alternateClassDefinitions: self alternateClassDefinitions;
		excludedMethods: self excludedMethods;
		includeGsCodeMethods: true;
		gsCodeClasses: self gsCodeClasses;
		newMethodPackageNames: self packageNames;
		newMethodClassNames: (self additionalClassList collect: #name).
	^ configuredExporter
]

{ #category : #private }
GtGemStoneGtCodeExporter >> excludedClassList [
	<excludedClasses>
	^ { GtGemStoneTopazExporterExamples.
		GtExamplesCommandLineHandler. }
]

{ #category : #private }
GtGemStoneGtCodeExporter >> excludedClasses [
	| classes |
	classes := OrderedCollection new.
	(Pragma allNamed: #excludedClasses in: self class)
		do: [ :pragma |
			(self perform: pragma methodSelector)
				do: [ :class | classes addIfNotPresent: class ] ].
	^ classes asArray
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> excludedMethods [
	| methods |
	methods := OrderedCollection new.
	(Pragma allNamed: #excludedMethods in: self class)
		do: [ :pragma |
			(self perform: pragma methodSelector)
				do: [ :method | methods addIfNotPresent: method ] ].
	^ methods asArray
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> excludedMethodsList [
	<excludedMethods>

	^ {
	GtLMarkdown>>#commentForSmaCC.
	GtLClassCreationDataExtractor>>#extractSuperclassIfError:.
	GtLClassChangeDataExtractor>>#extractSuperclassIfError:.
	GtLClassCreationDataExtractor>>#extractTargetClassNameIfError:.
	GtLDataView>>#documentData.
	GtLDataView>>#compositeData.
	GtLDataView>>#emptyData.
	GtLDataView>>#forwardCollection.
	GtLDataView>>#forwardObject.
	GtLDataView>>#imageData.
	GtLDataView>>#jsonData.
	GtLDataView>>#magritteObject.
	GtLDataView>>#basicOn:perform:withArguments:.
	GRPlatform>>#bindingOf:.
	GtLFunctionToolCallExecutionDetails>>#startTelemetryPing.
	GtLDataSourceEncoderDecoder class>>#writeClientHistory:to:selector:.
	GtLValueSerializerExamples>>#serializeProtoObjectClass.
	GtLPackageChangeHistory>>#gtViewChangeIcon.
	GtLPackageTagChangeHistory>>#gtViewChangeIcon.
	GtLClassChangeDataExtractor>>#extractTargetClassIfError:.
	GtLSmaCCModel>>#grammarFor:.
	GtLMagritteToolForClassDefinitionChangeExamples>>#removeClassNamedIfPresent:.
	GtLSmaCCToolForParserCompilationExamples>>#compile.
	GtLSmaCCToolForParserCompilationExamples>>#cleanUp.
	GtLMagritteToolForClassesCreationExamples>>#createClassesWithInstanceVariables.
	GtLMagritteToolForClassesCreationExamples>>#createTraitsWithInstanceVariables.
	GtLMagritteToolForClassesCreationExamples>>#removeClassNamedIfPresent:.
	GtLMagritteToolForMethodsRemovalExamples>>#removeClassNamedIfPresent:.
	GtLMethodChangeHistory>>#gtViewChangeIcon.
	GtLDocumentDataViewExamples>>#samplePdfBytes.
	GtLResponseMarkdownFormat>>#initialize.
	GtLToolForExampleClassesRun>>#extractExamplesFromClassesFrom:in:reportingNotFoundIn:.
	GtLToolForExampleClassesRun>>#extractExamplesFromMethodsFrom:in:reportingNotFoundIn:.
	GtLToolForTestClassesRun>>#privatePerformToolCall:inContext:.
	GtLOllamaMigrationExamples>>#gemma4Image.
	GtLMagritteToolForClassCommentChangeExamples>>#changeCommentSuccessful.
	GtLClassDefinitionChangeHistory>>#gtViewChangeIcon.
	GtLClassCommentChangeDescriptionElement>>#initialize.
	GtLMethodChangeDescriptionElement>>#initialize.
	GtLSmaCCParserTest>>#testParse.
	MARelationDescription>>#descriptionClasses.
	GtLMagritteToolForClassRemovalExamples>>#removeExistingClass.
	GtLClassDefinitionChangeDescriptionElement>>#updateForClassDefinitionChangeHistory:.
	GtLMagritteToolForClassRemovalExamples>>#removeClassNamedIfPresent:.
	GtLMagritteToolForMethodRemovalExamples>>#removeClassNamedIfPresent:.
	GtLPrimitiveDocumentDataBlockExamples>>#samplePdfBytes.
	GtLClassDefinitionDescriptionExamples>>#fromClassWithTraits.
	GtLPdfFileExamples>>#samplePdfContent.
	GtLMagritteToolForClassCreationExamples>>#createClassWithComment.
	GtLMagritteToolForClassCreationExamples>>#createClassWithInstanceVariables.
	GtLMagritteToolForClassCreationExamples>>#removeClassNamedIfPresent:.
	GtLClassChangeHistory>>#gtViewChangeIcon.
	GtLCodeChangesToolCallsSummarizerExamples>>#messagesGroupWithExecutedClassCommentChange.
	GtLCodeChangesToolCallsSummarizerExamples>>#removeClassNamedIfPresent:.
	MAStringReader>>#visitBlockDescription:.
	GtExamplesHudsonReport>>#runExample:.
	TestExecutionEnvironment>>#runUnmanagedExampleEvaluator:.
	TestExecutionEnvironment>>#processMonitor.
	GtExampleExternalDependencyResolver>>#appliesTo:.
	GtExamplesCommandLineHandler>>#activate.
	GtExampleOpenDebugger>>#initialize.
	GtExampleSubject>>#gtExamplesContained.
	GtExampleSubject>>#gtParametrizedExamplesContained.
	GtExampleThemeIcon>>#basicForm.
	GtDummyExamplesInSubclass>>#dCallSuper.
	GtExampleGroup>>#gtInspectorExamplesIn:.
	GtExampleThemeIcon>>#exists.
	Deprecation>>#freeze.
	GtExamplesCommandLineHandler>>#runPackages.
	GtExampleExternalDependencyResolver>>#posibleExampleForNode:fromMethod:forOriginalExample:.
	GtGemStoneExtensionMethods class>>#compileAllOnGemStone.
	GtGemStoneExtensionMethods class>>#newFromClass:selector:meta:.
	GtGemStoneExtensionMethods class>>#newFromClass:selector:meta:session:.
	GtMagritteModelExamples>>#simpleBaselineDescription.
	GtMagritteMemento>>#debugValidateValue:.
		NeoJSONReaderTests>>#testSmallDictionary.
		NeoJSONWriterTests>>#testListsExtra.
		NeoJSONWriterTests>>#testMapsExtra.
	OrderedDictionary>>#gtDebuggerPrintForComparisonOn:.
	OrderedDictionaryTest>>#testDictionaryPublicProtocolCompatibility.
	Point>>#@.
	Point >> #asBlocVector.
	Point>>#asScale3D.
	Point>>#asTranslate3D.
	Point>>#scalarMultiplicate2D:.
	Point>>#asBrAnchoredAnchorBounds.
	Point>>#asGSCoordinates.
	Point>>#asGVector.
	Point>>#asMargin.
	}
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> export [ 
	| outputFile |

	outputFile := 'gt4gemstone/src-gs/GT.gs' asFileReference.
	outputFile parent exists ifFalse:
		[ self error: 'Export directory doesn''t exist: ', outputFile parent fullName ].
	outputFile ensureDelete.
	exporter := self configuredExporter.
	exporter writeTo: outputFile.
	^ exporter
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> exporter [
	^ exporter
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> gsCodeClassList [
	<gsCodeClasses>

^ #(
		#Class
		#CurrentExecutionEnvironment class
		#Exception
		#GsNMethod
		#GtExample
		#GtExampleClassResolver
		#GtExampleDependenciesResolver
		#GtExampleDependenciesResolver class
		#GtExampleEvaluator
		#GtExampleMethodResolver
		#GtExampleResultNoValue class
		#GtGemStoneExtensionMethod
		#GtGemStoneTopazExporterExamples
		#GtProcessStackOverflowChecker class
		#Metaclass3
		#Object
		#Pragma
		#Symbol
	)

]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> gsCodeClasses [
	| names |
	names := OrderedCollection new.
	(Pragma allNamed: #gsCodeClasses in: self class)
		do: [ :pragma |
			(self perform: pragma methodSelector)
				do: [ :name | names addIfNotPresent: name ] ].
	^ names asArray
		collect: [ :each | Smalltalk globals at: each ifAbsent: [ nil ] ]
		thenReject: [ :each | each isNil ]
]

{ #category : #exporting }
GtGemStoneGtCodeExporter >> loadZnUrlPortOnGemStone [
	"Reload only the URL port in the default session, using the configured exporter.
	All class methods are replaced just as in a full export. Do not commit."
	| focused session evaluateTopazBlock newScript |
	focused := self znUrlPortExporter.
	session := GtGemStoneSessionRegistry defaultSession.
	evaluateTopazBlock := [ :topaz | | lines end |
		lines := topaz lines.
		end := lines indexOf: '%'.
		end > 0 ifTrue: [
			session evaluateAndWait: (String lf join: (lines copyFrom: 2 to: end - 1)) ] ].
	focused classesToDefine do: [ :class |
		evaluateTopazBlock value: (String streamContents: [ :stream |
			focused writeDefinitionOf: class on: stream ]) ].
	focused selectedClasses do: [ :class |
		session evaluateBlockAndWait: [ :name | | behavior |
			behavior := GsSession currentSession objectNamed: name.
			behavior selectors do: [ :selector | behavior removeSelector: selector ].
			behavior class selectors do: [ :selector | behavior class removeSelector: selector ].
			true ] withArguments: { class name } ].
	focused selectedClasses do: [ :class |
		{ class. class class } do: [ :behavior |
			(focused effectiveMethodsOf: behavior) do: [ :method |
				(focused shouldExportPharoSourceOf: method in: behavior) ifTrue: [
					GtGemStoneTopazExporter compileMethod: method in: session ] ] ] ].
	self znUrlPortExtensionSelectors do: [ :selector |
		GtGemStoneTopazExporter
			compileMethod: (GtGemStoneExtensionMethods class >> selector)
			in: session ].
	session evaluateBlockAndWait: [ :selectors |
		selectors do: [ :selector | (GtGemStoneExtensionMethods perform: selector) apply ].
		true ] withArguments: { self znUrlPortExtensionSelectors }.
	newScript := String streamContents: [ :stream | focused writeNewMethodsOn: stream ].
	newScript ifNotEmpty: [ evaluateTopazBlock value: newScript ].
	^ focused
]

{ #category : #'as yet unclassified' }
GtGemStoneGtCodeExporter >> magritteExcludedExampleMethods [
	<excludedMethods>
	
	^ {
GtMagritteByScripterExamples >> #address.
GtMagritteByScripterExamples >> #scripter.
GtMagritteByScripterExamples >> #serverObjectInStoppedStateAndChangedPort.
GtMagritteByScripterExamples >> #serverObjectInStartedStateAndReadOnlyPort.
GtMagritteByScripterExamples >> #serverObjectInStartedStateAndAutoAcceptWidget.
GtMagritteByScripterExamples >> #serverObjectInStartedState.
GtMagritteByScripterExamples >> #serverObject.
GtMagritteByScripterExamples >> #addressWithoutCancel.
GtMagritteByScripterExamples >> #addressWithCallbacksAndChangedFavorite.
GtMagritteByScripterExamples >> #addressWithErrorAcceptCallbacks.
GtMagritteByScripterExamples >> #addressWithCallbacksAndDefectiveCancelAction.
GtMagritteByScripterExamples >> #addressWithCallbacksAndDefectiveAcceptAction.
GtMagritteByScripterExamples >> #addressWithCallbacksAndCanceledChangedStreet.
GtMagritteByScripterExamples >> #addressWithCallbacksAndAcceptChangedStreet.
GtMagritteByScripterExamples >> #addressWithCallbacksAndChangedStreet.
GtMagritteByScripterExamples >> #addressWithCallbacksAndAcceptActionWithDefectiveCallbacks.
GtMagritteByScripterExamples >> #addressEmptyStreet.
GtMagritteByScripterExamples >> #addressCancelChangedStreet.
GtMagritteByScripterExamples >> #addressChangedStreet.
GtMagritteByScripterExamples >> #addressAcceptChangedStreet.
GtMagritteByScripterExamples >> #addressObjectWithCallbacks.
GtMagritteModelExamples >> #simpleDirectoryObject.
GtMagritteModelExamples >> #simpleBaselinesDescription.
GtMagritteViewModelExamples >> #basicAsyncViewModel.
GtMagritteViewModelExamples >> #viewModelWithPassword.
GtMagritteViewModelExamples >> #viewModelWithDirectory.
GtMagritteViewModelExamples >> #elementWithPrimaryAddress_TwiceAsElement.
GtMagritteViewModelExamples >> #elementWithPrimaryAddress.
GtMagritteViewModelExamples >> #asyncViewModelWithPrimaryAddress.
GtMagritteViewModelExamples >> #elementWithPersonObjectWithTwoAddresses_TwiceAsElement.
GtMagritteViewModelExamples >> #elementWithPersonObjectWithTwoAddresses.
GtMagritteViewModelExamples >> #asyncViewModelWithPersonObjectWithTwoAddresses_WithAddressesDescriptionOnly.
GtMagritteViewModelExamples >> #asyncViewModelWithPersonObjectWithTwoAddresses.
GtMagritteViewModelExamples >> #dynamicPersonViewModel.
GtMagritteViewModelExamples >> #viewModelWithBaselinesWithoutSaveOrCancelButton.
GtMagritteViewModelExamples >> #viewModelWithBaselines.
GtMagritteViewModelExamples >> #elementWithSimpleBaseline.
GtMagritteViewModelExamples >> #asyncViewModelWithSimpleBaselines.
GtMagritteViewModelExamples >> #asyncViewModelWithSimpleBaseline.
GtMagritteViewModelExamples >> #simpleBaselineDescription.
}

]

{ #category : #'as yet unclassified' }
GtGemStoneGtCodeExporter >> gtAdditionalClassesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Additional Classes';
		priority: 20;
		items: [ self additionalClasses sorted: #name ascending ]
]

{ #category : #'analysis - private' }
GtGemStoneGtCodeExporter >> methodContainsTopazTerminatorInLiteral: aCompiledMethod [
	^ aCompiledMethod allLiterals anySatisfy: [ :literal |
		literal isString and: [
			literal lines anySatisfy: [ :line | line beginsWith: '%' ] ] ]
]

{ #category : #'analysis - private' }
GtGemStoneGtCodeExporter >> methodReferencesSmalltalk: aCompiledMethod [
	| found |
	found := false.
	aCompiledMethod withAllNestedLiteralsDo: [ :literal |
		(literal isVariableBinding
			and: [ literal isGlobalVariable
			and: [ literal key = #Smalltalk ] ]) ifTrue: [ found := true ] ].
	^ found
]

{ #category : #'private - accessing' }
GtGemStoneGtCodeExporter >> packageClassNames [
	"Answer the class names that are part of packageNames"
	
	^ self packageNames flatCollect: [ :pkgName |
		(PackageOrganizer default packageNamed: pkgName) definedClasses
			collect: #name ].
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> packageNames [
	| packagePrefixes packageNames |

	packagePrefixes := { 
		'Gt4Llm'. 
		'GToolkit-Examples-Dummies'.
		'GToolkit4Magritte'.
		'Neo-JSON'.
		'GToolkit4NeoJSON'.
		}.
	packageNames := packagePrefixes flatCollect: [ :prefix |
		PackageOrganizer default packageNames asOrderedCollection
			select: [ :name | name beginsWith: prefix ] ]
				as: OrderedCollection.
	packageNames removeAll: { 'Gt4Llm' }.
	packageNames addAll: {
		'Grease-Core'.
		'Magritte-Model'.
		'GToolkit-Examples'.
		}.
	^ packageNames
]

{ #category : #analysis }
GtGemStoneGtCodeExporter >> staticExportAnalysisForPackageNames: aCollection [
	| gemstoneNames excludedClasses selected classesToScan scanned additional stubs excluded methods references missingClass generated actual difference |
	gemstoneNames := GtGemStoneTopazExporter gemstoneClassNames asSet.
	excludedClasses := self excludedClasses asSet.
	selected := Set new.
	aCollection do: [ :packageName |
		selected addAll: ((PackageOrganizer default
			packageNamed: packageName
			ifAbsent: [ self error: 'Unknown package: ', packageName ]) definedClasses) ].
	selected := selected reject: [ :each |
		each isTrait or: [ (excludedClasses includes: each) or: [ each superclass == PackageManifest ] ] ].
	classesToScan := selected asOrderedCollection.
	scanned := Set new.
	additional := Set new.
	stubs := Set new.
	excluded := Set new.
	[ classesToScan isEmpty ] whileFalse: [
		| class |
		class := classesToScan removeFirst.
		(scanned includes: class) ifFalse: [
			scanned add: class.
			methods := (class methodDict values, class classSide methodDict values).
			methods do: [ :method |
				((self methodReferencesSmalltalk: method)
					or: [ method readsThisContext
					or: [ self methodContainsTopazTerminatorInLiteral: method ] ])
					ifTrue: [ excluded add: method ] ].
			references := Set new.
			methods do: [ :method |
				(excluded includes: method) ifFalse: [ references addAll: method referencedClasses ] ].
			class superclass ifNotNil: [ references add: class superclass ].
			references do: [ :referencedClass |
				missingClass := referencedClass instanceSide.
				((selected includes: missingClass)
					or: [ (additional includes: missingClass)
					or: [ gemstoneNames includes: missingClass name ] ]) ifFalse: [
					((missingClass = Exception) or: [ missingClass inheritsFrom: Exception ])
						ifTrue: [
							additional add: missingClass.
							classesToScan add: missingClass ]
						ifFalse: [ stubs add: missingClass ] ] ] ] ].
	generated := Dictionary new
		at: #additionalClasses put: (additional sorted: [ :a :b | a name <= b name ]);
		at: #stubClasses put: (stubs sorted: [ :a :b | a name <= b name ]);
		at: #excludedMethods put: (excluded sorted: [ :a :b | a printString <= b printString ]);
		yourself.
	actual := Dictionary new
		at: #additionalClasses put: self additionalClasses asSet;
		at: #stubClasses put: self stubClasses asSet;
		at: #excludedMethods put: self excludedMethods asSet;
		yourself.
	difference := Dictionary new.
	#(#additionalClasses #stubClasses #excludedMethods) do: [ :key |
		| generatedSet actualSet |
		generatedSet := (generated at: key) asSet.
		actualSet := (actual at: key) asSet.
		difference at: key put: (Dictionary new
			at: #missingFromExisting put: (generatedSet reject: [ :each | actualSet includes: each ]);
			at: #onlyInExisting put: (actualSet reject: [ :each | generatedSet includes: each ]);
			yourself) ].
	^ Dictionary new
		at: #generated put: generated;
		at: #existing put: actual;
		at: #differences put: difference;
		yourself
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> stubClassNames [
	<stubClassNames>
	^ #(
		#AsyncCachedFuture
		#AsyncCachedStream
		#AsyncChunksStream
		#AsyncCounterSink
		#AsyncDebounceStream
		#AsyncDelayedFuture
		#AsyncEphemerousStream
		#AsyncErrorHandlingFuture
		#AsyncErrorHandlingStream
		#AsyncFilterStream
		#AsyncFlattenFuture
		#AsyncFlattenStream
		#AsyncFuseStream
		#AsyncFutureCache
		#AsyncFutureDummyWaker
		#AsyncFutureExecutionAtomicWaker
		#AsyncFutureExecutionConfiguration
		#AsyncFutureExecutionContext
		#AsyncFuturePromise
		#AsyncFutureThreadPool
		#AsyncLePageStream
		#AsyncLineReadStream
		#AsyncMapFuture
		#AsyncMapFutureStream
		#AsyncMapStream
		#AsyncMapWithCacheStream
		#AsyncMapWithIndexStream
		#AsyncMutex
		#AsyncObservableValue
		#AsyncOnceStream
		#AsyncOptionalValue
		#AsyncPassExceptionHandler
		#AsyncPeekSink
		#AsyncPoll
		#AsyncProcessStackOverflowCheckerFuture
		#AsyncSequenceStream
		#AsyncSharedDictionary
		#AsyncSharedOrderedCollection
		#AsyncSplitStream
		#AsyncStreamCollectFuture
		#AsyncStreamFoldFuture
		#AsyncStreamForEachFuture
		#AsyncStreamForwardFuture
		#AsyncStreamHasNextFuture
		#AsyncStreamNextFuture
		#AsyncStreamSizeHint
		#AsyncTakeStream
		#AsyncTerminatableStream
		#AsyncThrottleStream
		#AsyncWeakStream
		#AsyncWithTimeoutStream
		#AsyncWithoutDuplicatesStream
		#Author
		#Base64MimeConverter
		#Base64UrlEncoder
		#BeaconSignal
		#BinaryFileStream
		#BlArrowheadSimpleArrow
		#BlAttributedTextElement
		#BlBorder
		#BlCircleGeometry
		#BlClickEvent
		#BlCompositeStyler
		#BlCopyCursor
		#BlDevScripterToolActionStep
		#BlDoubleClickEvent
		#BlElement
		#BlElementAddedToSceneGraphEvent
		#BlElementSelectedStateWish
		#BlElementState
		#BlElementUniqueId
		#BlElementUniqueState
		#BlEllipseGeometry
		#BlEventHandler
		#BlExporter
		#BlFlowLayout
		#BlFocusFinder
		#BlFocusInEvent
		#BlFocusOutEvent
		#BlFocusSearchDirectionBackward
		#BlFocusSearchDirectionForward
		#BlFontFamilyAttribute
		#BlFontWeightAttribute
		#BlFrameLayout
		#BlGlamorousExpanderShadowAptitude
		#BlInsets
		#BlKeyCombination
		#BlKeyModifiers
		#BlLinearLayout
		#BlMouseEnterEvent
		#BlMouseLeaveEvent
		#BlMouseOutEvent
		#BlMouseOverEvent
		#BlParabollaArcElement
		#BlPromiseTask
		#BlRepeatedTaskAction
		#BlResizerBottomListener
		#BlResizerResizedEvent
		#BlResizerRightListener
		#BlRoundedRectangleGeometry
		#BlScripter
		#BlShortcutWithAction
		#BlSpace
		#BlStencil
		#BlTaskAction
		#BlText
		#BlTextAttributesBuilder
		#BlTextForegroundAttribute
		#BlTextStyler
		#BlTextStylerTelemetry
		#BlTextUnderlayAttribute
		#BlVisibility
		#BrAnchoredVisualAnalysis
		#BrAsyncFileWidget
		#BrButton
		#BrCheckbox
		#BrColumnedList
		#BrColumnedMultiListAptitude
		#BrDebuggableEditorElementStencil
		#BrDeletableFileWidget
		#BrDropdownHideWish
		#BrEditableLabel
		#BrEditor
		#BrEditorElement
		#BrEditorModeState
		#BrEditorShortcut
		#BrElementUpdater
		#BrExpander
		#BrFileSelector
		#BrFlowList
		#BrFrame
		#BrGlamorousButtonExteriorAptitude
		#BrGlamorousButtonIconDropdownAptitude
		#BrGlamorousButtonLabelAndIconAptitude
		#BrGlamorousButtonLabelAptitude
		#BrGlamorousButtonRectangularAptitude
		#BrGlamorousButtonWithIconAndLabelAptitude
		#BrGlamorousButtonWithIconAptitude
		#BrGlamorousButtonWithIconCircularAptitude
		#BrGlamorousButtonWithLabelAptitude
		#BrGlamorousButtonWithLabelTooltipAptitude2
		#BrGlamorousCheckboxAptitude
		#BrGlamorousCodeEditorAptitude
		#BrGlamorousColors
		#BrGlamorousColumnedListItemElementWithContextMenuDecorator
		#BrGlamorousColumnedListSelectableRowElementStencilBuilder
		#BrGlamorousEditableLabelAptitude
		#BrGlamorousExpanderSubtleAptitude
		#BrGlamorousFocusableShadowAptitude
		#BrGlamorousLabelAptitude
		#BrGlamorousListItemAptitude
		#BrGlamorousListLabelAptitude
		#BrGlamorousPopoverPinnableAptitude
		#BrGlamorousPopoverResizableAptitude
		#BrGlamorousRegularEditorAptitude
		#BrGlamorousResizerBottomBarAptitude
		#BrGlamorousResizerRightBarAptitude
		#BrGlamorousShrinkingLabelAptitude
		#BrGlamorousTabAptitude
		#BrGlamorousTabGroupAptitude
		#BrGlamorousTabSwitcherWithIconAptitude
		#BrGlamorousTaggerEditableAptitude
		#BrGlamorousToggleGroupAptitude
		#BrGlamorousToggleWithLabelAptitude
		#BrGlamorousToolbarAptitude
		#BrGlamorousVectorIcons
		#BrGlamorousWithExplicitContextMenuAptitude
		#BrGlamorousWithExplicitDropdownAptitude
		#BrGlamorousWithExplicitTooltipAptitude
		#BrGlamorousWithHorizontalResizerAptitude
		#BrGlamorousWithVerticalResizerAptitude
		#BrHorizontalFlow
		#BrHorizontalGrid
		#BrHorizontalPane
		#BrLabel
		#BrLayoutAlignmentAptitude
		#BrLayoutHorizontalResizerState
		#BrLayoutResizerAptitude
		#BrLayoutVerticalResizerState
		#BrLazyStyleCommonAptitude
		#BrListRowStencilBuilder
		#BrMenuActionItem
		#BrMenuItemGroupConfiguration
		#BrMenuItems
		#BrPackageNameInputFilter
		#BrPackageTagNameInputFilter
		#BrRBTextStyler
		#BrResizerElementLength
		#BrScrollPane
		#BrScrollPaneAptitude
		#BrSelectionChanged
		#BrSequenceableCollectionItemsProvider
		#BrShadowAptitude
		#BrSimpleList
		#BrSizeAdjustmentState
		#BrStencilBuilder
		#BrStreamItemsProvider
		#BrStyleCommonAptitude
		#BrTab
		#BrTabGroup
		#BrTagger
		#BrTaggerAddTagRequest
		#BrTaggerRemoveTagRequest
		#BrTextAdornmentAttribute
		#BrTextAdornmentDynamicAttribute
		#BrTextCursorDynamicAttribute
		#BrTextEditorModel
		#BrTextEditorModifiedEvent
		#BrTextEditorNoLineBreakInputFilter
		#BrTextHideAttribute
		#BrTextInvisibleMarkerAttribute
		#BrTextReplacingAttribute
		#BrToggle
		#BrToggleActivatedEvent
		#BrToggleGroup
		#BrToolbar
		#BrVerticalPane
		#BrWidgetModel
		#BrWish
		#Clipboard
		#Color
		#CommandLineHandler
		#CompiledMethod
		#ContextStackSignal
		#CurrentExecutionEnvironment
		#DebugAction
		#DictionaryValueHolder
		#DiffPatchVisitor
		#DiffVisitor
		#EpClassAddition
		#EpClassRemoval
		#EpMethodAddition
		#EpMethodRemoval
		#FLSerializer
		#File
		#FileSystemDirectoryEntry
		#Float32Array
		#Form
		#GZipReadStream
		#GtABAddressBook
		#GtABCartoonAddressBookExample
		#GtAnthropicClient
		#GtAnthropicListModelsAPIClient
		#GtAnthropicModelsGroup
		#GtBPEEncoder
		#GtBasicGroup
		#GtButtonAttribute
		#GtCachedTextExpandButtonAttribute
		#GtCharacterGroupDiffSplitter
		#GtClassCoderTool
		#GtClassesCompletionStrategy
		#GtClipboard
		#GtCodeDiffRBTextStyler
		#GtCoder
		#GtCoderElement
		#GtCoderExpanderAptitude
		#GtCoderPackageTagTarget
		#GtCoderPackageTarget
		#GtCoderRenameMethodRefactoring
		#GtCoderShortcutIds
		#GtCoderViewModelRenameAction
		#GtCompletionController
		#GtCompletionStrategyAttribute
		#GtCompositeCompletionAction
		#GtCompositeSmaCCASTStyler
		#GtConnector
		#GtConnectorExampleStyler
		#GtDebuggerDiffObjectStateComparisonStencil
		#GtDeleteTextCompletionAction
		#GtDiffBuilder
		#GtDiffElementWithLabelStencil
		#GtEpiceaEventFactory
		#GtExampleColorHandler
		#GtExampleGroupCoder
		#GtExampleLabelTextHandler
		#GtExampleResultSimplifiedErrorValue
		#GtExampleResultSimplifiedFailureValue
		#GtExampleResultSimplifiedNestedErrorValue
		#GtExampleResultSimplifiedSuccessValue
		#GtExplainerExplanationAptitude
		#GtFixItMarkerAttribute
		#GtGemStoneLlmToolForClassDefinitionChange
		#GtGemStoneLlmToolForClassLookup
		#GtGemStoneLlmToolForClassReferences
		#GtGemStoneLlmToolForClassSearch
		#GtGemStoneLlmToolForClassSubclasses
		#GtGemStoneLlmToolForMethodCompilation
		#GtGemStoneLlmToolForMethodImplementors
		#GtGemStoneLlmToolForMethodRemoval
		#GtGemStoneLlmToolForMethodSenders
		#GtGemStoneLlmToolForMethodsSource
		#GtGemStoneLlmToolForSmalltalkCodeEvaluation
		#GtGemStoneSessionRegistry
		#GtGeminiClient
		#GtGenericPharoStyler
		#GtHomeCard
		#GtHomeMultiCardSection
		#GtInsertTextCompletionAction
		#GtInspector
		#GtInspectorElementOverviewProperty
		#GtInspectorObject
		#GtInspectorPlusIconStencil
		#GtInspectorRoundButtonStencil
		#GtInspectorSampleWithExceptionsInExtensions
		#GtInspectorTool
		#GtJson
		#GtJsonShapeComparison
		#GtLlmAbstractFunctionTool
		#GtLlmActionCall
		#GtLlmActionMessage
		#GtLlmAssistant
		#GtLlmAssistantAction
		#GtLlmAssistantActionExample
		#GtLlmAssistantChatReadyStatus
		#GtLlmAssistantFormatDescription
		#GtLlmAssistantMessage
		#GtLlmChat
		#GtLlmChatMessage
		#GtLlmConnection
		#GtLlmConnectionRegistry
		#GtLlmCosineDistanceMetric
		#GtLlmCustomSerializationValueHolder
		#GtLlmDistanceMetric
		#GtLlmEmbedding
		#GtLlmEmbeddingsUtilities
		#GtLlmErrorThreadMessage
		#GtLlmFailureThreadMessage
		#GtLlmFileSearchTool
		#GtLlmFunctionTool
		#GtLlmFunctionToolCall
		#GtLlmInspectorMethodSummary
		#GtLlmInspectorMethodSummaryGroup
		#GtLlmInspectorSlotSummary
		#GtLlmInspectorSlotSummaryGroup
		#GtLlmInspectorSummary
		#GtLlmInspectorViewSummaryGroup
		#GtLlmMessageContentsUpdated
		#GtLlmMessagesGroup
		#GtLlmModelFile
		#GtLlmNewActionThreadMessage
		#GtLlmNewThreadMessage
		#GtLlmNewThreadMessageContentsChanged
		#GtLlmNullConnection
		#GtLlmNullProvider
		#GtLlmProvisionalThreadMessage
		#GtLlmSerializableValueHolder
		#GtLlmStaticProvider
		#GtLlmSystemMessage
		#GtLlmThreadMessageRestyleRequested
		#GtLlmThreadMessageViewModelChanged
		#GtLlmThreadRunAnnouncement
		#GtLlmThreadRunIsDoneAnnouncement
		#GtLlmThreadRunStartedAnnouncement
		#GtLlmTool
		#GtLlmToolsGroup
		#GtLlmUserMessage
		#GtLlmValueSerializer
		#GtMcpClient
		#GtMcpPrompt
		#GtMcpPromptsGroup
		#GtMcpResource
		#GtMcpResourcesGroup
		#GtMcpStaticTransport
		#GtMethodCoderTool
		#GtMethodsSortFunction
		#GtMultiSplitterDiffElement
		#GtOpenAIClient
		#GtOpenAIMessage
		#GtOpenAIMessageForGT
		#GtOpenAIObjectMessage
		#GtOpenAIProvider
		#GtOpenAIThreadRunUpdatedAnnouncement
		#GtPackageCoderTool
		#GtPharoCoderUIUtility
		#GtPharoCreationForm
		#GtPharoDummiesGenerator
		#GtPharoDummyEnvironment
		#GtPharoDynamicHighlightAttribute
		#GtPharoDynamicHighlightStyler
		#GtPharoMethodCoder
		#GtPharoParser
		#GtPharoSnippetCoder
		#GtPhlowActionUniqueTarget
		#GtPhlowActionsCollector
		#GtPhlowBrowseDefinitionAptitude
		#GtPhlowBuildContext
		#GtPhlowChangeAction
		#GtPhlowChangeActionAffectedMethodContext
		#GtPhlowChangeActionContext
		#GtPhlowChangeCompositeUpdateAction
		#GtPhlowChangeMethodSystemAnnouncerListener
		#GtPhlowChangeTabGroupActionExecutor
		#GtPhlowChangeTabGroupAddTabAction
		#GtPhlowChangeTabGroupModifyTabAction
		#GtPhlowChangeTabGroupRemoveTabAction
		#GtPhlowCollector
		#GtPhlowCompositeTool
		#GtPhlowCompositeView
		#GtPhlowConcreteDefiningMethodProvider
		#GtPhlowContext
		#GtPhlowDefiningMethodsCollector
		#GtPhlowEmptyView
		#GtPhlowForwardViewDefiningMethodProvider
		#GtPhlowLabelTooltipAptitude2
		#GtPhlowListToSelectHandler
		#GtPhlowObjectToSpawn
		#GtPhlowOverviewItem
		#GtPhlowTool
		#GtPhlowToolClassType
		#GtPhlowUtility
		#GtPhlowView
		#GtPhlowViewsCollector
		#GtPlaygroundEvaluatedCodeButtonAttribute
		#GtPlotterDataGroup
		#GtPlotterLineChart
		#GtPlotterLinearScale
		#GtPragmaType
		#GtPrefixTree
		#GtPretrainedEncoder
		#GtProcessStackOverflowChecker
		#GtPushUpMethodRefactoring
		#GtRBAddClassWithVarsRefactoring
		#GtRBAddMethodRefactoring
		#GtRBCompositeTransformation
		#GtRBNamespace
		#GtRBPullUpInstanceVariableRefactoring
		#GtRecursionSummaryFilter
		#GtRefactoringsPreviewElement
		#GtRemoteRunner
		#GtRenameActionAnnouncement
		#GtRenameController
		#GtRenameLiteralItemController
		#GtRenameSelectorEditorAttribute
		#GtResizablePreviewAttribute
		#GtRrChangesSync
		#GtRrExplicitExampleTask
		#GtRrImageSyncEvents
		#GtRrJobCompletedAnnouncement
		#GtRrLocalManagerStartupAndShutdown
		#GtSearchFixedMethodsFilter
		#GtSelectorInputFilter
		#GtSelectorStyler
		#GtSharedStringUpdated
		#GtSharedVariablesBindings
		#GtShellScriptProcess
		#GtSmaCCDiffSplitter
		#GtSmaCCGrammar
		#GtSmaCCPharoStyler
		#GtSourceCoderEditorId
		#GtSourceCoderEditorInnerId
		#GtSourceCoderEmbeddedExpanderToggleId
		#GtSourceCoderErrorAttribute
		#GtSourceCoderId
		#GtSourceCoderInlineRenameShortcut
		#GtSpotterContext
		#GtSpotterSubstringsFilter
		#GtStreamedCompletionStrategy
		#GtStringsCompletionStrategy
		#GtSystemUtility
		#GtTCurrency
		#GtTCurrencyMoney
		#GtTMoneyExamples
		#GtTemporaryDirectory
		#GtUrlStringUtility
		#GtVmRuntimeStatisticsDiffReport
		#GtWardleyMapAddEdgeChange
		#GtWardleyMapAddInnerNodeChange
		#GtWardleyMapAddNodeChange
		#GtWardleyMapAddNoteChange
		#GtWardleyMapAddOptionChange
		#GtWardleyMapAddProposition
		#GtWardleyMapCompositeChange
		#GtWardleyMapDecoratorViewModel
		#GtWardleyMapDecoratorViewModelRemoved
		#GtWardleyMapModel
		#GtWardleyMapRemoveEdgeChange
		#GtWardleyMapRemoveInnerNodeChange
		#GtWardleyMapRemoveNodeChange
		#GtWardleyMapRemoveNoteChange
		#GtWardleyMapRemoveProposition
		#GtWardleyMapRenameOriginalNameId
		#GtWardleyMapRenameProposalId
		#GtWardleyMapUpdateEdgeChange
		#GtWardleyMapUpdateMapChange
		#GtWardleyMapUpdateNodeChange
		#GtWardleyMapUpdateNoteChange
		#GtWardleyMapUtility
		#GtWorld
		#GtWorldElement
		#HSVAColorSelectorMorph
		#IceRepository
		#JSONParser
		#LayoutFrame
		#LeAddSnippetChange
		#LeCompletionStrategy
		#LeContentExamples
		#LeDatabase
		#LeDatabasesRegistry
		#LeExampleSnippet
		#LeExplicitlyAttachedLinksExamples
		#LeExternalUrlLinkNode
		#LeFileReference
		#LeFileSelectStencil
		#LeIcons
		#LeJsonV4
		#LeLogicalDatabase
		#LeObjectReferenceAnnotationAdapter
		#LePage
		#LePagePhlowTool
		#LePageToolContentTreeElement
		#LeParser
		#LePasteSnippetCommandItem
		#LePharoRewriteSnippet
		#LePharoSnippet
		#LePictureSnippet
		#LePythonSnippet
		#LeShellScriptSnippet
		#LeSnippetChange
		#LeSnippetStylerVisitor
		#LeTextCoderSnippetViewModel
		#LeTextSnippet
		#LeTextSnippetAttributeLabelElementId
		#LeTextualSnippet
		#LeUID
		#LepiterConstants
		#LinkedList
		#Margin
		#MessageTally
		#MetaLink
		#MethodAdded
		#MethodRemoved
		#Mutex
		#NetNameResolver
		#NonInteractiveTranscript
		#NumberParser
		#OCParseTreeRewriter
		#OSPlatform
		#OmReference
		#OpalCompiler
		#PBApplication
		#PBProxyObject
		#PNGReadWriter
		#PackageOrganizer
		#PharoLinkTestCaseError
		#PharoLinkTestCaseFailure
		#PharoLinkTestCasePass
		#PharoLinkTestCaseSkip
		#PharoLinkTestCaseWarning
		#ProcessMonitorTestService
		#ProtoObject
		#RBCondition
		#RBMethodRefactoring
		#RBNamespace
		#RBParser
		#RBPushDownMethodRefactoring
		#RBRemoveMethodRefactoring
		#RBRenameMethodRefactoring
		#RBScanner
		#RecursionStopper
		#SDL_Rect
		#SHA256
		#SessionManager
		#ShiftClassBuilder
		#SkiaImage
		#SmaCCDefinitionParser
		#SmaCCLineNumberStream
		#SmaCCParseNode
		#SmallDictionary
		#Socket
		#SourceFileArray
		#SourceFileBufferedReadWriteStream
		#SpLayoutFrame
		#SpStringTableColumn
		#StInspectorAssociationNode
		#StObjectPrinter
		#Stack
		#Stdio
		#StringSignal
		#SystemAnnouncer
		#SystemNavigation
		#TaskAtQueue
		#ThemeIcons
		#TraitChange
		#TraitedClass
		#UIManager
		#UUID
		#WeakIdentityKeyDictionary
		#WebBrowser
		#XMLHTMLParser
		#ZnBasicAuthenticator
		#ZnByteArrayEntity
		#ZnClient
		#ZnDispatcherDelegate
		#ZnEasy
		#ZnEntity
		#ZnHeaders
		#ZnHttpUnsuccessful
		#ZnIgnoreNewLineWriterStream
		#ZnMimePart
		#ZnMimeType
		#ZnMultiPartFormDataEntity
		#ZnMultiThreadedServer
		#ZnRequest
		#ZnRequestLine
		#ZnResponse
		#ZnServer
		#ZnStatusLine
		#ZnStringEntity
	)
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> stubClasses [
	| names |
	names := OrderedCollection new.
	(Pragma allNamed: #stubClassNames in: self class)
		do: [ :pragma |
			(self perform: pragma methodSelector)
				do: [ :name | names addIfNotPresent: name ] ].
	^ names asArray
		collect: [ :each | Smalltalk globals at: each ifAbsent: [ nil ] ]
		thenReject: [ :each | each isNil ]
]

{ #category : #private }
GtGemStoneGtCodeExporter >> znUrlExcludedMethods [
	<excludedMethods>
	"Keep the URL model and its focused tests; omit integrations and the options-dependent source."
	^ ((ZnUrl methods , ZnUrl class methods) select: [ :method |
		method protocol name first = $*
			or: [ #(performOperation: performOperation:with: asFileReference image) includes: method selector ] ]),
		{ ZnResourceMetaUtils class >> #queryKeyValueSafeSet.
		ZnUrlTest >> #testImage.
		ZnUrlTest >> #testRetrieveContents.
		ZnUrlTest >> #testSaveContentsToFile.
		ZnUrlTest >> #testPrintingConsidersDefaultCharacterConverter }
]

{ #category : #exporting }
GtGemStoneGtCodeExporter >> znUrlPortExporter [
	"Answer a focused exporter using the same definitions, exclusions and automatic method selection as the complete export."
	| configured classes |
	configured := self configuredExporter.
	classes := #(ZnUrl ZnResourceMetaUtils ZnPercentEncoder ZnMultiValueDictionary ZnDefaultCharacterEncoder ZnMaximumNumberOfDictionaryEntries ZnPortNotANumber ZnUnknownScheme ZnTooManyDictionaryEntries ArithmeticError DomainError ZnUrlTest) collect: [ :name | name asClass ].
	^ (GtGemStoneTopazExporter packages: #() additionalClasses: classes excluding: #())
		excludedMethods: configured excludedMethods;
		alternateClassDefinitions: self alternateClassDefinitions;
		newMethodClassNames: (classes collect: #name);
		yourself
]

{ #category : #exporting }
GtGemStoneGtCodeExporter >> znUrlPortExtensionSelectors [
	"Only the GT-managed adapters needed by the focused URL port."
	^ #(ext_ZnPercentEncoder_decode_to_ ext_ZnUrl_parseHostPort_ ext_ZnResourceMetaUtils_class_writeQueryFields_on_ ext_ZnDefaultCharacterEncoder_default ext_ZnDefaultCharacterEncoder_class_defaultValue ext_ZnMaximumNumberOfDictionaryEntries_class_defaultValue ext_ZnResourceMetaUtils_class_queryKeyValueSafeSet ext_String_asZnUrl ext_Collection_addedToZnUrl_ ext_ZnPercentEncoder_decode_ ext_ZnUrl_asString ext_String_addedToZnUrl_ ext_ZnUrlTest_testReferenceResolution ext_ZnPercentEncoder_readHexFrom_ ext_ZnUrl_portIfAbsent_ ext_String_asUrl ext_DomainError_class_signalFrom_to_ ext_ZnPercentEncoder_encode_to_)
]
