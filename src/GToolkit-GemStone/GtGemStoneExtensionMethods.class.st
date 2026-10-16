"
I am the registry of GT-managed GemStone extension methods. My class-side methods named ext_* answer extension descriptors; apply discovers and applies all of them.
"
Class {
	#name : #GtGemStoneExtensionMethods,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #applying }
GtGemStoneExtensionMethods class >> apply [
	^ self extensions collect: [ :each | each apply ]
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_AbstractException_gtMessageTextFor_ [
	^ GtGemStoneExtensionMethod new
		selector: #gtMessageTextFor:;
		protocol: #'gt-extension';
			meta: false;
		gtVersions: nil;
		className: #AbstractException;
		hash: #new;
		source: 'gtMessageTextFor: aView
	<gtView>
	<gtGsExtension>
	
	^ aView text
		title: ''Message Text'';
		priority: 10;
		text: [ self messageText ]'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Array_as_ [
	^ GtGemStoneExtensionMethod new
		selector: #as:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Array;
		hash: #new;
		source: 'as: aSimilarClass

	"Specific classes can redefine newFromArray: by a faster implementation if they want.

	Note: see Collection class>>newFromArray: for the rationale."

	
	<gtGsExtension>
aSimilarClass == self class ifTrue: [ ^ self ].
	^ aSimilarClass newFromArray: self'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Array_isArray [
	^ GtGemStoneExtensionMethod new
		selector: #isArray;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Array;
		hash: #new;
		source: 'isArray	
	<gtGsExtension>
	
	^true'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ArrayedCollection_fillFrom_with_ [
	^ GtGemStoneExtensionMethod new
		selector: #fillFrom:with:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #ArrayedCollection;
		hash: #new;
		source: 'fillFrom: aCollection with: aBlock
	<gtGsExtension>
	"Evaluate aBlock with each of aCollections''s elements as the argument.
	Collect the resulting values into self. Answer self."

	| index |
	index := 0.
	aCollection do: [ :each |
		self at: (index := index + 1) put: (aBlock value: each) ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Behavior___ [
	^ GtGemStoneExtensionMethod new
		selector: #>>;
		meta: false;
		gtVersions: nil;
		className: #Behavior;
		hash: #new;
		source: '>> aSelector
	<gtGsExtension>

	^ self compiledMethodAt: aSelector'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Behavior_compiler [
 ^ GtGemStoneExtensionMethod new
  selector: #compiler;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Behavior;
  hash: #new;
  source: 'compiler
 <gtGsExtension>
 "Answer the GemStone-compatible compiler facade."
 ^ OpalCompiler new'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Behavior_lookupSelector_ [
	^ GtGemStoneExtensionMethod new
		selector: #lookupSelector:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Behavior;
		hash: #new;
		source: 'lookupSelector: aSelector
	<gtGsExtension>
	"Answer the method, including inherited methods, or nil if absent."
	| behavior method |
	behavior := self.
	[ behavior notNil ] whileTrue: [
		method := behavior compiledMethodAt: aSelector environmentId: 0 otherwise: nil.
		method ifNotNil: [ ^ method ].
		behavior := behavior superclass ].
	^ nil'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Behavior_protocolNames [
 ^ GtGemStoneExtensionMethod new
  selector: #protocolNames;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Behavior;
  hash: #new;
  source: 'protocolNames
 <gtGsExtension>
 ^ self categoryNames collect: [ :each | each asString ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Behavior_selectorsInProtocol_ [
 ^ GtGemStoneExtensionMethod new
  selector: #selectorsInProtocol:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Behavior;
  hash: #new;
  source: 'selectorsInProtocol: aProtocol
 <gtGsExtension>
 ^ self selectorsIn: aProtocol'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_BlockClosure_asSortFunction [
	^ GtGemStoneExtensionMethod new
		selector: #asSortFunction;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #BlockClosure;
		hash: #new;
		source: 'asSortFunction
	<gtGsExtension>
	"Return a SortFunction around the receiver. If the receiver is a 2 arg block, it is assumed it will do the collation directly itself, returning -1, 0, or 1. If the receiver is a one arg block, it will be evaluated for each a and b and of the sort input, and the result of sending <=> to those will be used"

	self numArgs = 1 ifTrue: [^PropertySortFunction property: self].
	self numArgs = 2 ifTrue: [^CollatorBlockFunction usingBlock: self].

	self error: ''Can not be converted to sort function. It should have one or two args'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_BlockClosure_ascending [
	^ GtGemStoneExtensionMethod new
		selector: #ascending;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #BlockClosure;
		hash: #new;
		source: 'ascending
	<gtGsExtension>
	"Return a SortFunction around the receiver. If the receiver is a 2 arg block, it is assumed it will do the collation directly itself, returning -1, 0, or 1. If the receiver is a one arg block, it will be evaluated for each a and b and of the sort input, and the result of sending <=> to those will be used."

	^self asSortFunction'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_BlockClosure_collatedBy_ [
	^ GtGemStoneExtensionMethod new
		selector: #collatedBy:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #BlockClosure;
		hash: #new;
		source: 'collatedBy: aSortFunction
	<gtGsExtension>
	"Return a SortFunction around the receiver. If the receiver is a 2 arg block, it is assumed it will do the collation directly itself, returning -1, 0, or 1. If the receiver is a one arg block, it will be evaluated for each a and b and of the sort input, and the result of using aSortFunction on those will be used"

	self numArgs = 1 ifTrue: [^PropertySortFunction property: self collatedWith: aSortFunction asSortFunction].
	self error: ''Can not be converted to sort function. It should have one arg'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_BlockClosure_descending [
	^ GtGemStoneExtensionMethod new
		selector: #descending;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #BlockClosure;
		hash: #new;
		source: 'descending
	<gtGsExtension>
	"Opposite direction as ascending."

	^self asSortFunction reversed'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Boolean_isBoolean [
	^ GtGemStoneExtensionMethod new
		selector: #isBoolean;
		meta: false;
		gtVersions: nil;
		className: #Boolean;
		hash: #new;
		source: 'isBoolean
	<gtGsExtension>

	"Answer a boolean indicating whether the receiver is a boolean"

	^ true'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Boolean_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Boolean;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeBoolean: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Boolean_threeWayCompareTo_ [
	^ GtGemStoneExtensionMethod new
		selector: #threeWayCompareTo:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Boolean;
		hash: #new;
		source: 'threeWayCompareTo: anotherObject
	<gtGsExtension>
	^ self asBit threeWayCompareTo: anotherObject asBit'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ByteArray_asString [
	^ GtGemStoneExtensionMethod new
		selector: #asString;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #ByteArray;
		hash: #new;
		source: 'asString
	<gtGsExtension>
	"Convert to a String with Characters for each byte.
	Fast code uses primitive that avoids character conversion"

	^ (String new: self size) replaceFrom: 1 to: self size with: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ByteArray_hex [
 ^ GtGemStoneExtensionMethod new
 selector: #hex;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #ByteArray;
 hash: #new;
 source: 'hex
 <gtGsExtension>
	"Answer a lowercase hexadecimal String representation of the receiver"

	^ String
		new: self size * 2
		streamContents: [ :out |
			self do: [ :each | each printLowercaseHexByteOn: out ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ByteArray_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #ByteArray;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	"Write the receiver with the supplied writer"

	"If there is a specific mapping for the receiver, use that instead of the general collection"
	^ (neoJSONWriter mappingFor: self class ifAbsent: [ nil ])
		ifNotNil: [ neoJSONWriter writeObject: self ]
		ifNil: [ super neoJsonOn: neoJSONWriter ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Class_isClassSide [
	^ GtGemStoneExtensionMethod new
		selector: #isClassSide;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Class;
		hash: #new;
		source: 'isClassSide
	<gtGsExtension>
	^ self isMeta'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Class_withAllSubclasses [
 ^ GtGemStoneExtensionMethod new
  selector: #withAllSubclasses;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Class;
  hash: #new;
  source: 'withAllSubclasses
 <gtGsExtension>
	"Answer a Set of the receiver, the receiver''s descendent''s, and the
	receiver''s descendent''s subclasses."
	
	^ self allSubclasses add: self;
		 yourself'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_addedToZnUrl_ [
	^ GtGemStoneExtensionMethod new
		className: #Collection;
		selector: #'addedToZnUrl:';
		meta: false;
		protocol: #'*Zinc-Resource-Meta-Core';
		gtVersions: nil;
		hash: #new;
		source: 'addedToZnUrl: url
	<gtGsExtension>
	^ url withPathSegments: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_asOrderedDictionary [
	^ GtGemStoneExtensionMethod new
		selector: #asOrderedDictionary;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'asOrderedDictionary

	"Answers a Dictionary based on collection of Associations."

	"{''one'' -> 1. ''two'' ->2} asOrderedDictionary keys first >>> ''one''"

	
	<gtGsExtension>
^ self as: OrderedDictionary'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_asStringOn_delimiter_ [
	^ GtGemStoneExtensionMethod new
		selector: #asStringOn:delimiter:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'asStringOn: aStream delimiter: delimString
	<gtGsExtension>
	self
		do: [ :elem | aStream nextPutAll: elem asString ]
		separatedBy: [ aStream nextPutAll: delimString ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_associationsDo_ [
	^ GtGemStoneExtensionMethod new
		selector: #associationsDo:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'associationsDo: aBlock

	"Evaluate aBlock for each of the receiver''s elements (key/value
	associations).  If any non-association is within, the error is not caught now,
	but later, when a key or value message is sent to it.

	The point of this method it to do the *right thing* on Dictionaries and related classes.
	"

	"(String streamContents: [:s|
		{''one''->1. ''two''->2} associationsDo: [:a|
			s << a key << '':'' << a value asString << '';'']])
	>>> ''one:1;two:2;''"

	"(String streamContents: [:s|
		{''one''->1. ''two''->2} asOrderedDictionary associationsDo: [:a|
			s << a key << '':'' << a value asString << '';'']])
	>>> ''one:1;two:2;''"

	
	<gtGsExtension>
self do: aBlock'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_atRandom [
 ^ GtGemStoneExtensionMethod new
  selector: #atRandom;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Collection;
  hash: #new;
  source: 'atRandom
 <gtGsExtension>
 "Answer a uniformly selected element."
 | index |
 self isEmpty ifTrue: [ self error: ''Cannot select from an empty collection'' ].
 index := Random new integerBetween: 1 and: self size.
 self do: [ :each | index := index - 1. index = 0 ifTrue: [ ^ each ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_backslash [
	^ GtGemStoneExtensionMethod new
		selector: #'\';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: '\ aCollection
	<gtGsExtension>

	"Return all the elements in self that are not in aCollection.
	Alias of difference:"

	"#(10 20 30) \ (0 to: 15) >>> #(20 30)"
	"''abc'' \ ''cbe'' >>> ''a''."

	^ self difference: aCollection'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_collect_as_ [
	^ GtGemStoneExtensionMethod new
		selector: #collect:as:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'collect: aBlock as: aClass
	<gtGsExtension>
	"Evaluate aBlock with each of the receiver''s elements as the argument.
	Collect the resulting values into an instance of aClass. Answer the resulting collection."

	"(#(10 15 22 789) collect: [:x | x//10] as: Set) >>> #(1 2 78) asSet"
	"(''hello'' collect: #asciiValue as: Array) >>> #(104 101 108 108 111)"

	^(aClass new: self size) fillFrom: self with: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_copyEmpty [
 ^ GtGemStoneExtensionMethod new
  selector: #copyEmpty;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Collection;
  hash: #new;
  source: 'copyEmpty
 <gtGsExtension>

	"Return a new empty collection based on the species"

	"{1@2} copyEmpty >>> #()"
	"''hello'' copyEmpty >>> ''''"
	"(1 to: 10) copyEmpty >>> #()"

	^ self species new'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_count_ [
	^ GtGemStoneExtensionMethod new
		selector: #'count:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'count: aBlock
	<gtGsExtension>

	"Evaluate aBlock with each of the receiver''s elements as the argument.
	Answer the number of elements that answered true."

	"(#(1 2 3 4) count: [ :each | each even ]) >>> 2"
	"(''Hello, World!'' count: #isLowercase) >>> 8"

	| sum |
	sum := 0.
	self do: [ :each | (aBlock value: each) ifTrue: [ sum := sum + 1 ] ].
	^ sum'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_do_displayingProgress_ [
	^ GtGemStoneExtensionMethod new
		selector: #do:displayingProgress:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'do: aBlock displayingProgress: aStringOrBlock
	<gtGsExtension>

	^ self do: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_fillFrom_with_ [
	^ GtGemStoneExtensionMethod new
		selector: #fillFrom:with:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'fillFrom: aCollection with: aBlock
	<gtGsExtension>
	"Evaluate aBlock with each of aCollections''s elements as the argument.
	Collect the resulting values into self. Answer self."

	"(#(10 20) asOrderedCollection fillFrom: ''ABC'' with: [:x|x asciiValue]) >>> #(10 20 65 66 67) asOrderedCollection"
	"(#(10 20) asSet fillFrom: ''ABC'' with: [:x|x asciiValue]) >>> #(10 20 65 66 67) asSet"
	"({64->$@} asDictionary fillFrom: ''AB'' with: [:x|x asciiValue -> x]) >>> {64->$@. 65->$A. 66->$B} asDictionary"

	aCollection do: [ :each |
		self add: (aBlock value: each) ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_flatCollect_as_ [
	^ GtGemStoneExtensionMethod new
		selector: #'flatCollect:as:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'flatCollect: aBlock as: aCollectionClass
	<gtGsExtension>
	"Evaluate aBlock for each of the receiver''s elements and answer the
	list of all resulting values flatten one level. Assumes that aBlock returns some kind
	of collection for each element. Equivalent to the lisp''s mapcan"

	"(#(1 2 3) flatCollect: [:each | { each. each+1 } ] as: Set) >>> #(1 2 3 4) asSet"
	"(#(65 66 67) flatCollect: [:each | { each asCharacter. each asCharacter asLowercase } ] as: String) >>> ''AaBbCc''"

	| col |
	col := OrderedCollection new: self size.
	self do: [ :each | col addAll: (aBlock value: each) ].
	^ aCollectionClass withAll: col'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_identityIncludes_ [
 ^ GtGemStoneExtensionMethod new
 selector: #identityIncludes:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Collection;
 hash: #new;
 source: 'identityIncludes: anObject
 <gtGsExtension>
	"Answer whether anObject is one of the receiver''s elements."

	"({#hello. #world} identityIncludes: #hello) >>> true"
	"({''hel'',''lo''. ''world''} identityIncludes: ''hello'') >>> false"
	"({''hel'',''lo''. ''world''} includes: ''hello'') >>> true"

	self do: [:each | anObject == each ifTrue: [^true]].
	^false'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_ifEmpty_ifNotEmpty_ [
	^ GtGemStoneExtensionMethod new
		selector: #ifEmpty:ifNotEmpty:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
	"Evaluate emptyBlock if I''m empty, notEmptyBlock otherwise
	If the notEmptyBlock has an argument, eval with the receiver as its argument"

	
	<gtGsExtension>
^ self isEmpty
		ifTrue: [ emptyBlock value ]
		ifFalse: [ notEmptyBlock cull: self ]'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_intersection_ [
	^ GtGemStoneExtensionMethod new
		selector: #intersection:;
		meta: false;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'intersection: aCollection
	<gtGsExtension>

	^ self species withAll: (self asSet intersection: aCollection) asArray'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Collection;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeList: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_newFromArray_ [
	^ GtGemStoneExtensionMethod new
		selector: #newFromArray:;
		protocol: #'gt-extension';
		meta: true;
		gtVersions: nil;
		className: #Collection;
		hash: #new;
		source: 'newFromArray: anArray

	"Fast initialization with the items of a given array.
	This initializes elements faster that the generic withAll: or newFrom: methods.

	The main selling point is that dynamic arrays, like {1. 2. 3}, are really fast in Pharo.
	So other collections can be easily and efficiently initialized with `{1. 2. 3} asFoo` syntax.

	Important: Subclasses of Collection that redefine withAll: or newFrom: should also redefine this method
	either by having a proper implementation (specific to Arrays) or by calling the redefined versions of withAll:/newFrom:."

	"{ 1. 2. 3 } asSet >>> (Set new add: 1; add:2; add:3; yourself)"
	"{ 1. 2. 3 } asOrderedCollection >>> (OrderedCollection new add: 1; add:2; add:3; yourself)"
	"{ 1->2. 3->4 } asDictionary >>> (Dictionary new at: 1 put: 2; at: 3 put:4; yourself)"

	"({ 1. 2. 3 } as: Set) >>> (Set new add: 1; add:2; add:3; yourself)"
	"({ 1. 2. 3 } as: OrderedCollection) >>> (OrderedCollection new add: 1; add:2; add:3; yourself)"
	"({ 1->2. 3->4 } as: Dictionary) >>> (Dictionary new at: 1 put: 2; at: 3 put:4; yourself)"

	
	<gtGsExtension>
| newCollection size |
	size := anArray size.
	newCollection := self new: size.
	" This should be fast:
	1. Integer>>to:do: is inlined in the bytecode (no block).
	2. The Array>>at: callsite should be monomorph to a primitive method.
	"

	1 to: size do: [ :i | newCollection add: (anArray at: i) ].
	^ newCollection'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Collection_reject_thenDo_ [
 ^ GtGemStoneExtensionMethod new
 selector: #reject:thenDo:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Collection;
 hash: #new;
 source: 'reject: rejectBlock thenDo: doBlock
 <gtGsExtension>
	"Utility method to improve readability.
	Do not create the intermediate collection."

	self do: [ :each |
		(rejectBlock value: each)
			ifFalse: [ doBlock value: each ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_CurrentExecutionEnvironment_runUnmanagedExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runUnmanagedExampleEvaluator:;
		meta: true;
		gtVersions: nil;
		className: #CurrentExecutionEnvironment;
		hash: #new;
		source: 'runUnmanagedExampleEvaluator: anExampleEvaluator
	<gtGsExtension>

	"GemStone evaluates unmanaged examples synchronously in the current process."
	^ anExampleEvaluator value'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DateAndTime_class_fromString_ [
	^ GtGemStoneExtensionMethod new
		selector: #fromString:;
		protocol: #'Instance Creation';
		meta: true;
		gtVersions: nil;
		className: #DateAndTime;
		hash: 'f3c058fc2b52a651f7ca96f525bbd5038ffdceddab8b419a7761b5b5857ca162';
		source: 'fromString: aString
	<gtGsExtension>
	"
	YYYY-MM-DDTHH:MM:SS
	YYYY-MM-DDTHH:MM:SS.ssssss
	YYYY-MM-DDTHH:MM:SS+HH:MM
	YYYY-MM-DDTHH:MM:SS-HH:MM
	YYYY-MM-DDTHH:MM:SS.ssssss+HH:MM
	YYYY-MM-DDTHH:MM:SS.ssssss-HH:MM
	YYYY-MM-DDTHH:MM:SSZ
	YYYY-MM-DDTHH:MM:SS.ssssssZ
"

	| offsetDivider offset secondsEnd offsetHours offsetMinutes |
	(aString isEmpty not and: [ aString last = $Z ])
		ifTrue: [
			^ self fromString: ((aString copyFrom: 1 to: aString size - 1) , ''+00:00'') ].
	offsetDivider := aString findString: '':'' startingAt: 19.
	offsetDivider > 0
		ifTrue: [
			secondsEnd := offsetDivider - 4.
			offsetHours := (aString copyFrom: offsetDivider - 2 to: offsetDivider - 1)
				asNumber.
			offsetMinutes := (aString copyFrom: offsetDivider + 1 to: aString size)
				asNumber.
			offset := Duration
				days: 0
				hours: offsetHours
				minutes: offsetMinutes
				seconds: 0.
			(aString at: offsetDivider - 3) == $-
				ifTrue: [ offset := offset negated ] ]
		ifFalse: [
			secondsEnd := aString size.
			offset := nil ].
	^ self
		year: (aString copyFrom: 1 to: 4) asNumber
		month: (aString copyFrom: 6 to: 7) asNumber
		day: (aString copyFrom: 9 to: 10) asNumber
		hour: (aString copyFrom: 12 to: 13) asNumber
		minute: (aString copyFrom: 15 to: 16) asNumber
		second: (ScaledDecimal fromString: (aString copyFrom: 18 to: secondsEnd))
		offset: offset
'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Date_yyyymmdd [
	^ GtGemStoneExtensionMethod new
		selector: #yyyymmdd;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Date;
		hash: #new;
		source: 'yyyymmdd
	<gtGsExtension>
	"Format the date as a fixed-width ISO date, as in GT."
	^ self asStringUsingFormat: #(3 2 1 $- 1 1)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DefaultExecutionEnvironment_instance [
	^ GtGemStoneExtensionMethod new
		selector: #instance;
		meta: true;
		gtVersions: nil;
		className: #DefaultExecutionEnvironment;
		hash: '3a29aac01eec8949c5860660d69d08e1415f9af6ecdc9e66209c600b3baf4bbc';
		source: 'instance
	<gtGsExtension>

	^ SessionTemps current at: #DefaultExecutionEnvironment_instance ifAbsentPut: [ self new ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DefaultExecutionEnvironment_runExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runExampleEvaluator:;
		meta: false;
		gtVersions: nil;
		className: #DefaultExecutionEnvironment;
		hash: '7a967548d4401a8d779fee8e2a6b59925eaad191775be8cfa80b7490bf45005a';
		source: 'runExampleEvaluator: anExampleEvaluator
	<gtGsExtension>
	| testEnv |
	testEnv := TestExecutionEnvironment new initialize.
	"GemStone does not provide Pharo process-local environment activation."
	[ testEnv activated.
	  ^ testEnv runExampleEvaluator: anExampleEvaluator ]
		ensure: [ testEnv deactivated ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DefaultExecutionEnvironment_runUnmanagedExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runUnmanagedExampleEvaluator:;
		meta: false;
		gtVersions: nil;
		className: #DefaultExecutionEnvironment;
		hash: '010d9099dc737f4aeed515bac7b8698d826aeb51514dcdeb7a5f155151602cac';
		source: 'runUnmanagedExampleEvaluator: anExampleEvaluator
	<gtGsExtension>
	^ TestExecutionEnvironment new initialize
		runUnmanagedExampleEvaluator: anExampleEvaluator'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_associationAt_ifPresent_ [
 ^ GtGemStoneExtensionMethod new
  selector: #associationAt:ifPresent:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'associationAt: key ifPresent: aBlock
 <gtGsExtension>
 | assoc |
 assoc := self associationAt: key ifAbsent: [ ^ nil ].
 ^ aBlock cull: assoc'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_at_at_ [
 ^ GtGemStoneExtensionMethod new
 selector: #at:at:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Dictionary;
 hash: #new;
 source: 'at: firstKey at: secondKey
 <gtGsExtension>
 ^ self at: firstKey at: secondKey ifAbsent: [ KeyNotFound signalFor: secondKey ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_at_at_ifAbsentPut_ [
 ^ GtGemStoneExtensionMethod new
  selector: #at:at:ifAbsentPut:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'at: firstKey at: secondKey ifAbsentPut: aZeroArgBlock
 <gtGsExtension>
	"Return the object stored in the second dictionary at secondKey. The second dictionary is accessed via the key firstKey. If firstKey is not defined, set a new dictionary for the second key and set the value of aZeroArgBlock execution. If firstKey is defined and not second key set the value of aZeroArgBlock execution. See NestedDictionaryTest for examples."

	| subDictionary |
	subDictionary := self at: firstKey ifAbsentPut: [ self copyEmpty ].
	^ subDictionary at: secondKey ifAbsentPut: aZeroArgBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_at_at_ifAbsent_ [
 ^ GtGemStoneExtensionMethod new
  selector: #at:at:ifAbsent:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'at: firstKey at: secondKey ifAbsent: aZeroArgBlock
 <gtGsExtension>
		"Return the object stored in the second dictionary at secondKey. The second dictionary is accessed via the key firstKey. Execute aZeroArgBlock in case one of the key is wrong."

	| subDictionary |
	subDictionary := self at: firstKey ifAbsent: [ ^ aZeroArgBlock value ].
	^ subDictionary at: secondKey ifAbsent: aZeroArgBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_at_at_put_ [
 ^ GtGemStoneExtensionMethod new
  selector: #at:at:put:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'at: firstKey at: secondKey put: aValue
 <gtGsExtension>
	"Set a value at secondKey in the dictionary returned by firstKey."

	| subDictionary |
	subDictionary := self at: firstKey ifAbsentPut: [ self copyEmpty ].
	^ subDictionary at: secondKey put: aValue'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_at_ifPresent_ [
 ^ GtGemStoneExtensionMethod new
  selector: #at:ifPresent:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'at: key ifPresent: aBlock
 <gtGsExtension>
 ^ self at: key ifPresent: aBlock ifAbsent: [ nil ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_at_ifPresent_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #at:ifPresent:ifAbsent:;
		protocol: #'gt-extension';
			meta: false;
		gtVersions: nil;
		className: #Dictionary;
		hash: #new;
		source: 'at: aKey ifPresent: presentBlock ifAbsent: absentBlock
	<gtGsExtension>
	| anAssoc |
	
	anAssoc := self associationAt: aKey otherwise: nil .
	anAssoc == nil ifTrue:[ ^ absentBlock value ].
	^ presentBlock cull: anAssoc value.'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_capacity [
 ^ GtGemStoneExtensionMethod new
  selector: #capacity;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'capacity
 <gtGsExtension>
 "Answer the size of GemStone''s association table."
 ^ self tableSize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_class_newFromPairs_ [
 ^ GtGemStoneExtensionMethod new
 selector: #newFromPairs:;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #Dictionary;
 hash: #new;
 source: 'newFromPairs: anArray
 <gtGsExtension>
	"Answer an instance of me associating (anArray at: i) to (anArray at: i+1)
	 for each odd i.  anArray must have an even number of entries."

	"Dictionary newFromPairs: {''Red'' . Color red . ''Blue'' . Color blue . ''Green'' . Color green}."

	| newDictionary |
	newDictionary := self new: anArray size / 2.
	1 to: anArray size - 1 by: 2 do: [ :i | newDictionary at: (anArray at: i) put: (anArray at: i + 1) ].
	^ newDictionary'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_class_newFrom_ [
 ^ GtGemStoneExtensionMethod new
  selector: #newFrom:;
  protocol: #'gt-extension';
  meta: true;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'newFrom: aDictionaryOrCollectionOfAssociations
 <gtGsExtension>
	"Answer an instance of me containing the same associations as the argument.
	If the same key appears twice, the last one enumerated will win"

	"(Dictionary newFrom: {1->#a. 2->#b. 3->#c}) >>> ({1->#a. 2->#b. 3->#c} asDictionary)"

	| newDictionary |
	newDictionary := self new: aDictionaryOrCollectionOfAssociations size.
	aDictionaryOrCollectionOfAssociations associationsDo: [:x |newDictionary add: x].
	^ newDictionary'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_includesIdentity_ [
 ^ GtGemStoneExtensionMethod new
  selector: #includesIdentity:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'includesIdentity: anObject
 <gtGsExtension>
	"Answer whether anObject is one of the values of the receiver.  Contrast #includes: in which there is only an equality check, here there is an identity check"

	self do: [:each | anObject == each ifTrue: [^ true]].
	^ false'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_keyAtIdentityValue_ [
 ^ GtGemStoneExtensionMethod new
  selector: #keyAtIdentityValue:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'keyAtIdentityValue: value
 <gtGsExtension>
	"Answer the key that is the external name for the argument, value. If
	there is none, answer nil.
	Note: There can be multiple keys with the same value. Only one is returned."

	^self keyAtIdentityValue: value ifAbsent: [self errorValueNotFound: value]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_keyAtIdentityValue_ifAbsent_ [
 ^ GtGemStoneExtensionMethod new
  selector: #keyAtIdentityValue:ifAbsent:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'keyAtIdentityValue: value ifAbsent: exceptionBlock
 <gtGsExtension>
	"Answer the key that is the external name for the argument, value. If
	there is none, answer the result of evaluating exceptionBlock.
	Note: There can be multiple keys with the same value. Only one is returned."

	self associationsDo:
		[:association | value == association value ifTrue: [^association key]].
	^exceptionBlock value'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_keyForIdentity_ [
 ^ GtGemStoneExtensionMethod new
  selector: #keyForIdentity:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'keyForIdentity: anObject
 <gtGsExtension>
	"If anObject is one of the values of the receive, return its key, else return nil.  Contrast #keyAtValue: in which there is only an equality check, here there is an identity check"

	self associationsDo: [:assoc | assoc value == anObject ifTrue: [^ assoc key]].
	^ nil'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_keysSortedSafely [
 ^ GtGemStoneExtensionMethod new
  selector: #keysSortedSafely;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Dictionary;
  hash: #new;
  source: 'keysSortedSafely
 <gtGsExtension>
	"Answer an Array containing the receiver''s keys."
 	"Suggested by l. Uzonyi"

 	| sortedKeys |
 	sortedKeys := self keys asArray.
 	^ sortedKeys sort: [ :x :y |
 		"Should really be use <obj, string, num> compareSafely..."
 		((x isString and: [ y isString ])
 			or: [ x isNumber and: [ y isNumber ] ])
 			ifTrue: [ x < y ]
 			ifFalse: [ x class == y class
 				ifTrue: [ x printString < y printString ]
 				ifFalse: [ x class name < y class name ] ] ].
 	'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Dictionary;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeMap: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Dictionary_removeAll [
 ^ GtGemStoneExtensionMethod new
 selector: #removeAll;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Dictionary;
 hash: #new;
 source: 'removeAll
 <gtGsExtension>
 "Remove all associations while preserving the table capacity."
 self keys do: [ :key | self removeKey: key ].'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_DomainError_class_signalFrom_to_ [
	^ GtGemStoneExtensionMethod new
		className: #DomainError;
		selector: #signalFrom:to:;
		meta: true;
		protocol: #signaling;
		gtVersions: nil;
		hash: '654bdda2b28cc3850843545c2ba5acaa1df4777f0ff6ef7771bb41ccbea36650';
		source: 'signalFrom: start to: end
	<gtGsExtension>
	| msgStart msgEnd |
	msgStart := ((start isKindOf: Float) and: [start isFinite not]) ifTrue: [''(-infinity''] ifFalse: [''['', start printString].
	msgEnd := ((end isKindOf: Float) and: [end isFinite not]) ifTrue: [''infinity)''] ifFalse: [end printString, '']''].
	^ self signal: ''Value outside '', msgStart, '' , '' , msgEnd
		from: start
		to: end'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Duration_class_hours_ [
 ^ GtGemStoneExtensionMethod new
 selector: #hours:;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #Duration;
 hash: #new;
 source: 'hours: aNumber
 <gtGsExtension>
 "Equivalent to GT''s seconds:nanoSeconds: with zero nanoseconds."
 ^ self seconds: aNumber * 3600'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ExecBlock_forkAt_named_ [
	^ GtGemStoneExtensionMethod new
		selector: #forkAt:named:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #ExecBlock;
		hash: #new;
		source: 'forkAt: priority named: aString
	<gtGsExtension>
	"Create and schedule a process with the given priority and name."
	| forkedProcess |
	forkedProcess := self newProcess.
	forkedProcess priority: priority.
	forkedProcess name: aString.
	^ forkedProcess resume'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ExecBlock_forkNamed_ [
	^ GtGemStoneExtensionMethod new
		selector: #forkNamed:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #ExecBlock;
		hash: #new;
		source: 'forkNamed: aString
	<gtGsExtension>
	"Create and schedule a process with the given name."
	^ self newProcess name: aString; resume'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ExecBlock_onErrorDo_ [
	^ GtGemStoneExtensionMethod new
		selector: #onErrorDo:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #ExecBlock;
		hash: #new;
		source: 'onErrorDo: errorHandlerBlock
	<gtGsExtension>
	"Evaluate the receiver and return its value. On Error, return the value of the zero- or one-argument handler."
	^ self on: Error do: [ :ex | errorHandlerBlock cull: ex ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_class_infinity [
 ^ GtGemStoneExtensionMethod new
 selector: #infinity;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'infinity
 <gtGsExtension>
 ^ PlusInfinity'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_class_nan [
 ^ GtGemStoneExtensionMethod new
 selector: #nan;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'nan
 <gtGsExtension>
 "GemStone''s canonical positive quiet NaN."
 ^ PlusQuietNaN'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_class_negativeInfinity [
 ^ GtGemStoneExtensionMethod new
 selector: #negativeInfinity;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'negativeInfinity
 <gtGsExtension>
 ^ MinusInfinity'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_class_zero [
 ^ GtGemStoneExtensionMethod new
 selector: #zero;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'zero
 <gtGsExtension>
	^ 0.0'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_closeTo_ [
 ^ GtGemStoneExtensionMethod new
 selector: #closeTo:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'closeTo: num
 <gtGsExtension>
 "Use the GT DefaultComparisonPrecision value."
 ^ self closeTo: num precision: 1.4901161193847656e-8'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_closeTo_precision_ [
 ^ GtGemStoneExtensionMethod new
 selector: #closeTo:precision:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'closeTo: num precision: aPrecision
 <gtGsExtension>
 num isNumber ifFalse: [ ^ false ].
 ^ self = num asFloat or: [ (self - num) abs <= aPrecision ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_isFinite [
 ^ GtGemStoneExtensionMethod new
 selector: #isFinite;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'isFinite
 <gtGsExtension>
	"simple, byte-order independent test for rejecting Not-a-Number and (Negative)Infinity"

	^(self - self) = 0.0'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Float_isNaN [
 ^ GtGemStoneExtensionMethod new
 selector: #isNaN;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Float;
 hash: #new;
 source: 'isNaN
 <gtGsExtension>
 ^ self ~= self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Fraction_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Fraction;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	"Write the receiver with the supplied writer"

	"If there is a specific mapping for the receiver, use that instead of the general collection"
	^ (neoJSONWriter mappingFor: self class ifAbsent: [ nil ])
		ifNotNil: [ neoJSONWriter writeObject: self ]
		ifNil: [ super neoJsonOn: neoJSONWriter ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GsNMethod_isSourceSearchable [
	^ GtGemStoneExtensionMethod new
		selector: #isSourceSearchable;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #GsNMethod;
		hash: #new;
		source: 'isSourceSearchable
	<gtGsExtension>
	"Other projects may override this to exclude methods from source searches."
	^ true'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GsNMethod_sourceCode [
	^ GtGemStoneExtensionMethod new
		selector: #sourceCode;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #GsNMethod;
		hash: #new;
		source: 'sourceCode
	<gtGsExtension>
	^ self sourceString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtDummyExamplesWithAfterInstanceSide_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		meta: true;
		gtVersions: nil;
		className: #GtDummyExamplesWithAfterInstanceSide;
		hash: #new;
		source: 'new
	<gtGsExtension>
	^ super new initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtExampleDependenciesProcessor_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		meta: true;
		gtVersions: nil;
		className: #GtExampleDependenciesProcessor;
		hash: #new;
		source: 'new
	<gtGsExtension>

	^ self basicNew initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtExampleEvaluator_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		meta: true;
		gtVersions: nil;
		className: #GtExampleEvaluator;
		hash: #new;
		source: 'new
	<gtGsExtension>

	^ super new initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtExample_new [
	^ GtGemStoneExtensionMethod new
		selector: #new;
		meta: true;
		gtVersions: nil;
		className: #GtExample;
		hash: #new;
		source: 'new
	<gtGsExtension>

	^ super new initialize'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_GtSystemUtility_freeze_ [
	^ GtGemStoneExtensionMethod new
		selector: #freeze:;
		meta: true;
		gtVersions: nil;
		className: #GtSystemUtility;
		hash: #new;
		source: 'freeze: anException
	<gtGsExtension>
	"GemStone exceptions capture their stack; do not use Pharo context freezing."
	^ anException copy'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_asCharacterDigit [
 ^ GtGemStoneExtensionMethod new
 selector: #asCharacterDigit;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Integer;
 hash: #new;
 source: 'asCharacterDigit
 <gtGsExtension>
 ^ Character digitValue: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_class_readFrom_ifFail_ [
	^ GtGemStoneExtensionMethod new
		selector: #readFrom:ifFail:;
		protocol: #'gt-extension';
		meta: true;
		gtVersions: nil;
		className: #Integer;
		hash: #new;
		source: 'readFrom: aStringOrStream ifFail: aBlock
	<gtGsExtension>
	"Read an optional minus sign and decimal digits, answering the failure block when no digits exist."
	| stream sign value hasDigits |
	stream := aStringOrStream isString
		ifTrue: [ aStringOrStream readStream ]
		ifFalse: [ aStringOrStream ].
	sign := 1.
	(stream atEnd not and: [ stream peek = $- ])
		ifTrue: [ sign := -1. stream next ].
	value := 0.
	hasDigits := false.
	[ stream atEnd not and: [ ''0123456789'' includes: stream peek ] ]
		whileTrue: [
			hasDigits := true.
			value := value * 10 + stream next digitValue ].
	^ hasDigits ifTrue: [ value * sign ] ifFalse: [ aBlock value ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_digitAt_base_ [
 ^ GtGemStoneExtensionMethod new
 selector: #digitAt:base:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Integer;
 hash: #new;
 source: 'digitAt: anExponent base: base
 <gtGsExtension>
 ^ self // (base raisedToInteger: anExponent - 1) \\ base'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_hashMultiply [
	^ GtGemStoneExtensionMethod new
		selector: #hashMultiply;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Integer;
		hash: #new;
		source: 'hashMultiply
	<gtGsExtension>
	"Multiply hashes by 1664525 modulo 2 raised to 28, without VM-specific primitives."
	^ (self * 1664525) bitAnd: 16r0FFFFFFF'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_isPowerOfTwo [
 ^ GtGemStoneExtensionMethod new
 selector: #isPowerOfTwo;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Integer;
 hash: #new;
 source: 'isPowerOfTwo
 <gtGsExtension>
	"Return true if the receiver is an integral power of two."
	^ self ~= 0 and: [(self bitAnd: self-1) = 0]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Integer;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeInteger: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_numberOfDigitsInBase_ [
 ^ GtGemStoneExtensionMethod new
 selector: #numberOfDigitsInBase:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Integer;
 hash: #new;
 source: 'numberOfDigitsInBase: b
 <gtGsExtension>
	"Return how many digits are necessary to print this number in base b.
	This does not count any place for minus sign, radix prefix or whatever.
	Note that this algorithm may cost a few operations on LargeInteger."

	| nDigits q total |
	self negative ifTrue: [^self negated numberOfDigitsInBase: b].
	self < b ifTrue: [^1].
	b isPowerOfTwo ifTrue: [^self highBit + b highBit - 2 quo: b highBit - 1].

	"A conversion from base 2 to base b has to be performed.
	This algorithm avoids Float computations like (self log: b) floor + 1,
	1) because they are inexact
	2) because LargeInteger might overflow
	3) because this algorithm might be cheaper than conversion"

	q := self.
	total := 0.
	["Make an initial nDigits guess that is lower than or equal to required number of digits"
	nDigits := b = 10
		ifTrue: [((q highBit - 1) * 1233 >> 12) + 1. "This is because (2 log)/(10 log)*4096 is slightly greater than 1233"]
		ifFalse: [q highBit quo: b highBit].
	total := total + nDigits.

	"See how many digits remains above these first nDigits guess"
	(q := q quo: (b raisedToInteger: nDigits)) < b] whileFalse.
	^q = 0
		ifTrue: [total]
		ifFalse: [total + 1]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_printLowercaseHexByteOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #printLowercaseHexByteOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Integer;
 hash: #new;
 source: 'printLowercaseHexByteOn: characterWriteStream
 <gtGsExtension>
	"Assuming the receiver is a byte value [0, 255],
	print a 2 character hexadecimal representation on characterWriteStream
	using the lowercase alphabet."

	(self between: 0 and: 255)
		ifTrue: [
			| highNibble lowNibble hexDigits |
			highNibble := self bitShift: -4.
			lowNibble := self bitAnd: 15.
			hexDigits := ''0123456789abcdef''.
			characterWriteStream
				nextPut: (hexDigits at: highNibble + 1);
				nextPut: (hexDigits at: lowNibble + 1) ]
		ifFalse: [
			self error: ''byte value between 0 and 255 expected'' ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Integer_printStringLength_ [
	^ GtGemStoneExtensionMethod new
		selector: #printStringLength:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Integer;
		hash: #new;
		source: 'printStringLength: minimal
	<gtGsExtension>
	"Answer the decimal representation padded on the left with spaces to at least minimal characters."
	| decimal |
	decimal := self printString.
	^ String streamContents: [ :stream |
		1 to: minimal - decimal size do: [ :index | stream space ].
		stream nextPutAll: decimal ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Magnitude_threeWayCompareTo_ [
	^ GtGemStoneExtensionMethod new
		selector: #threeWayCompareTo:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Magnitude;
		hash: #new;
		source: 'threeWayCompareTo: anotherObject
	<gtGsExtension>
	"Do a three-way comparison between the receiver and anotherObject, returning
	-1 if self < anotherObject
	0 if self = anotherObject
	1 if self > anotherObject
	This assumes a total order in accordance with the mathematical law of trichotomy.
	See also:  http://en.wikipedia.org/wiki/Three-way_comparison"

	^ self = anotherObject
		ifTrue: [ 0 ]
		ifFalse: [ self < anotherObject
				ifTrue: [ -1 ]
				ifFalse: [ 1 ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_bottom [
	^ GtGemStoneExtensionMethod new
		selector: #'bottom';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'bottom
	<gtGsExtension>
	^ bottom'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_class_fromNumber_ [
	^ GtGemStoneExtensionMethod new
		selector: #'fromNumber:';
		protocol: #'gt-extension';
		meta: true;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'fromNumber: aNumber
	<gtGsExtension>
	"Create a margin whose four values are the same and based on anInteger"

	^ self new fromNumber: aNumber; yourself'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_class_fromPoint_ [
	^ GtGemStoneExtensionMethod new
		selector: #'fromPoint:';
		protocol: #'gt-extension';
		meta: true;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'fromPoint: aPoint
	<gtGsExtension>
	"Create a margin whose values are based on the point value: top and bottom are y and left right are x."

	^ self new fromPoint: aPoint; yourself'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_class_fromRectangle_ [
	^ GtGemStoneExtensionMethod new
		selector: #'fromRectangle:';
		protocol: #'gt-extension';
		meta: true;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'fromRectangle: aRectangle
	<gtGsExtension>
	"Create a margin with four values based on aRectangle using exactly top, left, bottom, right semantics. Pay attention that most of the time you should not use this method but prefer top:left:bottom:right:. The reason is that using rectangle may force you to create rectangles with negative extent which is totally wrong and bogus."

	^ self new fromRectangle: aRectangle; yourself'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_fromNumber_ [
	^ GtGemStoneExtensionMethod new
		selector: #'fromNumber:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'fromNumber: anInteger
	<gtGsExtension>

	self setTop: anInteger
		left: anInteger
		bottom: anInteger
		right: anInteger'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_fromPoint_ [
	^ GtGemStoneExtensionMethod new
		selector: #'fromPoint:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'fromPoint: aPoint
	<gtGsExtension>

	self setTop: aPoint y
		left: aPoint x
		bottom: aPoint y
		right: aPoint x'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_fromRectangle_ [
	^ GtGemStoneExtensionMethod new
		selector: #'fromRectangle:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'fromRectangle: aRectangle
	<gtGsExtension>
	"Pay attention do not use this method but prefer top:left:bottom:right:"

	self setTop: aRectangle top
		left: aRectangle left
		bottom: aRectangle bottom
		right: aRectangle right'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_insetRectangle_ [
	^ GtGemStoneExtensionMethod new
		selector: #'insetRectangle:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'insetRectangle: aRectangle
	<gtGsExtension>
	"Answer a rectangle whose size has been reduced by the receiver. The limitation is that since a rectangle topleft is always less than its bottomright you may have a some cases that are not possible to express. For that you should use a margin object instead of a rectangle."

	| l r t b |
	l := aRectangle left 	+ self left.
	r := left max: aRectangle right - self right.
	t := aRectangle top + self top.
	b := top max: aRectangle bottom - self bottom.

	^ Rectangle left: l right: r top: t bottom: b'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_left [
	^ GtGemStoneExtensionMethod new
		selector: #'left';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'left
	<gtGsExtension>
	^ left'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_right [
	^ GtGemStoneExtensionMethod new
		selector: #'right';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'right
	<gtGsExtension>
	^ right'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_setTop_left_bottom_right_ [
	^ GtGemStoneExtensionMethod new
		selector: #'setTop:left:bottom:right:';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'setTop: topNumber left: leftNumber bottom: bottomNumber right: rightNumber
	<gtGsExtension>

	top := topNumber.
	left := leftNumber.
	bottom := bottomNumber.
	right := rightNumber'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Margin_top [
	^ GtGemStoneExtensionMethod new
		selector: #'top';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Margin;
		hash: #new;
		source: 'top
	<gtGsExtension>
	^ top'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Metaclass3_isClassSide [
	^ GtGemStoneExtensionMethod new
		selector: #isClassSide;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Metaclass3;
		hash: #new;
		source: 'isClassSide
	<gtGsExtension>
	^ self isMeta'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_MultiByteString_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #MultiByteString;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeString: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_MutexTest_waitFor_ [
	^ GtGemStoneExtensionMethod new
		selector: #waitFor:;
		protocol: #helpers;
		meta: false;
		gtVersions: nil;
		className: #MutexTest;
		hash: '02d4891dfc39497b992bc29d96ffba251db0cc4dba68914c6872aee640ab2d4b';
		source: 'waitFor: aBlock
	<gtGsExtension>
	500 timesRepeat: [
		(Delay forMilliseconds: 10) wait.
		aBlock value ifTrue: [ ^ self ] ].
	self fail: ''Timed out waiting for process state'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_MutexTest_waitProcessLock_ [
	^ GtGemStoneExtensionMethod new
		selector: #waitProcessLock:;
		protocol: #helpers;
		meta: false;
		gtVersions: nil;
		className: #MutexTest;
		hash: '6675e6aded867518dfa9a4f70f40b19f5a291ebf2024f66b9816c191b8704afa';
		source: 'waitProcessLock: aProcess
	<gtGsExtension>
	self waitFor: [ aProcess waitingOn isNil not ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_MutexTest_waitProcessSuspend_ [
	^ GtGemStoneExtensionMethod new
		selector: #waitProcessSuspend:;
		protocol: #helpers;
		meta: false;
		gtVersions: nil;
		className: #MutexTest;
		hash: 'f676b9f0a3335120a0f714ec43bfefef704e8212b09a33fc5a2ee32e5c3964d7';
		source: 'waitProcessSuspend: aProcess
	<gtGsExtension>
	self waitFor: [ aProcess _isSuspended ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_MutexTest_waitProcessTermination_ [
	^ GtGemStoneExtensionMethod new
		selector: #waitProcessTermination:;
		protocol: #helpers;
		meta: false;
		gtVersions: nil;
		className: #MutexTest;
		hash: 'a1b232330d7e7319e5684e0d65ee534c18cf531ce336ad9db8bb5bb245c2fcbd';
		source: 'waitProcessTermination: aProcess
	<gtGsExtension>
	self waitFor: [ aProcess _isTerminated ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Mutex_critical_ [
	^ GtGemStoneExtensionMethod new
		selector: #critical:;
		protocol: #'mutual exclusion';
		meta: false;
		gtVersions: nil;
		className: #Mutex;
		hash: 'cb0ba924ab6fb36c90bb2b16f591b141449bd386c3dcbca9241c5e1ccf1f1dde';
		source: 'critical: aBlock
	<gtGsExtension>
	"Keep cleanup installed while waiting, including after a signal but before resumption."
	| activeProcess scheduler acquisitionCritical cleanupCritical waiting |
	activeProcess := Processor activeProcess.
	activeProcess == owner ifTrue: [ ^ aBlock value ].
	scheduler := semaphore _scheduler.
	waiting := false.
	^ [
		acquisitionCritical := scheduler _enterCritical.
		[
			waiting := true.
			semaphore wait.
			owner := activeProcess.
			waiting := false
		] ensure: [ acquisitionCritical == 0 ifTrue: [ scheduler _enterCritical. scheduler _exitCritical ] ].
		aBlock value
	] ensure: [
		cleanupCritical := scheduler _enterCritical.
		[
			owner == activeProcess
				ifTrue: [ owner := nil. semaphore signal ]
				ifFalse: [
					waiting ifTrue: [
						(semaphore includesIdentical: activeProcess)
							ifTrue: [ semaphore removeIdentical: activeProcess otherwise: nil ]
							ifFalse: [ semaphore signal ] ] ]
		] ensure: [ cleanupCritical == 0 ifTrue: [ scheduler _enterCritical. scheduler _exitCritical ] ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONArray_asString [
	^ GtGemStoneExtensionMethod new
		selector: #asString;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONArray;
		hash: #new;
		source: 'asString
	<gtGsExtension>
	"Answer my JSON representation, matching GT''s inherited asString behavior."

	^ self printString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONArray_at_add_ [
	^ GtGemStoneExtensionMethod new
		selector: #at:add:;
		protocol: #adding;
		meta: false;
		gtVersions: nil;
		className: #NeoJSONArray;
		hash: '01896760f3a0755a19e34550fdc74f2702f9eec2363430678d81182da7982e61';
		source: 'at: index add: object
	<gtGsExtension>
	"Use a public insertion index and accept either JSON append marker."
	^ (index = ''-'' or: [ index = #''-'' ])
		ifTrue: [ self addLast: object ]
		ifFalse: [ self add: object beforeIndex: index ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONExamplesTests_testMultiInstances [
	^ GtGemStoneExtensionMethod new
		selector: #testMultiInstances;
		protocol: #tests;
		meta: false;
		gtVersions: nil;
		className: #NeoJSONExamplesTests;
		hash: '5192becf181a0917fbd6af9ceb6225a6ae23d3c4d5c049896bbd0de298f7f3d0';
		source: 'testMultiInstances
	<gtGsExtension>
	"Newline delimited JSON (application/x-ndjson) - https://github.com/ndjson/ndjson-spec"
	"JSON Lines (application/jsonl) - https://jsonlines.org"

	| data json |
	
	data := (1 to: 10) collect: [ :each |
		{ ''number'' -> each } asDictionary ].
	
	json := String streamContents: [ :out |
		(NeoJSONWriter on: out) nextPutAll: data ].
	
	self assert: (NeoJSONReader on: json readStream) upToEnd equals: data.
	
	self assert: (NeoJSONReader on: json readStream) next equals: data first.
	self deny: ((NeoJSONReader on: json readStream) next; atEnd)
'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObjectTests_testCRUD [
	^ GtGemStoneExtensionMethod new
		selector: #testCRUD;
		protocol: #testing;
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObjectTests;
		hash: '1ff6438f214473d0240e6cbd31170ef14a8574f66f775c67ce191687479a8f58';
		source: 'testCRUD
	<gtGsExtension>
	| object |
	object := NeoJSONObject new.
	self assert: object isEmpty.
	self assert: object foo equals: nil.
	object foo: 123.
	self assert: object foo equals: 123.
	self assert: object printString equals: ''{"foo":123}''.
	object name: ''test''.
	object value: Float pi.
	self assert: object name equals: ''test''.
	self assert: (object value closeTo: Float pi).
	self assert: object keys asSet equals: #(''foo'' ''name'' ''value'') asSet.
	object removeKey: ''foo''.
	self assert: object foo equals: nil.
	object removeAll.
	self assert: object isEmpty'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObjectTests_testFindPath [
	^ GtGemStoneExtensionMethod new
		selector: #testFindPath;
		protocol: #testing;
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObjectTests;
		hash: 'c5f22588bb461daefe5a0015754d34279036515a6a9e95084eae204cebe44b6a';
		source: 'testFindPath
	<gtGsExtension>
	| json path |
	json := self exampleJSONSchema.
	
	path := json findPath: [ :object | object isDictionary and: [ (object at: ''$anchor'') = ''street_address'' ] ].
	self deny: path isNil.
	self assert: path equals: #(''properties'' ''street_address'').
	self assert: ((json atPath: path) at: ''$anchor'') equals: ''street_address''.
		
	path := json findPath: [ :object | object isDictionary and: [ (object at: ''foo'') = ''bar'' ] ].
	self assert: path isNil.
	
	path := json findPath: [ :object | object isDictionary and: [ (object at: ''$anchor'') = ''country'' ] ].
	self deny: path isNil.
	self assert: path equals: #(''$defs'' ''country'').
	self assert: ((json atPath: path) at: ''$anchor'') equals: ''country''.
	
	json := NeoJSONObject new at: ''$anchor'' put: ''top''; yourself.
	self 
		assert: (json findPath: [ :object | object isDictionary and: [ (object at: ''$anchor'') = ''top'' ] ])
		equals: #(())'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObjectTests_testFindPaths [
	^ GtGemStoneExtensionMethod new
		selector: #testFindPaths;
		protocol: #testing;
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObjectTests;
		hash: 'a04af3eb0169385b383491e0a860bce4c8350ad01cc5f23338a37fa823641595';
		source: 'testFindPaths
	<gtGsExtension>
	| json paths |
	json := self exampleJSONSchema.
	
	paths := json findPaths: [ :object | object isDictionary and: [ object includesKey: ''$anchor'' ] ].
	self deny: paths isEmpty.
	self assert: paths asArray equals: #((''properties'' ''street_address'') (''$defs'' ''country'')).
	self assert: ((json atPath: paths first) at: ''$anchor'') equals: ''street_address''.
	self assert: ((json atPath: paths second) at: ''$anchor'') equals: ''country''.
			
	paths := json findPaths: [ :object | object isDictionary and: [ (object at: ''foo'') = ''bar'' ] ].
	self assert: paths isEmpty.
	
	paths := json findPaths: [ :object | object isDictionary and: [ object includesKey: ''type'' ] ].
	self deny: paths isEmpty.
	paths do: [ :path |
		self assert: (#(''string'' ''object'') includes: ((json atPath: path) at: ''type'')) ].
		
	paths := json findPaths: [ :_ | true ].
	paths do: [ :each | 
		self assert: (json atPath: each) notNil ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_add_ [
	^ GtGemStoneExtensionMethod new
		selector: #add:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'add: anAssociation
	<gtGsExtension>
	^ super add: ((self normalizedJsonKey: anAssociation key) -> anAssociation value)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_asOrderedDictionary [
	^ GtGemStoneExtensionMethod new
		selector: #asOrderedDictionary;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'asOrderedDictionary
	<gtGsExtension>
	"Copy properties without invoking dynamic JSON property setters."
	| result |
	result := OrderedDictionary new.
	self keysAndValuesDo: [ :key :value | result at: key put: value ].
	^ result'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_associationAt_ [
	^ GtGemStoneExtensionMethod new
		selector: #associationAt:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'associationAt: aKey
	<gtGsExtension>
	^ super associationAt: (self normalizedJsonKey: aKey)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_associationAt_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #associationAt:ifAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'associationAt: aKey ifAbsent: aBlock
	<gtGsExtension>
	^ super associationAt: (self normalizedJsonKey: aKey) ifAbsent: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_associationAt_ifPresent_ [
	^ GtGemStoneExtensionMethod new
		selector: #associationAt:ifPresent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'associationAt: aKey ifPresent: aBlock
	<gtGsExtension>
	^ super associationAt: (self normalizedJsonKey: aKey) ifPresent: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_associationAt_ifPresent_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #associationAt:ifPresent:ifAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'associationAt: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock
	<gtGsExtension>
	self associationAt: aKey ifPresent: [ :association | ^ aPresentBlock cull: association ].
	^ anAbsentBlock value'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_at_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #at:ifAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'at: aKey ifAbsent: aBlock
	<gtGsExtension>
	^ super at: (self normalizedJsonKey: aKey) ifAbsent: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_at_ifPresent_ [
	^ GtGemStoneExtensionMethod new
		selector: #at:ifPresent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'at: aKey ifPresent: aBlock
	<gtGsExtension>
	^ super at: (self normalizedJsonKey: aKey) ifPresent: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_at_ifPresent_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #at:ifPresent:ifAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'at: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock
	<gtGsExtension>
	^ super at: (self normalizedJsonKey: aKey) ifPresent: aPresentBlock ifAbsent: anAbsentBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_at_put_ [
	^ GtGemStoneExtensionMethod new
		selector: #at:put:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'at: aKey put: aValue
	<gtGsExtension>
	^ super at: (self normalizedJsonKey: aKey) put: aValue'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_class_fromStream_ [
	^ GtGemStoneExtensionMethod new
		selector: #fromStream:;
		protocol: #convenience;
		meta: true;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: '2d3b8af77b7c1d9c919b7e775bbb29d3e7a0e23143396960f8cb2e5f92569826';
		source: 'fromStream: readStream
	<gtGsExtension>
	"Parse stream as JSON, so that maps become instances of me and lists instances of NeoJSONArray"

	^ (NeoJSONReader on: readStream readStream)
			mapClass: self;
			listClass: NeoJSONArray;
			propertyNamesAsSymbols: false;
			next
'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_includesAssociation_ [
	^ GtGemStoneExtensionMethod new
		selector: #includesAssociation:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'includesAssociation: anAssociation
	<gtGsExtension>
	^ super includesAssociation: ((self normalizedJsonKey: anAssociation key) -> anAssociation value)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_includesKey_ [
	^ GtGemStoneExtensionMethod new
		selector: #includesKey:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'includesKey: aKey
	<gtGsExtension>
	^ super includesKey: (self normalizedJsonKey: aKey)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_indexOfKey_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #indexOfKey:ifAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'indexOfKey: aKey ifAbsent: aBlock
	<gtGsExtension>
	^ super indexOfKey: (self normalizedJsonKey: aKey) ifAbsent: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_normalizedJsonKey_ [
	^ GtGemStoneExtensionMethod new
		selector: #normalizedJsonKey:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'normalizedJsonKey: aKey
	<gtGsExtension>
	"JSON property names use strings; leave other key types unchanged."
	^ aKey isSymbol ifTrue: [ aKey asString ] ifFalse: [ aKey ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_removeKey_ [
	^ GtGemStoneExtensionMethod new
		selector: #removeKey:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'removeKey: aKey
	<gtGsExtension>
	^ super removeKey: (self normalizedJsonKey: aKey)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_removeKey_ifAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #removeKey:ifAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'removeKey: aKey ifAbsent: aBlock
	<gtGsExtension>
	^ super removeKey: (self normalizedJsonKey: aKey) ifAbsent: aBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONObject_replaceKey_with_ [
	^ GtGemStoneExtensionMethod new
		selector: #replaceKey:with:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONObject;
		hash: #new;
		source: 'replaceKey: aKey with: otherKey
	<gtGsExtension>
	^ super replaceKey: (self normalizedJsonKey: aKey) with: (self normalizedJsonKey: otherKey)'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONReaderTests_testDate [
	^ GtGemStoneExtensionMethod new
		selector: #testDate;
		protocol: #'testing';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONReaderTests;
		hash: '49cbcfdb53f29a6fa7f1d63f8d182edd210813c70103278cb2c5cbaf0348c3dc';
		source: 'testDate
	<gtGsExtension>
	| reader |
	reader := [ :input | 
		(NeoJSONReader on: input readStream) 
			for: Date customDo: [ :mapping |
				mapping decoder: [ :string | Date fromString: string usingFormat: #(3 2 1 $- 1 1) ] ];
			nextAs: Date ].
	self assert: (reader value: '' "2012-06-08" '') equals: (Date fromString: ''2012-06-08'' usingFormat: #(3 2 1 $- 1 1)) '
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONWriterTests_testDate [
	^ GtGemStoneExtensionMethod new
		selector: #testDate;
		protocol: #'testing';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONWriterTests;
		hash: '761ce059998dfc96863b9219d1e79055fbfe89c06920d155c061a421f57f385f';
		source: 'testDate
	<gtGsExtension>
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: object class customDo: [ :mapping |
					mapping encoder: [ :date | date yyyymmdd ] ];
				nextPut: object ] ].
	self assert: (writer value: (Date fromString: ''2012-06-08'' usingFormat: #(3 2 1 $- 1 1))) equals: ''"2012-06-08"'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONWriterTests_testDateAndTime [
	^ GtGemStoneExtensionMethod new
		selector: #testDateAndTime;
		protocol: #'testing';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONWriterTests;
		hash: 'b7ec0fbcecd5c77d3aa3a5ac10cf1701cde9cddd5b67c5e2f97c9b470d0aaf60';
		source: 'testDateAndTime 
	<gtGsExtension>
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: object class customDo: [ :mapping |
					mapping encoder: [ :dateAndTime | dateAndTime asString ] ];
				nextPut: object ] ].
	self 
		assert: (writer value: (DateAndTime year: 2012 month: 2 day: 14 hour: 16 minute: 40 second: 18 offset: 1 hour)) 
		equals: ''"2012-02-14T16:40:18+01:00"'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONWriterTests_testTime [
	^ GtGemStoneExtensionMethod new
		selector: #testTime;
		protocol: #'testing';
		meta: false;
		gtVersions: nil;
		className: #NeoJSONWriterTests;
		hash: '8a27ae52825467ea00c1132d2469bf19fd69578af1733f448058f4064f74fa7b';
		source: 'testTime
	<gtGsExtension>
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: object class customDo: [ :mapping |
					mapping encoder: [ :time | time asStringUsingFormat: #($: true true) ] ];
				nextPut: object ] ].
	self assert: ((writer value: (Time fromSeconds: 52208)) includesSubstring: ''2:30:08'')'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_NeoJSONWriter_initialize [
 ^ GtGemStoneExtensionMethod new
  selector: #initialize;
  protocol: #'initialize-release';
  meta: false;
  gtVersions: nil;
  className: #NeoJSONWriter;
  hash: 'd9b0edac4892f9a1e1bfe0a5dd80963628cd0ece98ea8b7ca038f157e5e4e2af';
  source: 'initialize
 <gtGsExtension>
 super initialize.
 self newLine: Character lf asString.
 self prettyPrint: false.
 self asciiOnly: false.
 self writeNil: false.
 self floatPrinter: self.
 level := 0'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_adaptToPoint_andSend_ [
	^ GtGemStoneExtensionMethod new
		selector: #adaptToPoint:andSend:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Number;
		hash: #new;
		source: 'adaptToPoint: rcvr andSend: selector
	<gtGsExtension>
	"If I am involved in arithmetic with a Point, convert me to a Point."
	^ rcvr perform: selector with: self@self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_asMargin [
	^ GtGemStoneExtensionMethod new
		selector: #'asMargin';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Number;
		hash: #new;
		source: 'asMargin
	<gtGsExtension>
	^ Margin fromNumber: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_asPoint [
	^ GtGemStoneExtensionMethod new
		selector: #'asPoint';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Number;
		hash: #new;
		source: 'asPoint
	<gtGsExtension>
	"Answer a Point with the receiver as both coordinates; often used to
	supply the same value in two dimensions, as with symmetrical gridding
	or scaling."

	^self @ self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_atSign [
 ^ GtGemStoneExtensionMethod new
  selector: #@;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #Number;
  hash: #new;
  source: '@ y
 <gtGsExtension>
 ^ Point x: self y: y'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_closeTo_ [
 ^ GtGemStoneExtensionMethod new
 selector: #closeTo:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Number;
 hash: #new;
 source: 'closeTo: num
 <gtGsExtension>
 (num isKindOf: Float) ifTrue: [ ^ num closeTo: self asFloat ].
 ^ [ self = num ] on: Error do: [ :error | false ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_hour [
 ^ GtGemStoneExtensionMethod new
 selector: #hour;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Number;
 hash: #new;
 source: 'hour
 <gtGsExtension>
 ^ self hours'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_hours [
 ^ GtGemStoneExtensionMethod new
 selector: #hours;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Number;
 hash: #new;
 source: 'hours
 <gtGsExtension>
 ^ Duration hours: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Number_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Number;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeFloat: self asFloat'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_assert_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'assert: aBlock
	<gtGsExtension>

	"Throw an assertion error if aBlock does not evaluates to true.
	We check for true explicitly to make the assertion fail for non booleans"

	self assert: aBlock description: ''Assertion failed'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_assert_description_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:description:;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'assert: aBlock description: aStringOrBlock
	<gtGsExtension>

	"Throw an assertion error if aBlock does not evaluates to true."

	"we do the == true check to avoid NonBooleanReceiver error for nonBoolean aBlock values"
	aBlock value == true ifFalse: [
		AssertionFailure signal: aStringOrBlock value ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_assert_equals_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:equals:;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'assert: actual equals: expected
	<gtGsExtension>
	^ self assert: expected = actual description: [ ''Got '', actual printString, '' instead of '', expected printString ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_class_gtExampleRuntimeContext [
	^ GtGemStoneExtensionMethod new
		selector: #gtExampleRuntimeContext;
		meta: true;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'gtExampleRuntimeContext
	<gtGsExtension>
	^ self gtExamplesFactoryClass gtExampleRuntimeContext'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_fullPrintString [
	^ GtGemStoneExtensionMethod new
		selector: #fullPrintString;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'fullPrintString
	<gtGsExtension>
	^ self printString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_gtExampleRuntimeContext [
	^ GtGemStoneExtensionMethod new
		selector: #gtExampleRuntimeContext;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'gtExampleRuntimeContext
	<gtGsExtension>
	^ self class gtExampleRuntimeContext'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_gtLiveFor_ [
	^ GtGemStoneExtensionMethod new
		selector: #gtLiveFor:;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'gtLiveFor: aView
	"I am a utility method that can be useful for polymorphic purposes"
	<gtGsExtension>

	^ self gtPrintFor: aView'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_isArray [
	^ GtGemStoneExtensionMethod new
		selector: #isArray;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'isArray
	<gtGsExtension>
	
	^ false'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_isBoolean [
	^ GtGemStoneExtensionMethod new
		selector: #isBoolean;
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'isBoolean
	<gtGsExtension>

	"Answer a boolean indicating whether the receiver is a boolean"

	^ false'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_isPoint [
	^ GtGemStoneExtensionMethod new
		selector: #'isPoint';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Object;
		hash: #new;
		source: 'isPoint
	<gtGsExtension>
	"Overridden to return true in Point."

	^ false'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Object_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Object;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeObject: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_OpalCompiler_evaluate_ [
 ^ GtGemStoneExtensionMethod new
  selector: #evaluate:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #OpalCompiler;
  hash: #new;
  source: 'evaluate: aString
 <gtGsExtension>
 "Evaluate a Smalltalk expression in the current GemStone symbol list."
 ^ aString evaluate'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_OrderedCollection_removeAll [
	^ GtGemStoneExtensionMethod new
		selector: #removeAll;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #OrderedCollection;
		hash: #new;
		source: 'removeAll
	<gtGsExtension>
	"Remove all elements, as in GT OrderedCollection>>removeAll.
	GemStone stores elements directly rather than in a Pharo backing array."
	self isEmpty ifFalse: [ self removeFrom: 1 to: self size ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_OrderedCollection_removeAt_ [
	^ GtGemStoneExtensionMethod new
		selector: #removeAt:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #OrderedCollection;
		hash: #new;
		source: 'removeAt: index
	<gtGsExtension>
	"Remove and return the element at the public index, as in GT."
	^ self removeAtIndex: index'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_OrderedDictionaryTest_changedOrderedAssociationsFirst_ [
	^ GtGemStoneExtensionMethod new
		selector: #changedOrderedAssociationsFirst:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #OrderedDictionaryTest;
		hash: '3b21f71b7285bd34221751a363c370b15c093dae14b8d20193eca6a70882b204';
		source: 'changedOrderedAssociationsFirst: anInteger	
	<gtGsExtension>
	
	^ self changedOrderedAssociations copyFrom: 1 to: anInteger'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_OrderedDictionaryTest_orderedAssociationsFirst_ [
	^ GtGemStoneExtensionMethod new
		selector: #orderedAssociationsFirst:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #OrderedDictionaryTest;
		hash: 'd0b12077db764c34da7cda39e1f4ea1abafff542947c7a15ba68103286f18795';
		source: 'orderedAssociationsFirst: anInteger
	<gtGsExtension>
	
	^ self orderedAssociations copyFrom: 1 to: anInteger'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Point_asMargin [
	^ GtGemStoneExtensionMethod new
		selector: #'asMargin';
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Point;
		hash: #new;
		source: 'asMargin
	<gtGsExtension>
	"Return a margin instance based on the receiver. aMargin is an object representing either 1, 2 or 4 numbers. It represents the space between a rectangular area and this rectangular area augmented by the margin"

	^ Margin fromPoint: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ReadStream_readStream [
 ^ GtGemStoneExtensionMethod new
 selector: #readStream;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #ReadStream;
 hash: #new;
 source: 'readStream
 <gtGsExtension>
	"polymorphic with SequenceableCollection.  Return self"

	^ self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SequenceableCollection_allButLastDo_ [
 ^ GtGemStoneExtensionMethod new
 selector: #allButLastDo:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #SequenceableCollection;
 hash: #new;
 source: 'allButLastDo: block
 <gtGsExtension>

	"Executes aBlock on each of the receiver''s elements except for the last one"

	"(Array streamContents: [:stream | #(1 2 3) allButLastDo: [:each | stream nextPut: (each + 10)]]) >>> #(11 12)"

	1 to: self size - 1 do:
		[:index | block value: (self at: index)]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SequenceableCollection_first_ [
	^ GtGemStoneExtensionMethod new
		selector: #first:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #SequenceableCollection;
		hash: 'dcb35a7dde1e3716db66544193b1b5885f0da375d8aab831f39af880d4b7ed18';
		source: 'first: n
	"Answer the first n elements of the receiver.
	Raise an error if there are not enough elements."
	"(#(a b c d e f g h ) first: 3) >>> #(a b c)"

	
	<gtGsExtension>
^ self copyFrom: 1 to: n'

]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SequenceableCollection_isSortedBy_ [
	^ GtGemStoneExtensionMethod new
		selector: #isSortedBy:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #SequenceableCollection;
		hash: #new;
		source: 'isSortedBy: aBlock
	<gtGsExtension>
	"Return true if the receiver is sorted by the given criterion."
	"(#(1 2 3) isSortedBy: [:a :b | a <= b ]) >>> true"
	"(#(1 2 3) isSortedBy: [:a :b | a >= b ]) >>> false"
	"(#(xa xc xz xb xy) isSortedBy: #last ascending) >>> false"
	"(#(xa xb xc xy xz) isSortedBy: #last ascending) >>> true"

	| lastElm elm |
	self isEmpty ifTrue: [^ true].
	lastElm := self first.
	2 to: self size do:
		[:index |
		elm := self at: index.
		(aBlock value: lastElm value: elm) ifFalse: [^ false].
		lastElm := elm].
	^ true'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SequenceableCollection_sorted [
 ^ GtGemStoneExtensionMethod new
 selector: #sorted;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #SequenceableCollection;
 hash: #new;
 source: 'sorted
 <gtGsExtension>
	"Return a new sequenceable collection which contains the same elements as self but its
elements are sorted in ascending order using the #''<='' operator."
	"#(8 5 3 9) sorted >>> #(3 5 8 9)"
	"#(a b z d) sorted >>> #(a b d z)"

	^self sorted: [ :a :b| a <= b ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SequenceableCollection_sorted_ [
 ^ GtGemStoneExtensionMethod new
 selector: #sorted:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #SequenceableCollection;
 hash: #new;
 source: 'sorted: aSortBlockOrNil
 <gtGsExtension>
	"Return a new sequenceable collection which contains the same elements as self but its
elements are sorted by aSortBlockOrNil. The block should take two arguments and return true if
the first element should preceed the second one. If aSortBlock is nil then <= is used for
comparison."
	"(#(3 9 1) sorted: [:a :b | a <= b ]) >>> #(1 3 9)"
	"(#(3 9 1) sorted: [:a :b | a >= b ]) >>> #(9 3 1)"
	"(#(xa xc xz xb xy) sorted: #last ascending) >>> #(xa xb xc xy xz)"

	^ (self copy sort: aSortBlockOrNil) as: self species'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SequenceableCollection_writeStream [
 ^ GtGemStoneExtensionMethod new
 selector: #writeStream;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #SequenceableCollection;
 hash: #new;
 source: 'writeStream
 <gtGsExtension>
	^ WriteStream on: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Set_intersection_ [
	^ GtGemStoneExtensionMethod new
		selector: #intersection:;
		meta: false;
		gtVersions: nil;
		className: #Set;
		hash: #new;
		source: 'intersection: aCollection
	<gtGsExtension>
	"Answer the set theoretic intersection of two collections.
	Optimized version for Sets where no intermediate Set is necessary"

	"(#(1 2 3 4) asSet intersection: #(3 4 5) asSet) >>> #(3 4) asSet"

	"(#(1 2 3 4) asSet intersection: #() asSet) >>> Set new"

	"( #() asSet intersection: #(1 2 3 4) asSet) >>> Set new"

	| outputSet |
	outputSet := self class new.
	aCollection do: [ :each | (self includes: each) ifTrue: [ outputSet add: each ] ].
	^ outputSet'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SmallInteger_printOn_base_length_padded_ [
 ^ GtGemStoneExtensionMethod new
 selector: #printOn:base:length:padded:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #SmallInteger;
 hash: #new;
 source: 'printOn: stream base: base length: minimumLength padded: padWithZeroes
 <gtGsExtension>
	"Return a String representation of this number in base b with a minimum length and padded by 0 if zeroFlag is set"

	"(String streamContents: [ :s | 10 printOn: s base: 10 length: 4 padded: true] ) >>> ''0010''"
	"(String streamContents: [ :s | -10 printOn: s base: 10 length: 4 padded: true] ) >>> ''-010''"

	| n numberOfDigits totalLength divisor |
	self < 0
		ifTrue: [
			n := self negated.
			totalLength := 1 ]
		ifFalse: [
			n := self.
			totalLength := 0 ].
	numberOfDigits := n numberOfDigitsInBase: base.
	totalLength := totalLength + numberOfDigits.
	padWithZeroes ifFalse: [
		[ totalLength < minimumLength ] whileTrue: [
			stream space.
			totalLength := totalLength + 1 ] ].
	n = self ifFalse: [ stream nextPut: $- ].
	padWithZeroes ifTrue: [
		[ totalLength < minimumLength ] whileTrue: [
			stream nextPut: $0.
			totalLength := totalLength + 1 ] ].
	divisor := (base raisedToInteger: numberOfDigits - 1).
	[ divisor > 0 ] whileTrue: [
		| digit |
		digit := n // divisor.
		stream nextPut: (''0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'' at: digit + 1).
		n := n - (digit * divisor).
		divisor := divisor // base ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SmallInteger_printOn_base_nDigits_ [
 ^ GtGemStoneExtensionMethod new
 selector: #printOn:base:nDigits:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #SmallInteger;
 hash: #new;
 source: 'printOn: aStream base: b nDigits: n
 <gtGsExtension>
	"Append a representation of this number in base b on aStream using nDigits.
	self must be positive."

	self printOn: aStream base: b length: n padded: true'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_SortFunction_class_default [
	^ GtGemStoneExtensionMethod new
		selector: #default;
		protocol: #'accessing';
		meta: true;
		gtVersions: nil;
		className: #SortFunction;
		hash: '3d3743f94b535355530faf00b797eb9d15263a7aebceffddcd3c0871419db96c';
		source: 'default
	<gtGsExtension>
	^ SessionTemps current at: #SortFunction_default_value ifAbsentPut: [ DefaultSortFunction new ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_addedToZnUrl_ [
	^ GtGemStoneExtensionMethod new
		className: #String;
		selector: #'addedToZnUrl:';
		meta: false;
		protocol: #'*Zinc-Resource-Meta-Core';
		gtVersions: nil;
		hash: #new;
		source: 'addedToZnUrl: url
	<gtGsExtension>
	^ url withPathSegments: (self subStrings: ''/'')'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_asClass [
	^ GtGemStoneExtensionMethod new
		selector: #asClass;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'asClass
	<gtGsExtension>
	^ self asSymbol asClass'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_asClassIfAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #asClassIfAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'asClassIfAbsent: absentBlock
	<gtGsExtension>
	^ self asSymbol asClassIfAbsent: absentBlock'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_asPluralBasedOn_ [
	^ GtGemStoneExtensionMethod new
		selector: #asPluralBasedOn:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'asPluralBasedOn: aNumberOrCollection
	<gtGsExtension>
	^ (aNumberOrCollection = 1 or: [
		aNumberOrCollection isCollection and: [ aNumberOrCollection size = 1 ]])
		ifTrue: [ self ]
		ifFalse: [ self, ''s'' ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_asUrl [
	^ GtGemStoneExtensionMethod new
		className: #String;
		selector: #'asUrl';
		meta: false;
		protocol: #'*Zinc-Resource-Meta-Core';
		gtVersions: nil;
		hash: #new;
		source: 'asUrl
	<gtGsExtension>
	^ self asZnUrl'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_asZnUrl [
	^ GtGemStoneExtensionMethod new
		className: #String;
		selector: #'asZnUrl';
		meta: false;
		protocol: #'*Zinc-Resource-Meta-Core';
		gtVersions: nil;
		hash: '6f92cdede440f2cd6d730c2511d047d967a40107a97f019ffdb6c69001268045';
		source: 'asZnUrl
	<gtGsExtension>
	^ ZnUrl fromString: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_capitalized [
	^ GtGemStoneExtensionMethod new
		selector: #capitalized;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'capitalized
	<gtGsExtension>
	"Return a copy with the first letter capitalized"
	
	"''abc'' capitalized >>> ''Abc''"
	
	| cap |
	self isEmpty ifTrue: [ ^self copy ].
	cap := self copy.
	cap at: 1 put: (cap at: 1) asUppercase.
	^ cap'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_class_new_withAll_ [
 ^ GtGemStoneExtensionMethod new
 selector: #new:withAll:;
 protocol: #'gt-extension';
 meta: true;
 gtVersions: nil;
 className: #String;
 hash: #new;
 source: 'new: size withAll: value
 <gtGsExtension>
 "GemStone new: reserves capacity; fill through a stream to preserve GT''s result."
 ^ self streamContents: [ :stream | size timesRepeat: [ stream nextPut: value ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_findTokens_ [
	^ GtGemStoneExtensionMethod new
		selector: #findTokens:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'findTokens: delimiters
	<gtGsExtension>
	"Accept a character or collection of delimiters and omit empty tokens, as in GT."
	| separators |
	separators := delimiters isCharacter
		ifTrue: [ Array with: delimiters ]
		ifFalse: [ delimiters ].
	^ (self substrings: separators) asOrderedCollection'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_format_ [
	^ GtGemStoneExtensionMethod new
		selector: #format:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'format: collection
	<gtGsExtension>
	"Format the receiver by interpolating elements from collection, as in the following examples:"
	"(''Five is {1}.'' format: { 1 + 4}) >>> ''Five is 5.''"
	"(''Five is {five}.'' format: (Dictionary with: #five -> 5)) >>>  ''Five is 5.''"
	"(''In {1} you can escape \{ by prefixing it with \\'' format: {''strings''}) >>> ''In strings you can escape { by prefixing it with \'' "
	"(''In \{1\} you can escape \{ by prefixing it with \\'' format: {''strings''}) >>> ''In {1} you can escape { by prefixing it with \'' "

	^ self species
		new: self size
		streamContents: [ :result |
			| stream |
			stream := self readStream.
			[ stream atEnd ]
				whileFalse: [ | currentChar |
					(currentChar := stream next) == ${
						ifTrue: [ | expression index |
							expression := stream upTo: $}.
							"Parse a decimal index as GT does, using GemStone stream operations."
							index := [ | input value sign hasDigits |
								input := expression readStream.
								sign := 1.
								(input atEnd not and: [ input peek = $- ])
									ifTrue: [ sign := -1. input next ].
								value := 0.
								hasDigits := false.
								[ input atEnd not and: [ ''0123456789'' includes: input peek ] ]
									whileTrue: [ hasDigits := true. value := value * 10 + input next digitValue ].
								hasDigits ifTrue: [ value * sign ] ifFalse: [ expression ] ] value.
							result nextPutAll: (collection at: index) asString ]
						ifFalse: [ currentChar == $\
								ifTrue: [ stream atEnd
										ifFalse: [ result nextPut: stream next ] ]
								ifFalse: [ result nextPut: currentChar ] ] ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_includesSubstring_ [
 ^ GtGemStoneExtensionMethod new
 selector: #includesSubstring:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #String;
 hash: #new;
 source: 'includesSubstring: substring
 <gtGsExtension>
	"Returns whether the receiver contains the argument."
	"(''abcdefgh'' includesSubstring: ''de'') >>> true"

	^ substring isEmpty or: [ (self findString: substring startingAt: 1) > 0 ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #String;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeString: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_removePrefix_ [
	^ GtGemStoneExtensionMethod new
		selector: #removePrefix:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'removePrefix: prefix
	<gtGsExtension>
	"Remove the given prefix, if present."
	^ (self beginsWith: prefix)
		ifTrue: [ self copyFrom: 1 + prefix size to: self size ]
		ifFalse: [ self ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_removeSuffix_ [
	^ GtGemStoneExtensionMethod new
		selector: #removeSuffix:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'removeSuffix: suffix
	<gtGsExtension>
	"Remove the given suffix, if present."
	^ (self endsWith: suffix)
		ifTrue: [ self copyFrom: 1 to: self size - suffix size ]
		ifFalse: [ self ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_splitOn_ [
	^ GtGemStoneExtensionMethod new
		selector: #splitOn:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'splitOn: splitter
	<gtGsExtension>
	"Adapt GT''s split:indicesDo: implementations, preserving empty fields.
	Custom splitters such as regular expressions can implement split:."
	| result start position separatorSize sequence |
	result := OrderedCollection new.
	start := 1.
	(splitter isKindOf: ExecBlock) ifTrue: [
		1 to: self size do: [ :index |
			(splitter value: (self at: index)) ifTrue: [
				result add: (self copyFrom: start to: index - 1).
				start := index + 1 ] ].
		result add: (self copyFrom: start to: self size).
		^ result ].
	sequence := splitter isKindOf: SequenceableCollection.
	(sequence not and: [ splitter respondsTo: #split: ]) ifTrue: [ ^ splitter split: self ].
	separatorSize := sequence ifTrue: [ splitter size ] ifFalse: [ 1 ].
	separatorSize = 0 ifTrue: [ self error: ''The separator must not be empty'' ].
	position := sequence
		ifTrue: [ self indexOfSubCollection: splitter startingAt: start ]
		ifFalse: [ self indexOf: splitter startingAt: start ].
	[ position > 0 ] whileTrue: [
		result add: (self copyFrom: start to: position - 1).
		start := position + separatorSize.
		position := sequence
			ifTrue: [ self indexOfSubCollection: splitter startingAt: start ]
			ifFalse: [ self indexOf: splitter startingAt: start ] ].
	result add: (self copyFrom: start to: self size).
	^ result'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_threeWayCompareTo_ [
	^ GtGemStoneExtensionMethod new
		selector: #threeWayCompareTo:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'threeWayCompareTo: aString
	<gtGsExtension>
	^ self = aString ifTrue: [ 0 ] ifFalse: [ self < aString ifTrue: [ -1 ] ifFalse: [ 1 ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_String_withInternalLineEndings [
	^ GtGemStoneExtensionMethod new
		selector: #withInternalLineEndings;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #String;
		hash: #new;
		source: 'withInternalLineEndings
	<gtGsExtension>
	^ self withLineEndings: String cr'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_asClass [
	^ GtGemStoneExtensionMethod new
		selector: #asClass;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'asClass
	<gtGsExtension>
	"Answer the class named by the receiver, or signal an error."
	^ self asClassIfAbsent: [ self error: ''Class not found: '', self asString ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_asClassIfAbsent_ [
	^ GtGemStoneExtensionMethod new
		selector: #asClassIfAbsent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'asClassIfAbsent: absentBlock
	<gtGsExtension>
	"Resolve the receiver in the current session''s symbol list."
	| candidate |
	candidate := GsSession currentSession objectNamed: self.
	(candidate notNil and: [ candidate isBehavior ])
		ifTrue: [ ^ candidate ].
	^ absentBlock value'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_asClassIfPresent_ [
	^ GtGemStoneExtensionMethod new
		selector: #asClassIfPresent:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'asClassIfPresent: presentBlock
	<gtGsExtension>
	"returns a global class with my name"
	^ presentBlock cull: (self asClassIfAbsent: [ ^ nil ])'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_asSortFunction [
	^ GtGemStoneExtensionMethod new
		selector: #asSortFunction;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'asSortFunction
	<gtGsExtension>
	"Return a SortFunction around the receiver, where the receiver will be used as a unary message to send to both a and b during sorting, and then the result of said send will be collated in ascending order using the <=> method."
	"(#(''abc'' ''de'' ''fghi'') sorted: #size ascending) >>> #(''de'' ''abc'' ''fghi'')"

	^PropertySortFunction property: self'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_ascending [
	^ GtGemStoneExtensionMethod new
		selector: #ascending;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'ascending
	<gtGsExtension>
	"Return a SortFunction around the receiver, where the receiver will be used as a unary message to send to both a and b during sorting, and then the result of said send will be collated in ascending order using the <=> method."
	"(#(''abc'' ''de'' ''fghi'') sorted: #size ascending) >>> #(''de'' ''abc'' ''fghi'')"

	^self asSortFunction'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_collatedBy_ [
	^ GtGemStoneExtensionMethod new
		selector: #collatedBy:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'collatedBy: aSortFunction
	<gtGsExtension>
	"Return a SortFunction around the receiver, where the receiver will be used as a unary message to send to both a and b during sorting, and then the result of said send will be collated iusing aSortFunction."
	"(#(''abc'' ''de'' ''fghi'') sorted: (#size collatedBy: [:e|e bitAnd: 1]) , #size) >>> #( ''de'' ''fghi'' ''abc'')"

	^PropertySortFunction property: self collatedWith: aSortFunction asSortFunction'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_descending [
	^ GtGemStoneExtensionMethod new
		selector: #descending;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #Symbol;
		hash: #new;
		source: 'descending
	<gtGsExtension>
	"Return a SortFunction around the receiver, where the receiver will be used as a unary message to send to both a and b during sorting, and then the result of said send will be collated in descending order using the <=> method."
	"(#(''abc'' ''de'' ''fghi'') sorted: #size descending) >>> #(''fghi'' ''abc'' ''de'')"

	^self asSortFunction reversed'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Symbol_isUnary [
 ^ GtGemStoneExtensionMethod new
 selector: #isUnary;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #Symbol;
 hash: #new;
 source: 'isUnary
 <gtGsExtension>
	"Answer whether the receiver is an unary message selector."

	"#new isUnary >>> true"
	"#>> isUnary >>> false"
	"#between:and: isUnary >>> false"

	^ self precedence = 1'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TelemetryPing_totalFullGCTimeMicroseconds [
	^ GtGemStoneExtensionMethod new
		selector: #totalFullGCTimeMicroseconds;
		meta: false;
		gtVersions: nil;
		className: #TelemetryPing;
		hash: #new;
		source: 'totalFullGCTimeMicroseconds
	<gtGsExtension>
	"Answer the total time in microseconds spent in full GCs since session startup."
	^ (System myCacheStatistics
		at: (System cacheStatisticsDescriptionForGem
			indexOf: ''TimeInMarkSweep'')) * 1000'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TelemetryPing_totalScavengeGCTimeMicroseconds [
	^ GtGemStoneExtensionMethod new
		selector: #totalScavengeGCTimeMicroseconds;
		meta: false;
		gtVersions: nil;
		className: #TelemetryPing;
		hash: #new;
		source: 'totalScavengeGCTimeMicroseconds
	<gtGsExtension>
	"Answer the total time in microseconds spent in scavenge GCs since session startup."
	^ (System myCacheStatistics
		at: (System cacheStatisticsDescriptionForGem
			indexOf: ''TimeInScavenges'')) * 1000'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestAsserter_assertCollection_hasSameElements_ [
	^ GtGemStoneExtensionMethod new
		selector: #assertCollection:hasSameElements:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: nil;
		className: #TestAsserter;
		hash: #new;
		source: 'assertCollection: actual hasSameElements: expected
	<gtGsExtension>
	"Assert the same elements and occurrence counts, regardless of order.
	Use the bag comparison from GT as the deciding assertion."
	actual = expected ifTrue: [ ^ self ].
	^ self assert: actual asBag equals: expected asBag'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestAsserter_assertEmpty_ [
 ^ GtGemStoneExtensionMethod new
  selector: #assertEmpty:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #TestAsserter;
  hash: #new;
  source: 'assertEmpty: aCollection
 <gtGsExtension>
	"I Raise an AssertionFailure if the given collection is not empty. I also provide a specialized message in case I failed"

	^ self
		  assert: aCollection isEmpty
		  description: aCollection printString , '' should have been empty'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestAsserter_class_assert_identicalTo_ [
	^ GtGemStoneExtensionMethod new
		selector: #assert:identicalTo:;
		meta: false;
		gtVersions: nil;
		className: #TestAsserter;
		hash: #new;
		source: 'assert: anObject identicalTo: anotherObject
	<gtGsExtension>
	^ self assert: anObject identical: anotherObject'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestAsserter_denyEmpty_ [
 ^ GtGemStoneExtensionMethod new
  selector: #denyEmpty:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #TestAsserter;
  hash: #new;
  source: 'denyEmpty: aCollection
 <gtGsExtension>
	"I raise an AssertionFailure if the giving collection is empty. I also provide a specialized message in case I failed.
	
	Not using #isNotEmpty like this objects as parameter can only implement #isEmpty and not both messages."

	^ self assert: aCollection isEmpty not description: aCollection printString , '' should not have been empty'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestAsserter_deny_identicalTo_ [
 ^ GtGemStoneExtensionMethod new
  selector: #deny:identicalTo:;
  protocol: #'gt-extension';
  meta: false;
  gtVersions: nil;
  className: #TestAsserter;
  hash: #new;
  source: 'deny: actual identicalTo: expected
 <gtGsExtension>
	"Verify whether the actual and the expected are NOT the same object (have the same object pointer so #== returns false)."
	^ self
		deny: expected == actual
		description: [actual printString , '' should not be identical to '' , expected printString]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_processMonitor [
	^ GtGemStoneExtensionMethod new
		selector: #processMonitor;
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: #new;
		source: 'processMonitor
	<gtGsExtension>
	^ nil'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_registerDefaultServices [
	^ GtGemStoneExtensionMethod new
		selector: #registerDefaultServices;
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: 'ef6072b4f84be6b12ecba0308405bd2337b5d72d7f026fa6c7770e85aea932c8';
		source: 'registerDefaultServices
	<gtGsExtension>
	^ self'.
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_runExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runExampleEvaluator:;
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: 'f15ae466e754ac59f38532348d1b7d6345af896c5939a6f0fc5ddb4e264859f2';
		source: 'runExampleEvaluator: anExampleEvaluator
	<gtGsExtension>
	| exampleResult |
	testCase := anExampleEvaluator.
	maxTimeForTest := anExampleEvaluator timeLimit.
	testCompleted := false.
	watchDogSemaphore signal.
	[ exampleResult := self runExampleUnderWatchdogUsingEvaluator: anExampleEvaluator ]
		ensure: [
			testCompleted := true.
			watchDogSemaphore signal.
			self cleanUpAfterTest ].
	^ exampleResult'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_runExampleUnderWatchdogUsingEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runExampleUnderWatchdogUsingEvaluator:;
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: 'c8790ab4d491856631bdaf3a95c51966656a4fe5f53dc4b419f5dc8b591ec837';
		source: 'runExampleUnderWatchdogUsingEvaluator: anEvaluator
	<gtGsExtension>
	| exampleResult |
	exampleResult := nil.
	[ [ exampleResult := anEvaluator runUnmanaged ] ensure: [ self handleCompletedTest ] ]
		on: Exception
		do: [ :err | self handleException: err ].
	^ exampleResult'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_runUnmanagedExampleEvaluator_ [
	^ GtGemStoneExtensionMethod new
		selector: #runUnmanagedExampleEvaluator:;
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: #new;
		source: 'runUnmanagedExampleEvaluator: anExampleEvaluator
	<gtGsExtension>
	| exampleResult |
	testCase := anExampleEvaluator.
	testCompleted := false.
	[ exampleResult := anExampleEvaluator value ] ensure: [ testCompleted := true ].
	^ exampleResult'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_TestExecutionEnvironment_watchDogLoop [
	^ GtGemStoneExtensionMethod new
		selector: #watchDogLoop;
		meta: false;
		gtVersions: nil;
		className: #TestExecutionEnvironment;
		hash: '0af9624ddb0d3f9efb1285fa07fea5b07c30f80a909c5c97e8fa2ef5f9897aa2';
		source: 'watchDogLoop
	<gtGsExtension>
	| timeIsGone |
	[ watchDogSemaphore wait.
	  [ timeIsGone := (watchDogSemaphore waitForMilliseconds: maxTimeForTest asMilliseconds) not.
	    testCompleted ] whileFalse: [
	      timeIsGone ifTrue: [
	        "signalException: resumes a process waiting in Delay as well."
	        mainTestProcess signalException: TestTookTooMuchTime new ] ] ] repeat'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Text_threeWayCompareTo_ [
	"Text is optional in GemStone; leave this descriptor inactive when the class is absent."
	^ GtGemStoneExtensionMethod new
		selector: #threeWayCompareTo:;
		protocol: #'gt-extension';
		meta: false;
		gtVersions: (self gtDo: [ nil ] gemstoneDo: [ (GsSession currentSession objectNamed: #Text) ifNil: [ #() ] ifNotNil: [ nil ] ]);
		className: #Text;
		hash: #new;
		source: 'threeWayCompareTo: anotherText
	<gtGsExtension>
	
	^ self asString threeWayCompareTo: anotherText asString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Time_class_hour_minute_second_ [
 ^ GtGemStoneExtensionMethod new
  selector: #hour:minute:second:;
  protocol: #'gt-extension';
  meta: true;
  gtVersions: nil;
  className: #Time;
  hash: #new;
  source: 'hour: hour minute: minute second: second
 <gtGsExtension>
 "Construct local time, preserving the GT component and total-seconds limits."
 | seconds |
 hour >= 24 ifTrue: [ self error: ''An hour must be 23 or less'' ].
 minute >= 60 ifTrue: [ self error: ''A minute must be 59 or less'' ].
 second >= 60 ifTrue: [ self error: ''A second must be 59 or less'' ].
 seconds := (hour * 3600) + (minute * 60) + second.
 (seconds between: 0 and: 86399)
  ifFalse: [ self error: ''Time should be in a 24 hour period (0 to 86399 seconds)'' ].
 ^ self fromSeconds: seconds'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_Time_class_microsecondClockValue [
	^ GtGemStoneExtensionMethod new
		selector: #microsecondClockValue;
		protocol: #'gt-extension';
		meta: true;
		gtVersions: nil;
		className: #Time;
		hash: #new;
		source: 'microsecondClockValue
	<gtGsExtension>
	"Answer the millisecond clock in microseconds, retaining millisecond resolution."
	^ self millisecondClockValue * 1000'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_UndefinedObject_neoJsonOn_ [
 ^ GtGemStoneExtensionMethod new
 selector: #neoJsonOn:;
 protocol: #'gt-extension';
 meta: false;
 gtVersions: nil;
 className: #UndefinedObject;
 hash: #new;
 source: 'neoJsonOn: neoJSONWriter
 <gtGsExtension>
	neoJSONWriter writeNull'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnDefaultCharacterEncoder_class_defaultValue [
	^ GtGemStoneExtensionMethod new
		className: #ZnDefaultCharacterEncoder;
		selector: #'defaultValue';
		meta: true;
		protocol: #'accessing';
		gtVersions: nil;
		hash: #new;
		source: 'defaultValue
	<gtGsExtension>
	^ ZnUTF8Encoder default'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnDefaultCharacterEncoder_default [
	^ GtGemStoneExtensionMethod new
		className: #ZnDefaultCharacterEncoder;
		selector: #'default';
		meta: false;
		protocol: #'accessing';
		gtVersions: nil;
		hash: '94fb7ad2d75ea9a335c8a1a7d482570d92bfa20164b04783409f8553fb30ef42';
		source: 'default
	<gtGsExtension>
	^ self class defaultValue'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnMaximumNumberOfDictionaryEntries_class_defaultValue [
	^ GtGemStoneExtensionMethod new
		className: #ZnMaximumNumberOfDictionaryEntries;
		selector: #'defaultValue';
		meta: true;
		protocol: #'accessing';
		gtVersions: nil;
		hash: #new;
		source: 'defaultValue
	<gtGsExtension>
	^ 256'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnPercentEncoder_decode_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnPercentEncoder;
		selector: #'decode:';
		meta: false;
		protocol: #'converting';
		gtVersions: nil;
		hash: '4ed17bd89509f3ee432c80d0fc5a4294d4cecd0ea9547d533535b23a9a49e25d';
		source: 'decode: string
	<gtGsExtension>
	"Decode a percent encoded string and return the resulting byte array.
	After percent decoding I will use my character encoder to convert byte values to characters."

	| bytes stringStream |
	stringStream := string readStream.
	bytes := ByteArray streamContents: [ :byteStream |
		self decode: stringStream to: byteStream ].
	^ (self characterEncoder decodeBytes: bytes) asString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnPercentEncoder_decode_to_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnPercentEncoder;
		selector: #'decode:to:';
		meta: false;
		protocol: #'converting';
		gtVersions: nil;
		hash: '0b0fdab03d13269d89d62fb48154cc960e85bc7ddaa95b8846093144f21c4265';
		source: 'decode: stringStream to: byteStream
	<gtGsExtension>
	| char |
	self decodePlusAsSpace.
	[ stringStream atEnd ]
		whileFalse: [
			((char := stringStream next) == $+ and: [ decodePlusAsSpace ])
				ifTrue: [ byteStream nextPut: 32 ]
				ifFalse: [
					char == $%
						ifTrue: [ byteStream nextPut: (self readHexFrom: stringStream) ]
						ifFalse: [
							char asciiValue < 128
								ifTrue: [ byteStream nextPut: char asciiValue ]
								ifFalse: [ self errorAsciiCharacterExpected ] ] ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnPercentEncoder_encode_to_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnPercentEncoder;
		selector: #encode:to:;
		meta: false;
		protocol: #converting;
		gtVersions: nil;
		hash: '47a89876153446847153bd52efe89c1e60401261a966220dacec58a550655e52';
		source: 'encode: readStream to: writeStream
	<gtGsExtension>
	"Use each native encoder''s bulk byte API; its stream API need not write byte values."
	self safeSet; characterEncoder.
	(characterEncoder encodeString: readStream upToEnd) do: [ :byte |
		(safeSet includes: byte)
			ifTrue: [ writeStream nextPut: byte asCharacter ]
			ifFalse: [
				writeStream nextPut: $%.
				self writeHex: byte to: writeStream ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnPercentEncoder_readHexFrom_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnPercentEncoder;
		selector: #'readHexFrom:';
		meta: false;
		protocol: #'private';
		gtVersions: nil;
		hash: 'd3b46b033cdbbd5fa021698ce31cca33c587a0b7b3d8716c92f462a1ca8409ff';
		source: 'readHexFrom: stream
	<gtGsExtension>
	| first second digit |
	"GT accepts Unicode decimal digits but only ASCII hexadecimal letters."
	digit := [ :char | (char isDigit or: [ ''abcdefABCDEF'' includes: char ])
		ifTrue: [ char digitValueInRadix: 16 ] ifFalse: [ nil ] ].
	(stream atEnd not and: [ (first := digit value: stream next) notNil ])
		ifFalse: [ self errorHexDigitExpected ].
	(stream atEnd not and: [ (second := digit value: stream next) notNil ])
		ifFalse: [ self errorHexDigitExpected ].
	^ (first << 4) + second'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnResourceMetaUtils_class_queryKeyValueSafeSet [
	^ GtGemStoneExtensionMethod new
		className: #ZnResourceMetaUtils;
		selector: #'queryKeyValueSafeSet';
		meta: true;
		protocol: #'accessing';
		gtVersions: nil;
		hash: #new;
		source: 'queryKeyValueSafeSet
	<gtGsExtension>
	"Minimal URL port: retain the GT query encoding policy without Zinc HTTP options."
	^ ''abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~!$''''()*,;:@/?'''
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnResourceMetaUtils_class_writeQueryFields_on_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnResourceMetaUtils;
		selector: #'writeQueryFields:on:';
		meta: true;
		protocol: #'converting';
		gtVersions: nil;
		hash: '6a66356249792df3f00373578b26aa9cf6d59feb21546e1984c19b0061d3baf9';
		source: 'writeQueryFields: dictionary on: stream
	<gtGsExtension>
	self writeQueryFields: dictionary withEncoder: ZnUTF8Encoder default on: stream'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnUrlTest_testReferenceResolution [
	^ GtGemStoneExtensionMethod new
		className: #ZnUrlTest;
		selector: #'testReferenceResolution';
		meta: false;
		protocol: #'testing';
		gtVersions: nil;
		hash: '8362717591ff40c7713aed520bf93b9d211d5ec75b953980e72c7e9f225d438a';
		source: 'testReferenceResolution
	<gtGsExtension>
	"RFC 3986 Section 5"

	| baseUri specification result succeeded failed |
	baseUri := ''http://a/b/c/d;p?q'' asZnUrl.
	specification := {
		"Examples 5.4.1 - Normal"
		" ''g:h'' -> ''g:h''. " "we do not support unknown schemes without //"
		''mailto:john@acme.com'' -> ''mailto:john@acme.com''. "this we can do"
		''g'' -> ''http://a/b/c/g''.
		''./g'' -> ''http://a/b/c/g''.
		''g/'' -> ''http://a/b/c/g/''.
		''/g'' -> ''http://a/g''.
		''//g'' -> ''http://g/''.  "a trailing slash is added automatically"
		''//a.com/assets/img.jpg'' -> ''http://a.com/assets/img.jpg''.
		''?y'' -> ''http://a/b/c/d;p?y''.
		''g?y'' -> ''http://a/b/c/g?y''.
		''#s'' -> ''http://a/b/c/d;p?q#s''.
		''g#s'' -> ''http://a/b/c/g#s''.
		''g?y#s'' -> ''http://a/b/c/g?y#s''.
		'';x'' -> ''http://a/b/c/;x''.
		''g;x'' -> ''http://a/b/c/g;x''.
		''g;x?y#s'' -> ''http://a/b/c/g;x?y#s''.
		'''' -> ''http://a/b/c/d;p?q''.
		''.'' -> ''http://a/b/c/''.
		''./'' -> ''http://a/b/c/''.
		''..'' -> ''http://a/b/''.
		''../'' -> ''http://a/b/''.
		''../g'' -> ''http://a/b/g''.
		''../..'' -> ''http://a/''.
		''../../'' -> ''http://a/''.
		''../../g'' -> ''http://a/g''.
		"Examples 5.4.2 - Abnormal"
		''../../../g'' -> ''http://a/g''.
		''../../../../g'' -> ''http://a/g''.
		''/./g'' -> ''http://a/g''.
		''/../g'' -> ''http://a/g''.
		''g.'' -> ''http://a/b/c/g.''.
		''.g'' -> ''http://a/b/c/.g''.
		''g..'' -> ''http://a/b/c/g..''.
		''..g'' -> ''http://a/b/c/..g''.
		''./../g'' -> ''http://a/b/g''.
		''./g/.'' -> ''http://a/b/c/g/''.
		''g/./h'' -> ''http://a/b/c/g/h''.
		''g/../h'' -> ''http://a/b/c/h''.
		''g;x1/./y'' -> ''http://a/b/c/g;x1/y''.
		''g;x1/../y'' -> ''http://a/b/c/y''.
		''g?y/./x'' -> ''http://a/b/c/g?y/./x''.
		''g?y/../x'' -> ''http://a/b/c/g?y/../x''.
		''g#s/./x'' -> ''http://a/b/c/g#s/./x''.
		''g#s/../x'' -> ''http://a/b/c/g#s/../x''.
		''http://g'' -> ''http://g/'' "a trailing slash is added automatically"
	}.
	result := (1 to: specification size) collect: [ :index | | spec resolved success |
		spec := specification at: index.
		resolved := baseUri withRelativeReference: spec key.
		success := resolved asString = spec value.
		{ #input -> spec key. #expected -> spec value. #index -> index.
		#resolved -> resolved. #result -> success } asDictionary ].
	succeeded := result select: [ :each | each at: #result ].
	failed := result reject: [ :each | each at: #result ].
	self assert: failed isEmpty'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnUrl_asString [
	^ GtGemStoneExtensionMethod new
		className: #ZnUrl;
		selector: #'asString';
		meta: false;
		protocol: #'converting';
		gtVersions: nil;
		hash: #new;
		source: 'asString
	<gtGsExtension>
	^ self printString'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnUrl_parseHostPort_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnUrl;
		selector: #'parseHostPort:';
		meta: false;
		protocol: #'parsing';
		gtVersions: nil;
		hash: '879fb41acf0fb28c8ce343a36c46a5963b39168b7348a0aad842e66ac1ca802f';
		source: 'parseHostPort: stream
	<gtGsExtension>
	| hostString portNumber |
	self isFile
		ifTrue: [
			(hostString := stream upTo: $/) isEmpty
				ifFalse: [ self host: (self decodePercent: hostString) ] ]
		ifFalse: [
			(hostString := stream upTo: $:) isEmpty
				ifFalse: [ self host: (self decodePercent: hostString) ].
			stream atEnd
				ifFalse: [
					portNumber := [ Integer fromStream: stream ] on: Error do: [ :error | ZnPortNotANumber signal ].
					(portNumber between: 1 and: 65535) ifFalse: [ DomainError signalFrom: 1 to: 65535 ].
					self port: portNumber ] ]'
]

{ #category : #extensions }
GtGemStoneExtensionMethods class >> ext_ZnUrl_portIfAbsent_ [
	^ GtGemStoneExtensionMethod new
		className: #ZnUrl;
		selector: #'portIfAbsent:';
		meta: false;
		protocol: #'accessing';
		gtVersions: nil;
		hash: '4d8b16342ceabc14299ffc9a2ce6af99c9d6d20b76295b7b35abd7edbf155a85';
		source: 'portIfAbsent: valuable
	<gtGsExtension>
	^ self hasPort ifTrue: [ self port ] ifFalse: [ valuable value ]'
]

{ #category : #accessing }
GtGemStoneExtensionMethods class >> extensionSelectors [
	^ ((self class selectors select: [ :each | each asString beginsWith: 'ext_' ])
		asSortedCollection: [ :left :right | left asString < right asString ]) asArray
]

{ #category : #accessing }
GtGemStoneExtensionMethods class >> extensions [
	^ self extensionSelectors collect: [ :each | self perform: each ]
]

{ #category : #updating }
GtGemStoneExtensionMethods class >> updateHashOf: aSelector [
	| method extension hashMessages hashArgument source updatedSource |
	(self extensionSelectors includes: aSelector)
		ifFalse: [ self error: 'Unknown extension method: ', aSelector asString ].
	method := self class >> aSelector.
	method protocolName = #extensions
		ifFalse: [ self error: 'Method is not in the extensions protocol: ', aSelector asString ].
	extension := self perform: aSelector.
	extension existingMethod
		ifNil: [ self error: 'Cannot update the hash of a missing target method: ', extension className asString, '>>', extension selector asString ].
	hashMessages := method ast allChildren
		select: [ :node | node isMessage and: [ node selector = #hash: ] ].
	hashMessages size = 1
		ifFalse: [ self error: 'Expected exactly one hash: send in extension method: ', aSelector asString ].
	hashArgument := hashMessages first arguments first.
	hashArgument isLiteralNode
		ifFalse: [ self error: 'Expected a literal hash in extension method: ', aSelector asString ].
	source := method sourceCode.
	updatedSource := (source copyFrom: 1 to: hashArgument start - 1),
		extension existingMethodHash storeString,
		(source copyFrom: hashArgument stop + 1 to: source size).
	updatedSource = source
		ifFalse: [ self class compile: updatedSource classified: method protocolName ].
	^ self perform: aSelector
]
