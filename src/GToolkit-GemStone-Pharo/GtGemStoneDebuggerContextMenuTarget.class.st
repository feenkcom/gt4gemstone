"
I am a phlow action target for actions shown in the context menu of the GemStone debugger (see {{gtMethod:GtGemStoneExpandableDebuggerToolbar>>#addExtraActionsButton}}).

I am separate from {{gtClass:GtDebuggerContextMenuTarget}}, so that the GemStone debugger only shows actions that make sense for GemStone. For example, the chat actions defined for Pharo exceptions are not shown.

{{gtClass:GtGemStoneDebuggerSession}} and its exception contribute to this menu by defining `<gtAction>` methods with `target: GtGemStoneDebuggerContextMenuTarget`.
"
Class {
	#name : #GtGemStoneDebuggerContextMenuTarget,
	#superclass : #GtPhlowActionUniqueTarget,
	#category : #'GToolkit-GemStone-Pharo-Debugger'
}
