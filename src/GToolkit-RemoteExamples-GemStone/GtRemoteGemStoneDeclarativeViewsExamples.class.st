Class {
	#name : #GtRemoteGemStoneDeclarativeViewsExamples,
	#superclass : #GtRemoteDeclarativeViewsExamples,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #private }
GtRemoteGemStoneDeclarativeViewsExamples >> computeStyledTextForTreeNumber: anInteger [
	| computedString|
	computedString := anInteger asString, ' number'.
	(anInteger \\ 2) = 0 
		ifTrue: [
			computedString := (GtPhlowText forString: computedString)
				bold;
				highlight: (GtPhlowColor named: #yellow) ].
	^ computedString
]

{ #category : #'accessing - expected' }
GtRemoteGemStoneDeclarativeViewsExamples >> expectedColumnedListTypedColumnsTwoItemsPharo11 [
	^ ((Array new: 2) at: 1 put: ((Dictionary new) add: (#nodeValue->((Dictionary new) add: (#columnValues->((Array new: 3) at: 1 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+1.0'); yourself); at: 2 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+2'); yourself); at: 3 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->#classIcon); yourself); yourself)); yourself)); add: (#nodeId->1); yourself); at: 2 put: ((Dictionary new) add: (#nodeValue->((Dictionary new) add: (#columnValues->((Array new: 3) at: 1 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+2.0'); yourself); at: 2 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->'+3'); yourself); at: 3 put: ((Dictionary new) add: (#valueTypeName->'textualValue'); add: (#itemText->#classIcon); yourself); yourself)); yourself)); add: (#nodeId->2); yourself); yourself)
]

{ #category : #'accessing - expected' }
GtRemoteGemStoneDeclarativeViewsExamples >> expectedStyledText [
	^ GtRemotePhlowDeclarativeTestInspectable new  
			styledPhlowTextForRemoteComparison
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

{ #category : #accessing }
GtRemoteGemStoneDeclarativeViewsExamples >> objectsForListWithStyledTextComparison [
	^ GtRemotePhlowDeclarativeTestInspectable new 
			objectsForListWithStyledTextForRemoteComparison
]

{ #category : #'accessing - expected' }
GtRemoteGemStoneDeclarativeViewsExamples >> printForString [
	^ 'aGtRemotePhlowDeclarativeTestInspectable'
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

{ #category : #private }
GtRemoteGemStoneDeclarativeViewsExamples >> shouldConvertUsingDisplayTextObject: anObject [ 
	"When dealing with a remote GemStone installation phlow text is the
	normal text. So when preparing values for comparing them with remote
	values, we should keep the phlow text objects as they are."
	^ (anObject isString or: [anObject class = GtPhlowRunBasedText]) not
]

{ #category : #tests }
GtRemoteGemStoneDeclarativeViewsExamples >> testInspectableName [
	"Answer the name of the test inspectable class on the remote"

	^ #GtRemotePhlowDeclarativeTestInspectable
]
