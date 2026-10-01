"
I am a Pharo-side declaration for GemStone's GsNMethod. My gsCode: methods provide compiled-method compatibility required by the gtExample framework.
"
Class {
	#name : #GsNMethod,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Stubs'
}

{ #category : #testing }
GsNMethod >> isGTExampleMethod [
	<gsCode: '^ (self pragmas anySatisfy: [ :each | each isGTExamplePragma ])
		and: [ self numArgs = 0 ]'>
	^ self shouldNotImplement
]

{ #category : #accessing }
GsNMethod >> methodClass [
	<gsCode: '^ self inClass'>
	^ self shouldNotImplement
]
