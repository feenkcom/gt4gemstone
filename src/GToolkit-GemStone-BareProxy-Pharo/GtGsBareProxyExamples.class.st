Class {
	#name : #GtGsBareProxyExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : 'GToolkit-GemStone-BareProxy-Pharo-Examples'
}

{ #category : #examples }
GtGsBareProxyExamples >> testEqualityWithClient [
	"Confirm the equality rules for a bare proxy without a service client"
	<gtExample>
	| proxy1 proxy2 |

	proxy1 := GtGsBareProxy forProxyObject: GtRsrProxyServiceClient new.
	proxy2 := GtGsBareProxy forProxyObject: GtRsrProxyServiceClient new.

	self assert: proxy1 = proxy1.
	self deny: proxy1 = proxy2.

]

{ #category : #examples }
GtGsBareProxyExamples >> testEqualityWithoutClient [
	"Confirm the equality rules for a bare proxy without a service client"
	<gtExample>
	| proxy1 proxy2 |

	proxy1 := GtGsBareProxy new.
	proxy2 := GtGsBareProxy new.

	self assert: proxy1 = proxy1.
	self deny: proxy1 = proxy2.

]
