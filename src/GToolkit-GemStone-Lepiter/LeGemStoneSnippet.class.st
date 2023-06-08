Class {
	#name : #LeGemStoneSnippet,
	#superclass : #LeCodeSnippet,
	#instVars : [
		'connectorName'
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
		add: (#connectorName -> #connectorName);
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
		attributeNamed: #connectorName setValue: connectorName
]

{ #category : #converting }
LeGemStoneSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeGemStoneSnippetViewModel new snippetModel: self
]

{ #category : #accessing }
LeGemStoneSnippet >> connectorName [
	^ connectorName
]

{ #category : #accessing }
LeGemStoneSnippet >> connectorName: anObject [

	connectorName := anObject.
	self updateEditTimeAndEmail.
	self announceContentChanged.
]

{ #category : #initialization }
LeGemStoneSnippet >> newCoder [
	^ GtGemStoneCoderModel new
]
