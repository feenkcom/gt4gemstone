Extension { #name : 'LeLocalStore' }

{ #category : '*GToolkit-GemStone-Lepiter' }
LeLocalStore >> gemStone [
	"Answer the Dictionary containing the GemStone settings for this database"
	<return: #Dictionary>

	^ self dbProperties at: #gemStone
		ifPresent: [ :aDictionary | aDictionary ]
		ifAbsent: [ Dictionary new ]
]

{ #category : '*GToolkit-GemStone-Lepiter' }
LeLocalStore >> gemStone: aDictionaryOrNil [

	self 
		updateProperty: #gemStone
		value: aDictionaryOrNil
]

{ #category : '*GToolkit-GemStone-Lepiter' }
LeLocalStore >> gemStoneSettings [
	"Answer the initialised LeGemStoneSettings for this database"
	<return: #LeGemStoneSettings>

	^ LeGemStoneSettings new dbProperties: self
]
