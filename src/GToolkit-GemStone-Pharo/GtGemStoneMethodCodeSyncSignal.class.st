Class {
	#name : #GtGemStoneMethodCodeSyncSignal,
	#superclass : #GtGemStoneCodeSyncSignal,
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneMethodCodeSyncSignal >> printOneLineContentsOn: stream [

	stream
		<< session name;
		<< ': ';
		<< change behaviorAffectedName;
		<< '>>#';
		<< change selector
]
