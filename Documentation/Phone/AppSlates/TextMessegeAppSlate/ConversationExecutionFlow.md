EXECUTION FLOW OF CONVERSATIONS

1. ConversationEntryNode.create_conversation_slate
2. ConversationAppSlate.start_convo_slate
3. ConversationAppSlate.pop_process_convo_dict
4. ConversationAppSlate.process_convo_dict
5. ConversationAppSlate.init_entry_node_display_conditions
-TIMER-
6. ConversationAppSlate.send_first_timer_to_entry_node
7. ConversationEntryNode.create_first_push_timer
8. ConversationEntryNode.cancel_and_restart_timer
-GSB FREQUENCY-
9. ConversationEntryNode.create_game_story_beat_requirements
10. ConversationEntryNode.emit(RequestGSBFrequencyInfo)
11. TextMessengerAppSlate._on_gsb_frequency_info_request
12. TextMessengerAppSlate.emit(RequestGameStoryBeatFrequency)
13. GameDaemon._on_gsb_frequency_requested
14. ConversationEntryNode.evaluate_game_story_beat_requirements
15. ConversationEntryNode.handle_display_appslate
-TIMER RESOLVES LIKE SO-
16a. [wait for timer]
16b. ConversationEntryNode._on_FirstPushTimer_timeout
16c. ConversationEntryNode.handle_display_appslate
-GSB RESOLVES LIKE SO-
17a. [wait for GSB]
17b. GameDaemon.evaluate_game_story_beat
17c. GameDaemon.advance_required_story_beat
17d. GameDaemon.emit(GameStoryBeatAdvanced)
17e. TextMessengerAppSlate._on_game_story_beat_advanced
17f. TextMessengerAppSlate.emit(GameStoryBeatAdvanced)
17g. TextMessengerAppSlate._on_game_story_beat_advanced
17h. TextMessengerAppSlate.evaluate_game_story_beat_advanced
17i. (If beat matches) TextMessenger.handle_display_appslate
-ONCE BOTH TIMER AND GSB RESOLVE-
18. ConversationEntryNode.emit(GameStoryBeatTriggered)
19. ConversationAppSlate.handle_next_convo_dict
20. (If prompt needed) ConversationAppSlate.create_lex_prompt
21. (If prompt needed) ConversationAppSlate.create_lex_prompt
22. ConversationAppSlate.display_next_convo_dict
23. ConversationAppSlate.create_static_message_text
24. Back to Step 3!
25. ConversationEntryNode.send_notification_to_phone


