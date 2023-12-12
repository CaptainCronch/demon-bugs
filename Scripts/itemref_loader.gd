extends ResourcePreloader

var ref_strings : PackedStringArray = [
	"bug_net"
]


func _init():
	for ref in ref_strings:
		add_resource(ref, load("res://Resources/" + ref + ".tres"))


func _ready():
	Global.itemref_loader = self
