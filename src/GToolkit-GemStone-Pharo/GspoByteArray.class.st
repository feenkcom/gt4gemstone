Class {
	#name : #GspoByteArray,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GspoByteArray class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #ByteArray
]
