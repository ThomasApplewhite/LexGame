extends AppSlate

func _on_TextMessengerButton_pressed():
	emit_signal(slate_change_signal_name, GameEnums.AppSlateType.TEXT)
	
func _on_back_button_pressed():
	# No functionality. This is intentional.
	pass
	
func _on_home_button_pressed():
	# No functionality. This is intentional.
	pass
	
func _on_opts_button_pressed():
	# No functionality. This is intentional.
	pass
