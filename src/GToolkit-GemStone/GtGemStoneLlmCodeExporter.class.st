Class {
	#name : #GtGemStoneLlmCodeExporter,
	#superclass : #Object,
	#instVars : [
		'exporter'
	],
	#category : #'GToolkit-GemStone-Export'
}

{ #category : #private }
GtGemStoneLlmCodeExporter >> additionalClassList [
	^ { NotFound. KeyNotFound. NeoJSONParseError. AssertionFailure. BlDevScripterAssertionFailure. AsyncFutureExecutionError. GtExampleComparisonExceptionWithDebuggingViews. TestSkipped. GtLlmError. GtAnthropicError. NetworkError. SmaCCParserError. RBRefactoringError. }
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> additionalClasses [
	| additionalClasses |
	
	additionalClasses := OrderedCollection new.
	additionalClasses
		addAll: (GtLlmAbstractFunctionTool withAllSuperclasses first: 3);
		addAll: self additionalClassList.
	^ additionalClasses
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> excludedMethods [

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
	GtLPackageChangeHistory >>#gtViewChangeIcon.
	GtLPackageTagChangeHistory>>#gtViewChangeIcon.
	GtLlmReificationForm>>#assistantNameDescription.
	GtLlmReificationForm>>#assistantSuperclassDescription.
	GtLlmReificationForm>>#messageNameDescription.
	GtLlmReificationForm>>#messageSuperclassDescription.
	GtLClassChangeDataExtractor>>#extractTargetClassIfError:.
	GtLSmaCCModel>>#grammarFor:.
	GtLMagritteToolForClassDefinitionChangeExamples>>#removeClassNamedIfPresent:.
	GtLSmaCCToolForParserCompilationExamples >> #compile.
	GtLSmaCCToolForParserCompilationExamples >> #cleanUp.
	GtLMagritteToolForClassesCreationExamples>>#createClassesWithInstanceVariables.
	GtLMagritteToolForClassesCreationExamples>>#createTraitsWithInstanceVariables.
	GtLMagritteToolForClassesCreationExamples>>#removeClassNamedIfPresent:.
	GtLMagritteToolForMethodsRemovalExamples>>#removeClassNamedIfPresent:.
	GtLMethodChangeHistory>>#gtViewChangeIcon.
	GtLDocumentDataViewExamples>>#samplePdfBytes.
	GtLResponseMarkdownFormat>>#initialize.
	GtLToolForExampleClassesRun >>#extractExamplesFromClassesFrom:in:reportingNotFoundIn:.
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
}
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> export [ 
	| outputFile |

	outputFile := 'GT.gs' asFileReference.
	outputFile ensureDelete.
	exporter := GtGemStoneTopazExporter
		packages: self packageNames
		additionalClasses: self additionalClasses
		stubClasses: self stubClasses
		excluding: { }.
	exporter 
		excludedMethods: self excludedMethods;
		stubClassesWithoutParents: self stubClassesWithoutParents.
	exporter writeTo: outputFile.
	exporter
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> exporter [
	^ exporter
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> packageNames [
	| packageNames |

	packageNames := PackageOrganizer default packageNames asOrderedCollection
	select: [ :name | name beginsWith: 'Gt4Llm' ].
	packageNames removeAll: { 'Gt4Llm'. }.
	packageNames addAll: { 'Grease-Core'. 'Magritte-Model'. }.
	^ packageNames.

]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> stubClasses [

	^ self stubClasses1, self stubClasses2
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> stubClasses1 [

	^ { BlElement. BlElementUniqueId. GtBasicGroup. LeTextualSnippet. LeCompletionStrategy. GtPhlowActionUniqueTarget. BlDevScripterToolActionStep. GtPhlowChangeActionContext. BlTextStyler. BlTextStylerTelemetry. BlStencil. GtLlmAssistant. GtLlmConnectionRegistry. BlElementUniqueState. BrMenuItemGroupConfiguration. ZnClient. ZnResponse. AsyncMutex. ZnStringEntity. ZnIgnoreNewLineWriterStream. GtPhlowCollector. BrFrame. BrVerticalPane. BrHorizontalPane. BrExpander. BrGlamorousExpanderSubtleAptitude. BlGlamorousExpanderShadowAptitude. GtPhlowChangeAction. GtStreamedCompletionStrategy. GtPhlowTool. GtPhlowToolClassType. BrStencilBuilder. GtGenericPharoStyler. PBProxyObject. GtSourceCoderInlineRenameShortcut. GtHomeMultiCardSection. GtCoderViewModelRenameAction. GtRenameLiteralItemController. GtPharoCreationForm. BrTextAdornmentAttribute. RBMethodRefactoring. BrHorizontalFlow. BrEditableLabel. GtLlmFunctionToolCall. GtCoderElement. LeIcons. LeDatabasesRegistry. LePage. LeTextSnippet. LePasteSnippetCommandItem. BrGlamorousVectorIcons. GtClipboard. GtDiffBuilder. GtMultiSplitterDiffElement. GtCharacterGroupDiffSplitter. GtMcpClient. GtMcpStaticTransport. GtRBNamespace. BrGlamorousCodeEditorAptitude. BrRBTextStyler. GtCodeDiffRBTextStyler. JSONParser. GtPhlowEmptyView. NeoJSONSchema. LeFileReference. GtLlmCosineDistanceMetric. BlInsets. Color. BrShadowAptitude. BrLabel. BrGlamorousLabelAptitude. GtExplainerExplanationAptitude. BrLazyStyleCommonAptitude. BrGlamorousColors. BlRoundedRectangleGeometry. GtLlmAssistantFormatDescription. GtLlmAssistantAction. GtLlmAssistantActionExample. GtExampleWithResult. BrLayoutResizerAptitude. GtPharoMethodCoder. GtTCurrencyMoney. GtTCurrency. LePharoRewriteSnippet. GtClassCoderTool. GtLlmFileSearchTool. GtLlmFunctionTool. GtExampleResult. TraitChange. TraitedClass. GtSmaCCGrammar. GtCompositeSmaCCASTStyler. GtPharoParser. GtSmaCCPharoStyler. GtPharoDynamicHighlightStyler. NeoJSONReader. ZnMultiThreadedServer. ZnDispatcherDelegate. ZnMimeType. NeoJSONWriter. AsyncPassExceptionHandler. ZnStatusLine. ZnHeaders. ZnByteArrayEntity. GtPhlowActionsCollector. GtPhlowViewsCollector. BlCompositeStyler. LePharoSnippet. GtPhlowConcreteDefiningMethodProvider. GtPhlowDefiningMethodsCollector. GtPhlowContext. GtSystemUtility. ZnRequest. GtMcpPrompt. GtLlmUserMessage. GtLlmSystemMessage. GtMcpResource. PNGReadWriter. BlScripter. BlExporter. AsyncSequenceStream. BrSequenceableCollectionItemsProvider. BrLayoutHorizontalResizerState. BrLayoutVerticalResizerState. GtWardleyMapDecoratorViewModelRemoved. BlTaskAction. BlLinearLayout. GtCoderExpanderAptitude. Stack. GtLlmActionCall. GtLlmActionMessage. BlVisibility. LeDatabase. LeJsonV4. UUID. BrWidgetModel. BrElementUpdater. GtPhlowObjectToSpawn. BrGlamorousWithExplicitDropdownAptitude. BrButton. BrGlamorousButtonWithIconAptitude. BrGlamorousButtonExteriorAptitude. BrGlamorousButtonWithLabelTooltipAptitude2. BrGlamorousButtonWithLabelAptitude. BrSimpleList. BrSelectionChanged. GtLlmNewThreadMessageContentsChanged. BrGlamorousPopoverResizableAptitude. BrDropdownHideWish. RBParser. GtLlmMessagesGroup. GtLlmAssistantMessage. GtSearchFixedMethodsFilter. GtWardleyMapUtility. GtWardleyMapDecoratorViewModel. GtPhlowUtility. GtPhlowChangeCompositeUpdateAction. GtPhlowChangeTabGroupAddTabAction. GtPhlowChangeTabGroupRemoveTabAction. GtPhlowChangeTabGroupModifyTabAction. GtPhlowChangeActionAffectedMethodContext. GtHomeCard. GtPhlowBrowseDefinitionAptitude. BrEditor. BrGlamorousRegularEditorAptitude. GtLlmApiKeyCardElement. GtAnthropicClient. GtGeminiClient. GtOpenAIClient. GtWorld. GtInspectorElementOverviewProperty. BrToolbar. BrGlamorousToolbarAptitude. BrSizeAdjustmentState. GtPhlowCompositeView. GtPhlowCompositeTool. BrTab. BrGlamorousTabAptitude. BrTabGroup. BrGlamorousTabGroupAptitude. GtPhlowBuildContext. GtPhlowChangeMethodSystemAnnouncerListener. LeParser. BlFontWeightAttribute. LeTextSnippetAttributeLabelElementId. GtButtonAttribute. GtPlaygroundEvaluatedCodeButtonAttribute. LeSnippetStylerVisitor. BlClickEvent. BlMouseEnterEvent. BlCopyCursor. GtCachedTextExpandButtonAttribute. GtResizablePreviewAttribute. LepiterConstants. GtMethodCoderTool. GtUrlStringUtility. BrTextInvisibleMarkerAttribute. BrTextCursorDynamicAttribute. BrTextHideAttribute. GtPharoSnippetCoder. LeExternalUrlLinkNode. LeFileSelectStencil. BrAsyncFileWidget. BrGlamorousWithVerticalResizerAptitude. BlResizerResizedEvent. BrResizerElementLength. BrGlamorousButtonLabelAndIconAptitude. WebBrowser. GtSharedVariablesBindings. GtSharedStringUpdated. BlTextForegroundAttribute. BlTextUnderlayAttribute. GtLlmThreadRunStartedAnnouncement. GtOpenAIThreadRunUpdatedAnnouncement. GtLlmThreadRunIsDoneAnnouncement. AsyncFutureExecutionConfiguration. BrColumnedList. GtLlmErrorThreadMessage. GtLlmFailureThreadMessage. SpStringTableColumn. StObjectPrinter. GtMagritteDescriptionElementStencilBuilder. GtMagritteBuilderUtility. GtMagritteFormStencilBuilder. GtMagritteDescriptionFromModelUpdateSpecification. GtMagritteDescriptionValueFromModelUpdateSpecification. BrFileSelector. FileSystemDirectoryEntry. BrTextEditorModifiedEvent. BlKeyCombination. GtCompletionController. BrDeletableFileWidget. BrGlamorousFocusableShadowAptitude. GtCoderShortcutIds. DiffPatchVisitor. DiffVisitor. GtPushUpMethodRefactoring. ZnRequestLine. SmallDictionary. GtRBCompositeTransformation. GtRBAddClassWithVarsRefactoring. GtSpotterSubstringsFilter. GtSpotterContext. GtLlmNullProvider. GtLlmSerializableValueHolder. GtLlmValueSerializer. SmaCCDefinitionParser. GtPackageCoderTool. GtInspectorTool. GtInspector. GtInspectorObject. GtPragmaType. LePagePhlowTool. LeObjectReferenceAnnotationAdapter. GtLlmInspectorSummary. GtLlmInspectorSlotSummaryGroup. GtLlmInspectorSlotSummary. GtLlmInspectorViewSummaryGroup. GtLlmInspectorMethodSummaryGroup. GtLlmInspectorMethodSummary. GtDebuggerDiffObjectStateComparisonStencil . BlAttributedTextElement . AsyncFutureExecutionContext. AsyncFutureDummyWaker . AsyncProcessStackOverflowCheckerFuture . AsyncPoll. TaskAtQueue . AsyncOnceStream . AsyncFuturePromise. AsyncFutureThreadPool . AsyncDelayedFuture . AsyncFlattenFuture . AsyncMapFuture . AsyncErrorHandlingFuture. BlElementAddedToSceneGraphEvent. GtMATextDescription. SystemAnnouncer. GtCompositeCompletionAction. GtDeleteTextCompletionAction. GtInsertTextCompletionAction. GtRenameActionAnnouncement. GtCoderRenameMethodRefactoring. RBRenameMethodRefactoring. SystemNavigation. BlKeyModifiers. GtPhlowOverviewItem. GtAnthropicListModelsAPIClient. BrGlamorousTabSwitcherWithIconAptitude. GtDiffElementWithLabelStencil. GtSmaCCDiffSplitter. GtLlmModelFile. GtWardleyMapAddProposition. GtWardleyMapRemoveProposition. BrColumnedMultiListAptitude. BrGlamorousColumnedListItemElementWithContextMenuDecorator. BrGlamorousColumnedListSelectableRowElementStencilBuilder. GtPhlowListToSelectHandler. BrGlamorousWithHorizontalResizerAptitude. BrGlamorousButtonWithIconAndLabelAptitude. GtMagritteActionUtility. GtEpiceaEventFactory. EpClassAddition. EpMethodAddition. EpClassRemoval. EpMethodRemoval. AkgLlmKnowlingRag. GtLlmChat. LeUID. GtWardleyMapAddOptionChange. GtWardleyMapCompositeChange. GtLlmStaticProvider. GtLlmNullConnection. GtLlmConnection. LeLogicalDatabase. LeExplicitlyAttachedLinksExamples. GtTMoneyExamples. GtSourceCoderErrorAttribute. GtInspectorSampleWithExceptionsInExtensions. LeContentExamples. }
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> stubClasses2 [

	^ { OSPlatform . PackageOrganizer . GtPharoDummyEnvironment . BlFrameLayout . BrGlamorousShrinkingLabelAptitude . BrScrollPane . BrScrollPaneAptitude . BrToggleGroup . BrGlamorousToggleGroupAptitude . BrToggle . BrGlamorousToggleWithLabelAptitude . BrToggleActivatedEvent . SkiaImage . GtJsonShapeComparison . GtRenameSelectorEditorAttribute . GtSelectorStyler . GtSelectorInputFilter . BlFontFamilyAttribute . GtCompletionStrategyAttribute . LePageToolContentTreeElement . GtSourceCoderEmbeddedExpanderToggleId . GtPharoDynamicHighlightAttribute . OpalCompiler . XMLHTMLParser . ShiftClassBuilder . GtShellScriptProcess . GtProcessStackOverflowChecker . Float32Array . GtLlmEmbedding . GtLlmEmbeddingsUtilities. RBScanner. SmaCCLineNumberStream. RBPushDownMethodRefactoring. RBRemoveMethodRefactoring. GtWardleyMapModel. GtLlmProvisionalThreadMessage. GtLlmNewThreadMessage. GtLlmNewActionThreadMessage. GtPharoDummiesGenerator. BrTextEditorModel. PBApplication. GtPhlowForwardViewDefiningMethodProvider. GtRrImageSyncEvents. GtRrChangesSync. GtRemoteRunner. GtRrLocalManagerStartupAndShutdown. GtRrExplicitExampleTask. GtRrJobCompletedAnnouncement. OmReference. GtOpenAIObjectMessage. BlMouseOverEvent. BlMouseOutEvent. BrGlamorousListItemAptitude. GtWardleyMapRenameOriginalNameId. GtWardleyMapRenameProposalId. GtABCartoonAddressBookExample. ZnMultiValueDictionary. ZnMultiPartFormDataEntity. ZnMimePart. GtAnthropicModelsGroup. NumberParser. GZipReadStream. LeSnippetChange. LePythonSnippet. LeShellScriptSnippet. LeExampleSnippet. GtCoder. GtSourceCoderId. GtSourceCoderEditorId. BrAnchoredVisualAnalysis. GtRefactoringsPreviewElement. GtSourceCoderEditorInnerId. GtTemporaryDirectory. GtMagritteCompletionStrategyStencilBuilder. GtMagritteMemento. GtMagritteElementBuilder. GtMagritteStringEditorElementStencilBuilder. GtMagrittePasswordEditorElementStencilBuilder. GtOpenAIProvider. GtPlotterDataGroup. GtPlotterLineChart. GtPlotterLinearScale. BrGlamorousButtonRectangularAptitude. BrGlamorousButtonIconDropdownAptitude. BrMenuItems. BrMenuActionItem. RBCondition. RBParseTreeRewriter. PharoLinkTestCaseSkip. LeTextCoderSnippetViewModel. LeAddSnippetChange. GtWorldElement. GtOpenAIMessageForGT. GtLlmCustomSerializationValueHolder. GtRBPullUpInstanceVariableRefactoring. SessionManager. GtLlmToolsGroup. GtMcpResourcesGroup. GtMcpPromptsGroup. GtPhlowChangeTabGroupActionExecutor. BlBorder. BrDebuggableEditorElementStencil. GtLlmAssistantChatReadyStatus. Point. BrStreamItemsProvider. AsyncObservableValue. AsyncOptionalValue. AsyncCachedStream. AsyncChunksStream. AsyncDebounceStream. AsyncEphemerousStream. AsyncErrorHandlingStream. AsyncFilterStream. AsyncMapStream. AsyncMapWithCacheStream. AsyncMapWithIndexStream. AsyncMapFutureStream. AsyncStreamForEachFuture. AsyncStreamCollectFuture. AsyncStreamFoldFuture. AsyncLineReadStream. AsyncStreamForwardFuture. AsyncFuseStream. AsyncStreamHasNextFuture. AsyncStreamNextFuture. AsyncStreamSizeHint. AsyncSplitStream. AsyncTakeStream. AsyncTerminatableStream. AsyncThrottleStream. AsyncWithoutDuplicatesStream. AsyncFlattenStream. AsyncWithTimeoutStream. AsyncWeakStream. AsyncLePageStream. AsyncFutureExecutionAtomicWaker. GtABAddressBook. GtBPEEncoder. GtPretrainedEncoder. AsyncSharedDictionary. GtRBAddMethodRefactoring. GtWardleyMapUpdateMapChange. GtWardleyMapAddInnerNodeChange. GtWardleyMapRemoveEdgeChange. GtWardleyMapRemoveNodeChange. GtWardleyMapUpdateEdgeChange. GtWardleyMapRemoveNoteChange. GtWardleyMapAddNodeChange. GtWardleyMapUpdateNodeChange. GtWardleyMapAddEdgeChange. GtWardleyMapAddNoteChange. GtWardleyMapUpdateNoteChange. GtWardleyMapRemoveInnerNodeChange. . GtMagritteActionElement . GtMagritteFieldViewModel . GtMagritteBasicAction . Socket . BrListRowStencilBuilder . GtMagritteModelStencilBuilder . GtMagritteListElementStencilBuilder . BlDoubleClickEvent . AsyncCounterSink . AsyncPeekSink . BlTextAttributesBuilder . BrGlamorousEditableLabelAptitude . GtFixItMarkerAttribute . BlMouseLeaveEvent }
]

{ #category : #accessing }
GtGemStoneLlmCodeExporter >> stubClassesWithoutParents [

	^ { WeakIdentityKeyDictionary. NeoJSONArray. NeoJSONObject. ConnectionClosed. BeaconSignal. BrWish. ContextStackSignal. GtLlmThreadMessageRestyleRequested. GtLlmThreadMessageViewModelChanged. GtLlmMessageContentsUpdated. }
]
