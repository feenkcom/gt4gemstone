Class {
	#name : #GspoRowanProjectService,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GspoRowanProjectService class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #RowanProjectService
]

{ #category : #ui }
GspoRowanProjectService >> gtPullAndLoadSessionFor: anAction [
	<gtAction>

	^ anAction button
		priority: 10;
		label: 'git';
		icon: BrGlamorousVectorIcons down;
		tooltip: 'Pull and Load Repository';
		action: [ :button |
			self pullFromGit.
			self reloadProjectAllowResolve.
			UIManager inform: Time now printString, ': reloaded ', self name ].
]

{ #category : #accessing }
GspoRowanProjectService >> name [

	^ name ifNil: [ name := self proxyPerform: #name 
		serializationStrategy: #GtRsrLiteralAndProxySerializationStrategy ]
]

{ #category : #actions }
GspoRowanProjectService >> pullFromGit [

	self proxyPerformReturnProxy: #pullFromGit.
]

{ #category : #actions }
GspoRowanProjectService >> reloadProject [

	self proxyPerformReturnProxy: #reloadProject.
]

{ #category : #actions }
GspoRowanProjectService >> reloadProjectAllowResolve [

	^ self evaluateAndWaitReturnProxy: 
		'[ self reloadProject ]
			on: RwAllowChangeRepositoryRevisionOnResolveNotification
			do: [ :ex | ex resume: true ]'.
]
