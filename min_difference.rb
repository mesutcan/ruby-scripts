# Helper function to detect header line and column indices
def detect_column_indices(lines, column_names)
  lines.each do |line|
    columns = line.split
    # Ensure all required columns are in the header line
    if column_names.keys.all? { |name| columns.include?(name) }
      return column_names.map { |name, offset| [name, { index: columns.index(name), offset: offset }] }.to_h
    end
  end
  raise "Error: Could not find header line with specified column names."
end
  
# Helper method to extract column data by index and offset
def extract_column(line, index, adjust_offset = 0)
  columns = line.split
  columns[index + adjust_offset] rescue nil
end
  
# Generic function to find the smallest difference
# Takes file path, column names with offsets, and a key column for identification
def find_smallest_difference(file_path, column_names, key_column)
  smallest_difference = Float::INFINITY
  identifier = nil
  
  # Read all lines to detect headers and process data
  lines = File.readlines(file_path)
  column_indices = detect_column_indices(lines, column_names)
  
  lines.each do |line|
    # Skip lines that don't look like data rows
    next unless line =~ /^\s*\d+/

    # Extract data dynamically
    key = extract_column(line, column_indices[key_column][:index], column_indices[key_column][:offset])
    values = column_names.reject { |name, _| name == key_column }.map do |col, _|
      extract_column(line, column_indices[col][:index], column_indices[col][:offset])&.to_i
    end

    # Skip if any value is missing
    next if key.nil? || values.any?(&:nil?)

    # Calculate the difference
    difference = (values[0] - values[1]).abs

    # Update the smallest difference if we found a new minimum
    if difference < smallest_difference
      smallest_difference = difference
      identifier = key
    end
  end
  
  { identifier: identifier, difference: smallest_difference }
end
  
puts "Enter the file name:"
file_path = gets.chomp

if file_path.strip.empty? || !File.exist?(file_path)
  puts "Error: File not found or no file name provided. Please try again."
  exit
end

#specify column names with offset. Ex: Team and the data for Team has offset of 1. Team is on index 0 on the header but the data for Team starts on index 1 on the next row.
puts "Enter the column names and offsets as a hash (e.g., { \"Team\" => 1, \"F\" => 1, \"A\" => 2 }):"
column_names = eval(gets.chomp)

puts "Enter the key column name (e.g., 'Team' or 'Dy'):"
key_column = gets.chomp

begin
  result = find_smallest_difference(file_path, column_names, key_column)
  puts "Identifier with the smallest difference: #{result[:identifier]} (Difference: #{result[:difference]})"
rescue => e
  puts "Error: #{e.message}"
end
