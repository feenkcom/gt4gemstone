Class {
	#name : #GspoGtRmGeoUser,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #accessing }
GspoGtRmGeoUser class >> remoteClassName [
	^ #GtRmGeoUser
]

{ #category : #accessing }
GspoGtRmGeoUser >> addTrajectory: aGtRmGeoGpsTrajectory [

	^ self proxyPerform: #addTrajectoryFromJsonData: 
		withArguments: { aGtRmGeoGpsTrajectory asJsonDictionary }.
]
