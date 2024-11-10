extends Node
class State extends CoroutineWrapper:

	signal Transitioned

	func enter():
		pass
	
	func exit():
		pass
	
	func update(_delta: float):
		pass
