"
I export Pharo classes as a GemStone Topaz command file. I select classes from packages plus explicit inclusions, apply class and method exclusions, order classes so superclasses precede subclasses, and emit all class definitions before method-loading commands.

Traits are flattened into each exported consumer. Effective instance-side and class-side methods are emitted under the consuming class, aliases and exclusions follow Pharo's resolved method dictionaries, methods injected solely to implement TraitedClass are omitted, and effective trait slots are merged into the generated GemStone definition. Traits themselves are never defined. Excluding an origin trait method also excludes its flattened copies.

Methods to omit are supplied as compiled method objects through #excludedMethods:. Optionally, methods annotated with #gsCode: can be exported using their pragma-supplied GemStone source; this search can be limited to #gsCodeClasses: or searches all classes by default.

Stub classes supplied through #stubClasses: contribute only class definitions and do not have methods removed or loaded. Their Pharo parent classes are included up to, but excluding, classes already present in GemStone according to #gemstoneClassNames.  The topmost included stub is exported as an Object subclass; descendants retain their hierarchy. Stub classes are filtered by the same class exclusions as regular exported classes.
"
Class {
	#name : #GtGemStoneTopazExporter,
	#superclass : #Object,
	#instVars : [
		'packageNames',
		'additionalClasses',
		'stubClasses',
		'excludedClasses',
		'excludedMethods',
		'includeGsCodeMethods',
		'gsCodeClasses',
		'gemstoneClassNames'
	],
	#category : #'GToolkit-GemStone-Pharo-Export'
}

{ #category : #utilities }
GtGemStoneTopazExporter class >> compileMethod: aCompiledMethod in: aGemStoneSession [
	| script |
	script := GtGemStoneClassDefinitionTool
		compileScriptForSource: (self gemstoneSourceFor: aCompiledMethod)
		protocol: aCompiledMethod protocolName
		className: aCompiledMethod methodClass instanceSide name
		meta: aCompiledMethod methodClass isMeta
		environmentId: 0.
	aGemStoneSession connect.
	^ aGemStoneSession evaluateAndWait: script
]

{ #category : #accessing }
GtGemStoneTopazExporter class >> gemstoneClassNames [

	^ #(#GtRsrEvaluatorServiceTest #GtGemStoneEvaluationContextTest #GtThreadSafeIdentityDictionary #ZnBase64Encoder #STONJSON #GtRsrRemoteObjectWireSerializationStrategy #GtRsrWireSerializationStrategy #GtRsrStonSerializationStrategy #GtRsrProxyOnlySerializationStrategy #GtRsrPrimitiveOnlySerializationStrategy #GtRsrLocalObjectSerializationStrategy #GtRsrLiteralAndProxySerializationStrategy #GtRsrLegacySerializationStrategy #GtRsrDirectLocalObjectSerializationStrategy #GtRsrSerializationStrategy #GtGsRelease #GtGemStoneTranscriptHandler #GtGemStoneInImageTranscript #GtGemStoneTranscript #GtGemStoneSpecificationMedatada #GtGemStoneProcessSpecification #GtGemStoneMethodsSpecification #GtGemStoneContextSpecification #GtGemStoneMethodSpecification #GtGemStoneFeaturesSpecification #GtGemStoneFeatureSpecification #GtGemStoneClassBasicDetails #GtGemStoneCallFrameIdentifier #GtGemStoneSpecification #GtGemStoneSessionTransactionConflictsReport #GtGemStoneSessionFeatures #GtGemStoneSessionFeature #GtGemStoneSerializationExamples #GtGemStoneSemanticVersionNumber #GtGemStoneRemotePhlowDictionaryPrinter #GtGemStoneRemotePhlowCollectionPrinter #GtGemStoneLocalExceptionWithCallStack #GtGemStoneLocalCallStackUpdater #GtGemStoneLocalCallStack #GtGemStoneActiveProcessCallFrame #GtGemStoneLocalCallFrame #GtGemstoneHttpJsonSerializer #GtGemstoneHttpClient #GtGemStoneExampleRunner #GtGemStoneExampleResult #GtGemStoneExampleObjectForLocalDelegate #GtGemstoneEvaluationResumedResult #GtGemstoneEvaluationInProgressResult #GtGemstoneEvaluationExceptionResult #GtGemstoneEvaluationComputedResult #GtGemstoneEvaluationCancelledResult #GtGemstoneEvaluationResult #GtGemStoneEvaluationFrameContext #GtGemStoneEvaluationContext #GtGemStoneDoubleLocalCallStack #GtGemStoneDoubleLocalCallFrame #GtGemStoneDebuggerState #GtGemStoneCompilationContext #BlockClosureOnProcessExamples #AkgDebuggerPlay #GtGsDynamicVariable #GtGemStoneAssertionFailure #GtRsrWireTransferServiceServer #GtRsrWireTransferService #GtRsrTestServiceServer #GtRsrTestServiceClient #GtRsrTestService #GtRsrProxyServiceServer #GtRsrProxyService #GtRsrEvaluatorServiceServer #GtRsrEvaluatorService #GtRsrEvaluatorFeaturesServiceServer #GtRsrEvaluatorFeaturesService #GtWireStream #GtWireStonEncoder #GtWireReplicationEncoder #GtWireObjectByNameEncoder #GtWireNilEncoder #GtWireMinDepthEncoder #GtWireMaxDepthEncoder #GtWirePositiveIntegerEncoder #GtWireNegativeIntegerEncoder #GtWireIntegerEncoder #GtWireInstVarEncoder #GtWireGsBareProxyEncoder #GtWireGemStoneWithRsrEncoder #GtWireGemStoneRsrEncoder #GtWireGemStoneRemoteObjectEncoder #GtWireGemStoneOopEncoder #GtWireFractionEncoder #GtWireFloatPrintStringEncoder #GtWireFloatEncoder #GtWireDummyProxyEncoder #GtWireDateAndTimeEncoder #GtWireSetEncoder #GtWireOrderedCollectionEncoder #GtWireDictionaryEncoder #GtWireArrayEncoder #GtWireCollectionEncoder #GtWireClassEncoder #GtWireCharacterEncoder #GtWireSymbolEncoder #GtWireStringEncoder #GtWireCharacterArrayEncoder #GtWireByteArrayEncoder #GtWireTrueEncoder #GtWireFalseEncoder #GtWireBooleanEncoder #GtWireBlockClosureEncoder #GtWireAssociationEncoder #GtWireObjectEncoder #GtWireNestedEncodingExamples #GtWireGbsReplicationSpecEncodingExamples #GtWireGbsReplicationSpecConverterExamples #GtWireGbsReplicationSpecConverter #GtWireEncodingInspectionObject #GtWireEncodingExamples #GtWireEncodingExampleInstVarObject #GtWireEncodingDummyProxy #GtRemoteObjectWireEncoder #GtWireEncoder #GtWireInspectionDecoder #GtWireDecoder #GtWireEncoderDecoder #GtWireUnsupportedObject #RsrTokenExchangeCodecTestCase #RsrTestingProcessModelTestCase #RsrTemplateResolverWithClassVersions #RsrTemplateResolverTestCase #RsrSocketStressTest #RsrInMemoryStressTest #RsrStressTest #RsrSocketSpeciesEquality #RsrInMemorySpeciesEquality #RsrSpeciesEquality #RsrSocketServiceTest #RsrInMemoryServiceTest #RsrServiceTest #RsrSocketMessageSendingTest #RsrInMemoryMessageSendingTest #RsrMessageSendingTest #RsrSocketLifetimeTest #RsrInMemoryLifetimeTest #RsrLifetimeTest #RsrEphemeronMourningDeadlock #RsrSocketConnectionTestCase #RsrInMemoryConnectionTestCase #RsrConnectionTestCase #RsrSystemTestCase #RsrSocketTestCase #RsrSocketStreamTestCase #RsrSnapshotAnalysisTest #RsrProtocolVersionNegotiationCodecTestCase #RsrPromiseTest #RsrThreadSafeNumericSpigotTest #RsrNumericSpigotTest #RsrGarbageCollectorTestCase #RsrForwarderTest #RsrConnectionSpecificationTestCase #RsrCommandEncoderTest #RsrCommandDecoderTest #RsrCommandCodecTest #RsrClassResolverTestCase #RsrAsyncMournHandlerTestCase #RsrTestCase #RsrTestingProcessModel #RsrProcessModel #RsrPlatformInitializer #RsrTokenRejected #RsrTokenAccepted #RsrToken #RsrTokenExchangeMessage #RsrThreadSafeDictionary #RsrCommandSource #RsrCommandSink #RsrStreamChannelLoop #RsrSocketStream #RsrStream #RsrSocketPair #RsrSocket #RsrSnapshotAnalysis #RsrSignalErrorInAsString #RsrServiceSnapshot #RsrServiceEphemeron #RsrScientist #RsrRemotePromiseResolver #RsrRegistryEntry #RsrServiceReference #RsrPositiveIntegerReference #RsrNegativeIntegerReference #RsrIntegerReference #RsrDoubleReference #RsrDateAndTimeReference #RsrSetReference #RsrOrderedCollectionReference #RsrDictionaryReference #RsrArrayReference #RsrCollectionReference #RsrCharacterReference #RsrSymbolReference #RsrStringReference #RsrCharacterArrayReference #RsrByteArrayReference #RsrValueReference #RsrNilReference #RsrTrueReference #RsrFalseReference #RsrBooleanReference #RsrImmediateReference #RsrReference #RsrSupportedVersions #RsrNoVersionOverlap #RsrChosenVersion #RsrProtocolVersionNegotiationMessage #RsrPromiseResolutionAction #RsrPromise #RsrPendingMessage #RsrThreadSafeNumericSpigot #RsrNumericSpigot #RsrMessageSend #RsrLogWithPrefix #RsrTranscriptSink #RsrCustomSink #RsrLogSink #RsrLog #RsrTokenSender #RsrTokenReceiver #RsrTokenExchange #RsrProtocolVersionNegotiationServer #RsrProtocolVersionNegotiationClient #RsrProtocolVersionNegotiation #RsrHandshakeStep #RsrHandshake #RsrGarbageCollector #RsrEphemeron #RsrEnvironment #RsrDateAndTime #RsrGciInitiateConnection #RsrInitiateConnection #RsrGciAcceptConnection #RsrAcceptConnection #RsrSocketConnectionSpecification #RsrInternalSocketConnectionSpecification #RsrInMemoryConnectionSpecification #RsrInternalConnectionSpecification #RsrConnectionSpecification #RsrConnection #RsrReleaseServices #RsrSendMessage #RsrDeliverResponse #RsrMessagingCommand #RsrCommand #RsrTokenExchangeCodec #RsrProtocolVersionNegotiationCodec #RsrCommandEncoder #RsrCommandDecoder #RsrCommandCodec #RsrCodec #RsrClassResolver #RsrNullChannel #RsrInMemoryChannel #RsrBinaryStreamChannel #RsrChannel #RsrBufferedSocketStream #RsrAsyncMournHandler #RsrTemplateResolver #RsrAbstractTemplateResolver #RsrVersionServiceServer #RsrVersionServiceClient #RsrVersionService #RsrValueHolderServer #RsrValueHolderClient #RsrValueHolder #RsrServerTestService #RsrClientTestService #RsrTestService #RsrServerReferenceService #RsrClientReferenceService #RsrServiceReferenceService #RsrServerNoInstVars #RsrClientNoInstVars #RsrServiceNoInstVars #RsrKnownClient #RsrSendUnknownService #RsrKnownServer #RsrReturnUnknownService #RsrRemoteActionServer #RsrRemoteActionClient #RsrRemoteAction #RsrReflectedVariableTestServer #RsrReflectedVariableTestClient #RsrReflectedVariableTestServiceB #RsrReflectedVariableTestServiceA #RsrRemoteExceptionServer #RsrRemoteExceptionClient #RsrRemoteException #RsrPolicyRejectedServiceServer #RsrPolicyRejectedServiceClient #RsrPolicyRejectedService #RsrReasonService #RsrMockServer #RsrMockClient #RsrMockService #RsrInstrumentedServer #RsrInstrumentedClient #RsrInstrumentedService #RsrConcurrentTestServer #RsrConcurrentTestClient #RsrConcurrentTestService #RsrService #RsrAbstractService #RsrDecodingRaisedException #RsrConnectionClosedBeforeReceivingResponse #RsrAbstractReason #RsrTestPolicy #RsrDefaultPolicy #RsrAbstractPolicy #RsrObject #RsrForwarder #RsrNotification #RsrUnhandledException #RsrWaitForConnectionCancelled #RsrUnsupportedObject #RsrUnknownTemplate #RsrUnknownSID #RsrUnknownClass #RsrSocketClosed #RsrInvalidBind #RsrConnectFailed #RsrSocketError #RsrServiceRejected #RsrResumableError #RsrRemoteError #RsrBrokenPromise #RsrAlreadyResolved #RsrPromiseError #RsrOutOfRange #RsrNonresumableError #RsrTokenExchangeFailed #RsrProtocolVersionNegotiationFailed #RsrHandshakeError #RsrConnectionFailed #RsrAlreadyRegistered #RsrError #RsrConnectionClosed #RsrConnectionStateAnnouncement #RsrAnnouncement #WeakAnnouncerTest #AnnouncerTest #AnnouncementSetTest #AnnouncementSet #WeakSubscriptionBuilder #WeakAnnouncementSubscription #SubscriptionRegistry #AnnouncerSubscriberMockB #AnnouncerSubscriberMockA #Announcer #AnnouncementSubscription #GemToGemAnnouncement #AnnouncementMockD #AnnouncementMockC #AnnouncementMockB #AnnouncementMockA #Announcement #WeakBlockUnsupported #SoftCollisionBucket #KeySoftValueDictionary #IdentitySoftCollisionBucket #IdentityKeySoftValueDictionary #SharedQueue #GsPackagePolicy #RcBtreeBasicLeafNode #RcBtreeBasicInteriorNode #RcBtreeLeafNode #RcBtreeInteriorNode #IndexManager #Dictionary #GsInterSessionSignal #ClientForwarder #Set #Bag #PassiveObject #ISOLatin #GsDocText #GsClassDocumentation #RedoLog #StringPairSet #StringPair #AutoComplete #ClassSet #ProfMonitor #ClassOrganizer #PrintStream #LogEntry #PathEvaluator #RangeIndexReadStream #BtreeReadStream #QueryExecuter #MappingInfo #GsObjectSecurityPolicySet #DependencyList #IndexList #PathTerm #RangeEqualityIndex #IdentityIndex #NscBuilder #BucketValueBag #RcIndexBucket #RcIndexDictionary #RcCollisionBucket #RcKeyValueDictionary #BasicSortNode #SortNode #BtreeBasicLeafNode #BtreeBasicInteriorNode #BtreeLeafNode #BtreeInteriorNode #BtreeNode #Special56bit15 #Special56bit14 #Special56bit13 #Special56bit12 #Special56bit11 #Special56bit10 #Special56bit9 #Special56bit8 #Special56bit7 #Special56bit6 #Special56bit5 #Special56bit4 #Special56bit3 #Special56bit2 #Special56bit1 #Special56bit0 #SessionTemps #CCalloutStructs #AzureDataKey #AzureError #AwsDataKey #AbstractCloudKey #AbstractCloudCredentials #AwsError #SshSocketError #GsSftpRemoteFile #GcFinalizeNotification #GsTsExternalSession #SmallScaledDecimal #SmallDate #SmallTime #Time #SmallDateAndTime #DateAndTime #DateAndTimeANSI #AlmostOutOfMemoryError #AlmostOutOfStackError #DecimalFloat #GsHostProcess #ReadStreamPortable #AppendStream #GciErrSType #GciLibrary #GsLegacyExternalSession #PPPredicateObjectParser #TimeZoneTransition #TimeZoneInfo #Duration #TimeZone #Locale #Delay #FastIdentityKeyValueDictionary #GsSessionMethodDictionary #Utf16 #MigrationError #CryptoError #GsBitmap #Message #CDeclaration #CPreprocessorToken #CPreprocessor #CHeader #GsX509ExternalSession #GsX509CertificateChain #GsX509Certificate #GsTlsPublicKey #GsTlsPrivateKey #GsTlsCredential #GemStoneX509Parameters #Processor #GsSignalingSocket #SecureSocketError #KerberosPrincipal #UserProfileGroup #PrivateObject #SmallFraction #AbstractFraction #EqualityCollisionBucket #IO #GsMethodLookupCache #TransientShortArray #GsFileStat #CZstream #CByteArray #CPointer #CCallin #CCallout #CFunction #CLibrary #Reflection #UnauthorizedObjectStub #Unicode32 #Unicode16 #Unicode7 #Utf8 #IcuCollator #IcuLocale #CompileWarning #TransactionBacklog #ObjectsCommittedNotification #InterSessionSignal #FloatingPointException #Deprecated #RepositoryViewLost #AlmostOutOfMemory #AlmostOutOfStack #Admonition #UserDefinedError #UncontinuableError #TransactionError #ThreadError #SignalBufferFull #SecurityError #RepositoryError #NumericError #NameError #LockError #GciTransportError #InternalError #IndexingErrorPreventingCommit #FloatingPointError #OutOfRange #OffsetError #LookupError #CannotReturn #ArgumentTypeError #ArgumentError #ImproperOperation #SystemCallError #SocketError #IOError #PostgresError #ExternalError #EndOfStream #CompileError #TerminateProcess #Halt #ClientForwarderSend #Breakpoint #Break #ControlInterrupt #AbstractException #GsExceptionHandler #MatchData #Range #ExecBlockN #ExecBlock5 #ExecBlock4 #ExecBlock3 #ExecBlock2 #ExecBlock1 #ExecBlock0 #ExecBlock #GsNativeCode #GsNMethod #CBuffer #MultiByteString #BitSet #LargeInteger #ExceptionSet #ResumableTestFailure #TestFailure #Warning #Notification #ZeroDivide #MessageNotUnderstood #Error #ScaledDecimal #QuadByteSymbol #QuadByteString #DoubleByteSymbol #DoubleByteString #SmallFloat #Float #ClampSpecification #GsSocket #GsFile #VariableContext #GsProcess #Exception #Semaphore #SortedCollection #OrderedCollection #SelectBlock #BlockClosure #GsCurrentSession #GsSession #AbstractSession #ProcessorScheduler #GsStackBuffer #ClusterBucketArray #ClusterBucket #UserProfile #UndefinedObject #System #WriteStream #ReadStream #PositionableStream #Stream #SoftReference #GsObjectSecurityPolicy #FixedPoint #SmallDouble #BinaryFloat #SmallInteger #Integer #Fraction #Number #DateTime #Date #Character #Magnitude #LanguageDictionary #SymbolList #UserSecurityData #UserProfileSet #AbstractUserProfileSet #SymbolSet #InvariantArray #Repository #Interval #GsMethodDictionary #SymbolKeyValueDictionary #IntegerKeyValueDictionary #Boolean #IdentitySet #IdentityBag #UnorderedCollection #InvariantString #IdentityCollisionBucket #ByteArray #ClassHistory #SymbolAssociation #Association #CanonStringBucket #CollisionBucket #AbstractCollisionBucket #CanonSymbolDict #CanonStringDict #SymbolDictionary #IdentityDictionary #IdentityKeyValueDictionary #StringKeyValueDictionary #KeyValueDictionary #AbstractDictionary #Symbol #String #CharacterCollection #Array #SequenceableCollection #Collection #Object #Class #Metaclass3 #Module #Behavior #CriticalSection #PathSorter #SetValuedPathEvaluator #CollectionBasedPathEvaluator #IndexDictionaryEntryHolder #UnicodeRangeEqualityIndex #RcUnicodeRangeEqualityIndex #RcRangeEqualityIndex #DepListBucket #IdentityBtreeNode #Upgrade1B #DeletedUserProfile #GsTestResult #TranscriptStreamPortable #FileStreamPortable #ReadWriteStreamPortable #WriteStreamPortable #ReadByteStreamPortable #PositionableStreamPortable #WriteStreamLegacy #ReadByteStreamLegacy #ReadStreamLegacy #PositionableStreamLegacy #Upgrade2C #TestSuite #TestResult #SimpleTestResourceCircular1 #SimpleTestResourceCircular #SimpleTestResourceB1 #SimpleTestResourceB #SimpleTestResourceA2 #SimpleTestResourceA1 #SimpleTestResourceA #SimpleTestResource #TestResource #SUnitTest #CircularTestResourceTestCase #ManyTestResourceTestCase #FailingTestResourceTestCase #SimpleTestResourceTestCase #ResumableTestFailureTestCase #ExampleSetTest #TestCase #TestAsserter #SUnitNameResolver #Lag25000CmwcRandom #Lag1MwcRandom #SeededRandom #HostRandom #Random #AbstractExternalSession #SUnitDelay #ReadByteStream #FileStream #GciInterface #GsFileIn #ReadWriteStream #Upgrade2A #TransactionBoundaryDefaultPolicy #SystemLoginNotification #RcQueueEntry #RcQueueElement #RcCounterElement #GsPipeElement #GsPackage #RcIdentitySet #RcLowMaintenanceIdentityBag #ChildError #RcPipe #GsPipe #RcQueueSessionComponent #RcQueueRemovalSeqNumbers #RcArray #InstVarMappingArray #GsCommitList #ReversedRangeIndexReadStream #RcCounter #JwtUserClaim #JwtSecurityData #IndexManagerAutoCommitPolicy #IdentityIndexQueryEvaluator #EqualityIndexQueryEvaluator #IndexedQueryEvaluator #BtreeUnicodeComparisonQuerySpec #BtreeUnicodeRangeComparisonQuerySpec #BtreeRangeComparisonQuerySpec #BtreeComparisonQuerySpec #BtreeQuerySpec #BtreeComparisonForUnicodeCompare #BtreeComparisonForUnicodeSort #BtreeComparisonForSort #BtreeComparisonForCompare #IdentityIndexSpecification #RcEqualityIndexSpecification #EqualityIndexSpecification #AbstractIndexSpecification #PathPathBagUnicodeEnumerator #PathPathBagEnumerator #BagUnicodeRangeEnumerator #BagRangeEnumerator #BagUnicodeEnumerator #BagEnumerator #AbstractBagEnumerator #RcIdentityBag #RcIndexBucketWithCache #RcQueue #DepListTable #SortNodeArray #SelectorPathTerm #OptionalPathTerm #SetValuedPathTerm #EnumeratedPathTerm #CollectionBasedPathTerm #TreeSet #GsTestSuite #GsTestCase #AppendableString #PPStream #CPreprocessorStream #RcKeyValueNoRebuildDictionary #JsonPetitParser #ProfMonitorEntry #ProfMonitorTree #Pragma #LdapDirectoryServer #JsonParser #HtSetTreeWalker #HtDictionaryTreeWalker #HtTreeWalker #HtHeap #GsUuidV4 #GsSshPublicKey #GsSshPrivateKey #GsSysLog #GsReferencePathParentsInfo #GsReferencePath #GsPackageLibrary #GsObjectInventoryEntry #GsObjectInventory #GsLog #GsDigitalEnvelope #TraversalBuffer #AzureCredentials #AwsCredentials #GsSftpSocket #GsSshSocket #GsSecureSocket #GciLegacyError #SortBlockUnicodeNode #SortBlockNode #NonPersistentArray #HtSetScratchLeafNode #HtSetLeafNode #HtDictionaryScratchLeafNode #HtDictionaryLeafNode #HtLeafNode #HtSetInternalNode #HtDictionaryInternalNode #HtInternalNode #ErrorDescription #GsExternalSession #TreeDictionary #BtreePlusGsReversedIndexReadStream #BtreePlusGsIndexReadStream #BtreePlusReadStream #IcuSortedCollection #Int64Array #Uint64Array #Int32Array #Uint32Array #Int16Array #Uint16Array #RcUnicodeIndexSpecification #Upgrade3Init #SelectorPathEvaluator #OptionalTermPathEvaluator #PPToken #PPUnresolvedParser #PPStartOfWordParser #PPStartOfLogicalLineParser #PPStartOfLineParser #PPPredicateSequenceParser #PPPredicateParser #PPPluggableParser #PPLiteralSequenceParser #PPLiteralObjectParser #PPLiteralParser #PPSequenceParser #PPLimitedChoiceParser #PPChoiceParser #PPListParser #PPFailingParser #PPEpsilonParser #PPEndOfLineParser #PPEndOfFileParser #PPTrimmingParser #PPPossessiveRepeatingParser #PPLazyRepeatingParser #PPGreedyRepeatingParser #PPLimitedRepeatingParser #PPRepeatingParser #PPOptionalParser #PPNotParser #PPMemoizedParser #GsQueryTokenParser #PPTokenParser #PPFlattenParser #PPExpressionParser #PPEndOfInputParser #PPConditionalParser #GsQueryParser #GsQueryGrammar #PPCompositeParser #PPAndParser #PPWrappingParser #PPActionParser #GsQueryErrorHandlingParser #PPDelegateParser #PPParser #PPMemento #PPForwardingParser #PPFailure #PPContextMemento #PPContext #PPCharSetPredicate #ParallelDoWorker #ParallelDoManager #ParallelDoHost #JsonWebToken #GsSingleRefPathFinderForObject #GsSingleRefPathFinder #GsQueryLiteralValue #GsQueryLiteralArray #GsQueryLiteral #GsStreamableQueryChecker #GsQueryConjoinSetChecker #GsStreamableConjunctiveClauseChecker #GsConjunctiveClauseConjoinSetChecker #GsClassicConjunctiveClauseOptimizer #Gs32UnaryConstantPredicateOptimizer #Gs32DisjunctiveClauseOptimizer #GsClauseOptimizer #Gs32Optimizer #GsClassicQueryBlockOptimizer #GsAbstractQueryOptimizer #GsQueryFormulaVisitor #GsUnaryClause #GsCompoundClause #GsPreparedRangeQueryPredicate #GsRangeQueryPredicate #GsPathPathPredicate #GsPreparedPathConstantPredicate #GsPathConstantPredicate #GsConstantPathPredicate #GsConstantConstantPredicate #GsQueryPredicate #GsAbstractQueryPredicate #GsQueryFormula #GsQuery #GsQueryOptions #GsIndexOptions #GsOptions #GsNetworkResourceString #GsIndexSpec #GsIdentityIndexQueryEvaluator #GsEqualityIndexQueryEvaluator #GsIndexedQueryEvaluator #GsEventLogSystemEntry #GsEventLogEntry #GsEventLog #GemStoneParameters #GciTsLibrary #CanonicalObjectRegistry #CanonicalObjectPolicy #CanonicalObjectManager #BtreePlusRootObjectMap #RcBtreePlusRoot #BtreePlusRoot #BtreePlusNodeAuditor #ReferencingObjectPolicy #AbstractReferencingObjectPolicy #LogRotateNotification #GsUnsatisfiableQueryNotification #BtreePlusTraversalMapDictionary #GsQueryParseError #GsQueryExpectedImplicitIdentityIndexError #GsMalformedQueryExpressionError #GciError #ExitClientError #UnicodeIndexSpecification #ConstrainedCharacterCollectionIndexSpecification #EnumeratedPathEvaluator #BtreePlusUnicodeComparisonQuerySpec #BtreePlusUnicodeRangeComparisonQuerySpec #BtreePlusRangeComparisonQuerySpec #BtreePlusComparisonQuerySpec #BtreeOptimizedUnicodeComparison #BtreeOptimizedComparison #BtreeComparisonForIdentity #GsPathReferenceAssociation #GsVariableReferenceAssociation #GsQueryPathReferenceAssociation #GsConstantReferenceAssociation #GsAbstractReferenceAssociation #GsSingleRefPathResult #GsSelectorPathTerm #GsOptionalPathTerm #GsSetValuedPathTerm #GsEnumeratedPathTerm #GsCollectionBasedPathTerm #GsPathTerm #GsUnicodeRangeEqualityIndex #GsConstrainedCharacterCollectionIndex #GsRangeEqualityIndex #GsIdentityIndex #GsAbstractIndex #BtreePlusLeafKeyValueRootObjectNode #BtreePlusLeafKeyValueNode #BtreePlusLeafKeyNode #BtreePlusLeafNode #BtreePlusInteriorKeyValueRootObjectNode #BtreePlusInteriorKeyValueNode #BtreePlusInteriorNode #BtreePlusNode #BlockSorter #ParallelDoReportStream #ParallelDoExternalSession #UpgradeStreams #GsTraitImpl #Trait #ClassTrait #AbstractTrait #STONWriter #STONMapWriter #STONShortListWriter #STONListWriter #STONStreamWriter #STONReference #STONReader #STON #STONFileReference #STONWriterError #STONReaderError #ZnCharacterWriteStream #ZnEncodedWriteStream #ZnCharacterReadStream #ZnEncodedReadStream #ZnEncodedStream #ZnBufferedWriteStream #ZnBufferedReadWriteStream #ZnBufferedReadStream #ZnStream #ZnUTF8Encoder #Zn8BITEncoder #ZnCharacterEncoder #RelativePath #AbsolutePath #Path #MemoryFileWriteStream #MemoryFileSystemFile #MemoryFileSystemDirectory #MemoryFileSystemEntry #FsLibcUnistd_macOS #FsLibcUnistd_Linux #FsLibcUnistd #FsLibcStdio_macOS #FsLibcStdio_Linux #FsLibcStdio #FsLibcStat_macOS_x64 #FsLibcStat_macOS_arm64 #FsLibcStat_macOS #FsLibcStat_Linux_x64 #FsLibcStat_Linux_aarch64 #FsLibcStat_Linux #FsLibcStat #FsLibcFcntl_macOS #FsLibcFcntl_Linux #FsLibcFcntl #FsLibcDirent_macOS_x64 #FsLibcDirent_macOS_arm64 #FsLibcDirent_macOS #FsLibcDirent_Linux #FsLibcDirent #FsLibcInterface #FsFileOpeningOptions_macOS #FsFileOpeningOptions_Linux_x64 #FsFileOpeningOptions_Linux_aarch64 #FsFileOpeningOptions_Linux #FsUnixFileOpeningOptions #FsMemoryFileOpeningOptions #FsFileOpeningOptions #FsFileDescriptorRegistry #FsFileDescriptorEphemeron #FsFileDescriptor #FsTimespecStruct #FsStatStruct_macOS #FsStatStruct_Linux_x64 #FsStatStruct_Linux_aarch64 #FsStatStruct_Linux #FsStatStruct #FsDirentStruct_macOS #FsDirentStruct_Linux #FsDirentStruct #FsCStructure #FsBinaryFileStream #MemoryStore #FsMacOSStore_x64 #FsMacOSStore_arm64 #FsMacOSStore #FsLinuxStore_x64 #FsLinuxStore_aarch64 #FsLinuxStore #UnixStore #DiskStore #FileSystemStore #SystemResolver #UnixResolver #MacOSResolver #PlatformResolver #EnvironmentResolver #FileSystemResolver #FileSystemPermission #MemoryHandle #FileSystemHandle #FsMemoryFileSystem #FsDiskFileSystem #FileSystem #FileReference #FileLocator #AbstractFileReference #ZnCharacterEncodingError #ZnError #FsEROFS #FsENOTDIR #FsENOSPC #FsENOMEM #FsENOENT #FsEINVAL #FsEINTR #FsEEXIST #FsEBADF #FsEACCES #FsUnixError #FsFileDescriptorInvalid #FilePermissionDenied #FileExists #FileAttributeNotSupported #DirectoryRequired #DirectoryIsNotEmpty #DirectoryExists #DirectoryDoesNotExist #FileSystemError #FileRequired #FileDoesNotExistException #FileException #FsError #GsTsX509ExternalSession #GtRemotePhlowDetailsRowSpecificationExamples #GtRsrInspectorProxyDataSerializationStrategy #GtRsrInspectorProxySerializationStrategy #GtRmMovieCollection #GtRmMovie #GtRmGeoUser #GtRmGeolifeLocalImporter #GtRmGeolifeBaseImporter #GtRmGeolife #GtRmGeoGpsTrajectory #GtRmGeoGpsRecord #GtRmGeoGpsUsersGroup #GtRmGeoGpsTrajectoriesGroup #GtRmGeoGpsRecordsGroup #GtRmGeoGpsGroup #GtRemotePhlowWebViewExplicitContentFileWriter #GtRemotePhlowWebBrowserViewTestObject #GtRemotePhlowWebBrowserViewErrorTestObject #GtRemotePhlowWebBrowserStencilTestObject #GtRemotePhlowViewedObject #GtRemoteTextStylerComputableSpecification #GtRemotePhlowTextNullStylerSpecification #GtRemotePhlowTextParserStylerSpecification #GtRemotePhlowTextClassStylerSpecification #GtRemotePhlowTextNamedStylerSpecification #GtRemotePhlowTextAttributeRunsStylerSpecification #GtRemotePhlowTextStylerSpecification #GtRemotePhlowTestDataForExamples #GtRemotePhlowStylableText #GtRemotePhlowStencilObjectWrapper #GtRemotePhlowStencilComputationWrapper #GtRemotePhlowStencilDataWrapper #GtRemotePhlowViewSpecificationConversionExamples #GtRemotePhlowActionSpecificationConversionExamples #GtRemotePhlowSpecificationConversionExamples #GtRemotePhlowSpawnObjectWrapper #GtRemotePhlowSendObjectTransformation #GtRemotePhlowViewErrorView #GtRemotePhlowTextView #GtRemotePhlowTextEditorView #GtRemotePhlowTextualView #GtRemotePhlowWebBrowserView #GtRemotePhlowPictureView #GtRemotePhlowLocalView #GtRemotePhlowTreeView #GtRemotePhlowListView #GtRemotePhlowColumnedTreeView #GtRemotePhlowColumnedListView #GtRemotePhlowBasicColumnedView #GtRemotePhlowListingView #GtRemotePhlowForwarderView #GtRemotePhlowExplicitView #GtRemotePhlowEmptyView #GtRemotePhlowDetailsView #GtRemotePhlowView #GtRemotePhlowProtoView #GtRemotePhlowPictureViewTestObject #GtRemotePhlowPictureViewErrorTestObject #GtRemotePhlowRowBuilder #GtRemotePhlowItemBuilder #GtRemotePhlowNodeValueBuilder #GtRemotePhlowRowValue #GtRemotePhlowItemErrorValue #GtRemotePhlowDetailsRowValue #GtRemotePhlowItemTextualValue #GtRemotePhlowItemValue #GtRemotePhlowNodeValue #GtRemotePhlowExplicitViewWithSerializationTestObject #GtRemotePhlowExplicitViewWithEditableUIPersonObject #GtRemotePhlowExplicitViewTestObject #GtRemotePhlowExplicitViewErrorTestObject #GtRemotePhlowDummyTextStyler #GtRemotePhlowDetailsRowSpecification #GtRemotePhlowDetailsRow #GtRemotePhlowDeclarativeWebBrowserViewDataSource #GtRemotePhlowDeclarativeViewColumnedTreeDataSource #GtRemotePhlowDeclarativeViewTreeDataSource #GtRemotePhlowDeclarativeViewListDataSource #GtRemotePhlowDeclarativeViewColumnedListDataSource #GtRemotePhlowDeclarativeViewListingDataSource #GtRemotePhlowDeclarativeViewDetailsDataSource #GtRemotePhlowDeclarativeTextualViewDataSource #GtRemotePhlowDeclarativeForwardViewDataSource #GtRemotePhlowDeclarativeExplicitViewDataSource #GtRemotePhlowConcreteDataViewDataSource #GtRemotePhlowDeclarativeViewDataSource #GtRemotePhlowDeclarativeTreeExamples #GtRemotePhlowDeclarativeTextTestInspectable #GtRemotePhlowDeclarativeTestWithViewIncrement #GtRemotePhlowDeclarativeTestInspectable #GtRemotePhlowDeclarativeTestForCustomProxyInspectable #GtRemotePhlowDeclarativeViewsProxySimulationExamples #GtRemotePhlowDeclarativeViewsRemoteViewedObjectExamples #GtRemotePhlowDeclarativeViewsLocalViewedObjectExamples #GtRemotePhlowDeclarativeViewsDirectViewedObjectExamples #GtRemotePhlowDeclarativeViewsExamples #GtRemotePhlowDeclarativeActionsProxySimulationExamples #GtRemotePhlowDeclarativeActionsRemoteViewedObjectExamples #GtRemotePhlowDeclarativeActionsLocalViewedObjectExamples #GtRemotePhlowDeclarativeActionsDirectViewedObjectExamples #GtRemotePhlowDeclarativeActionsExamples #GtRemotePhlowDeclarativeExamples #GtRemotePhlowDeclarativeErrorTestInspectable #GtRemotePhlowDeclarativeDetailsInspectableForExamples #GtRemotePhlowDeclarativeActionsInspectableForExamples #GtRemotePhlowDeclarativeBlockActionDataSource #GtRemotePhlowDeclarativeActionDataSource #GtRemotePhlowColumnedTreeNode #GtRemotePhlowTreeNode #GtRemotePhlowDetailsNode #GtRemotePhlowDataNode #GtRemotePhlowColumnSpecification #GtRemotePhlowTextColumn #GtRemotePhlowNumberColumn #GtRemotePhlowThemeIconNameColumn #GtRemotePhlowIconNameColumn #GtRemotePhlowTypedColumn #GtRemotePhlowExplicitColumn #GtRemotePhlowColumn #GtRemotePhlowPluggableCollectionIterator #GtRemotePhlowGenericCollectionIterator #GtRemotePhlowDictionaryKeysIterator #GtRemotePhlowDictionaryAssociationsIterator #GtRemotePhlowUnindexedCollectionIterator #GtRemotePhlowSequenceableCollectionIterator #GtRemotePhlowCollectionIterator #GtRemotePhlowApiWrapper #GtRemotePhlowNoAction #GtRemotePhlowErrorAction #GtRemotePhlowButtonAction #GtRemotePhlowAction #GtRemotePhlowExplicitViewWithEditableUIPersonWithNotificationStencil #GtPhlowPictureWithExplicitDataExampleRemoteStencil #GtPhlowNamedStencil #GtPhlowErrorStencil #GtPhlowForwardStencil #GtPhlowWithDataStencil #GtPhlowWithSpecificationStencil #GtRemotePhlowWebBrowserViewSpecification #GtRemotePhlowExplicitViewSpecification #GtRemotePhlowConcreteDataViewSpecification #GtPhlowViewErrorViewSpecification #GtPhlowTextViewSpecification #GtPhlowTextEditorViewSpecification #GtPhlowTextualViewSpecification #GtPhlowTreeViewSpecification #GtPhlowListViewSpecification #GtPhlowColumnedTreeViewSpecification #GtPhlowColumnedListViewSpecification #GtPhlowBasicColumnedViewSpecification #GtPhlowListingViewSpecification #GtPhlowForwardViewSpecification #GtPhlowEmptyViewSpecification #GtPhlowDetailsViewSpecification #GtPhlowViewSpecification #GtPhlowTextHighlight #GtPhlowTextDecoration #GtPhlowTextUnknownAttribute #GtPhlowTextDecorationAttribute #GtPhlowTextHighlightAttribute #GtPhlowTextForegroundAttribute #GtPhlowTextColorAttribute #GtPhlowFontWeightAttribute #GtPhlowFontSizeAttribute #GtPhlowFontNameAttribute #GtPhlowFontEmphasisAttribute #GtPhlowTextAttribute #GtPhlowSubText #GtPhlowRunBasedText #GtPhlowText #GtPhlowRunsGroup #GtPhlowRuns #GtRemotePhlowViewedObjectClassSpecification #GtRemotePhlowSpawnObjectAction #GtRemotePhlowNavigationUpdateViewAction #GtRemotePhlowNavigationUpdateMainToolAction #GtRemotePhlowNavigationUpdateCurrentToolAction #GtRemotePhlowNavigationRefreshAction #GtRemotePhlowNavigationAction #GtRemotePhlowWebViewHeader #GtRemotePhlowWebViewUrlContent #GtRemotePhlowWebViewHtmlContent #GtRemotePhlowWebViewTextualContent #GtRemotePhlowWebViewByteArrayContent #GtRemotePhlowWebViewExplicitContent #GtRemotePhlowWebViewContent #GtRemotePhlowViewErrorData #GtRemotePhlowPictureViewData #GtRemotePhlowViewData #GtRemotePhlowBasicViewData #GtRemotePhlowForwardStencilSpecification #GtRemotePhlowDirectStencilSpecification #GtRemotePhlowAbstractStencilSpecification #GtPhlowStencilNoExplicitDataSerializationStrategy #GtPhlowStencilMediumSerializationStrategy #GtPhlowStencilDictionaryDataSerializationStrategy #GtPhlowStencilDataSerializationStrategy #GtRemotePhlowWebBrowserStencil #GtPhlowPictureWithDirectDataExampleStencil #GtPhlowPngBytesIconStencil #GtPhlowThemeIconNameStencil #GtPhlowGlamorousVectorIconNameStencil #GtPhlowGlamorousIconNameStencil #GtPhlowBasicGlamorousIconNameStencil #GtPhlowNamedIconStencil #GtPhlowIconStencil #GtPhlowStencil #GtPhlowErrorActionSpecification #GtPhlowButtonActionSpecification #GtPhlowActionSpecification #GtPhlowDeclarativeSpecification #GtPhlowUnknownDeclarativeListingType #GtPhlowThemeIconNameDeclarativeListingType #GtPhlowTextLinkDeclarativeListingType #GtPhlowTextDeclarativeListingType #GtPhlowNumberDeclarativeListingType #GtPhlowDeclarativeListingType #GtPhlowColor #GtPhlowRun #GtPhlowBasicRun #MessageSend #CidrParser #CidrGrammar #ObjectFilteringPolicyMap #ObjectFilteringPolicy #IPv4Subnet #Cidr)
]

{ #category : #utilities }
GtGemStoneTopazExporter class >> gemstoneSourceFor: aCompiledMethod [
	^ self gemstoneSourceForSource: aCompiledMethod sourceCode
]

{ #category : #utilities }
GtGemStoneTopazExporter class >> gemstoneSourceForSource: aString [
	| methodNode pragma code |
	methodNode := GtPharoParser parse: aString.
	pragma := methodNode pragmas
		detect: [ :each | each selector = #gsCode: ]
		ifNone: [ ^ aString ].
	code := pragma values first literalValue.
	code ifNil: [ ^ aString ].
	^ (aString copyFrom: 1 to: pragma startPosition - 1), code asString
]

{ #category : #'instance creation' }
GtGemStoneTopazExporter class >> packages: packageNames additionalClasses: additionalClasses excluding: excludedClasses [
	^ self new
		packageNames: packageNames;
		additionalClasses: additionalClasses;
		excludedClasses: excludedClasses;
		yourself
]

{ #category : #'instance creation' }
GtGemStoneTopazExporter class >> packages: packageNames additionalClasses: additionalClasses stubClasses: stubClasses excluding: excludedClasses [
	^ self new
		packageNames: packageNames;
		additionalClasses: additionalClasses;
		stubClasses: stubClasses;
		excludedClasses: excludedClasses;
		yourself
]

{ #category : #accessing }
GtGemStoneTopazExporter >> additionalClasses: aCollection [
	additionalClasses := aCollection collect: [ :each | self resolveClass: each ]
]

{ #category : #exporting }
GtGemStoneTopazExporter >> asTopazString [
	^ String streamContents: [ :stream | self writeTopazOn: stream ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> classesToDefine [
	| classes |
	classes := OrderedCollection new.
	classes addAll: self selectedClasses.
	classes addAll: (stubClasses reject: [ :each |
		excludedClasses includes: each ]).
	^ Class superclassOrder: classes asSet
]

{ #category : #'private - traits' }
GtGemStoneTopazExporter >> effectiveMethodsOf: aBehavior [
	"Answer the methods that belong to the flattened behavior. A traited
	metaclass also contains methods injected by TraitedClass to implement the
	trait mechanism; metaMethods deliberately removes those methods."
	^ (aBehavior respondsTo: #metaMethods)
		ifTrue: [ aBehavior metaMethods ]
		ifFalse: [ aBehavior methods ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> excludedClasses: aCollection [
	excludedClasses := aCollection collect: [ :each | self resolveClass: each ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> excludedMethods [
	^ excludedMethods
]

{ #category : #accessing }
GtGemStoneTopazExporter >> excludedMethods: aCollection [
	excludedMethods := aCollection
]

{ #category : #accessing }
GtGemStoneTopazExporter >> gemstoneClassNames [
	^ gemstoneClassNames ifNil:
		[ gemstoneClassNames := self class gemstoneClassNames asSet ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> gsCodeClasses [
	^ gsCodeClasses
]

{ #category : #accessing }
GtGemStoneTopazExporter >> gsCodeClasses: aCollection [
	gsCodeClasses := aCollection.
	^ self
]

{ #category : #'private - exporting' }
GtGemStoneTopazExporter >> gsCodeClassesForExport [
	| classes |
	classes := gsCodeClasses
		ifNil: [ Smalltalk globals allClasses asOrderedCollection, Smalltalk globals allTraits ]
		ifNotNil: [ gsCodeClasses collect: [ :each | self resolveClass: each ] ].
	^ classes asSet
]

{ #category : #'private - exporting' }
GtGemStoneTopazExporter >> gsCodePragmaOf: aMethod [
	^ aMethod pragmas
		detect: [ :each | each selector = #gsCode: ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> includeGsCodeMethods [
	^ includeGsCodeMethods
]

{ #category : #accessing }
GtGemStoneTopazExporter >> includeGsCodeMethods: aBoolean [
	includeGsCodeMethods := aBoolean.
	^ self
]

{ #category : #initialization }
GtGemStoneTopazExporter >> initialize [
	super initialize.
	packageNames := #().
	additionalClasses := #().
	stubClasses := #().
	excludedClasses := #().
	excludedMethods := #().
	includeGsCodeMethods := false.
	gsCodeClasses := nil
]

{ #category : #'private - traits' }
GtGemStoneTopazExporter >> isExcludedMethod: aMethod in: aBehavior [
	| origin |
	(excludedMethods includes: aMethod) ifTrue: [ ^ true ].
	origin := self originMethodOf: aMethod in: aBehavior.
	^ excludedMethods includes: origin
]

{ #category : #'private - exporting' }
GtGemStoneTopazExporter >> mergedSlotNames: localSlotNames withTraitsOf: aBehavior [
	| result definedSlotNames behavior |
	result := localSlotNames asOrderedCollection.
	definedSlotNames := OrderedCollection new.
	behavior := aBehavior.
	[ behavior notNil ] whileTrue: [
		definedSlotNames addAll: behavior instVarNames.
		behavior := behavior isMeta
			ifTrue: [
				behavior instanceSide superclass
					ifNil: [ nil ]
					ifNotNil: [ :aSuperclass | aSuperclass class ] ]
			ifFalse: [ behavior superclass ] ].
	(self traitSlotNamesOf: aBehavior) do: [ :each |
		((result includes: each) or: [ definedSlotNames includes: each ]) ifFalse: [
			result add: each ] ].
	^ result asArray
]

{ #category : #'private - traits' }
GtGemStoneTopazExporter >> originMethodOf: aMethod in: aBehavior [
	^ (aBehavior respondsTo: #findOriginMethodOf:)
		ifTrue: [ aBehavior findOriginMethodOf: aMethod ]
		ifFalse: [ aMethod ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> packageNames: aCollection [
	packageNames := aCollection collect: [ :each |
		(each respondsTo: #name)
			ifTrue: [ each name asString ]
			ifFalse: [ each asString ] ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> packages: aCollection [
	self packageNames: aCollection
]

{ #category : #private }
GtGemStoneTopazExporter >> resolveClass: aClassOrName [
	^ aClassOrName isBehavior
		ifTrue: [ aClassOrName instanceSide ]
		ifFalse: [ self class environment at: aClassOrName asSymbol ]
]

{ #category : #'private - selection' }
GtGemStoneTopazExporter >> selectedClasses [
	| selected |
	selected := Set new.
	packageNames do: [ :packageName |
		selected addAll: ((PackageOrganizer default
			packageNamed: packageName
			ifAbsent: [ self error: 'Unknown package: ', packageName ]) definedClasses) ].
	selected addAll: additionalClasses.
	selected := selected reject: [ :each |
		(each isTrait) or: [ excludedClasses includes: each ] ].
	selected := selected reject: [ :each | each superclass == PackageManifest ].
	^ Class superclassOrder: selected
]

{ #category : #'private - exporting' }
GtGemStoneTopazExporter >> shouldExportGsCodeOf: aMethod [
	^ includeGsCodeMethods
		and: [ (self gsCodePragmaOf: aMethod) notNil
			and: [ (excludedMethods includes: aMethod) not
				and: [ (excludedClasses includes: aMethod methodClass instanceSide) not
					and: [ self gsCodeClassesForExport includes: aMethod methodClass instanceSide ] ] ] ]
]

{ #category : #'private - testing' }
GtGemStoneTopazExporter >> shouldExportGsCodeOf: aMethod in: aBehavior [
	| origin |
	includeGsCodeMethods ifFalse: [ ^ false ].
	(self isExcludedMethod: aMethod in: aBehavior) ifTrue: [ ^ false ].
	origin := self originMethodOf: aMethod in: aBehavior.
	(self gsCodePragmaOf: origin) ifNil: [ ^ false ].
	(excludedClasses includes: aBehavior instanceSide) ifTrue: [ ^ false ].
	^ (self gsCodeClassesForExport includes: aBehavior instanceSide)
		or: [ self gsCodeClassesForExport includes: origin methodClass instanceSide ]
]

{ #category : #'private - exporting' }
GtGemStoneTopazExporter >> shouldExportPharoSourceOf: aMethod [
	^ (excludedMethods includes: aMethod) not
		and: [ (self shouldExportGsCodeOf: aMethod) not ]
]

{ #category : #'private - testing' }
GtGemStoneTopazExporter >> shouldExportPharoSourceOf: aMethod in: aBehavior [
	^ (self isExcludedMethod: aMethod in: aBehavior) not
		and: [ (self shouldExportGsCodeOf: aMethod in: aBehavior) not ]
]

{ #category : #accessing }
GtGemStoneTopazExporter >> stubClasses [
	^ stubClasses
]

{ #category : #accessing }
GtGemStoneTopazExporter >> stubClasses: aCollection [
	| gsClassNames newStubClasses |
	gsClassNames := self gemstoneClassNames.
	newStubClasses := Set new.
	aCollection do: [ :each |
		| aClass |
		aClass := self resolveClass: each.
		[ aClass notNil and: [ (gsClassNames includes: aClass name) not ] ]
			whileTrue: [
				newStubClasses add: aClass.
				aClass := aClass superclass ] ].
	stubClasses := newStubClasses asArray.
]

{ #category : #private }
GtGemStoneTopazExporter >> topazQuoted: aString [
	^ aString asString copyReplaceAll: '''' with: ''''''
]

{ #category : #'private - traits' }
GtGemStoneTopazExporter >> traitSlotNamesOf: aBehavior [
	| traitSlots |
	
	aBehavior hasTraitComposition ifFalse: [ ^ #() ].
	traitSlots := aBehavior isMeta
		ifTrue: [ aBehavior instanceSide traitComposition allTraits flatCollect:
			[ :trait | trait classSide slots ] ]
		ifFalse:[ aBehavior traitComposition slots ].
	^ traitSlots collect: [ :each | each name ]
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeApplyExtensionMethodsOn: aStream [
	aStream 
		<< 'run'; lf;
		<< 'GtGemStoneExtensionMethods apply.'; lf;
		<< 'true'; lf;
		<< '%'; lf; lf.
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeClassInitializationsFor: classes on: aStream [
	aStream << 'run'; lf.
	classes
		select: [ :each | each classSide methodDict includesKey: #initialize ]
		thenDo: [ :each |
			aStream
				<< each name;
				<< ' initialize.';
				lf ].
	aStream
		<< 'true'; lf;
		<< '%'; lf; lf.
]

{ #category : #'private - writing' }
GtGemStoneTopazExporter >> writeDefinitionOf: aClass on: aStream [
	| packageName superclass instanceVariables classInstanceVariables arrayFormatter definition |
	(self gemstoneClassNames includes: aClass name) ifTrue: [
		self error: aClass printString, ' must not be defined.' ].
	(stubClasses includes: aClass)
		ifTrue: [
			packageName := 'GToolkit-Stubs'.
			superclass := ((stubClasses includes: aClass superclass)
				and: [ (excludedClasses includes: aClass superclass) not ])
					ifTrue: [ aClass superclass ]
					ifFalse: [ Object ] ]
		ifFalse: [
			packageName := aClass package name.
			superclass := aClass superclass ].
	instanceVariables := self mergedSlotNames: aClass instVarNames withTraitsOf: aClass instanceSide.
	classInstanceVariables := self mergedSlotNames: aClass class instVarNames withTraitsOf: aClass classSide.
	arrayFormatter := [ :names | String streamContents: [ :stream |
		stream << '#('.
		names do: [ :each | stream space; << each asString ].
		stream nextPut: $) ] ].
	definition := String streamContents: [ :stream |
		stream
			<< superclass name;
			<< ' subclass: ''';
			<< aClass name;
			<< ''''; lf;
			<< '  instVarNames: ';
			<< (arrayFormatter value: instanceVariables); lf;
			<< '  classVars: ';
			<< (arrayFormatter value: aClass classVarNames); lf;
			<< '  classInstVars: ';
			<< (arrayFormatter value: classInstanceVariables); lf;
			<< '  poolDictionaries: #()'; lf;
			<< '  inDictionary: ';
			<< (GtpoMetaclass3 defaultDictionary value: aClass); lf;
			<< '  options: #()'; lf ].
	aStream
		<< 'doit'; lf;
		<< '('; << definition; << ') category: ''';
		<< (self topazQuoted: packageName); << ''';'; lf;
		<< '  immediateInvariant.'; lf;
		<< '%'; lf; lf
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeGsCodeFor: aMethod origin: originMethod pragma: aPragma targetBehavior: aBehavior on: aStream [
	| source pragmaNode prefix code className command |
	code := aPragma arguments first.
	code
		ifNil: [ source := aMethod sourceCode ]
		ifNotNil: [
			source := aMethod sourceCode.
			pragmaNode := aMethod ast pragmas
				detect: [ :each | each selector = #gsCode: ]
				ifNone: [ originMethod ast pragmas detect: [ :each | each selector = #gsCode: ] ].
			(pragmaNode stop <= source size)
				ifTrue: [ prefix := source copyFrom: 1 to: pragmaNode start - 1 ]
				ifFalse: [
					prefix := originMethod sourceCode copyFrom: 1 to: (originMethod ast pragmas
						detect: [ :each | each selector = #gsCode: ]) start - 1.
					aMethod selector = originMethod selector ifFalse: [
						prefix := (originMethod getSourceReplacingSelectorWith: aMethod selector)
							copyFrom: 1 to: prefix size + aMethod selector size - originMethod selector size ] ].
			source := prefix, code asString ].
	className := aBehavior instanceSide name.
	command := aBehavior isMeta ifTrue: [ 'classmethod: ' ] ifFalse: [ 'method: ' ].
	aStream
		<< 'category: '''; << (self topazQuoted: aMethod protocolName); << ''''; lf;
		<< command; << className; lf;
		<< source.
	(source endsWith: String lf) ifFalse: [ aStream lf ].
	aStream << '%'; lf; lf
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeGsCodeFor: aMethod pragma: aPragma on: aStream [
	| source className command |
	source := self class gemstoneSourceFor: aMethod.
	className := aMethod methodClass instanceSide name.
	command := aMethod methodClass isMeta
		ifTrue: [ 'classmethod: ' ]
		ifFalse: [ 'method: ' ].
	aStream
		<< 'category: ''';
		<< (self topazQuoted: aMethod protocolName);
		<< ''''; lf;
		<< command;
		<< className;
		lf;
		<< source.
	(source endsWith: String lf) ifFalse: [ aStream lf ].
	aStream << '%'; lf; lf
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeGsCodeMethodsOn: aStream [
	| classes |
	classes := self selectedClasses asSet.
	classes addAll: self gsCodeClassesForExport.
	classes do: [ :aClass |
		{ aClass instanceSide. aClass classSide } do: [ :aBehavior |
			((self effectiveMethodsOf: aBehavior) asSortedCollection: [ :left :right |
				left selector <= right selector ]) do: [ :method |
				(self shouldExportGsCodeOf: method in: aBehavior) ifTrue: [
					| origin pragma |
					origin := self originMethodOf: method in: aBehavior.
					pragma := self gsCodePragmaOf: origin.
					self writeGsCodeFor: method origin: origin pragma: pragma targetBehavior: aBehavior on: aStream ] ] ] ]
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeHeaderOn: aStream [
	aStream
		<< 'fileformat utf8'; lf;
		<< 'set sourcestringclass String'; lf;
		<< 'set compile_env: 0'; lf; lf
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeMethodRemovalsFor: aClass on: aStream [
	aStream
		<< 'removeallmethods ';
		<< aClass name;
		lf;
		<< 'removeallclassmethods ';
		<< aClass name;
		lf; lf
]

{ #category : #'private-writing' }
GtGemStoneTopazExporter >> writeMethodsOf: aClass on: aStream [
	self writeMethodsOf: aClass instanceSide topazClassName: aClass name command: 'method: ' on: aStream.
	self writeMethodsOf: aClass classSide topazClassName: aClass name command: 'classmethod: ' on: aStream
]

{ #category : #'private - writing' }
GtGemStoneTopazExporter >> writeMethodsOf: aBehavior topazClassName: aClassName command: aCommand on: aStream [
	| methods currentProtocol |
	methods := ((self effectiveMethodsOf: aBehavior) reject: [ :each |
		(self shouldExportPharoSourceOf: each in: aBehavior) not ])
		sorted: [ :left :right |
			left protocolName = right protocolName
				ifTrue: [ left selector <= right selector ]
				ifFalse: [ left protocolName <= right protocolName ] ].
	currentProtocol := nil.
	methods do: [ :method |
		currentProtocol = method protocolName ifFalse: [
			currentProtocol := method protocolName.
			aStream << 'category: '''; << (self topazQuoted: currentProtocol); << ''''; lf ].
		aStream
			<< aCommand; << aClassName; lf;
			<< method sourceCode; lf;
			<< '%'; lf; lf ]
]

{ #category : #exporting }
GtGemStoneTopazExporter >> writeTo: aFileReference [
	aFileReference ensureDelete.
	aFileReference writeStreamDo: [ :stream | 
		self writeTopazOn: (ZnNewLineWriterStream on: stream) ].
	^ aFileReference
]

{ #category : #writing }
GtGemStoneTopazExporter >> writeTopazOn: aStream [
	| classes |
	
	classes := self selectedClasses.
	self writeHeaderOn: aStream.
	self classesToDefine do: [ :each | self writeDefinitionOf: each on: aStream ].
	classes do: [ :each | self writeMethodRemovalsFor: each on: aStream ].
	classes do: [ :each | self writeMethodsOf: each on: aStream ].
	includeGsCodeMethods ifTrue: [ self writeGsCodeMethodsOn: aStream ].
	"self writeClassInitializationsFor: classes on: aStream."
	self writeApplyExtensionMethodsOn: aStream.
]
