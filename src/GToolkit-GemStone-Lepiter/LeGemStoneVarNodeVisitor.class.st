Class {
	#name : #LeGemStoneVarNodeVisitor,
	#superclass : #Object,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#instVars : [
		'assignedVariables',
		'temporaryVariables',
		'definedVariables',
		'accessedFirstUndeclaredVariables'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> accessedFirstUndeclaredVariableNames [
	"Answer the set of variable names where the variable is accessed before being assigned a value (if at all)"

	^ accessedFirstUndeclaredVariables 
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> assignFirstUndeclaredVariablesName [

	^ assignedVariables difference: (accessedFirstUndeclaredVariables, temporaryVariables)
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> assignedUndeclaredVariableNames [
	"Answer the set of variable names where the variable is assigned a value, but is not a temporary variable"

	^ self assignedVariableNames asSet difference: self temporaryVariableNames asSet
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> assignedVariableNames [

	^ assignedVariables
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> definedVariableNames [

	^ definedVariables 
]

{ #category : #'as yet unclassified' }
LeGemStoneVarNodeVisitor >> globalVariableNames [

	^ (accessedFirstUndeclaredVariables, assignedVariables) difference: temporaryVariables
]

{ #category : #'gt - extensions' }
LeGemStoneVarNodeVisitor >> gtViewSummaryFor: aView [

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
	
	definedVariables := Set new.
	assignedVariables := Set new.
	temporaryVariables := Set new.
	accessedFirstUndeclaredVariables := Set new.
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> requiredVariableNames [
	^ self undeclaredVariableNames difference: self assignFirstUndeclaredVariablesName.
]

{ #category : #accessing }
LeGemStoneVarNodeVisitor >> temporaryVariableNames [

	^ temporaryVariables
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
	assignedVariables add: (anAssignment variable variableName).
	^ self visitValue: anAssignment
]

{ #category : #generated }
LeGemStoneVarNodeVisitor >> visitNamedVariable: aNamedVariable [
	| name |

	name := aNamedVariable variableName.
	name first isLowercase ifTrue: [
		definedVariables add: name ].
	
	((assignedVariables includes: name) or: [ 
		temporaryVariables includes: name ]) ifFalse: [ 
			accessedFirstUndeclaredVariables add: name ].
		
	^ self visitVariable: aNamedVariable
]

{ #category : #generated }
LeGemStoneVarNodeVisitor >> visitSequence: aSequence [

	temporaryVariables addAll: (aSequence variables collect: #variableName).
	^ self visitProgram: aSequence
]
