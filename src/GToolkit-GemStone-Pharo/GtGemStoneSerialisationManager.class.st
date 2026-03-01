"
Convenience methods for managing serialisation
"
Class {
	#name : #GtGemStoneSerialisationManager,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #replication }
GtGemStoneSerialisationManager class >> gtWireReplicationSpec [
	"Answer the replication spec dictionary for the default selector (#replicationSpec)"

	^ self gtWireReplicationSpecFor: #replicationSpec.
]

{ #category : #replication }
GtGemStoneSerialisationManager class >> gtWireReplicationSpecFor: aSelector [
	"Collect GemStone GBS replication specs for all implementors of the given class-side selector. 
	For each implementing class and its subclasses, answer a dictionary keyed by class name and valued with the result of evaluating the selector, using the most specific implementation (a class's own selector overrides inherited specs).
	Note: Object is excluded as it provides only the default empty spec."
	| specs nav implementors |
	
	specs := Dictionary new.
	nav := SystemNavigation default.
	implementors := (nav allImplementorsOf: aSelector)
		select: [ :methodRef | 
			methodRef methodClass isMeta 
				and: [ methodRef methodClass instanceSide ~~ Object ] ].
	implementors do: [ :methodRef |
		| baseClass |
		baseClass := methodRef methodClass instanceSide.
		(baseClass withAllSubclasses) do: [ :eachClass |
			(eachClass == baseClass
				or: [ (eachClass class includesSelector: aSelector) not ]) ifTrue: [
				specs at: eachClass name put: (eachClass perform: aSelector) ] ] ].
	^ specs
]

{ #category : #serialization }
GtGemStoneSerialisationManager class >> installWireEncodingGbsReplicationSpec: replicationSpecification on: aGtGemStoneSession [

	aGtGemStoneSession evaluateBlockAndWait: [ :rsArray | 
			| encoder serializer rs serializers |
			rsArray do: [ :assoc |
				assoc key: (GsSession currentSession objectNamed: assoc key) ].
			rs := rsArray asDictionary.
			serializers := SessionTemps current
				at: #GtSerializationStrategies
				ifAbsentPut: [ Dictionary new ].
			serializer := serializers
				at: #GtRsrWireSerializationStrategy
				ifAbsentPut: [ GtRsrWireSerializationStrategy new ].
			encoder := serializer encoder ifNil: 
				[ serializer encoder: GtWireEncoder onByteArray.
				serializer encoder. ].
			GtWireGbsReplicationSpecConverter new update: encoder from: rs.
			nil. ]
		withArguments: { replicationSpecification associations }.

]
