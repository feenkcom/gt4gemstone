Class {
	#name : #GtGemStoneSessionsCardWidgetExamples,
	#superclass : #Object,
	#instVars : [
		'theSessionRegistry'
	],
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'tear down' }
GtGemStoneSessionsCardWidgetExamples >> clearGemStoneRegistry [
	theSessionRegistry ifNil: [ ^ self ].
	
	theSessionRegistry sessions copy do: [ :aSession | aSession close ]
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionsCardWidgetExamples >> createSessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	| registry |

	registry := GtGemStoneSessionRegistry new.
	self assert: registry activeSessions size equals: 0.
	
	^ registry
]

{ #category : #'building elements' }
GtGemStoneSessionsCardWidgetExamples >> createSessionsWidget [
	<gtExample>
	^ GtGemStoneSessionsCardWidget new
		size: 325 @ 150;
		registry: self sessionRegistryWithTestConnectors
]

{ #category : #examples }
GtGemStoneSessionsCardWidgetExamples >> emptySessionWidget [
	<gtExample>
	| scripter |
	
	scripter := BlScripter new.
	scripter element: self createSessionsWidget.
	
	scripter checkStep: [ :aStep |
		aStep
			//GtGemStoneSessionsCardWidgetAddSessionButtonId;
			exists ].
	scripter checkStep: [ :aStep |
		aStep
			//GtGemStoneSessionsCardWidgetRefreshButtonId;
			exists ].
	scripter checkStep: [ :aStep |
		aStep
			//GtGemStoneSessionsCardWidgetInspectButtonId;
			exists ].
	
	scripter checkStep: [ :aStep |
		aStep
			// GtPhlowLabelWithIcon
			// #nameLabel;
			value: [ :aLabel | aLabel text asString] equals: 'No Sessions' ].
	
	^ scripter
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionsCardWidgetExamples >> sessionRegistry [
	"Answer an empty session registry"
	<gtExample>
	<after: #clearGemStoneRegistry>
	
	^ theSessionRegistry ifNil: [
		theSessionRegistry := self createSessionRegistry ]
]

{ #category : #'examples - setup/tear down' }
GtGemStoneSessionsCardWidgetExamples >> sessionRegistryWithTestConnectors [
	"Answer an empty session registry"
	<gtExample>
	| registry connectorA connectorB |
	registry := self sessionRegistry.
	
	connectorA := GtRemoteGemstoneExamplesSessionBuilder 
	 	createConnectorNamed: 'testA'.
	registry connectors 
		at: connectorA name
		put: connectorA.
	
	connectorB := GtRemoteGemstoneExamplesSessionBuilder 
	 	createConnectorNamed: 'testB'.
	registry connectors 
		at: connectorB name
		put: connectorB.
		
	^ registry
]
