'From Cuis6.0 [latest update: #6153] on 19 March 2024 at 3:55:16 pm'!
'Description '!
!provides: 'Annotations' 1 48!
!requires: 'YAXO' 1 24 nil!
SystemOrganization addCategory: #Annotations!


!classDefinition: #AnnotatedTextModel category: #Annotations!
TextModel subclass: #AnnotatedTextModel
	instanceVariableNames: 'conversations'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'AnnotatedTextModel class' category: #Annotations!
AnnotatedTextModel class
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
	instanceVariableNames: 'textModelMorph commentsMorph text selectedConversation annotatedTextModel showResolvedConversations'
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

!classDefinition: #TestAnnotatedTextModel category: #Annotations!
TestCase subclass: #TestAnnotatedTextModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Annotations'!
!classDefinition: 'TestAnnotatedTextModel class' category: #Annotations!
TestAnnotatedTextModel class
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


!AnnotatedTextModel methodsFor: 'xml' stamp: 'DF 3/19/2024 15:37:40'!
decodeXML: anXMLNode

	conversations := OrderedCollection new.
		
	anXMLNode firstTagNamed: #text with: [:node | 
		
		actualContents := Text fromString: node characterData . true ].
	
	anXMLNode firstTagNamed: #conversations with:[:node |
		node elementsDo: [:each | 
			conversations add: (TextConversation fromXML: each text: actualContents) ]. true ].
		
! !

!AnnotatedTextModel methodsFor: 'xml' stamp: 'DF 3/19/2024 13:00:50'!
encodeXML: anXMLWriter 
		
	anXMLWriter xmlDeclaration: '1.0' encoding: 'UTF-8'.
	
	anXMLWriter startTag:'body'; endTag.
	
	anXMLWriter 
		startTag: 'text' ; endTag ; 
		pcData: actualContents asString ;
		endTag: 'text'.
		
	anXMLWriter startTag: 'conversations' ; endTag.
		
	conversations do:[:each | each encodeXML: anXMLWriter ].
	
	anXMLWriter endTag: 'conversations'.
	
	anXMLWriter endTag: 'body'.! !

!AnnotatedTextModel methodsFor: 'syncing edits' stamp: 'DF 3/19/2024 12:55:08'!
basicReplaceFrom: start to: stop with: replacement
	
	super basicReplaceFrom: start to: stop with: replacement.
		
	start <= stop ifTrue:[ self removeFrom: start to: stop].
	
	self insert: replacement size at: start.
	
	
	
	! !

!AnnotatedTextModel methodsFor: 'syncing edits' stamp: 'DF 3/19/2024 12:54:12'!
insert: length at: begin

	conversations do:[:each |each insert:length at:begin].
! !

!AnnotatedTextModel methodsFor: 'syncing edits' stamp: 'DF 3/19/2024 12:54:27'!
removeFrom: begin to: end

	self assert: begin >= 1.
	
	self assert: begin <= end.
	
	self assert: end <= self size.
	
	conversations := conversations reject:[:each | each coveredBy: begin to:end].
	
	conversations do:[:each |each removeFrom: begin to: end].
	
	! !

!AnnotatedTextModel methodsFor: 'user interface support' stamp: 'DF 3/19/2024 12:50:09'!
editorClass
	^AnnotatedTextEditor! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 13:35:42'!
acceptContentsFrom: aTextModelMorph

	self changed: #clearUserEdits.
	
	^true! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 13:28:49'!
addConversationBy: author firstComment: aString from: start to: end

	| comment conversation  |
	
	self assert: start >= 1.
	
	"self assert: start <= end." "allow start > end to represent a point in the document"
	
	self assert: end <= (actualContents size + 1).
	
	comment := TextComment new author: author ; comment: aString ; date: DateAndTime now; yourself.
	
	conversation := TextConversation new text: actualContents; start: start ; stop: end ; yourself.
	
	conversation comments add: comment.
	
	conversations add: conversation.
	
		

	! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 13:24:23'!
conversations
	^conversations! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 12:51:56'!
initialize

	super initialize.
	
	conversations := OrderedCollection new.! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:35:37'!
refusesToAccept
	^false! !

!AnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:33:25'!
wantsFrameAdornments 
	^true! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/17/2024 22:15:24'!
acceptContents
	
	^super acceptContents ! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 13:29:18'!
addComment

	StringRequestMorph
		request: 'Enter a comment'
		do: [:aString | model addConversationBy: 'Alice' firstComment: aString from: self startIndex  to: self stopIndex. model changed ].
! !

!AnnotatedTextEditor methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 21:59:44'!
getMenu

	| aMenu |
	
	aMenu := super getMenu.
	
	aMenu addLine.
	
	aMenu add: 'Add comment...'
		action: #addComment.
		
	^aMenu	! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 19:51:44'!
addComment

	
	selectedConversation ifNil:[^self].
	
	StringRequestMorph
		request: 'Enter a comment'
		do: [:aString | selectedConversation addComment:aString by:'Alice' . self changed: #conversations.  ].
		
	
		
	
	! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:55:51'!
conversationMenu

	| menu |
	menu := MenuMorph entitled: 'Conversation menu'.
	
	menu add: showResolvedConversations asMenuItemTextPrefix , 'Show resolved' target: self action: #toggleShowResolved.

	menu addLine.
	
	menu add: 'Resolve' target: self action: #resolveConversation.

	menu add: 'Unresolve' target: self action: #unresolveConversation.
	
	menu addLine.
	
	menu add: 'Edit ...' target: self action: #editComment.

	menu add: 'Reply ...' target: self action: #addComment.
		
	^ menu
! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:53:43'!
conversations

	showResolvedConversations ifTrue:[
		^annotatedTextModel conversations collect:[:each | ConversationWrapper with: each model:self ] ].
		
	^ (annotatedTextModel conversations reject:[:each | each resolved ]) collect: [:each | ConversationWrapper with: each model:self ].! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:21:23'!
editComment
	
	selectedConversation ifNil:[^self].

	selectedConversation isKindOf: CommentWrapper :: ifFalse:[^self].
	
	StringRequestMorph
		request: 'Edit your comment'
		initialAnswer: selectedConversation item comment 
		do: [:aString | selectedConversation item comment:aString ;author:'Alice' ; date: DateAndTime now . self changed: #conversations.  ].
		
	
		
	
	! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:50:21'!
initialize
	
	super initialize.
	
	self beRow.
	
	showResolvedConversations := false.

	annotatedTextModel := AnnotatedTextModel new.
	
	commentsMorph := HierarchicalListMorph model: self listGetter: #conversations indexGetter: #selection indexSetter: #selection: mainView: self menuGetter:#conversationMenu keystrokeAction:nil.
	 
	annotatedTextModel when: #changed: send: #update to: self.
	
	textModelMorph := TextModelMorph withModel: annotatedTextModel.
	
	self addMorph: (textModelMorph pw:0.6;ph:1.0).
	self addMorph: (commentsMorph pw:0.4 ; ph:1.0).


! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:49:36'!
resolveConversation

	selectedConversation isKindOf: AnnotationWrapper :: ifFalse:[^self].
	
	selectedConversation resolve: true.
	
	self changed: #conversations.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 11:56:53'!
selection

	^selectedConversation ! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 11:56:11'!
selection: aConversationWrapper
	
	aConversationWrapper ifNil:[^self].
	
	selectedConversation := aConversationWrapper.
	
	selectedConversation isKindOf: AnnotationWrapper :: ifFalse:[^self].
	
	textModelMorph selectFrom: selectedConversation start to: selectedConversation stop. 
	
	self changed: #conversations.
	
	textModelMorph redrawNeeded.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:50:33'!
toggleShowResolved

	showResolvedConversations := showResolvedConversations not.
	
	self changed: #conversations.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:49:46'!
unresolveConversation

	selectedConversation isKindOf: AnnotationWrapper :: ifFalse:[^self].
	
	selectedConversation resolve: false.
	
	self changed: #conversations.! !

!AnnotatedTextMorph methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 22:31:11'!
update

	self changed: #conversations.! !

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

!CommentWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 14:51:52'!
resolve: aBoolean
	model resolved: aBoolean! !

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

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:07:43'!
start
	^item start! !

!ConversationWrapper methodsFor: 'as yet unclassified' stamp: 'DF 3/16/2024 20:07:47'!
stop
	^item stop! !

!TestAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 13:39:21'!
testEmpty

	| text c |
	
	text := AnnotatedTextModel new.
	
	text addConversationBy: 'David' firstComment: '' from: 1  to: 0.
	
	text basicReplaceFrom: 1 to: 0 with: 'Hello'. 
	
	c := text conversations at:1.
	
	self assert: c start = 1. 
	self assert: c stop = 0.
	
	text addConversationBy: 'David' firstComment:'' from: 6  to: 5.

	text basicReplaceFrom: 1 to: 0 with: 'abc'. 

	self assert: c start = 1. 
	self assert: c stop = 0.

	c := text conversations at:2.

	self assert: c start = 9. 
	self assert: c stop = 8.
! !

!TestAnnotatedTextModel methodsFor: 'as yet unclassified' stamp: 'DF 3/19/2024 15:49:38'!
testXML

	| original reconstructed aWriteStream |
	
	original := AnnotatedTextModel new.
	
	original actualContents: 'was brillig, and the slithy toves
Did gyre and gimble in the wabe:
All mimsy were the borogoves,
And the mome raths outgrabe'.

	original addConversationBy: 'David' firstComment: '' from: 1  to: 0.
	
	original addConversationBy: 'David' firstComment:'' from: 6  to: 5.

	aWriteStream := WriteStream on:''.
	
	original encodeXML: (XMLWriter on: aWriteStream).
	
	reconstructed := AnnotatedTextModel new.
	
	reconstructed decodeXML:  (XMLDOMParser parseDocumentFrom: (ReadStream on: aWriteStream contents)).
	
	self assert: original actualContents equals: reconstructed actualContents.
	
	self assert: original conversations equals: reconstructed conversations.
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
