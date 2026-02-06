Class {
	#name : #GtGsRelease,
	#superclass : #Object,
	#instVars : [
		'versionString'
	],
	#classInstVars : [
		'default'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #accessing }
GtGsRelease class >> default [
	^ default ifNil: [ 
		default := self new ]
]

{ #category : #accessing }
GtGsRelease class >> versionString [
	^ default
		ifNil: [ '<none>' ]
		ifNotNil: [
			self default versionString ]
]

{ #category : #accessing }
GtGsRelease class >> versionString: aString [
	self default versionString: aString
]

{ #category : #accessing }
GtGsRelease >> versionString [

	^ versionString
]

{ #category : #accessing }
GtGsRelease >> versionString: aString [

	versionString := aString
]
