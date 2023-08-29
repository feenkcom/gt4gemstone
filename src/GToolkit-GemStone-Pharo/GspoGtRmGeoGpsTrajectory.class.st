Class {
	#name : #GspoGtRmGeoGpsTrajectory,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #accessing }
GspoGtRmGeoGpsTrajectory class >> remoteClassName [
	^ #GtRmGeoGpsTrajectory
]

{ #category : #'gt - extensions' }
GspoGtRmGeoGpsTrajectory >> gtActionDownloadFor: anAction [ 
	<gtAction>
	
	^ anAction button
		tooltip: 'Download copy locally';
		priority: 10;
		icon: BrGlamorousIcons cloud;
		action: [ :aButton |
			aButton phlow spawnObject: (GtRmGeoGpsTrajectory 
				fromJsonDictionary: (self 
					proxyPerform: #asJsonDictionary))  ]
]

{ #category : #'gt - extensions' }
GspoGtRmGeoGpsTrajectory >> gtViewPathShapeFor: aView [ 
	<gtView>
	
	^ aView explicit
		title: 'Path Shape';
		priority: 55;
		stencil: [GtRmGeoGpsPathsStencil new
			pathPoints:  ((self proxyPerform: #recordsAsJsonData)
				collect: [ :aData | 
					GtRmGeoGpsRecord fromJsonDictionary: aData ])]
]
