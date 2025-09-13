class_name CallableStateMachine

# Internal state storage shape:
#   state_dictionary[state_name] = {
#       normal: Callable,
#       enter: Callable,
#       leave: Callable,
#   }
var state_dictionary: Dictionary = {}
var current_state: StringName = &""


func add_state(
	normal_state_callable: Callable,
	enter_state_callable: Callable,
	leave_state_callable: Callable
):
	# Validate input
	if normal_state_callable.is_null():
		push_warning(
			"add_state: normal_state_callable is null; state not added."
		)
		return

	var state_name: StringName = normal_state_callable.get_method()
	if String(state_name).is_empty():
		push_warning(
			"add_state: normal_state_callable has empty method name; state not added."
		)
		return

	if state_dictionary.has(state_name):
		push_warning(
			(
				"add_state: Duplicate state '"
				+ String(state_name)
				+ "' will be overwritten."
			)
		)

	state_dictionary[state_name] = {
		normal = normal_state_callable,
		enter = enter_state_callable,
		leave = leave_state_callable,
	}


func set_initial_state(state_callable: Callable):
	var state_name: StringName = state_callable.get_method()
	if state_dictionary.has(state_name):
		_set_state(state_name)
	else:
		push_warning("No state with name " + String(state_name))


func update(_delta: float = 0.0):
	if current_state != &"":
		var normal_callable: Callable = state_dictionary[current_state].normal
		# Call without delta to keep existing state function signatures simple.
		normal_callable.call()


func change_state(state_callable: Callable):
	var state_name: StringName = state_callable.get_method()
	if state_dictionary.has(state_name):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state with name " + String(state_name))


func _set_state(state_name: StringName):
	if current_state != &"":
		var leave_callable: Callable = state_dictionary[current_state].leave
		if not leave_callable.is_null():
			leave_callable.call()

	current_state = state_name
	var enter_callable: Callable = state_dictionary[current_state].enter
	if not enter_callable.is_null():
		enter_callable.call()
