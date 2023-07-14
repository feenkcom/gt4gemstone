Class {
	#name : #GtpoBlockClosure,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoBlockClosure class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #BlockClosure
]
