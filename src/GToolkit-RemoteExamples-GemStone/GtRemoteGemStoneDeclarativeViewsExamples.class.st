Class {
	#name : #GtRemoteGemStoneDeclarativeViewsExamples,
	#superclass : #GtRemotePhlowDeclarativeViewsExamples,
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
GtRemoteGemStoneDeclarativeViewsExamples >> expectedNodesForRawView [
	^ {
		GtRemotePhlowColumnedTreeNode new
			nodeId: 1;
			nodeValue: (GtRemotePhlowRowValue new 
				columnValues: {
					GtRemotePhlowItemTextualValue new 
						itemText: 'classIcon'.
					GtRemotePhlowItemTextualValue new 
						itemText: 'self'.
					GtRemotePhlowItemTextualValue new 
						itemText: 'aGtRemotePhlowDeclarativeTestInspectable'}).
		GtRemotePhlowColumnedTreeNode new
			nodeId: 2;
			nodeValue: (GtRemotePhlowRowValue new 
				columnValues: {
					GtRemotePhlowItemTextualValue new 
						itemText: 'stringIcon'.
					GtRemotePhlowItemTextualValue new 
						itemText: 'string'.
					GtRemotePhlowItemTextualValue new 
						itemText: 'hello world'}).
	GtRemotePhlowColumnedTreeNode new
			nodeId: 3;
			nodeValue: (GtRemotePhlowRowValue new 
				columnValues: {
					GtRemotePhlowItemTextualValue new 
						itemText: 'collectionIcon'.
					GtRemotePhlowItemTextualValue new 
						itemText: 'collectionOfObjects'.
					GtRemotePhlowItemTextualValue new 
						itemText: 'anArray( 42, ''Hello World'', 2021-04-06T14:43:50.123456+02:00)'}) }
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

{ #category : #'examples - views' }
GtRemoteGemStoneDeclarativeViewsExamples >> rawView [
	<gtExample>
	<after: #stopServer>
	| viewedObjectProxy viewDictionary viewSpecification viewDatasource obtainedNodes |

	viewedObjectProxy := self viewedObjectProxy.
	viewDictionary :=  viewedObjectProxy getViewDeclaration: #gtRawFor:.
	viewSpecification := GtPhlowViewSpecification fromDictionary: viewDictionary.
	
	self assert: viewSpecification title equals: #Raw.
	self 
		assert: viewSpecification columnTitles 
		equals: {'Icon' . 'Variable' . 'Value'}.
	self assert: viewSpecification columnWidths equals: #(36 nil nil).
	self 
		assert: (viewSpecification columnTypes collect: #typeLabel) 
		equals: #(#icon #text #text).
	self 
		assert: viewSpecification dataTransport 
		equals: GtPhlowViewSpecification dataLazy.
	
	viewDatasource := viewedObjectProxy getDeclarativeViewFor: #gtRawFor:.
	
	obtainedNodes := self 
		assertNodesInViewDatasource: viewDatasource 
		ofType: GtRemotePhlowColumnedTreeNode
		equalNodes: self expectedNodesForRawView.
	
	^ viewSpecification
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
