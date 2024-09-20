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
	| snippet registry viewModel |

	registry := GtGemStoneSessionRegistry new.
	snippet := LeGemStoneSnippet new
		code: '4+3';
		sessionIdentifier: (GtGemStoneExplicitSessionIdentifier 			sessionName: 'nonExistentConnector:1').

	viewModel := snippet asSnippetViewModel.
	viewModel gemstoneSessionRegistry: registry.
	self shouldnt: [ viewModel updateGemstoneSession ]
		raise: Error.
]
