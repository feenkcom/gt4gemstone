Class {
	#name : #GspoGtRemotePhlowDeclarativeTestForCustomProxyInspectable,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #accessing }
GspoGtRemotePhlowDeclarativeTestForCustomProxyInspectable class >> remoteClassName [
	^ #GtRemotePhlowDeclarativeTestForCustomProxyInspectable
]

{ #category : #accessing }
GspoGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtLocalSideButtonActionFor: anAction [
	<gtProxyAction>
	
	^ anAction button
		tooltip: 'Local Side - Bare Proxy';
		priority: 10;
		label: 'Service Client';
		icon: (GtPhlowGlamorousVectorIconNameStencil new 
			iconName: #playinspect);
		action: [ :aButton |
			aButton phlow 
				spawnObject: self ]
]

{ #category : #accessing }
GspoGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtLocalSideTextViewFor: aView [
	<gtProxyView>
	
	^ aView text
		title: 'Local side';
		priority: 10;
		text: [ 'Local side view added by the service client' ]
]

{ #category : #accessing }
GspoGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtRemoteSideButtonActionFor: anAction [
	<gtAction>
	
	^ anAction button
		tooltip: 'GemStone Side - Bare Proxy';
		priority: 10;
		label: 'Service Client';
		icon: (GtPhlowGlamorousVectorIconNameStencil new 
			iconName: #playinspect);
		action: [ :aButton |
			aButton phlow 
				spawnObject: self ]
]

{ #category : #accessing }
GspoGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtRemoteSideTextViewFor: aView [
	<gtView>
	
	^ aView text
		title: 'Remote side';
		priority: 10;
		text: [ 'Remote side view added by the service client' ]
]
