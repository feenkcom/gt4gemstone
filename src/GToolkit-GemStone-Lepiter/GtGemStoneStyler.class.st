Class {
	#name : #GtGemStoneStyler,
	#superclass : #GtPharoStyler,
	#category : #'GToolkit-GemStone-Lepiter-Styler'
}

{ #category : #'visiting - variables' }
GtGemStoneStyler >> visitGSPath: aGSPath [
	| isDeclaredVariable varName |
	super visitGSPath: aGSPath.
	varName := aGSPath name source.
	varName := varName first: (varName indexOf: $.) - 1.
	isDeclaredVariable := aGSPath allParents
			anySatisfy: [ :each | each isErrorNode not and: [ each defines: varName ] ].
	isDeclaredVariable ifTrue: [ ^ self visitDeclaredVariable: aGSPath ].

	isDeclaredVariable := self coderViewModel hasDeclaredVariableNamed: varName.
	isDeclaredVariable ifTrue: [ ^ self visitDeclaredVariable: aGSPath ].

	isDeclaredVariable := self coderViewModel hasDeclaredGlobalNamed: varName.
	isDeclaredVariable ifTrue: [ ^ self visitDeclaredGlobalVariable: aGSPath ].

	self visitUndeclaredVariable: aGSPath
]
