Class {
	#name : #GtGemStoneCodeSyncCategoriesStrategy,
	#superclass : #GtGemStoneCodeSyncClassStrategy,
	#instVars : [
		'categories'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncCategoriesStrategy >> categories [
	^ categories
]

{ #category : #accessing }
GtGemStoneCodeSyncCategoriesStrategy >> categories: anObject [
	categories := anObject
]

{ #category : #testing }
GtGemStoneCodeSyncCategoriesStrategy >> syncClass: aClass registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied class should be synced"
	| category |

	category := aClass category.
	^ categories
		detect: [ :matcher | matcher matches: category ]
		ifFound: [ true ]
		ifNone: [ false ]
]
