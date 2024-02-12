Class {
	#name : #GtRemoteGemStoneDeclarativeViewsExamples,
	#superclass : #GtRemoteDeclarativeViewsExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemoteGemStoneDeclarativeViewsExamples >> expectedColumnedListTypedColumnsTwoItemsPharo11 [
	^ ((Array new: 2) at: 1 put: ((Dictionary new) add: (#nodeValue->((Dictionary new) add: (#columnValues->((Array new: 3) at: 1 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+1.0'); yourself); at: 2 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+2'); yourself); at: 3 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->#classIcon); yourself); yourself)); yourself)); add: (#nodeId->1); yourself); at: 2 put: ((Dictionary new) add: (#nodeValue->((Dictionary new) add: (#columnValues->((Array new: 3) at: 1 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+2.0'); yourself); at: 2 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+3'); yourself); at: 3 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->#classIcon); yourself); yourself)); yourself)); add: (#nodeId->2); yourself); yourself)
]

{ #category : #accessing }
GtRemoteGemStoneDeclarativeViewsExamples >> expectedNumberOfRunsForBasicStyledText [
	^ 8
]

{ #category : #private }
GtRemoteGemStoneDeclarativeViewsExamples >> getRemoteObject [

	^ self runningServer evaluateAndWait: self remoteObjectCommand
]

{ #category : #private }
GtRemoteGemStoneDeclarativeViewsExamples >> getViewedObjectProxy [
	"Answer the GtViewedObject proxy for the remote object"
	
	self remoteObject viewProxyDo: [ :aProxy | ^ aProxy ].
]

{ #category : #'private - commands' }
GtRemoteGemStoneDeclarativeViewsExamples >> listViewDisplayArray [
	"Answer the command Array returned by the remote's list view"

	^ #('42' 'Hello World' '2021-04-06T14:43:49.623384+02:00')
]

{ #category : #'private - commands' }
GtRemoteGemStoneDeclarativeViewsExamples >> remoteObjectCommand [
	"Answer the command to retrieve the test inspectable from the remote"

	^ self testInspectableName, ' new'
]

{ #category : #private }
GtRemoteGemStoneDeclarativeViewsExamples >> runningServer [
	"Answer a running server."
	<gtExample>
	<after: #stopServer>

	server ifNotNil: [ ^ server ].
	^ server := GtRemoteGemstoneExamplesSessionBuilder createAndStartSession
]

{ #category : #tests }
GtRemoteGemStoneDeclarativeViewsExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ #GtRemotePhlowDeclarativeTestInspectable
]
