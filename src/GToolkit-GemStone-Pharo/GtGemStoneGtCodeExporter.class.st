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
		#AssertionFailure
		#AsyncFutureExecutionError
		#AutomaticRewriting
		#BlDevScripterAssertionFailure
		#ConnectionClosed
		#DefaultExecutionEnvironment
		#Deprecation
		#DeprecationPerformedNotification
		#ExecutionEnvironment
		#GtAnthropicError
		#GtExampleComparisonExceptionWithDebuggingViews
		#GtGemStoneExtensionMethods
		#GtLlmError
		#KeyNotFound
		#NeoJSONParseError
		#NetworkError
		#NotFound
		#RBRefactoringError
		#SmaCCParserError
		#SystemNotification
		#TestExecutionEnvironment
		#TestExecutionService
		#TestSkipped
		#TestTookTooMuchTime
	)
]

{ #category : #private }
GtGemStoneGtCodeExporter >> additionalClasses [
	| additionalClasses |
	
	additionalClasses := OrderedCollection new.
	additionalClasses
		addAll: (GtLlmAbstractFunctionTool withAllSuperclasses first: 3);
		addAll: self additionalClassList.
	^ additionalClasses
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
		excludedMethods: self excludedMethods;
		includeGsCodeMethods: true;
		gsCodeClasses: self gsCodeClasses.
	^ configuredExporter
]

{ #category : #private }
GtGemStoneGtCodeExporter >> excludedClassList [
	<excludedClasses>
	^ { GtGemStoneTopazExporterExamples. }
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
	GtLlmInspectorSummarizer>>#summarizeMethods:.
	GtLValueSerializerExamples>>#serializeProtoObjectClass.
	GtLPackageChangeHistory>>#gtViewChangeIcon.
	GtLPackageTagChangeHistory>>#gtViewChangeIcon.
	GtLlmReificationForm>>#assistantNameDescription.
	GtLlmReificationForm>>#assistantSuperclassDescription.
	GtLlmReificationForm>>#messageNameDescription.
	GtLlmReificationForm>>#messageSuperclassDescription.
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
	GtLlmToolForExampleClassesRun>>#extractExamplesFromClassesFrom:in:reportingNotFoundIn:.
	GtLlmToolForExampleClassesRun>>#extractExamplesFromMethodsFrom:in:reportingNotFoundIn:.
	GtLClassDefinitionChangeHistory>>#gtViewChangeIcon.
	GtLClassCommentChangeDescriptionElement>>#initialize.
	GtLMethodChangeDescriptionElement>>#initialize.
	GtLSmaCCParserTest>>#testParse.
	GtLlmRenameFormatComponentRefactoringExamples>>#destroyClass.
	MARelationDescription>>#descriptionClasses.
	GtLlmAssistantLibraryForGt class>>#textFormatWithSmalltalkBlocks.
	GtLMagritteToolForClassRemovalExamples>>#removeExistingClass.
	GtLClassDefinitionChangeDescriptionElement>>#updateForClassDefinitionChangeHistory:.
	GtLMagritteToolForClassRemovalExamples>>#removeClassNamedIfPresent:.
	GtLMagritteToolForMethodRemovalExamples>>#removeClassNamedIfPresent:.
	GtLPrimitiveDocumentDataBlockExamples>>#samplePdfBytes.
	GtLlmToolForSUnitClassesRun>>#privatePerformToolCall:.
	GtLClassDefinitionDescriptionExamples>>#fromClassWithTraits.
	GtLPdfFileExamples>>#samplePdfContent.
	GtLMagritteToolForClassCreationExamples>>#createClassWithComment.
	GtLMagritteToolForClassCreationExamples>>#createClassWithInstanceVariables.
	GtLMagritteToolForClassCreationExamples>>#removeClassNamedIfPresent:.
	GtLClassChangeHistory>>#gtViewChangeIcon.
	GtLCodeChangesToolCallsSummarizerExamples>>#messagesGroupWithExecutedClassCommentChange.
	GtLCodeChangesToolCallsSummarizerExamples>>#removeClassNamedIfPresent:.
	MAStringReader>>#visitBlockDescription:.
	GtLlmRenameFormatComponentRefactoring>>#renameComponentReferences.
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
GtGemStoneGtCodeExporter >> gsCodeClasses [
	^ { Metaclass3. GsNMethod. Pragma. GtGemStoneExtensionMethod. Exception. GtSystemUtility. GtExampleClassResolver. GtExampleMethodResolver. GtExampleDependenciesResolver. GtExample. GtExampleEvaluator. ExecutionEnvironment. CurrentExecutionEnvironment. }
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

{ #category : #accessing }
GtGemStoneGtCodeExporter >> packageNames [
	| packageNames |

	packageNames := PackageOrganizer default packageNames asOrderedCollection
		select: [ :name | name beginsWith: 'Gt4Llm' ].
	packageNames removeAll: { 'Gt4Llm' }.
	packageNames addAll: {
		'Grease-Core'.
		'Magritte-Model'.
		'GToolkit-Examples'.
		'GToolkit-Examples-Dummies-Package2'.
		'GToolkit-Examples-Dummies-Package4'.
		'GToolkit-Examples-Dummies-Package6'.
		'GToolkit-Examples-Dummies'.
		'GToolkit-Examples-Dummies-Package1'.
		'GToolkit-Examples-Dummies-Package3'.
		'GToolkit-Examples-Dummies-Package5'.
		'GToolkit-Examples-Dummies-Package7' }.
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
		#AutomaticRewriting
		#Base64MimeConverter
		#Base64UrlEncoder
		#BeaconSignal
		#BinaryFileStream
		#BlArrowheadSimpleArrow
		#BlAttributedTextElement
		#BlBorder
		#BlClickEvent
		#BlCompositeStyler
		#BlCopyCursor
		#BlDevScripterToolActionStep
		#BlDoubleClickEvent
		#BlElement
		#BlElementAddedToSceneGraphEvent
		#BlElementState
		#BlElementUniqueId
		#BlElementUniqueState
		#BlEllipseGeometry
		#BlExporter
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
		#BlResizerBottomListener
		#BlResizerResizedEvent
		#BlResizerRightListener
		#BlRoundedRectangleGeometry
		#BlScripter
		#BlSpace
		#BlStencil
		#BlTaskAction
		#BlTextAttributesBuilder
		#BlTextForegroundAttribute
		#BlTextStyler
		#BlTextStylerTelemetry
		#BlTextUnderlayAttribute
		#BlVisibility
		#BrAnchoredVisualAnalysis
		#BrAsyncFileWidget
		#BrButton
		#BrColumnedList
		#BrColumnedMultiListAptitude
		#BrDebuggableEditorElementStencil
		#BrDeletableFileWidget
		#BrDropdownHideWish
		#BrEditableLabel
		#BrEditor
		#BrEditorElement
		#BrEditorShortcut
		#BrElementUpdater
		#BrExpander
		#BrFileSelector
		#BrFrame
		#BrGlamorousButtonExteriorAptitude
		#BrGlamorousButtonIconDropdownAptitude
		#BrGlamorousButtonLabelAndIconAptitude
		#BrGlamorousButtonLabelAptitude
		#BrGlamorousButtonRectangularAptitude
		#BrGlamorousButtonWithIconAndLabelAptitude
		#BrGlamorousButtonWithIconAptitude
		#BrGlamorousButtonWithLabelAptitude
		#BrGlamorousButtonWithLabelTooltipAptitude2
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
		#BrGlamorousToggleGroupAptitude
		#BrGlamorousToggleWithLabelAptitude
		#BrGlamorousToolbarAptitude
		#BrGlamorousVectorIcons
		#BrGlamorousWithExplicitDropdownAptitude
		#BrGlamorousWithExplicitTooltipAptitude
		#BrGlamorousWithHorizontalResizerAptitude
		#BrGlamorousWithVerticalResizerAptitude
		#BrHorizontalFlow
		#BrHorizontalPane
		#BrLabel
		#BrLayoutHorizontalResizerState
		#BrLayoutResizerAptitude
		#BrLayoutVerticalResizerState
		#BrLazyStyleCommonAptitude
		#BrListRowStencilBuilder
		#BrMenuActionItem
		#BrMenuItemGroupConfiguration
		#BrMenuItems
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
		#BrTextAdornmentAttribute
		#BrTextAdornmentDynamicAttribute
		#BrTextCursorDynamicAttribute
		#BrTextEditorModel
		#BrTextEditorModifiedEvent
		#BrTextHideAttribute
		#BrTextInvisibleMarkerAttribute
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
		#GtClipboard
		#GtCodeDiffRBTextStyler
		#GtCoder
		#GtCoderElement
		#GtCoderExpanderAptitude
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
		#GtJsonShapeComparison
		#GtLlmAbstractFunctionTool
		#GtLlmActionCall
		#GtLlmActionMessage
		#GtLlmApiKeyCardElement
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
		#GtMATextDescription
		#GtMagritteActionElement
		#GtMagritteActionUtility
		#GtMagritteBasicAction
		#GtMagritteBuilderUtility
		#GtMagritteCompletionStrategyStencilBuilder
		#GtMagritteDescriptionElementStencilBuilder
		#GtMagritteDescriptionFromModelUpdateSpecification
		#GtMagritteDescriptionValueFromModelUpdateSpecification
		#GtMagritteElementBuilder
		#GtMagritteFieldViewModel
		#GtMagritteFormStencilBuilder
		#GtMagritteListElementStencilBuilder
		#GtMagritteMemento
		#GtMagritteModelStencilBuilder
		#GtMagrittePasswordEditorElementStencilBuilder
		#GtMagritteStringEditorElementStencilBuilder
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
		#IceRepository
		#JSONParser
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
		#MessageTally
		#MetaLink
		#MethodAdded
		#MethodRemoved
		#Mutex
		#NeoJSONArray
		#NeoJSONObject
		#NeoJSONReader
		#NeoJSONSchema
		#NeoJSONWriter
		#NetNameResolver
		#NonInteractiveTranscript
		#NumberParser
		#OCParseTreeRewriter
		#OSPlatform
		#OmReference
		#OpalCompiler
		#OrderedDictionary
		#PBApplication
		#PBProxyObject
		#PNGReadWriter
		#PackageOrganizer
		#PharoLinkTestCaseError
		#PharoLinkTestCaseFailure
		#PharoLinkTestCasePass
		#PharoLinkTestCaseSkip
		#PharoLinkTestCaseWarning
		#Point
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
		#SpStringTableColumn
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
		#UUID
		#WeakIdentityKeyDictionary
		#WebBrowser
		#XMLHTMLParser
		#ZnBasicAuthenticator
		#ZnByteArrayEntity
		#ZnClient
		#ZnDispatcherDelegate
		#ZnEntity
		#ZnHeaders
		#ZnHttpUnsuccessful
		#ZnIgnoreNewLineWriterStream
		#ZnMimePart
		#ZnMimeType
		#ZnMultiPartFormDataEntity
		#ZnMultiThreadedServer
		#ZnMultiValueDictionary
		#ZnPercentEncoder
		#ZnRequest
		#ZnRequestLine
		#ZnResponse
		#ZnServer
		#ZnStatusLine
		#ZnStringEntity
		#ZnUrl
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
