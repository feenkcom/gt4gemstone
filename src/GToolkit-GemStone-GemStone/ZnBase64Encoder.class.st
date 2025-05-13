Class {
	#name : 'ZnBase64Encoder',
	#superclass : 'Object',
	#instVars : [
		'alphabet',
		'inverse',
		'lineLength',
		'lineEnd',
		'whitespace',
		'padding',
		'strict'
	],
	#category : 'GToolkit-GemStone-GemStone'
}

{ #category : 'other' }
ZnBase64Encoder class >> new [
	^ self basicNew initialize
]

{ #category : 'other' }
ZnBase64Encoder >> beStrict [
	"Configure me to enforce padding when decoding"

	strict := true
]

{ #category : 'other' }
ZnBase64Encoder >> characterCountFor: bytes [
	| n characterCount |
	"This assumes that padding is used"
	n := bytes size.
	characterCount := (n // 3 + (n \\ 3) sign) * 4.
	^ lineLength
		ifNil: [ characterCount ]
		ifNotNil: [ characterCount + (characterCount // lineLength * lineEnd size) ]
]

{ #category : 'other' }
ZnBase64Encoder >> characterForValue: value [
	^ alphabet at: value + 1
]

{ #category : 'other' }
ZnBase64Encoder >> defaultAlphabet [
	^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
]

{ #category : 'other' }
ZnBase64Encoder >> defaultInverse [
	| defaultInverse |
	defaultInverse := Array new: 128.
	0 to: 127 do: [ :each | 
		| offset |
		offset := self defaultAlphabet indexOf: each asCharacter ifAbsent: [ nil ].
		defaultInverse at: each + 1 put: (offset ifNotNil: [ offset - 1 ]) ].
	^ defaultInverse
]

{ #category : 'other' }
ZnBase64Encoder >> encode: byteArray [
	"Encode byteArray using Base64 encoding and return the resulting string"

	^ String
		new: (self characterCountFor: byteArray)
		streamContents: [ :stringStream |
			self encode: byteArray readStream to: stringStream ]
]

{ #category : 'other' }
ZnBase64Encoder >> encode: byte1 and: byte2 and: byte3 to: stream [
	stream nextPut: (self characterForValue: (byte1 bitShift: -2)).
	byte2
		ifNil: [
			stream nextPut: (self characterForValue: ((byte1 bitAnd: 2r11) bitShift: 4)).
			padding ifNotNil: [ stream nextPut: padding; nextPut: padding ] ]
		ifNotNil: [
			stream nextPut: (self characterForValue: (((byte1 bitAnd: 2r11) bitShift: 4) + (byte2 bitShift: -4))).
			byte3
				ifNil: [
					stream nextPut: (self characterForValue: ((byte2 bitAnd: 2r1111) bitShift: 2)).
					padding ifNotNil: [ stream nextPut: $= ] ]
				ifNotNil: [
					stream nextPut: (self characterForValue: (((byte2 bitAnd: 2r1111) bitShift: 2) + (byte3 bitShift: -6))).
					stream nextPut: (self characterForValue: (byte3 bitAnd: 2r111111)) ] ]
]

{ #category : 'other' }
ZnBase64Encoder >> encode: byteStream to: stringStream [
	| byte1 byte2 byte3 count |
	lineLength
		ifNil: [
			[ byteStream atEnd ] whileFalse: [
				byte1 := byteStream next.
				byte2 := byteStream next.
				byte3 := byteStream next.
				self encode: byte1 and: byte2 and: byte3 to: stringStream ] ]
		ifNotNil: [
			count := 0.
			[ byteStream atEnd ] whileFalse: [
				byte1 := byteStream next.
				byte2 := byteStream next.
				byte3 := byteStream next.
				self encode: byte1 and: byte2 and: byte3 to: stringStream.
				(count := count + 4) = lineLength
					ifTrue: [
						stringStream nextPutAll: lineEnd.
						count := 0 ] ] ]
]

{ #category : 'other' }
ZnBase64Encoder >> initialize [
	super initialize.
	alphabet := self defaultAlphabet.
	inverse := self defaultInverse.
	self padding: $=.
	self whitespace: #any.
	self beStrict
]

{ #category : 'other' }
ZnBase64Encoder >> padding: character [
	"Configure me to use character as padding.
	One or two padding character might be needed to complete each quad.
	Use nil to disable padding."

	padding := character
]

{ #category : 'other' }
ZnBase64Encoder >> whitespace: mode [
	"Set the whitespace mode:
	nil is no whitespace allowed,
	#separator is CR, LF, FF, SPACE, TAB allowed,
	#any is all non-alphabet characters allowed (the default)"

	whitespace := mode
]
