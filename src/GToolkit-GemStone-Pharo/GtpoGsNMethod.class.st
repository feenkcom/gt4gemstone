Class {
	#name : 'GtpoGsNMethod',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo'
}

{ #category : 'accessing' }
GtpoGsNMethod class >> remoteClassName [

	^ #GsNMethod
]

{ #category : 'ui' }
GtpoGsNMethod >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Source';
		priority: 10;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self proxyPerform: #sourceString ]
]
