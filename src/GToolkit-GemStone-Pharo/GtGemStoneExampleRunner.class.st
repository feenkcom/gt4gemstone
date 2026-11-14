"
Run a specified list of SUnit tests and gtExamples.  This provides a convenience mechanism to run a set of SUnit tests and examples that are expected to pass when GT.gs has been loaded in to the GemStone database.

Lives in GT; discovery and execution take place in the supplied GemStone session. Does not commit or abort the session. Inspect summary and non-passing GemStone method editors. Send select before inspecting an unrun selection, or run to select and execute afresh.
"
Class {
	#name : #GtGemStoneExampleRunner,
	#superclass : #Object,
	#instVars : [
		'session',
		'remoteSelection',
		'records'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #'instance creation' }
GtGemStoneExampleRunner class >> on: aSession [
	^ self new session: aSession
]

{ #category : #'gt - views' }
GtGemStoneExampleRunner >> gtNotPassedMethodsFor: aView [
	"Which selected tests and examples have not passed, and how can I edit their GemStone methods? Includes skipped and unrun methods."

	<gtView>
	^ aView explicit
		title: 'Failures & Errors';
		priority: 20;
		stencil: [ self notPassedCoders asElement ]
]

{ #category : #'gt - views' }
GtGemStoneExampleRunner >> gtResultsFor: aView [
	"What is the outcome of every selected method?"

	<gtView>
	^ aView columnedList
		title: 'Results';
		priority: 30;
		items: [ records ];
		column: 'Kind' text: #first;
		column: 'Class' text: #second;
		column: 'Selector' text: #third;
		column: 'Status' text: #fourth
]

{ #category : #'gt - views' }
GtGemStoneExampleRunner >> gtSummaryFor: aView [
	"How many tests and examples were selected, executed and classified?"

	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 10;
		items: [ self summary ];
		column: 'Kind' text: [ :row | row first ];
		column: 'Selected' text: [ :row | row second ];
		column: 'Run' text: [ :row | row third ];
		column: 'Passed' text: [ :row | row fourth ];
		column: 'Failed' text: [ :row | row fifth ];
		column: 'Errors' text: [ :row | row sixth ];
		column: 'Skipped' text: [ :row | row seventh ];
		column: 'Not run' text: [ :row | row eighth ];
		column: 'Other' text: [ :row | row ninth ]
]

{ #category : #initialization }
GtGemStoneExampleRunner >> initialize [
	super initialize.
	records := #()
]

{ #category : #accessing }
GtGemStoneExampleRunner >> notPassed [
	^ records reject: [ :row | row fourth = 'Passed' ]
]

{ #category : #accessing }
GtGemStoneExampleRunner >> notPassedCoders [
	| specifications |
	remoteSelection
		ifNil: [ ^ GtGemStoneMethodCodersModel
				forMethodSpecifications: (GtGemStoneMethodsSpecification forGsMethods: #())
				inSession: self session ].
	specifications := self session
			evaluateBlockAndWaitReturnProxy: [ :selection | 
				| methods |
				methods := (selection reject: [ :entry | entry third = 'Passed' ])
						collect: [ :entry | 
							| item |
							item := entry second.
							entry first = 'Test'
								ifTrue: [ item class lookupSelector: item selector ]
								ifFalse: [ item method ] ].
				GtGemStoneMethodsSpecification forGsMethods: methods ]
			withArguments: {remoteSelection}.
	^ GtGemStoneMethodCodersModel
		forMethodSpecifications: (GtGemStoneMethodsSpecification
				fromJsonString: (specifications proxyPerform: #asJsonForExport))
		inSession: self session
]

{ #category : #accessing }
GtGemStoneExampleRunner >> records [
	^ records
]

{ #category : #running }
GtGemStoneExampleRunner >> refresh [
	"Answer rows sorted by class name, then selector."

	records := self session
			evaluateBlockAndWait: [ :selection | 
				((selection asArray
					collect: [ :entry | 
						| item |
						item := entry at: 2.
						{entry first.
							(entry first = 'Test'
								ifTrue: [ item class name ]
								ifFalse: [ item methodClass name ]) asString.
							item selector asString.
							entry third} ])
					asSortedCollection: [ :a :b | a second < b second or: [ a second = b second and: [ a third <= b third ] ] ])
					asArray ]
			withArguments: {remoteSelection}.
	^ self
]

{ #category : #running }
GtGemStoneExampleRunner >> run [
	self select.
	^ self runSelected
]

{ #category : #running }
GtGemStoneExampleRunner >> runSelected [
	remoteSelection ifNil: [ self select ].
	[ self session
		evaluateBlockAndWait: [ :selection | 
			selection
				do: [ :entry | 
					| item result |
					item := entry at: 2.
					entry first = 'Test'
						ifTrue: [ result := item run.
							entry
								at: 3
								put: (result hasErrors
										ifTrue: [ 'Error' ]
										ifFalse: [ result hasFailures ifTrue: [ 'Failed' ] ifFalse: [ 'Passed' ] ]) ]
						ifFalse: [ item ignoreTest
								ifTrue: [ entry at: 3 put: 'Skipped' ]
								ifFalse: [ item run.
									entry
										at: 3
										put: (item isSuccess
												ifTrue: [ 'Passed' ]
												ifFalse: [ item isFailure
														ifTrue: [ 'Failed' ]
														ifFalse: [ item isError ifTrue: [ 'Error' ] ifFalse: [ 'Other' ] ] ]) ] ] ].
			nil ]
		withArguments: {remoteSelection} ] ensure: [ self refresh ].
	^ self
]

{ #category : #running }
GtGemStoneExampleRunner >> select [
	"Keep executable objects in GemStone, not serialized copies in GT."

	remoteSelection := self session
			evaluateBlockAndWaitReturnProxy: [ | classes exampleClasses selection |
				selection := OrderedCollection new.
				classes := ((ClassOrganizer gtDefault allSubclassesOf: TestCase)
						select: [ :each | each category = 'Neo-JSON-Tests' and: [ each isAbstract not ] ])
						asSet.
				classes
					add: OrderedDictionaryTest;
					add: RectangleTest.
				classes
					do: [ :each | 
						each buildSuiteFromSelectors tests
							do: [ :test | 
								selection
									add: {'Test'.
											test.
											'Not run'} ] ].
				exampleClasses := OrderedCollection new.
				(ClassOrganizer gtDefault
					classNamesInClassCategoryNamed: 'Gt4LlmCore-Examples'
					dictionaryName: nil)
					do: [ :name | 
						(name beginsWith: 'GtMagritte')
							ifTrue: [ exampleClasses add: name asSymbol asClass ] ].
				(ClassOrganizer gtDefault
					classNamesInClassCategoryNamed: 'GToolkit4Magritte-Examples'
					dictionaryName: nil)
					do: [ :name | exampleClasses add: name asSymbol asClass ].
				exampleClasses
					addAll: {
							GtLMagritteToolForMethodSourceExamples.
							GtLMagritteToolForMethodsSourceExamples.
							}.
				exampleClasses
					do: [ :each | 
						(GtExampleGroup withAll: each gtExamples) examples
							do: [ :example | 
								selection
									add: {'Example'.
											example.
											'Not run'} ] ].
				selection ].
	self refresh.
	^ self
]

{ #category : #accessing }
GtGemStoneExampleRunner >> session [
	^ session ifNil: [ session := GtGemStoneSessionRegistry defaultSession ]
]

{ #category : #accessing }
GtGemStoneExampleRunner >> session: aSession [
	session := aSession.
	remoteSelection := nil.
	records := #()
]

{ #category : #accessing }
GtGemStoneExampleRunner >> summary [
	^ #('Test' 'Example' 'Total')
		collect: [ :kind | 
			| selected count |
			selected := kind = 'Total'
					ifTrue: [ records ]
					ifFalse: [ records select: [ :row | row first = kind ] ].
			count := [ :status | selected count: [ :row | row fourth = status ] ].
			{kind.
				selected size.
				selected size - (count value: 'Not run') - (count value: 'Skipped').
				count value: 'Passed'.
				count value: 'Failed'.
				count value: 'Error'.
				count value: 'Skipped'.
				count value: 'Not run'.
				count value: 'Other'} ]
]
