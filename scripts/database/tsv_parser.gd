# res://scripts/database/tsv_parser.gd
class_name TSVParser
extends RefCounted

const SEPARATOR = "\t"

# Parse TSV-Datei → Dictionary Array
static func parse_file(file_path: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []

	if not FileAccess.file_exists(file_path):
		push_error("TSV file not found: " + file_path)
		return result

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + file_path)
		return result

	# Read header
	var header_line = file.get_line()
	var headers = header_line.split(SEPARATOR)

	# Read data lines
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty():
			continue

		var values = line.split(SEPARATOR)
		var entry = {}

		for i in range(min(headers.size(), values.size())):
			var key = headers[i].strip_edges()
			var value = values[i].strip_edges()
			entry[key] = _convert_value(value)

		result.append(entry)

	file.close()
	return result

# Konvertiere String → richtiger Typ
static func _convert_value(value: String):
	if value.is_empty():
		return null

	# Try integer
	if value.is_valid_int():
		return value.to_int()

	# Try float
	if value.is_valid_float():
		return value.to_float()

	# Return as string
	return value

# Write Dictionary Array → TSV
static func write_file(file_path: String, data: Array[Dictionary], headers: Array) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: " + file_path)
		return false

	# Write header
	file.store_line(SEPARATOR.join(headers))

	# Write data
	for entry in data:
		var row_values = []
		for header in headers:
			var value = entry.get(header, "")
			row_values.append(str(value))
		file.store_line(SEPARATOR.join(row_values))

	file.close()
	return true

# Export to JSON
static func export_to_json(data: Array[Dictionary], json_path: String) -> bool:
	var file = FileAccess.open(json_path, FileAccess.WRITE)
	if file == null:
		return false

	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true
