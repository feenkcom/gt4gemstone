Class {
	#name : #GtGemStoneLepiterExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'GToolkit-GemStone-Lepiter-Examples'
}

{ #category : #examples }
GtGemStoneLepiterExamples >> openPageNoProperties [
	"Check that opening a page that references a GS database when there is no properties file doesn't raise an error"

	<gtExample>
	<return: #GtGemStoneLepiterExamples>
	| snippet registry viewModel |
	registry := GtGemStoneSessionRegistry new.
	snippet := (LeGemStoneSnippet sessionName: 'nonExistentConnector:1')
			code: '4+3'.

	viewModel := snippet asSnippetViewModel.
	viewModel gemstoneSessionRegistry: registry.
	self shouldnt: [ viewModel updateGemstoneSession ] raise: Error
]
