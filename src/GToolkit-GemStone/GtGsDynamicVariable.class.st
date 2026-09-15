Class {
	#name : 'GtGsDynamicVariable',
	#superclass : 'Notification',
	#category : 'GToolkit-GemStone'
}

{ #category : 'defaults' }
GtGsDynamicVariable class >> defaultValue [

	^ nil
]

{ #category : 'accessing' }
GtGsDynamicVariable class >> value [

	^ self signal
]

{ #category : 'accessing' }
GtGsDynamicVariable class >> value: anObject during: aBlock [

	^ aBlock on: self do: [ :notification |
		notification resume: anObject ]
]

{ #category : 'defaults' }
GtGsDynamicVariable >> defaultAction [

	^ self class defaultValue
]
