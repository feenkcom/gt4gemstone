Class {
	#name : #GtGemStoneSessionsCardWidgetByScripterExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtGemStoneSessionsCardWidgetByScripterExamples >> cardCellsAreAlignedWithTheirHeaders [
	<gtExample>
	<return: #BlScripter>
	| keepAliveExamples registry aScripter |

	keepAliveExamples := GtGemStoneSessionKeepAliveExamples new.
	registry := keepAliveExamples emptyRegistry.
	keepAliveExamples
		connectSessionWith: (keepAliveExamples connectorNamed: 'aligned')
		to: registry.
	aScripter := BlScripter new.
	aScripter extent: 325 @ 150.
	aScripter
		model: registry;
		element: (GtGemStoneSessionsCardWidget new
			registry: registry;
			matchParent;
			yourself).
	aScripter wait forEmptySpaceTaskQueue; play.
	aScripter assertStep: [ :s |
		s
			label: 'Assert the cells start where their column headers start';
			satisfies: [ :aCard |
				| headerStarts |
				headerStarts := self headerStartsIn: aCard sessionList.
				headerStarts size = 3 and: [
					(self rowCellStartsIn: aCard sessionList) = headerStarts ] ] ].
	^ aScripter

]

{ #category : #examples }
GtGemStoneSessionsCardWidgetByScripterExamples >> cardMarksTheSessionsPendingLogout [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self scripterOnCardWithSessionsInDifferentStates.
	aScripter assertStep: [ :s |
		s
			label: 'Assert that only the rows pending logout are marked';
			value: [ :aCard |
				((aCard sessionList query // #scrollable) anyOne children collect: [ :aRow |
					(aRow userData at: #gtGemStoneLogoutPendingRowAptitude) isLogoutPending ]) asArray ]
			equals: #(true false true) ].
	aScripter assertStep: [ :s |
		s
			label: 'Assert the orange background of a row pending logout';
			value: [ :aCard |
				((aCard sessionList query // #scrollable) anyOne children first) background paint color ]
			equals: GtGemStoneLogoutPendingRowAptitude backgroundColor ].
	^ aScripter

]

{ #category : #examples }
GtGemStoneSessionsCardWidgetByScripterExamples >> cardOffersToPostponeTheLogout [
	<gtExample>
	<return: #BlScripter>
	| aScripter card registry pending changedAndPending labels |

	aScripter := self scripterOnCardWithSessionsInDifferentStates.
	card := aScripter element.
	registry := aScripter model.
	pending := registry activeSessions detect: [ :each | each name = 'pending:default' ].
	changedAndPending := registry activeSessions detect: [ :each |
		each name = 'changed-pending:default' ].
	labels := ((card sessionActionsFor: pending) items collect: #key) asArray.
	self
		assert: (labels indexOf: 'Postpone logout')
		equals: (labels indexOf: 'Disconnect') + 1.
	self assert: (((card sessionActionsFor: changedAndPending) items collect: #key)
		includes: 'Postpone logout') not.
	((card sessionActionsFor: pending) items detect: [ :each | each key = 'Postpone logout' ])
		value cull: card.
	self assert: pending keepAlive isPostponed.
	self assert: pending isLogoutPending not.
	aScripter wait forEmptySpaceTaskQueue; play.
	aScripter assertStep: [ :s |
		s
			label: 'Assert that the postponed session is no longer marked';
			value: [ :aCard |
				((aCard sessionList query // #scrollable) anyOne children collect: [ :aRow |
					(aRow userData at: #gtGemStoneLogoutPendingRowAptitude) isLogoutPending ]) asArray ]
			equals: #(true false false) ].
	^ aScripter

]

{ #category : #private }
GtGemStoneSessionsCardWidgetByScripterExamples >> headerStartsIn: aSessionList [

	^ ((aSessionList query // #'column-header' // BrLabel) result collect: [ :aLabel |
		(aLabel bounds inParent: aSessionList) left ]) asArray

]

{ #category : #private }
GtGemStoneSessionsCardWidgetByScripterExamples >> rowCellStartsIn: aSessionList [
	| firstRow |

	firstRow := (aSessionList query // #scrollable) anyOne children first.
	^ (firstRow children collect: [ :aCell |
		(aCell bounds inParent: aSessionList) left ]) asArray

]

{ #category : #private }
GtGemStoneSessionsCardWidgetByScripterExamples >> scripterOnCardWithSessionsInDifferentStates [
	| registry aScripter |

	registry := GtGemStoneSessionKeepAliveExamples new
		notificationWithSessionsInDifferentStates keepAlive registry.
	aScripter := BlScripter new.
	aScripter extent: 325 @ 150.
	aScripter
		model: registry;
		element: (GtGemStoneSessionsCardWidget new
			registry: registry;
			matchParent;
			yourself).
	aScripter wait forEmptySpaceTaskQueue; play.
	^ aScripter

]
