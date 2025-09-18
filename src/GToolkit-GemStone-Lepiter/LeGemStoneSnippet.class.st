Class {
	#name : #LeGemStoneSnippet,
	#superclass : #LeCodeSnippet,
	#instVars : [
		'sessionIdentifier'
	],
	#category : #'GToolkit-GemStone-Lepiter-Snippet'
}

{ #category : #'api - accessing menu' }
LeGemStoneSnippet class >> contextMenuItemSpecification [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: self description
]

{ #category : #'api - accessing menu' }
LeGemStoneSnippet class >> description [
	^ 'GemStone'
]

{ #category : #'lepiter-store' }
LeGemStoneSnippet class >> leFromJsonV4Dictionary: aDictionary [
	"Create a new instance of the receiver from the supplied dictionary.
	Subclasses can override this to provide custom mappings."
	| aLeModel |

	aLeModel := super leFromJsonV4Dictionary: aDictionary.
	aDictionary at: #sessionName
		ifPresent: [ :sessionName |
			aLeModel sessionIdentifier: 
				(GtGemStoneExplicitSessionIdentifier sessionName: sessionName) ].
	^ aLeModel
]

{ #category : #'lepiter-store' }
LeGemStoneSnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#sessionIdentifier -> #sessionIdentifier);
		yourself
]

{ #category : #'lepiter-store' }
LeGemStoneSnippet class >> leJsonV4Name [

	^ 'gemstoneSnippet'
]

{ #category : #'instance creation' }
LeGemStoneSnippet class >> sessionName: aString [

	^ self new 
		sessionIdentifier: (GtGemStoneExplicitSessionIdentifier 
			sessionName: aString)
]

{ #category : #'instance creation' }
LeGemStoneSnippet class >> withDefaultSessionIdentifier [
	^ self new 
		sessionIdentifier: GtGemStoneDefaultSessionIdentifier new
]

{ #category : #visiting }
LeGemStoneSnippet >> acceptVisitor: aVisitor [

	^ aVisitor visitGemStoneSnippet: self
]

{ #category : #accessing }
LeGemStoneSnippet >> additionalStateForCopying [

	^ super additionalStateForCopying
		attributeNamed: #sessionIdentifier setValue: self sessionIdentifier
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
LeGemStoneSnippet >> sessionDisplayName [

	^ sessionIdentifier
		ifNil: [ GtGemStoneNullConnector connectorName ]
		ifNotNil: [ sessionIdentifier displayName ]
]

{ #category : #accessing }
LeGemStoneSnippet >> sessionIdentifier [
	^ sessionIdentifier
]

{ #category : #accessing }
LeGemStoneSnippet >> sessionIdentifier: aGtGemStoneSessionIdentifier [

	self assert: (aGtGemStoneSessionIdentifier isNil or:
		[ aGtGemStoneSessionIdentifier isKindOf: GtGemStoneSessionIdentifier ]).
	sessionIdentifier := aGtGemStoneSessionIdentifier
]

{ #category : #accessing }
LeGemStoneSnippet >> sessionName [

	^ sessionIdentifier ifNotNil: #sessionName
]

{ #category : #testing }
LeGemStoneSnippet >> shouldPerformLocalRefactoring [
	^ true
]
