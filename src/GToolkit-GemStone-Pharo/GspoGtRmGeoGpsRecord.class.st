Class {
	#name : #GspoGtRmGeoGpsRecord,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo'
}

{ #category : #accessing }
GspoGtRmGeoGpsRecord class >> remoteClassName [
	^ #GtRmGeoGpsRecord
]

{ #category : #'gt - extensions' }
GspoGtRmGeoGpsRecord >> gtActionDownloadFor: anAction [ 
	<gtAction>
	
	^ anAction button
		tooltip: 'Download copy locally';
		priority: 10;
		icon: BrGlamorousIcons cloud;
		action: [ :aButton |
			aButton phlow spawnObject: (GtRmGeoGpsRecord 
				fromJsonDictionary: (self 
					proxyPerform: #asJsonDictionary
					autoCommit: false))  ]
]

{ #category : #'gt - extensions' }
GspoGtRmGeoGpsRecord >> gtViewOnMapFor: aView [ 
	<gtView>
	
	^ aView explicit
		title: 'On Map';
		priority: 78;
		stencil: [ GtRmGeoGpsWorldWithPointStencil new 
			targetPoint: (self proxyPerform: #longitude) 
				@ (self proxyPerform: #latitude) ]
]

{ #category : #'gt - extensions' }
GspoGtRmGeoGpsRecord >> gtViewOnOsmFor: aView [ 
	<gtView>
	
	^ aView explicit
		title: 'On OSM';
		priority: 55;
		stencil: [ GtOpenStreetMapTiles new 
			tileWithMarkerAt:  (self proxyPerform: #longitude) 
				@ (self proxyPerform: #latitude) zoom: 15 ]
]
