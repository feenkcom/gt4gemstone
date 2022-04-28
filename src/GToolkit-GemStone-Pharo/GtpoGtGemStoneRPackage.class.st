Class {
	#name : #GtpoGtGemStoneRPackage,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'name'
	],
	#category : 'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtGemStoneRPackage class >> remoteClassName [

	^ #GtGemStoneRPackage
]

{ #category : #accessing }
GtpoGtGemStoneRPackage >> classes [

	^ self proxyPerform: #classes
]

{ #category : #accessing }
GtpoGtGemStoneRPackage >> name [

	^ name ifNil: [ name := self proxyPerform: #name ]
]
