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
	<return: #Collection of: #String>

	^ categories
]

{ #category : #accessing }
GtGemStoneCodeSyncCategoriesStrategy >> categories: aCollectionOfStrings [

	categories := aCollectionOfStrings
]

{ #category : #printing }
GtGemStoneCodeSyncCategoriesStrategy >> gtDisplayOn: aStream [

	aStream
		<< 'classes in categories: ';
		print: categories
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
