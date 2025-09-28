Class {
	#name : #GspoGtRmGeoGpsTrajectory,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-GeolifeDemo'
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
		icon: BrGlamorousVectorIcons cloud;
		action: [ :aButton |
			aButton phlow spawnObject: (GtRmGeoGpsTrajectory 
				fromJsonDictionary: (self 
					proxyPerform: #asJsonDictionary))  ]
]

{ #category : #accessing }
GspoGtRmGeoGpsTrajectory >> gtViewMapFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'OSM';
		priority: 20;
		stencil: [ self osmMap ]
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

{ #category : #accessing }
GspoGtRmGeoGpsTrajectory >> osmMap [
	| map path points |

	map := GtOsmMap new zoom: 15.
	points := self records collect: #asPoint.
	points do: 
		[ :point | map includeCoordinate: point ].
	map addChildren.
	path := GtOsmPath new coordinates: points.
	path addToMap: map.
	^ map asScalableElement
]

{ #category : #accessing }
GspoGtRmGeoGpsTrajectory >> records [

	^ ((self proxyPerform: #asJsonDictionary) at: #records)
		collect: [ :each | GtRmGeoGpsRecord fromJsonDictionary: each ].
]
