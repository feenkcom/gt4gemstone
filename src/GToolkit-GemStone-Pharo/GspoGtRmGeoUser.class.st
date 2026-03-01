Class {
	#name : #GspoGtRmGeoUser,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-GeolifeDemo'
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

{ #category : #accessing }
GspoGtRmGeoUser >> gtActionDownloadFor: anAction [ 
	<gtAction>
	
	^ anAction button
		tooltip: 'Download copy locally';
		priority: 10;
		icon: BrGlamorousVectorIcons cloud;
		action: [ :aButton |
			aButton phlow spawnObject: (GtRmGeoUser 
				fromJsonDictionary: (self 
					proxyPerform: #asJsonDictionary))  ]
]
