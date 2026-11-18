"
Examples for date and time formatting shared by GT and GemStone.
"
Class {
	#name : #GtDateTimeUtilityExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #examples }
GtDateTimeUtilityExamples >> asLocalStringYMDHM [
	<gtExample>
	| date expected |
	date := DateAndTime
			year: 2024
			month: 2
			day: 3
			hour: 4
			minute: 5
			second: 6
			offset: (Duration seconds: 0).
	expected := date asLocal asStringYMDHM.
	self assert: date asLocalStringYMDHM equals: expected.
	^ date
]

{ #category : #examples }
GtDateTimeUtilityExamples >> asLocalStringYMDHMS [
	<gtExample>
	| date expected |
	date := DateAndTime
			year: 2024
			month: 2
			day: 3
			hour: 4
			minute: 5
			second: 6
			offset: (Duration seconds: 0).
	expected := date asLocal asStringYMDHMS.
	self assert: date asLocalStringYMDHMS equals: expected.
	^ date
]

{ #category : #examples }
GtDateTimeUtilityExamples >> asStringYMDHM [
	<gtExample>
	| first last |
	first := DateAndTime
			year: 2024
			month: 2
			day: 3
			hour: 4
			minute: 5
			second: 6
			offset: (Duration seconds: 0).
	last := DateAndTime
			year: 2024
			month: 12
			day: 31
			hour: 23
			minute: 59
			second: 9
			offset: (Duration seconds: 0).
	self assert: first asStringYMDHM equals: '2024-02-03 04:05'.
	self assert: last asStringYMDHM equals: '2024-12-31 23:59'.
	^ first
]

{ #category : #examples }
GtDateTimeUtilityExamples >> asStringYMDHMS [
	<gtExample>
	| first last |
	first := DateAndTime
			year: 2024
			month: 2
			day: 3
			hour: 4
			minute: 5
			second: 6
			offset: (Duration seconds: 0).
	last := DateAndTime
			year: 2024
			month: 12
			day: 31
			hour: 23
			minute: 59
			second: 9
			offset: (Duration seconds: 0).
	self assert: first asStringYMDHMS equals: '2024-02-03 04:05:06'.
	self assert: last asStringYMDHMS equals: '2024-12-31 23:59:09'.
	^ first
]
