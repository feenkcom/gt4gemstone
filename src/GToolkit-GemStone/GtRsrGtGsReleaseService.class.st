Class {
	#name : #GtRsrGtGsReleaseService,
	#superclass : #RsrService,
	#instVars : [
		'versionString'
	],
	#category : 'GToolkit-GemStone'
}

{ #category : #accessing }
GtRsrGtGsReleaseService class >> templateClassName [

	^ #GtRsrGtGsReleaseService
]

{ #category : #actions }
GtRsrGtGsReleaseService >> updateVersion [

	^ versionString := GtGsRelease versionString
]

{ #category : #accessing }
GtRsrGtGsReleaseService >> versionString [
	^ versionString
]

{ #category : #accessing }
GtRsrGtGsReleaseService >> versionString: anObject [
	versionString := anObject
]
