Extension { #name : #ClassOrganizer }

{ #category : #'*GToolkit-GemStone-GemStone' }
ClassOrganizer class >> cleanUpGtDefault [

	^ SessionTemps current
		removeKey: #GtGs_ClassOrganizer_Cache
		ifAbsent: [].
]

{ #category : #'*GToolkit-GemStone-GemStone' }
ClassOrganizer class >> gtDefault [
	"Cache a ClassOrganizer in the session temps as in a large database reflection is very slow,
	so the initial call can take minutes."

	^ SessionTemps current
		at: #GtGs_ClassOrganizer_Cache
		ifAbsentPut: [ self new ].
]
