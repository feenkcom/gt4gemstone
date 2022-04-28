Class {
	#name : #GtGemStoneGciConnectorWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'connectorViewModel',
		'saveButton'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'instance creation' }
GtGemStoneGciConnectorWidget class >> onConnector: aGtGemStoneGciConnector propertiesFile: aGtGemStonePropertiesFile [

	^ self new connectorViewModel:
		(GtGemStoneGciConnectorViewModel new 
			connector: aGtGemStoneGciConnector;
			propertiesFile: aGtGemStonePropertiesFile)
]

{ #category : #'private - list' }
GtGemStoneGciConnectorWidget >> addListHeader [

	self addChild: (BrHorizontalPane new
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 2);
		addChild: (BrLabel new 
			hExact: self propertyWidth;
			vFitContent;
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Property');
		addChild: (BrLabel new 
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Value'))
]

{ #category : #'private - list' }
GtGemStoneGciConnectorWidget >> addListLabelName: nameSymbol title: titleString [
	"Add a string label field"

	self addChild: (BrHorizontalPane new
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 2);
		addChild: (BrLabel new 
			hExact: self propertyWidth;
			aptitude: BrGlamorousLabelAptitude new;
			text: titleString);
		addChild: (BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			vFitContent;
			hMatchParent) as: nameSymbol)
]

{ #category : #'private - list' }
GtGemStoneGciConnectorWidget >> addListPasswordName: nameSymbol title: titleString [
	"Add a string input field"

	self addChild: (BrHorizontalPane new
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 2);
		addChild: (BrLabel new 
			hExact: self propertyWidth;
			aptitude: BrGlamorousLabelAptitude new;
			text: titleString);
		addChild: (BrEditor new
			aptitude: (BrGlamorousRegularEditorAptitude new replacingText: $*) + BrGlamorousInputFieldSpacingAptitude;
			vFitContent;
			hMatchParent) as: nameSymbol)
]

{ #category : #'private - list' }
GtGemStoneGciConnectorWidget >> addListStringName: nameSymbol title: titleString [
	"Add a string input field"

	self addChild: (BrHorizontalPane new
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 2);
		addChild: (BrLabel new 
			hExact: self propertyWidth;
			aptitude: BrGlamorousLabelAptitude new;
			text: titleString);
		addChild: (BrEditor new
			aptitude: BrGlamorousEditorAptitude + BrGlamorousInputFieldSpacingAptitude;
			vFitContent;
			hMatchParent) as: nameSymbol)
]

{ #category : #initialization }
GtGemStoneGciConnectorWidget >> buildUI [
	| toolbar |

	self matchParent.

	self createPropertiesList.
	toolbar := self createToolbar.
	self addChildren: { toolbar. }
]

{ #category : #accessing }
GtGemStoneGciConnectorWidget >> connectorViewModel: aGtGemStoneConnectorViewModel [

	connectorViewModel ifNotNil:
		[ connectorViewModel unsubscribe: self ].
	connectorViewModel := aGtGemStoneConnectorViewModel.
	connectorViewModel
		when: GtGemStoneConnectorAnnouncement 
		send: #onConnectorViewModelChanged:
		to: self.
	self onConnectorViewModelChanged.
]

{ #category : #initialization }
GtGemStoneGciConnectorWidget >> createPropertiesList [

	self addListHeader.
	self addListStringName: #name title: 'Name'.
	self addListStringName: #stone title: 'Stone'.
	self addListStringName: #username title: 'Username'.
	self addListPasswordName: #password title: 'Password'.
	self addListStringName: #host title: 'Host'.
	self addListStringName: #gemstoneVersion title: 'GemStone Version'.
	self addListStringName: #libraryPath title: 'Library Path'.
	self addListStringName: #netldi title: 'NetLDI'.
	self addListStringName: #hostUsername title: 'Host Username'.
	self addListPasswordName: #hostPassword title: 'Host Password'.
]

{ #category : #initialization }
GtGemStoneGciConnectorWidget >> createSaveButton [

	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		icon: BrGlamorousVectorIcons accept;
		label: 'Save';
		action: [ self saveProperties ].

]

{ #category : #initialization }
GtGemStoneGciConnectorWidget >> createToolbar [
	| toolbar |

	toolbar := BrHorizontalPane new.
	toolbar 
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 2);
		alignCenterRight.

	saveButton := self createSaveButton.
	toolbar addChild: saveButton.

	^ toolbar
]

{ #category : #initialization }
GtGemStoneGciConnectorWidget >> initialize [ 

	super initialize.
	self buildUI.
]

{ #category : #private }
GtGemStoneGciConnectorWidget >> onConnectorViewModelChanged [
	| libraryPath |

	#(name stone username password host gemstoneVersion netldi hostUsername hostPassword) 
		do: [ :name |
			(self childNamed: name) text: (name value: connectorViewModel connector) asString ].
	libraryPath := connectorViewModel connector libraryPath.
	(self childNamed: #libraryPath) text: 
		(libraryPath
			ifNil: [ '' ]
			ifNotNil: [ libraryPath fullName ]).

]

{ #category : #private }
GtGemStoneGciConnectorWidget >> onConnectorViewModelChanged: aGtGemStoneConnectorAnnouncement [

	aGtGemStoneConnectorAnnouncement operation = #updated ifFalse: [ ^ self ].
	self onConnectorViewModelChanged.
]

{ #category : #'private - list' }
GtGemStoneGciConnectorWidget >> propertyWidth [
	"Answer the width of the Property column"
	
	^ 150
]

{ #category : #private }
GtGemStoneGciConnectorWidget >> saveProperties [
	| nameChanged connector propertiesFile |

	connector := connectorViewModel connector.
	nameChanged := connector name ~= (self childNamed: #name) text asString.
	#(name stone username password host gemstoneVersion netldi hostUsername hostPassword) 
		do: [ :name |
			connector
				perform: name asMutator 
				withArguments: { (self childNamed: name) text asString } ].
	connector 
		libraryPath: (self childNamed: #libraryPath) text asString asFileReference.
	propertiesFile := connectorViewModel propertiesFile.
	nameChanged 
		ifTrue: [ connector notifyNameChanged ]
		ifFalse: [ connector notifyUpdated ].
	propertiesFile ifNotNil: [ propertiesFile saveProperties ].

]
