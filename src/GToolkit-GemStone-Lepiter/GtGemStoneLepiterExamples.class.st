Class {
	#name : #GtGemStoneLepiterExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'GToolkit-GemStone-Lepiter-Examples'
}

{ #category : #examples }
GtGemStoneLepiterExamples >> openPageNoProperties [
	"Check that opening a page that references a GS database when there is no properties file doesn't raise an error"

	<gtExample>
	<return: #GtGemStoneLepiterExamples>
	| snippet registry viewModel |
	registry := GtGemStoneSessionRegistry new.
	snippet := (LeGemStoneSnippet sessionName: 'nonExistentConnector:1')
			code: '4+3'.

	viewModel := snippet asSnippetViewModel.
	viewModel gemstoneSessionRegistry: registry.
	self shouldnt: [ viewModel updateGemstoneSession ] raise: Error
]

{ #category : #'examples - refactoring' }
GtGemStoneLepiterExamples >> renameMethodUpdatesSnippet [
	<gtExample>
	| scripter snippet newDb folderReference localStore page refactoring oldSelector newSelector |
	oldSelector := 'zzzfactorialzzz' asSymbol.
	newSelector := (oldSelector , '111') asSymbol.
	SmallInteger compile: oldSelector , ' ^ self factorial' classified: #examples.
	[ folderReference := FileSystem memory / 'storage-secondary'.
	folderReference ensureCreateDirectory.

	localStore := LeLocalStoreLoad current.
	localStore localRoot: folderReference.
	newDb := localStore loadAndMonitorFrom: folderReference.

	page := newDb pageBuilder
			title: 'GemStone snippet';
			add.
	snippet := LeGemStoneSnippet withDefaultSessionIdentifier
			code: '10 zzzfactorialzzz'.
	page addSnippet: snippet.

	LeDatabasesRegistry uniqueInstance defaultLogicalDatabase addDB: newDb.

	[ scripter := BlScripter new.
	scripter
		substep: 'Initialize Coder Model and UI'
		do: [ :aStep | 
			aStep set
				label: 'Initialize Coder Model';
				model: [ page asContentUIModel ];
				play.
			aStep set
				label: 'Initialize Coder UI';
				element: [ :each | 
					LePageToolContentTreeElement new
						pageViewModel: each;
						matchParent ];
				onModel;
				play ].

	scripter do 
		label: 'Execute refactoring';
		block: [
			refactoring := GtRBRenameMethodRefactoring
				renameMethod: oldSelector
				in: SmallInteger
				to: newSelector
				permutation: #().
		refactoring execute ];
		play.

	scripter
		assertStep: [ :s | 
			s
				// GtSourceCoderEditorId;
				value: [ :each | each text asString ] equals: '10 ' , newSelector ].
	^ scripter ]
		ensure: [ LeDatabasesRegistry uniqueInstance defaultLogicalDatabase removeDB: newDb ] ]
		ensure: [ SmallInteger
				removeSelector: oldSelector;
				removeSelector: newSelector ]
]

{ #category : #'examples - refactoring' }
GtGemStoneLepiterExamples >> renameMethodUpdatesSnippet_outsideOfUIProcess [
	<gtExample>
	| scripter snippet newDb folderReference localStore page refactoring oldSelector newSelector |
	oldSelector := 'zzzfactorialzzz' asSymbol.
	newSelector := (oldSelector , '111') asSymbol.
	SmallInteger compile: oldSelector , ' ^ self factorial' classified: #examples.
	[ folderReference := FileSystem memory / 'storage-secondary'.
	folderReference ensureCreateDirectory.

	localStore := LeLocalStoreLoad current.
	localStore localRoot: folderReference.
	newDb := localStore loadAndMonitorFrom: folderReference.

	page := newDb pageBuilder
			title: 'GemStone snippet';
			add.
	snippet := LeGemStoneSnippet withDefaultSessionIdentifier
			code: '10 zzzfactorialzzz'.
	page addSnippet: snippet.

	LeDatabasesRegistry uniqueInstance defaultLogicalDatabase addDB: newDb.

	[ scripter := BlScripter new.
	scripter
		substep: 'Initialize Coder Model and UI'
		do: [ :aStep | 
			aStep set
				label: 'Initialize Coder Model';
				model: [ page asContentUIModel ];
				play.
			aStep set
				label: 'Initialize Coder UI';
				element: [ :each | 
					LePageToolContentTreeElement new
						pageViewModel: each;
						matchParent ];
				onModel;
				play ].

	scripter do 
		label: 'Execute refactoring';
		block: [ :anElement |
			| aPromise |
			aPromise := [
				refactoring := GtRBRenameMethodRefactoring
					renameMethod: oldSelector
					in: SmallInteger
					to: newSelector
					permutation: #().
				refactoring execute ] asAsyncFuture await: GtRefactoringsConstants futureExecutionConfiguration.
			 anElement enqueueTask: (BlPromiseTask new promise: aPromise) ];
		play.

	scripter
		assertStep: [ :s | 
			s
				// GtSourceCoderEditorId;
				value: [ :each | each text asString ] equals: '10 ' , newSelector ].
	^ scripter ]
		ensure: [ LeDatabasesRegistry uniqueInstance defaultLogicalDatabase removeDB: newDb ] ]
		ensure: [ SmallInteger
				removeSelector: oldSelector;
				removeSelector: newSelector ]
]
