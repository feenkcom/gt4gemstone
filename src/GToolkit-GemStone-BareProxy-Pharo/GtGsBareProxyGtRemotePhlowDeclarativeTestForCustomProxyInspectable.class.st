Class {
	#name : #GtGsBareProxyGtRemotePhlowDeclarativeTestForCustomProxyInspectable,
	#superclass : #GtGsBareProxy,
	#category : #'GToolkit-GemStone-BareProxy-Pharo-Examples'
}

{ #category : #accessing }
GtGsBareProxyGtRemotePhlowDeclarativeTestForCustomProxyInspectable class >> remoteClassName [
	^ #GtRemotePhlowDeclarativeTestForCustomProxyInspectable
]

{ #category : #accessing }
GtGsBareProxyGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtLocalSideButtonActionFor: anAction [
	<gtProxyAction>
	
	^ anAction button
		tooltip: 'Local Side - Bare Proxy';
		priority: 5;
		label: 'Bare';
		icon: (GtPhlowGlamorousVectorIconNameStencil new 
			iconName: #playinspect);
		action: [ :aButton |
			aButton phlow 
				spawnObject: self ]
]

{ #category : #accessing }
GtGsBareProxyGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtLocalSideTextViewFor: aView [
	<gtProxyView>
	
	^ aView text
		title: 'Bare local side';
		priority: 5;
		text: [ 'Local side view added by the bare proxy' ]
]

{ #category : #accessing }
GtGsBareProxyGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtRemoteSideButtonActionFor: anAction [
	<gtAction>
	
	^ anAction button
		tooltip: 'GemStone Side - Bare Proxy';
		priority: 5;
		label: 'Bare';
		icon: (GtPhlowGlamorousVectorIconNameStencil new 
			iconName: #playinspect);
		action: [ :aButton |
			aButton phlow 
				spawnObject: self ]
]

{ #category : #accessing }
GtGsBareProxyGtRemotePhlowDeclarativeTestForCustomProxyInspectable >> gtRemoteSideTextViewFor: aView [
	<gtView>
	
	^ aView text
		title: 'Bare remote side';
		priority: 5;
		text: [ 'Remote side view added by the bare proxy' ]
]
