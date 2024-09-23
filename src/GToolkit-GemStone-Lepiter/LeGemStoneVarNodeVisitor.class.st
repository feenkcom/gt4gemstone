Class {
	#name : #LeGemStoneVarNodeVisitor,
	#superclass : #Object,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#instVars : [
		'definedVariableNames',
		'assignedVariableNames',
		'temporaryVariableNames',
		'accessedFirstUndeclaredVariableNames',
		'variableNodesByName'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> accessedFirstUndeclaredVariableNames [
	"Answer the set of variable names where the variable is accessed before being assigned a value (if at all)"

	^ accessedFirstUndeclaredVariableNames 
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> assignFirstUndeclaredVariablesName [

	^ assignedVariableNames difference: (accessedFirstUndeclaredVariableNames, temporaryVariableNames)
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> assignedUndeclaredVariableNames [
	"Answer the set of variable names where the variable is assigned a value, but is not a temporary variable"

	^ self assignedVariableNames asSet difference: self temporaryVariableNames asSet
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> assignedVariableNames [

	^ assignedVariableNames
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> definedVariableNames [

	^ definedVariableNames 
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> globalVariableNames [

	^ (accessedFirstUndeclaredVariableNames, assignedVariableNames) difference: temporaryVariableNames
]

{ #category : #'gt - extensions' }
LeGemStoneVarNodeVisitor >> gtViewDefinedVariablesFor: aView [
	<gtView>
	
	^ aView list 
		title: 'Defined variables';
		priority: 10;
		items: [ self definedVariableNames sorted ];
		itemText: [ :aVariableName | aVariableName printString ];
		send: [ :aVariableName | 
			variableNodesByName at: aVariableName ];
		actionUpdateButton
]

{ #category : #'gt - extensions' }
LeGemStoneVarNodeVisitor >> gtViewVariablesSummaryFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Variables details';
		priority: 5;
		items: [ self variableDetails ];
		column: #Name text: [ :item | item key ];
		column: #Variables text: [ :item | item value ];
		send: [ :item | item value ];
		actionUpdateButton
]

{ #category : #initialization }
LeGemStoneVarNodeVisitor >> initialize [
	super initialize.
	
	definedVariableNames := Set new.
	assignedVariableNames := Set new.
	temporaryVariableNames := Set new.
	accessedFirstUndeclaredVariableNames := Set new.
	
	variableNodesByName := Dictionary new.
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> requiredVariableNames [
	^ self undeclaredVariableNames difference: self assignFirstUndeclaredVariablesName.
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> stopPositionForVariableNamed: aVariableName [
	^ variableNodesByName 
		at: aVariableName
		ifPresent: [ :aNode | aNode name stopPosition ] 
		ifAbsent: [ nil ]
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> temporaryVariableNames [

	^ temporaryVariableNames
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> undeclaredVariableNames [
	"Answer the set of variable names where the variable is accessed, but is not a temporary variable"

	^ self definedVariableNames asSet difference: self temporaryVariableNames asSet
]

{ #category : #'gt - extensions' }
LeGemStoneVarNodeVisitor >> variableDetails [
^ { 
	'Defined Variables' -> self definedVariableNames.
	'Temporary Variables' -> self temporaryVariableNames.
	'Assigned Variables' -> self assignedVariableNames.
	'Undeclared Variables' -> self undeclaredVariableNames.
	'Assigned Undeclared Variable' -> self assignedUndeclaredVariableNames.
	'Accessed First Undeclared Variables' -> self accessedFirstUndeclaredVariableNames.
	'Assigned First Undeclared Variables' -> self assignFirstUndeclaredVariablesName.
	'Required Variables' -> self requiredVariableNames }
]

{ #category : #generated }
LeGemStoneVarNodeVisitor >> visitAssignment: anAssignment [

	"Get the assigned node and save"
	assignedVariableNames add: (anAssignment variable variableName).
	^ self visitValue: anAssignment
]

{ #category : #generated }
LeGemStoneVarNodeVisitor >> visitNamedVariable: aNamedVariable [
	| name |

	name := aNamedVariable variableName.
	name first isLowercase ifTrue: [
		definedVariableNames add: name.
		variableNodesByName at: name ifAbsentPut: [ aNamedVariable ] ].
	
	((assignedVariableNames includes: name) or: [ 
		temporaryVariableNames includes: name ]) ifFalse: [ 
			accessedFirstUndeclaredVariableNames add: name ].
		
	^ self visitVariable: aNamedVariable
]

{ #category : #generated }
LeGemStoneVarNodeVisitor >> visitSequence: aSequence [

	temporaryVariableNames addAll: (aSequence variables collect: #variableName).
	^ self visitProgram: aSequence
]
