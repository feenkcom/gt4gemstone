Class {
	#name : #GtRsrGtGsReleaseServiceClient,
	#superclass : #GtRsrGtGsReleaseService,
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #'private-synchronization' }
GtRsrGtGsReleaseServiceClient >> updateVersion [

	remoteSelf updateVersion wait.
	^ versionString
]
