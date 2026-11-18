extends GutTest

const Greeting = preload("res://src/greeting.gd")


func test_greet_includes_the_name() -> void:
	assert_eq(Greeting.greet("Ada"), "Hello, Ada!")
