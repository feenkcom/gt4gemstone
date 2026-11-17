"
I am the HTTPS socket stream for GemStone's native Zinc (ZincGlobals), which has no secure socket stream class of its own (ZnNetworkingUtils>>#secureSocketStreamClass looks for Zodiac's ZdcSecureSocketStream).

I exist only for the GemStone export. In the stone I am a SocketStream subclass (GtGemStoneGtCodeExporter>>#alternateClassDefinitions) and my methods come from the ext_GtGsSecureSocketStream_* descriptors in GtGemStoneExtensionMethods; ext_ZnNetworkingUtils_secureSocketStreamClass makes Zinc use me. The TCP connection is opened as for http, then #connect upgrades it to TLS with GsSecureSocket. The certificate chain is always verified against the system CA bundle, and the host name against serverName (set through #serverNameIndication:, which is also sent as SNI). There is no unverified mode.
"
Class {
	#name : #GtGsSecureSocketStream,
	#superclass : #Object,
	#instVars : [
		'serverName'
	],
	#category : #'GToolkit-GemStone'
}
