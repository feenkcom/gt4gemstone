Class {
	#name : #GtGemStoneClassCodeSyncSignal,
	#superclass : #GtGemStoneCodeSyncSignal,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #printing }
GtGemStoneClassCodeSyncSignal >> printOneLineContentsOn: stream [

	stream
		<< session name;
		<< ': ';
		<< change behaviorAffectedName
]
