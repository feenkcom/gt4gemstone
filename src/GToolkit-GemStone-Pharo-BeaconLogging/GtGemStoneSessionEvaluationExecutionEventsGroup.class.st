Class {
	#name : #GtGemStoneSessionEvaluationExecutionEventsGroup,
	#superclass : #GtGemStoneLogEventsGroup,
	#category : #'GToolkit-GemStone-Pharo-BeaconLogging-Events'
}

{ #category : #accessing }
GtGemStoneSessionEvaluationExecutionEventsGroup >> gtExecutionsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Executions';
		priority: 1;
		items: [ self ];
		column: 'Type' 
			text: [ :anEvent | 
				anEvent eventLabel removeSuffix: ' Execution' ]
			width: 75;
		column: 'Exection' text: #executionDescription;
		column: 'Timestamp' 
			text: #timestamp
			width: 200;
		column: 'Duration' 
			text: [ :anEvent | anEvent duration ]
			width: 150
]
