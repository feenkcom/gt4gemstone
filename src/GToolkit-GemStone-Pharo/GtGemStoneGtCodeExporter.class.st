Class {
	#name : #GtGemStoneGtCodeExporter,
	#superclass : #Object,
	#instVars : [
		'exporter'
	],
	#category : #'GToolkit-GemStone-Pharo-Export'
}

{ #category : #private }
GtGemStoneGtCodeExporter >> additionalClassList [
	^ { NotFound. KeyNotFound. NeoJSONParseError. AssertionFailure. BlDevScripterAssertionFailure. AsyncFutureExecutionError. GtExampleComparisonExceptionWithDebuggingViews. TestSkipped. GtLlmError. GtAnthropicError. NetworkError. SmaCCParserError. RBRefactoringError. AutomaticRewriting. ConnectionClosed. Deprecation. DeprecationPerformedNotification. SystemNotification. GtGemStoneExtensionMethod. GtGemStoneExtensionMethods. ExecutionEnvironment. DefaultExecutionEnvironment. TestExecutionEnvironment. TestExecutionService. TestTookTooMuchTime. }
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
		excluding: self excludedClassList.
	configuredExporter
		excludedMethods: self excludedMethods;
		includeGsCodeMethods: true;
		gsCodeClasses: self gsCodeClasses.
	^ configuredExporter
]

{ #category : #private }
GtGemStoneGtCodeExporter >> excludedClassList [
	^ { GtGemStoneTopazExporterExamples. }
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> excludedMethods [

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

	outputFile := 'GT.gs' asFileReference.
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
	excludedClasses := self excludedClassList asSet.
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
GtGemStoneGtCodeExporter >> stubClasses [
	| exportedClasses |
	exportedClasses := { GtExampleWithResult. GtExampleResult. ConnectionClosed }.
	^ (self stubClasses1, self stubClasses2, self stubClasses3, self stubClasses4)
		reject: [ :each | exportedClasses includes: each ]
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> stubClasses1 [

	^ { BlElement. BlElementUniqueId. GtBasicGroup. LeTextualSnippet. LeCompletionStrategy. GtPhlowActionUniqueTarget. BlDevScripterToolActionStep. GtPhlowChangeActionContext. BlTextStyler. BlTextStylerTelemetry. BlStencil. GtLlmAssistant. GtLlmConnectionRegistry. BlElementUniqueState. BrMenuItemGroupConfiguration. ZnClient. ZnResponse. AsyncMutex. ZnStringEntity. ZnIgnoreNewLineWriterStream. GtPhlowCollector. BrFrame. BrVerticalPane. BrHorizontalPane. BrExpander. BrGlamorousExpanderSubtleAptitude. BlGlamorousExpanderShadowAptitude. GtPhlowChangeAction. GtStreamedCompletionStrategy. GtPhlowTool. GtPhlowToolClassType. BrStencilBuilder. GtGenericPharoStyler. PBProxyObject. GtSourceCoderInlineRenameShortcut. GtHomeMultiCardSection. GtCoderViewModelRenameAction. GtRenameLiteralItemController. GtPharoCreationForm. BrTextAdornmentAttribute. RBMethodRefactoring. BrHorizontalFlow. BrEditableLabel. GtLlmFunctionToolCall. GtCoderElement. LeIcons. LeDatabasesRegistry. LePage. LeTextSnippet. LePasteSnippetCommandItem. BrGlamorousVectorIcons. GtClipboard. GtDiffBuilder. GtMultiSplitterDiffElement. GtCharacterGroupDiffSplitter. GtMcpClient. GtMcpStaticTransport. GtRBNamespace. BrGlamorousCodeEditorAptitude. BrRBTextStyler. GtCodeDiffRBTextStyler. JSONParser. GtPhlowEmptyView. NeoJSONSchema. LeFileReference. GtLlmCosineDistanceMetric. BlInsets. Color. BrShadowAptitude. BrLabel. BrGlamorousLabelAptitude. GtExplainerExplanationAptitude. BrLazyStyleCommonAptitude. BrGlamorousColors. BlRoundedRectangleGeometry. GtLlmAssistantFormatDescription. GtLlmAssistantAction. GtLlmAssistantActionExample. GtExampleWithResult. BrLayoutResizerAptitude. GtPharoMethodCoder. GtTCurrencyMoney. GtTCurrency. LePharoRewriteSnippet. GtClassCoderTool. GtLlmFileSearchTool. GtLlmFunctionTool. GtExampleResult. TraitChange. TraitedClass. GtSmaCCGrammar. GtCompositeSmaCCASTStyler. GtPharoParser. GtSmaCCPharoStyler. GtPharoDynamicHighlightStyler. NeoJSONReader. ZnMultiThreadedServer. ZnDispatcherDelegate. ZnMimeType. NeoJSONWriter. AsyncPassExceptionHandler. ZnStatusLine. ZnHeaders. ZnByteArrayEntity. GtPhlowActionsCollector. GtPhlowViewsCollector. BlCompositeStyler. LePharoSnippet. GtPhlowConcreteDefiningMethodProvider. GtPhlowDefiningMethodsCollector. GtPhlowContext. GtSystemUtility. ZnRequest. GtMcpPrompt. GtLlmUserMessage. GtLlmSystemMessage. GtMcpResource. PNGReadWriter. BlScripter. BlExporter. AsyncSequenceStream. BrSequenceableCollectionItemsProvider. BrLayoutHorizontalResizerState. BrLayoutVerticalResizerState. GtWardleyMapDecoratorViewModelRemoved. BlTaskAction. BlLinearLayout. GtCoderExpanderAptitude. Stack. GtLlmActionCall. GtLlmActionMessage. BlVisibility. LeDatabase. LeJsonV4. UUID. BrWidgetModel. BrElementUpdater. GtPhlowObjectToSpawn. BrGlamorousWithExplicitDropdownAptitude. BrButton. BrGlamorousButtonWithIconAptitude. BrGlamorousButtonExteriorAptitude. BrGlamorousButtonWithLabelTooltipAptitude2. BrGlamorousButtonWithLabelAptitude. BrSimpleList. BrSelectionChanged. GtLlmNewThreadMessageContentsChanged. BrGlamorousPopoverResizableAptitude. BrDropdownHideWish. RBParser. GtLlmMessagesGroup. GtLlmAssistantMessage. GtSearchFixedMethodsFilter. GtWardleyMapUtility. GtWardleyMapDecoratorViewModel. GtPhlowUtility. GtPhlowChangeCompositeUpdateAction. GtPhlowChangeTabGroupAddTabAction. GtPhlowChangeTabGroupRemoveTabAction. GtPhlowChangeTabGroupModifyTabAction. GtPhlowChangeActionAffectedMethodContext. GtHomeCard. GtPhlowBrowseDefinitionAptitude. BrEditor. BrGlamorousRegularEditorAptitude. GtLlmApiKeyCardElement. GtAnthropicClient. GtGeminiClient. GtOpenAIClient. GtWorld. GtInspectorElementOverviewProperty. BrToolbar. BrGlamorousToolbarAptitude. BrSizeAdjustmentState. GtPhlowCompositeView. GtPhlowCompositeTool. BrTab. BrGlamorousTabAptitude. BrTabGroup. BrGlamorousTabGroupAptitude. GtPhlowBuildContext. GtPhlowChangeMethodSystemAnnouncerListener. LeParser. BlFontWeightAttribute. LeTextSnippetAttributeLabelElementId. GtButtonAttribute. GtPlaygroundEvaluatedCodeButtonAttribute. LeSnippetStylerVisitor. BlClickEvent. BlMouseEnterEvent. BlCopyCursor. GtCachedTextExpandButtonAttribute. GtResizablePreviewAttribute. LepiterConstants. GtMethodCoderTool. GtUrlStringUtility. BrTextInvisibleMarkerAttribute. BrTextCursorDynamicAttribute. BrTextHideAttribute. GtPharoSnippetCoder. LeExternalUrlLinkNode. LeFileSelectStencil. BrAsyncFileWidget. BrGlamorousWithVerticalResizerAptitude. BlResizerResizedEvent. BrResizerElementLength. BrGlamorousButtonLabelAndIconAptitude. WebBrowser. GtSharedVariablesBindings. GtSharedStringUpdated. BlTextForegroundAttribute. BlTextUnderlayAttribute. GtLlmThreadRunStartedAnnouncement. GtOpenAIThreadRunUpdatedAnnouncement. GtLlmThreadRunIsDoneAnnouncement. AsyncFutureExecutionConfiguration. BrColumnedList. GtLlmErrorThreadMessage. GtLlmFailureThreadMessage. SpStringTableColumn. StObjectPrinter. GtMagritteDescriptionElementStencilBuilder. GtMagritteBuilderUtility. GtMagritteFormStencilBuilder. GtMagritteDescriptionFromModelUpdateSpecification. GtMagritteDescriptionValueFromModelUpdateSpecification. BrFileSelector. FileSystemDirectoryEntry. BrTextEditorModifiedEvent. BlKeyCombination. GtCompletionController. BrDeletableFileWidget. BrGlamorousFocusableShadowAptitude. GtCoderShortcutIds. DiffPatchVisitor. DiffVisitor. GtPushUpMethodRefactoring. ZnRequestLine. SmallDictionary. GtRBCompositeTransformation. GtRBAddClassWithVarsRefactoring. GtSpotterSubstringsFilter. GtSpotterContext. GtLlmNullProvider. GtLlmSerializableValueHolder. GtLlmValueSerializer. SmaCCDefinitionParser. GtPackageCoderTool. GtInspectorTool. GtInspector. GtInspectorObject. GtPragmaType. LePagePhlowTool. LeObjectReferenceAnnotationAdapter. GtLlmInspectorSummary. GtLlmInspectorSlotSummaryGroup. GtLlmInspectorSlotSummary. GtLlmInspectorViewSummaryGroup. GtLlmInspectorMethodSummaryGroup. GtLlmInspectorMethodSummary. GtDebuggerDiffObjectStateComparisonStencil . BlAttributedTextElement . AsyncFutureExecutionContext. AsyncFutureDummyWaker . AsyncProcessStackOverflowCheckerFuture . AsyncPoll. TaskAtQueue . AsyncOnceStream . AsyncFuturePromise. AsyncFutureThreadPool . AsyncDelayedFuture . AsyncFlattenFuture . AsyncMapFuture . AsyncErrorHandlingFuture. BlElementAddedToSceneGraphEvent. GtMATextDescription. SystemAnnouncer. GtCompositeCompletionAction. GtDeleteTextCompletionAction. GtInsertTextCompletionAction. GtRenameActionAnnouncement. GtCoderRenameMethodRefactoring. RBRenameMethodRefactoring. SystemNavigation. BlKeyModifiers. GtPhlowOverviewItem. GtAnthropicListModelsAPIClient. BrGlamorousTabSwitcherWithIconAptitude. GtDiffElementWithLabelStencil. GtSmaCCDiffSplitter. GtLlmModelFile. GtWardleyMapAddProposition. GtWardleyMapRemoveProposition. BrColumnedMultiListAptitude. BrGlamorousColumnedListItemElementWithContextMenuDecorator. BrGlamorousColumnedListSelectableRowElementStencilBuilder. GtPhlowListToSelectHandler. BrGlamorousWithHorizontalResizerAptitude. BrGlamorousButtonWithIconAndLabelAptitude. GtMagritteActionUtility. GtEpiceaEventFactory. EpClassAddition. EpMethodAddition. EpClassRemoval. EpMethodRemoval. AkgLlmKnowlingRag. GtLlmChat. LeUID. GtWardleyMapAddOptionChange. GtWardleyMapCompositeChange. GtLlmStaticProvider. GtLlmNullConnection. GtLlmConnection. LeLogicalDatabase. LeExplicitlyAttachedLinksExamples. GtTMoneyExamples. GtSourceCoderErrorAttribute. GtInspectorSampleWithExceptionsInExtensions. LeContentExamples. }
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> stubClasses2 [

	^ { OSPlatform . PackageOrganizer . GtPharoDummyEnvironment . BlFrameLayout . BrGlamorousShrinkingLabelAptitude . BrScrollPane . BrScrollPaneAptitude . BrToggleGroup . BrGlamorousToggleGroupAptitude . BrToggle . BrGlamorousToggleWithLabelAptitude . BrToggleActivatedEvent . SkiaImage . GtJsonShapeComparison . GtRenameSelectorEditorAttribute . GtSelectorStyler . GtSelectorInputFilter . BlFontFamilyAttribute . GtCompletionStrategyAttribute . LePageToolContentTreeElement . GtSourceCoderEmbeddedExpanderToggleId . GtPharoDynamicHighlightAttribute . OpalCompiler . XMLHTMLParser . ShiftClassBuilder . GtShellScriptProcess . GtProcessStackOverflowChecker . Float32Array . GtLlmEmbedding . GtLlmEmbeddingsUtilities. RBScanner. SmaCCLineNumberStream. RBPushDownMethodRefactoring. RBRemoveMethodRefactoring. GtWardleyMapModel. GtLlmProvisionalThreadMessage. GtLlmNewThreadMessage. GtLlmNewActionThreadMessage. GtPharoDummiesGenerator. BrTextEditorModel. PBApplication. GtPhlowForwardViewDefiningMethodProvider. GtRrImageSyncEvents. GtRrChangesSync. GtRemoteRunner. GtRrLocalManagerStartupAndShutdown. GtRrExplicitExampleTask. GtRrJobCompletedAnnouncement. OmReference. GtOpenAIObjectMessage. BlMouseOverEvent. BlMouseOutEvent. BrGlamorousListItemAptitude. GtWardleyMapRenameOriginalNameId. GtWardleyMapRenameProposalId. GtABCartoonAddressBookExample. ZnMultiValueDictionary. ZnMultiPartFormDataEntity. ZnMimePart. GtAnthropicModelsGroup. NumberParser. GZipReadStream. LeSnippetChange. LePythonSnippet. LeShellScriptSnippet. LeExampleSnippet. GtCoder. GtSourceCoderId. GtSourceCoderEditorId. BrAnchoredVisualAnalysis. GtRefactoringsPreviewElement. GtSourceCoderEditorInnerId. GtTemporaryDirectory. GtMagritteCompletionStrategyStencilBuilder. GtMagritteMemento. GtMagritteElementBuilder. GtMagritteStringEditorElementStencilBuilder. GtMagrittePasswordEditorElementStencilBuilder. GtOpenAIProvider. GtPlotterDataGroup. GtPlotterLineChart. GtPlotterLinearScale. BrGlamorousButtonRectangularAptitude. BrGlamorousButtonIconDropdownAptitude. BrMenuItems. BrMenuActionItem. RBCondition. RBParseTreeRewriter. PharoLinkTestCaseSkip. LeTextCoderSnippetViewModel. LeAddSnippetChange. GtWorldElement. GtOpenAIMessageForGT. GtLlmCustomSerializationValueHolder. GtRBPullUpInstanceVariableRefactoring. SessionManager. GtLlmToolsGroup. GtMcpResourcesGroup. GtMcpPromptsGroup. GtPhlowChangeTabGroupActionExecutor. BlBorder. BrDebuggableEditorElementStencil. GtLlmAssistantChatReadyStatus. Point. BrStreamItemsProvider. AsyncObservableValue. AsyncOptionalValue. AsyncCachedStream. AsyncChunksStream. AsyncDebounceStream. AsyncEphemerousStream. AsyncErrorHandlingStream. AsyncFilterStream. AsyncMapStream. AsyncMapWithCacheStream. AsyncMapWithIndexStream. AsyncMapFutureStream. AsyncStreamForEachFuture. AsyncStreamCollectFuture. AsyncStreamFoldFuture. AsyncLineReadStream. AsyncStreamForwardFuture. AsyncFuseStream. AsyncStreamHasNextFuture. AsyncStreamNextFuture. AsyncStreamSizeHint. AsyncSplitStream. AsyncTakeStream. AsyncTerminatableStream. AsyncThrottleStream. AsyncWithoutDuplicatesStream. AsyncFlattenStream. AsyncWithTimeoutStream. AsyncWeakStream. AsyncLePageStream. AsyncFutureExecutionAtomicWaker. GtABAddressBook. GtBPEEncoder. GtPretrainedEncoder. AsyncSharedDictionary. GtRBAddMethodRefactoring. GtWardleyMapUpdateMapChange. GtWardleyMapAddInnerNodeChange. GtWardleyMapRemoveEdgeChange. GtWardleyMapRemoveNodeChange. GtWardleyMapUpdateEdgeChange. GtWardleyMapRemoveNoteChange. GtWardleyMapAddNodeChange. GtWardleyMapUpdateNodeChange. GtWardleyMapAddEdgeChange. GtWardleyMapAddNoteChange. GtWardleyMapUpdateNoteChange. GtWardleyMapRemoveInnerNodeChange. . GtMagritteActionElement . GtMagritteFieldViewModel . GtMagritteBasicAction . Socket . BrListRowStencilBuilder . GtMagritteModelStencilBuilder . GtMagritteListElementStencilBuilder . BlDoubleClickEvent . AsyncCounterSink . AsyncPeekSink . BlTextAttributesBuilder . BrGlamorousEditableLabelAptitude . GtFixItMarkerAttribute . BlMouseLeaveEvent. }
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> stubClasses3 [
	^ { WeakIdentityKeyDictionary. NeoJSONArray. NeoJSONObject. ConnectionClosed. BeaconSignal. BrWish. ContextStackSignal. GtLlmThreadMessageRestyleRequested. GtLlmThreadMessageViewModelChanged. GtLlmMessageContentsUpdated. OrderedDictionary. GtRenameController. BrGlamorousWithExplicitTooltipAptitude. GtPhlowView. BrEditorShortcut. ZnEntity. BlElementState. RBParseTreeRewriter. OCParseTreeRewriter. GtGemStoneLlmToolForClassSearch. GtGemStoneLlmToolForClassLookup. GtGemStoneLlmToolForClassSubclasses. GtGemStoneLlmToolForClassReferences. GtGemStoneLlmToolForMethodImplementors. GtGemStoneLlmToolForMethodSenders. GtGemStoneLlmToolForMethodsSource. GtGemStoneLlmToolForMethodCompilation. GtGemStoneLlmToolForMethodRemoval. GtGemStoneLlmToolForClassDefinitionChange. GtGemStoneLlmToolForSmalltalkCodeEvaluation. GtGemStoneSessionRegistry. Clipboard. BrStyleCommonAptitude. ProtoObject. BlSpace. GtLlmDistanceMetric. SmaCCParseNode. GtLlmThreadRunAnnouncement. BrEditorElement. BrGlamorousButtonLabelAptitude. GtLlmTool. RBNamespace. LinkedList. GtLlmChatMessage. GtLlmAbstractFunctionTool. BrTextAdornmentDynamicAttribute. GtOpenAIMessage. }
]

{ #category : #accessing }
GtGemStoneGtCodeExporter >> stubClasses4 [
	^ {
		PharoLinkTestCasePass. GtInspectorPlusIconStencil. FLSerializer.
		BrGlamorousResizerBottomBarAptitude. IceRepository. BlEllipseGeometry.
		SourceFileBufferedReadWriteStream. CompiledMethod. NetNameResolver.
		BrGlamorousPopoverPinnableAptitude. GtConnectorExampleStyler.
		PharoLinkTestCaseFailure. GtExampleResultSimplifiedFailureValue.
		BlParabollaArcElement. Stdio. CurrentExecutionEnvironment.
		GtPharoCoderUIUtility. Author. ThemeIcons. GtVmRuntimeStatisticsDiffReport.
		Form. PharoLinkTestCaseWarning. GtExampleResultSimplifiedSuccessValue.
		File. BrGlamorousListLabelAptitude. GtExampleLabelTextHandler.
		NonInteractiveTranscript. GtRecursionSummaryFilter. BinaryFileStream.
		MetaLink. CommandLineHandler. MethodAdded. GtPhlowLabelTooltipAptitude2.
		GtConnector. GtInspectorRoundButtonStencil. GtExampleGroupCoder.
		PharoLinkTestCaseError. GtExampleResultSimplifiedErrorValue.
		BlArrowheadSimpleArrow. BrGlamorousResizerRightBarAptitude. ZnUrl.
		BlResizerRightListener. RecursionStopper.
		ZnBasicAuthenticator. StringSignal. MessageTally. ZnServer.
		GtExampleResultSimplifiedNestedErrorValue. BlResizerBottomListener.
		Mutex. GtExampleColorHandler. GtMethodsSortFunction. MethodRemoved.
		SourceFileArray. Base64MimeConverter. TraitedClass.
		SHA256. }
]
