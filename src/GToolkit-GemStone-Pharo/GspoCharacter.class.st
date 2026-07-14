Class {
	#name : #GspoCharacter,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GspoCharacter class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #Character
]

{ #category : #'gt - extensions' }
GspoCharacter >> gtPreviewFor: aView [
	<gtView>
	
	^ aView forward
			title: 'Preview';
			priority: 10;
			object: [ 
				self proxyPerform: #yourself ];
			view: #gtPreviewFor:
]

{ #category : #'gt - extensions' }
GspoCharacter >> gtUnicodeDetailsFor: aView [
	<gtView>
	
	^ aView forward
			title: 'Unicode';
			priority: 20;
			object: [ 
				self proxyPerform: #yourself ];
			view: #gtUnicodeDetailsFor:
]

{ #category : #'gt - extensions' }
GspoCharacter >> gtViewUnicodeCharacterDetailsIn: aView [
	<gtView>
	
	^ aView forward
			title: 'Unicode details';
			priority: 31;
			object: [ 
				self proxyPerform: #yourself ];
			view: #gtViewUnicodeCharacterDetailsIn:
]
