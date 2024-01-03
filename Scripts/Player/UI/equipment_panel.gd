extends Control

@export var parent_node : Node3D

@onready var armor : InventoryPanel = $VBoxContainer/ArmorContainer
@onready var accessory : InventoryPanel = $VBoxContainer/AccessoryContainer


func _ready():
	armor.parent_node = parent_node
	accessory.parent_node = parent_node
