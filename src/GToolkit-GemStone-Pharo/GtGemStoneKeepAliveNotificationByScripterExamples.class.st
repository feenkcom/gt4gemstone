Class {
	#name : #GtGemStoneKeepAliveNotificationByScripterExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> abortFromTheContextMenu [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self contextMenuOfAChangedSessionPendingLogout.
	self clickMenuItemLabeled: 'Abort' in: aScripter.
	self
		assertRowsIn: aScripter
		equal: #(
			#('changed:default' 'Changed')
			#('pending:default' 'Logout pending')
			#('changed-pending:default' 'Logout pending')).
	^ aScripter

]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> assertRowsIn: aScripter equal: anArray [

	aScripter assertStep: [ :s |
		s
			label: 'Assert the session rows';
			// BrColumnedList;
			value: [ :aList | self rowTextsIn: aList ]
			equals: anArray ]

]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> clickMenuItemLabeled: aString in: aScripter [

	aScripter menuStep
		clickMenuItemWithLabel: aString;
		onMenuContainer;
		play.
	aScripter wait
		forEmptySpaceTaskQueue;
		play

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> commitFromTheContextMenu [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self contextMenuOfAChangedSession.
	self clickMenuItemLabeled: 'Commit' in: aScripter.
	self
		assertRowsIn: aScripter
		equal: #(
			#('pending:default' 'Logout pending')
			#('changed-pending:default' 'Changed, logout pending')).
	^ aScripter

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> contextMenuOfAChangedSession [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self notificationShowsTheSessionsAndTheirStatus.
	self openContextMenuOfSessionNamed: 'changed:default' in: aScripter.
	aScripter menuStep
		assertMenuItemLabels: #('Disconnect' 'Commit' 'Abort' 'Inspect');
		play.
	^ aScripter

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> contextMenuOfAChangedSessionPendingLogout [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self notificationShowsTheSessionsAndTheirStatus.
	self openContextMenuOfSessionNamed: 'changed-pending:default' in: aScripter.
	aScripter menuStep
		assertMenuItemLabels: #('Disconnect' 'Commit' 'Abort' 'Be Default' 'Inspect' 'Logout now');
		play.
	^ aScripter

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> contextMenuOfAPostponableSession [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self notificationShowsTheSessionsAndTheirStatus.
	self openContextMenuOfSessionNamed: 'pending:default' in: aScripter.
	aScripter menuStep
		assertMenuItemLabels: #('Disconnect' 'Commit' 'Abort' 'Be Default' 'Inspect' 'Postpone logout for 15 minutes' 'Logout now');
		play.
	^ aScripter

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> disconnectFromTheContextMenu [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self contextMenuOfAChangedSession.
	self clickMenuItemLabeled: 'Disconnect' in: aScripter.
	self
		assertRowsIn: aScripter
		equal: #(
			#('pending:default' 'Logout pending')
			#('changed-pending:default' 'Changed, logout pending')).
	self assert: aScripter model keepAlive loggedOutConnections isEmpty.
	^ aScripter

]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> headerStartsIn: aSessionList [

	^ ((aSessionList query // #'column-header' // BrLabel) result collect: [ :aLabel |
		(aLabel bounds inParent: aSessionList) left ]) asArray

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> logoutNowFromTheContextMenu [
	<gtExample>
	<return: #BlScripter>
	| aScripter loggedOutConnections |

	aScripter := self contextMenuOfAChangedSessionPendingLogout.
	self clickMenuItemLabeled: 'Logout now' in: aScripter.
	self
		assertRowsIn: aScripter
		equal: #(
			#('changed:default' 'Changed')
			#('pending:default' 'Logout pending')).
	loggedOutConnections := aScripter model keepAlive loggedOutConnections.
	self assert: loggedOutConnections size equals: 1.
	self assert: loggedOutConnections first disconnectionReason hadUncommittedChanges.
	self
		assert: loggedOutConnections first disconnectionReason causeDescription
		equals: 'Logged out by the user'.
	^ aScripter

]

{ #category : #'examples - sessions' }
GtGemStoneKeepAliveNotificationByScripterExamples >> notificationCellsAreAlignedWithTheirHeaders [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self notificationShowsTheSessionsAndTheirStatus.
	aScripter assertStep: [ :s |
		s
			label: 'Assert the cells start where their column headers start';
			// BrColumnedList;
			satisfies: [ :aList |
				| headerStarts |
				headerStarts := self headerStartsIn: aList.
				headerStarts size = 2 and: [
					(self rowCellStartsIn: aList) = headerStarts ] ] ].
	^ aScripter

]

{ #category : #'examples - sessions' }
GtGemStoneKeepAliveNotificationByScripterExamples >> notificationShowsTheSessionsAndTheirStatus [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self scripterOnNotification: GtGemStoneSessionKeepAliveExamples new
		notificationWithSessionsInDifferentStates.
	self
		assertRowsIn: aScripter
		equal: #(
			#('changed:default' 'Changed')
			#('pending:default' 'Logout pending')
			#('changed-pending:default' 'Changed, logout pending')).
	aScripter assertStep: [ :s |
		s
			label: 'Assert the logout warning';
			satisfies: [ :anElement |
				anElement descriptionEditor text asString
					includesSubstring: 'will be logged out at the next keep alive check' ] ].
	^ aScripter

]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> openContextMenuOfSessionNamed: aString in: aScripter [

	aScripter menuStep
		label: 'Open the context menu of ' , aString;
		openContextMenu;
		// BrColumnedList;
		// BrLabel;
		@ [ :aLabel | aLabel text asString = aString ];
		play

]

{ #category : #'examples - context menu' }
GtGemStoneKeepAliveNotificationByScripterExamples >> postponeFromTheContextMenu [
	<gtExample>
	<return: #BlScripter>
	| aScripter pending |

	aScripter := self contextMenuOfAPostponableSession.
	self clickMenuItemLabeled: 'Postpone logout for 15 minutes' in: aScripter.
	pending := aScripter model sessions detect: [ :each |
		each name = 'pending:default' ].
	self assert: pending keepAlive isPostponed.
	self
		assertRowsIn: aScripter
		equal: (Array
			with: #('changed:default' 'Changed')
			with: #('pending:default' 'Logout postponed')
			with: #('changed-pending:default' 'Changed, logout pending')).
	^ aScripter


]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> rowCellStartsIn: aSessionList [
	| firstRow |

	firstRow := (aSessionList query // #scrollable) anyOne children first.
	^ ((firstRow query // BrLabel) result collect: [ :aLabel |
		(aLabel bounds inParent: aSessionList) left ]) asArray

]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> rowTextsIn: aSessionList [

	^ ((aSessionList query // #scrollable) anyOne children collect: [ :aRow |
		((aRow query // BrLabel) result collect: [ :aLabel |
			aLabel text asString ]) asArray ]) asArray

]

{ #category : #private }
GtGemStoneKeepAliveNotificationByScripterExamples >> scripterOnNotification: aNotification [
	| aScripter |

	aScripter := BlScripter new.
	aScripter extent: 500 @ 400.
	aScripter
		model: aNotification;
		element: aNotification asElement.
	^ aScripter

]

{ #category : #'examples - notification' }
GtGemStoneKeepAliveNotificationByScripterExamples >> sessionsPendingLogoutHaveAnOrangeBackground [
	<gtExample>
	<return: #BlScripter>
	| aScripter |

	aScripter := self notificationShowsTheSessionsAndTheirStatus.
	aScripter assertStep: [ :s |
		s
			label: 'Assert that only the rows pending logout are marked';
			// BrColumnedList;
			value: [ :aList |
				((aList query // #scrollable) anyOne children collect: [ :aRow |
					(aRow userData at: #gtGemStoneLogoutPendingRowAptitude) isLogoutPending ]) asArray ]
			equals: #(false true true) ].
	aScripter assertStep: [ :s |
		s
			label: 'Assert the orange background of a row pending logout';
			// BrColumnedList;
			value: [ :aList |
				((aList query // #scrollable) anyOne children at: 2) background paint color ]
			equals: GtGemStoneLogoutPendingRowAptitude backgroundColor ].
	^ aScripter

]
