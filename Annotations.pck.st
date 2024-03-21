'From Cuis6.0 [latest update: #6153] on 21 March 2024 at 3:40:26 pm'!
'Description '!
!provides: 'Annotations' 1 101!
!requires: 'YAXO' 1 24 nil!
SystemOrganization addCategory: #Annotations!


!classDefinition: #AnnotatedTextModel category: #Annotations!
TextModel subclass: #AnnotatedTextModel
	instanceVariableNames: 'author'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'AnnotatedTextModel class' category: #Annotations!
AnnotatedTextModel class
	instanceVariableNames: ''!

!classDefinition: #PluggableAnnotatedTextModel category: #Annotations!
AnnotatedTextModel subclass: #PluggableAnnotatedTextModel
	instanceVariableNames: 'getter setter provider'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'PluggableAnnotatedTextModel class' category: #Annotations!
PluggableAnnotatedTextModel class
	instanceVariableNames: ''!

!classDefinition: #AnnotatedText category: #Annotations!
Text subclass: #AnnotatedText
	instanceVariableNames: 'annotations'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'AnnotatedText class' category: #Annotations!
AnnotatedText class
	instanceVariableNames: ''!

!classDefinition: #AnnotatedTextEditor category: #Annotations!
TextEditor subclass: #AnnotatedTextEditor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'AnnotatedTextEditor class' category: #Annotations!
AnnotatedTextEditor class
	instanceVariableNames: ''!

!classDefinition: #AnnotatedTextMorph category: #Annotations!
LayoutMorph subclass: #AnnotatedTextMorph
	instanceVariableNames: 'textModelMorph commentsMorph selectedConversation annotatedTextModel showResolvedConversations author'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'AnnotatedTextMorph class' category: #Annotations!
AnnotatedTextMorph class
	instanceVariableNames: ''!

!classDefinition: #AnnotationWrapper category: #Annotations!
ListItemWrapper subclass: #AnnotationWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'AnnotationWrapper class' category: #Annotations!
AnnotationWrapper class
	instanceVariableNames: ''!

!classDefinition: #CommentWrapper category: #Annotations!
AnnotationWrapper subclass: #CommentWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'CommentWrapper class' category: #Annotations!
CommentWrapper class
	instanceVariableNames: ''!

!classDefinition: #ConversationWrapper category: #Annotations!
AnnotationWrapper subclass: #ConversationWrapper
	instanceVariableNames: 'conversation'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'ConversationWrapper class' category: #Annotations!
ConversationWrapper class
	instanceVariableNames: ''!

!classDefinition: #TestAnnotatedText category: #Annotations!
TestCase subclass: #TestAnnotatedText
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'TestAnnotatedText class' category: #Annotations!
TestAnnotatedText class
	instanceVariableNames: ''!

!classDefinition: #TextComment category: #Annotations!
Object subclass: #TextComment
	instanceVariableNames: 'author comment date'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'TextComment class' category: #Annotations!
TextComment class
	instanceVariableNames: ''!

!classDefinition: #TextConversation category: #Annotations!
Object subclass: #TextConversation
	instanceVariableNames: 'comments text start stop resolved'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'TextConversation class' category: #Annotations!
TextConversation class
	instanceVariableNames: ''!


!AnnotatedTextModel methodsFor: 'user interface support' stamp: 'DF 3/19/2024 12:50:09'!
editorClass
	^AnnotatedTextEditor! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 13:35:42'!
acceptContentsFrom: aTextModelMorph

	self changed: #clearUserEdits.
	
	^true! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:28:42'!
addComment: aString to: aConversation 

	aConversation addComment:aString by:author.

	self changed: #annotations.
! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:28:33'!
addConversation: aString from: start to: end

	actualContents addConversationBy: author firstComment: aString from: start to: end.
	
	self changed: #annotations.
		

	! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:22:11'!
annotations

	actualContents ifNil:[^{}].
	
	self assert: (actualContents isKindOf: AnnotatedText).
	
	^ actualContents annotations! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:28:54'!
author: aString
	author := aString! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:35:37'!
refusesToAccept
	^false! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:33:25'!
wantsFrameAdornments 
	^true! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 22:17:31'!
acceptContentsFrom: aTextModelMorph

	provider perform: setter with: actualContents.
		
	^ super acceptContentsFrom: aTextModelMorph ! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 20:18:42'!
actualContents

	actualContents ifNil: [ self refetch ].
	
	self assert: (actualContents isKindOf: AnnotatedText).
	^actualContents ! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:23:16'!
addComment: aString to: aConversation 

	super addComment: aString to: aConversation.

	provider perform: setter with: actualContents. "to notify the provider that a change has occurred"
		
! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:28:16'!
addConversation: aString from: start to: end

	super addConversation: aString from: start to: end.
	
	provider perform: setter with: actualContents. "to notify the provider that a change has occurred"
	
	! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:29:36'!
basicActualContents: aTextOrString

	"Do not throw events."
	| prevContents t |
	
	t := aTextOrString isKindOf: AnnotatedText :: 
		ifTrue:[	 aTextOrString ] 
		ifFalse: [ AnnotatedText fromString: aTextOrString ].
	
	prevContents := actualContents.
	actualContents := t.
	actualContents = prevContents ifFalse: [	"Compares only characters, not attributes"
		undoRedoCommands resetToStart.
		lastEditTimeStamp := nil ]! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 17:48:13'!
get: aSymbol
	getter := aSymbol! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:18:56'!
initialize

	super initialize .
	! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 17:48:23'!
provider: anObject
	provider := anObject! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:16:45'!
refetch

	self basicActualContents: (provider perform:getter).
	
	^true! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 17:48:33'!
set: aSymbol
	setter := aSymbol! !

!PluggableAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 18:43:59'!
update: aSymbol

	actualContents := provider perform: getter.
	
	self changed: #actualContents.! !

!AnnotatedText methodsFor: 'private' stamp: 'DF 3/19/2024 23:24:42'!
annotations: anOrderedCollection
	annotations := anOrderedCollection ! !

!AnnotatedText methodsFor: 'private' stamp: 'DF 3/19/2024 23:00:38'!
insert: length at: begin

	annotations do:[:each |each insert:length at:begin].
! !

!AnnotatedText methodsFor: 'private' stamp: 'DF 3/21/2024 15:39:48'!
removeFrom: begin to: end
	
	self assert: begin >= 1.
	
	self assert: begin <= end.
	
	self assert: end <= (self size + 1).
	
	annotations := annotations reject:[:each | each coveredBy: begin to:end].
	
	annotations do:[:each |each removeFrom: begin to: end].
	
	! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:03:20'!
addConversationBy: author firstComment: aString from: start to: end

	| comment conversation  |
	
	self assert: start >= 1.
	
	"self assert: start <= end." "allow start > end to represent a point in the document"
	
	self assert: end <= (self size + 1).
	
	comment := TextComment new author: author ; comment: aString ; date: DateAndTime now; yourself.
	
	conversation := TextConversation new text: self; start: start ; stop: end ; yourself.
	
	conversation comments add: comment.
	
	annotations add: conversation.
	
			

	! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:52:39'!
annotations
	^annotations! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:48:47'!
asXML

	| aWriteStream |
	
	aWriteStream := WriteStream on:''.
	
	self encodeXML: (XMLWriter on: aWriteStream).
	
	^ aWriteStream contents
! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 20:56:02'!
decodeXML: anXMLNode

	annotations := OrderedCollection new.
		
	anXMLNode firstTagNamed: #text with: [:node | 
		
		self setString: node characterData setRuns: (RunArray new: node characterData size withAll: #()) . true ].
	
	anXMLNode firstTagNamed: #annotations with:[:node |
		node elementsDo: [:each | 
			annotations add: (TextConversation fromXML: each text: self) ]. true ].
		
! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:01:45'!
encodeXML: anXMLWriter 
		
	anXMLWriter xmlDeclaration: '1.0' encoding: 'UTF-8'.
	
	anXMLWriter startTag:'body'; endTag.
	
	anXMLWriter 
		startTag: 'text' ; endTag ; 
		pcData: self asString ;
		endTag: 'text'.
		
	anXMLWriter startTag: 'annotations' ; endTag.
		
	annotations do:[:each | each encodeXML: anXMLWriter ].
	
	anXMLWriter endTag: 'annotations'.
	
	anXMLWriter endTag: 'body'.! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 22:59:44'!
initialize

	super initialize.
	
	annotations := OrderedCollection new.
! !

!AnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/21/2024 15:39:31'!
replaceFrom: start to: stop with: replacement
	
	start <= stop ifTrue:[ self removeFrom: start to: stop].
	
	self insert: replacement size at: start.
	
	super replaceFrom: start to: stop with: replacement.

	
	
	
	! !

!AnnotatedText class methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:50:36'!
fromXML: aString

	| reconstructed |
	
	reconstructed := self new.
	
	reconstructed decodeXML:  (XMLDOMParser parseDocumentFrom: (ReadStream on: aString)).
	
	^reconstructed
! !

!AnnotatedText class methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:24:55'!
string: aString runs: anArray  

	^self basicNew setString: aString setRuns: anArray ; annotations: OrderedCollection new ; yourself.! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/17/2024 22:15:24'!
acceptContents
	
	^super acceptContents ! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:26:12'!
addComment

	StringRequestMorph
		request: 'Enter a comment'
		do: [:aString | model addConversation: aString from: self startIndex  to: self stopIndex ].
! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/21/2024 15:40:21'!
backspace: aKeyboardEvent

	^super backspace: aKeyboardEvent .
	
	
	
	! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 21:59:44'!
getMenu

	| aMenu |
	
	aMenu := super getMenu.
	
	aMenu addLine.
	
	aMenu add: 'Add comment...'
		action: #addComment.
		
	^aMenu	! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:23:16'!
addComment
	
	selectedConversation ifNil:[^self].
	
	StringRequestMorph
		request: 'Enter a comment'
		do: [:aString | annotatedTextModel addComment:aString to: selectedConversation ].
		
	
		
	
	! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:53:29'!
annotations

	showResolvedConversations ifTrue:[
		^annotatedTextModel annotations collect:[:each | ConversationWrapper with: each model:self ] ].
		
	^ (annotatedTextModel annotations reject:[:each | each resolved ]) collect: [:each | ConversationWrapper with: each model:self ].! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:18:23'!
author: aString
	author := aString! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:55:01'!
buildGUI

	commentsMorph := HierarchicalListMorph model: self listGetter: #annotations indexGetter: #selection indexSetter: #selection: mainView: self menuGetter:#conversationMenu keystrokeAction:nil.
	 
	annotatedTextModel addDependent: commentsMorph.
	
	textModelMorph := TextModelMorph withModel: annotatedTextModel.
	
	self addMorph: (textModelMorph pw:0.75;ph:1.0).
	self addAdjusterMorph.
	self addMorph: (commentsMorph pw:0.25 ; ph:1.0).


! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 22:57:12'!
conversationMenu

	| menu |
	menu := MenuMorph entitled: 'Conversation menu'.
	
	menu add: showResolvedConversations asMenuItemTextPrefix , 'Show resolved' target: self action: #toggleShowResolved.

	menu addLine.
	
	selectedConversation isKindOf: AnnotationWrapper ::
		ifTrue:[
			selectedConversation resolved not :: 
				ifTrue:[ 	menu add: 'Resolve' target: self action: #resolveConversation ]
				ifFalse:[	menu add: 'Unresolve' target: self action: #unresolveConversation ] ].
	
	menu addLine.
	
	menu add: 'Edit ...' target: self action: #editComment.

	menu add: 'Reply ...' target: self action: #addComment.
		
	^ menu
! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:53:29'!
editComment
	
	selectedConversation ifNil:[^self].

	selectedConversation isKindOf: CommentWrapper :: ifFalse:[^self].
	
	StringRequestMorph
		request: 'Edit your comment'
		initialAnswer: selectedConversation item comment 
		do: [:aString | selectedConversation item comment:aString ;author:'Alice' ; date: DateAndTime now . self changed: #annotations.  ].
		
	
		
	
	! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:20:44'!
initialize
	
	super initialize.
	
	self beRow.
	
	author := 'Authorus Anonymous'.
	
	showResolvedConversations := false.

! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:40:53'!
model: anAnnotatedTextModel

	self assert: annotatedTextModel isNil.
	
	annotatedTextModel := anAnnotatedTextModel.
	
	
! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:53:29'!
resolveConversation

	selectedConversation isKindOf: AnnotationWrapper :: ifFalse:[^self].
	
	selectedConversation resolve: true.
	
	self changed: #annotations.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 11:56:53'!
selection

	^selectedConversation ! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 21:48:31'!
selection: aConversationWrapper
	
	aConversationWrapper ifNil:[^self].
	
	selectedConversation := aConversationWrapper.
	
	selectedConversation isKindOf: AnnotationWrapper :: ifFalse:[^self].
	
	textModelMorph selectFrom: selectedConversation start to: selectedConversation stop - 1. 
	
	self changed: #annotations.
	
	textModelMorph focusText.
	
	textModelMorph redrawNeeded.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:53:29'!
toggleShowResolved

	showResolvedConversations := showResolvedConversations not.
	
	self changed: #annotations.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:53:29'!
unresolveConversation

	selectedConversation isKindOf: AnnotationWrapper :: ifFalse:[^self].
	
	selectedConversation resolve: false.
	
	self changed: #annotations.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 21:53:29'!
update
	
	self changed: #annotations.! !

!AnnotatedTextMorph class methodsFor: 'instance creation' stamp: 'DF 3/19/2024 17:27:50'!
on: anAnnotatedTextModel

	| aMorph |
	
	aMorph := self new.
	
	aMorph model: anAnnotatedTextModel.
	
	aMorph buildGUI.
	
	^aMorph! !

!AnnotatedTextMorph class methodsFor: 'instance creation' stamp: 'DF 3/20/2024 21:30:02'!
textProvider: model textGetter: getter textSetter: setter author: author

	| anAnnotatedTextModel |
	
	anAnnotatedTextModel := PluggableAnnotatedTextModel new.
	
	anAnnotatedTextModel provider: model; get: getter ; set: setter ; author: author.
	
	model addDependent: anAnnotatedTextModel.
	
	^self on: anAnnotatedTextModel.
! !

!AnnotationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 22:54:47'!
resolved
	^self subclassResponsibility ! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:09:51'!
addComment: aString by: author
	model addComment: aString by: author ! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 19:33:50'!
asString
	^ item comment! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/18/2024 10:51:20'!
contents

	^ { ListItemWrapper with: item author . 
		ListItemWrapper with: 
			(item date date = Date today 
				ifTrue:[ 'Today at {1}:{2}' format: { item date time hour24 . item date time minute }] 
				ifFalse:[item date date asString]) }
	
	! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 18:06:55'!
resolve: aBoolean
	model resolve: aBoolean! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 22:55:05'!
resolved
	^model resolved! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:07:08'!
start
	^model start! !

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:07:12'!
stop
	^model stop! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:10:05'!
addComment: aString by: author
	item addComment: aString by: author ! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:55:03'!
asString
	^ item header , ( item resolved ifTrue:[' (resolved)'] ifFalse:[''])! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 19:58:22'!
contents
	^ item comments collect:[:each | CommentWrapper with: each model: self ]
	! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:51:42'!
resolve: aBoolean
	item resolved: aBoolean! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 22:55:15'!
resolved
	^item resolved! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:07:43'!
start
	^item start! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:07:47'!
stop
	^item stop! !

!TestAnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:35:35'!
testEmpty

	| text c |
	
	text := AnnotatedText new.
	
	text addConversationBy: 'David' firstComment: '' from: 1  to: 0.
	
	text replaceFrom: 1 to: 0 with: 'Hello'. 
	
	c := text annotations at:1.
	
	self assert: c start = 1. 
	self assert: c stop = 0.
	
	text addConversationBy: 'David' firstComment:'' from: 6  to: 5.

	text replaceFrom: 1 to: 0 with: 'abc'. 

	self assert: c start = 1. 
	self assert: c stop = 0.

	c := text annotations at:2.

	self assert: c start = 9. 
	self assert: c stop = 8.
! !

!TestAnnotatedText methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 23:35:59'!
testXML

	| original reconstructed aWriteStream |
	
	original := AnnotatedText fromString: 'was brillig, and the slithy toves
Did gyre and gimble in the wabe:
All mimsy were the borogoves,
And the mome raths outgrabe'.

	original addConversationBy: 'David' firstComment: '' from: 1  to: 0.
	
	original addConversationBy: 'David' firstComment:'' from: 6  to: 5.

	aWriteStream := WriteStream on:''.
	
	original encodeXML: (XMLWriter on: aWriteStream).
	
	reconstructed := AnnotatedText new.
	
	reconstructed decodeXML:  (XMLDOMParser parseDocumentFrom: (ReadStream on: aWriteStream contents)).
	
	self assert: original equals: reconstructed .
	
	self assert: original annotations equals: reconstructed annotations.
	! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:39:06'!
= other

	self == other ifTrue:[^true].
	
	other isKindOf: self class :: ifFalse:[^false].
	
	^author = other author and:[comment = other comment] and: [date = other date].! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:22:46'!
author
	^author! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:22:19'!
author: aString
	author := aString! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:22:53'!
comment
	^comment! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:22:35'!
comment: aString
	comment := aString! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:22:49'!
date
	^date! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:22:28'!
date: aDateTime
	date := aDateTime! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:46:27'!
encodeXML: anXMLWriter 

	anXMLWriter startTag: 'comment' ; attribute: 'author' value: author ; attribute: 'date' value: date asString ; endTag.
	
	anXMLWriter pcData: comment.
		
	anXMLWriter endTag: 'comment'.! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:39:30'!
hash

	^ (author hash bitXor: comment hash) bitXor: date hash.! !

!TextComment methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 23:24:08'!
icon
	^nil! !

!TextComment class methodsFor: 'as yet unclassified' stamp: 'DF 3/18/2024 23:14:41'!
fromXML: anXMLNode

	| author date content |
	
	anXMLNode firstTagNamed: #comment with: [:node |
		
		author := node attributeAt: 'author'.
		date := DateAndTime fromString: (node attributeAt: 'date').
		content := node characterData.
		
		^ self new author: author; date: date; comment: content ; yourself ].
	
	self assert: false.! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:40:28'!
= other

	self == other ifTrue:[^true].
	
	other isKindOf: self class :: ifFalse:[^false].
	
	^comments = other comments and:[text = other text] and: [resolved = other resolved] and:[start = other start] and: [stop = other stop].! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 19:48:43'!
addComment: aString by: author

	comments add: (TextComment new author: author ; comment: aString ; date: DateAndTime now ; yourself)! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:31:03'!
comments
	^comments! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:20:01'!
comments: aString
	comments := aString! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 14:48:17'!
coveredBy: begin to:end

	^ begin < start and:[end > stop] 
! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:46:27'!
encodeXML: anXMLWriter 

	anXMLWriter startTag: 'conversation' ; attribute: 'start' value: start asString ; attribute: 'stop' value: stop asString ; attribute: 'resolved' value: resolved asString; endTag.
	
	comments do:[:each | each encodeXML: anXMLWriter ].
	
	anXMLWriter endTag: 'conversation'.! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:41:13'!
hash

	^ comments hash bitXor: text hash! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:57:27'!
header
	
	| s | 
	
	s :=  text copyFrom: start to: stop.
	
	s size > 16 ifTrue:[
		^ (s copyFrom: 1 to: 7), ' ... ', (s copyFrom: s size - 5 to: s size)].
	
	^ s
	! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/20/2024 23:25:46'!
icon
	^Theme current chatIcon! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:44:05'!
initialize
	comments := OrderedCollection new.
	
	resolved := false.! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 15:01:18'!
insert: length at: begin

	begin > stop ifTrue:[^self].
	
	begin < start ifTrue:[
		start := start + length.
		stop := stop + length.
		^self].
	
	stop := stop + length.! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/17/2024 20:41:57'!
removeFrom: begin to: end

	self assert: (self coveredBy:begin to: end) not.

	begin > stop ifTrue:[^self].
	
	end < start ifTrue:[
		start := start - (end - begin + 1).
		stop := stop - (end - begin + 1).
		^self].

	start <= begin and: [begin <= stop] :: ifTrue:[
		
		stop := stop - ( (stop - start) min: (end - begin + 1) ).
		
		^self ].
	
	self assert: start > begin.
	
	self assert: end >= start.
	
	end <= stop ifTrue:[
		stop := stop - (end - begin + 1).
		start := begin. ].
	
	
	

	! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:45:46'!
resolved
	^resolved! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:43:54'!
resolved: aBoolean
	resolved := aBoolean! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 15:58:23'!
start
	^start! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 14:21:59'!
start: anInteger
	start := anInteger! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 15:58:26'!
stop
	^stop! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 14:22:07'!
stop: anInteger
	stop := anInteger ! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:50:07'!
text
	^text! !

!TextConversation methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 17:59:41'!
text: aText
	text := aText! !

!TextConversation class methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:46:54'!
fromXML: anXMLElement text: aText

	| start stop resolved comments |

	anXMLElement firstTagNamed: #conversation with:[:node | 
		start := node attributeAt: 'start' :: asNumber.		
		stop := node attributeAt: 'stop' :: asNumber.
		resolved := (node attributeAt: 'resolved') = 'true'.
	
		comments := OrderedCollection new.
		
		node elementsDo:[:each | comments add: (TextComment fromXML: each) ].
		true.
	].

	^self new start: start; stop: stop ; comments: comments ; text: aText ; resolved: resolved; yourself! !
