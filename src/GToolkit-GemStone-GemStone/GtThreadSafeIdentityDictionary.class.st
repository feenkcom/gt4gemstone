Class {
	#name : #GtThreadSafeIdentityDictionary,
	#superclass : #RsrThreadSafeDictionary,
	#category : #'GToolkit-GemStone-GemStone'
}

{ #category : #accessing }
GtThreadSafeIdentityDictionary >> at: aKey ifPresent: presentBlock ifAbsent: absentBlock [
	| isPresent result |

	isPresent := true.
	result := self critical: [map at: aKey ifAbsent: [isPresent := false]].
	^isPresent
		ifTrue: [ presentBlock value: result ]
		ifFalse: [ absentBlock value ].
]

{ #category : #initialization }
GtThreadSafeIdentityDictionary >> initialize [

	super initialize.
	map := IdentityDictionary new.
]
