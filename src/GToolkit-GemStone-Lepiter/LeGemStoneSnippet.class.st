Class {
	#name : #LeGemStoneSnippet,
	#superclass : #LeCodeSnippet,
	#instVars : [
		'sessionName',
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : #'api - accessing menu' }
LeGemStoneSnippet class >> contextMenuItemSpecification [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: 'GemStone'
]

{ #category : #'lepiter-store' }
LeGemStoneSnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#sessionName -> #sessionName);
		yourself
]

{ #category : #'lepiter-store' }
LeGemStoneSnippet class >> leJsonV4Name [

	^ 'gemstoneSnippet'
]

{ #category : #visiting }
LeGemStoneSnippet >> acceptVisitor: aVisitor [

	^ aVisitor visitGemStoneSnippet: self
]

{ #category : #accessing }
LeGemStoneSnippet >> additionalStateForCopying [

	^ super additionalStateForCopying
		attributeNamed: #sessionName setValue: sessionName
]

{ #category : #converting }
LeGemStoneSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeGemStoneSnippetViewModel new snippetModel: self
]

{ #category : #accessing }
LeGemStoneSnippet >> connectorName: aString [
	"Deprecated, provided for old snippets that are serialised."

	self sessionName: aString, ':1'.
]

{ #category : #initialization }
LeGemStoneSnippet >> newCoder [
	^ GtGemStoneSnippetCoderModel new
]

{ #category : #accessing }
LeGemStoneSnippet >> sessionName [

	^ sessionName
]

{ #category : #accessing }
LeGemStoneSnippet >> sessionName: aString [

	sessionName := aString.
	self updateEditTimeAndEmail.
	self announceContentChanged.
]
