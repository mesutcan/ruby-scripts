file = 'w_data.dat'

smallest_temp_diff = Float::INFINITY
smallest_temp_day = nil

# Constants for header names, if header names change, just update the constants.
DAY = 'Dy'.freeze
MAX_TEMP = 'MxT'.freeze
MIN_TEMP = 'MnT'.freeze

# Helper function to detect header line and column indices
def detect_column_indices(lines)
  lines.each do |line|
    columns = line.split
    next unless columns.include?(DAY) && columns.include?(MAX_TEMP) && columns.include?(MIN_TEMP)

    return {
      day: columns.index(DAY),
      max_temp: columns.index(MAX_TEMP),
      min_temp: columns.index(MIN_TEMP)
    }
  end
  raise "Error: Could not find header line with column names."
end

# Helper method to extract column data by index
def extract_column(line, index)
  columns = line.split
  columns[index] rescue nil
end

# Read all lines to detect headers and process data
lines = File.readlines(file)
column_indices = detect_column_indices(lines)

# Process each line for data
lines.each do |line|
  # Skip lines that don't look like data rows
  next unless line =~ /^\s*\d+/

  # Adjust indices for data rows
  day = extract_column(line, column_indices[:day])&.to_i
  max_temp = extract_column(line, column_indices[:max_temp])&.to_i
  min_temp = extract_column(line, column_indices[:min_temp])&.to_i

  # Skip lines with missing temperature data
  next if day.nil? || max_temp.nil? || min_temp.nil?

  # Calculate the temperature spread
  spread = (max_temp - min_temp).abs

  # Update the smallest spread if we found a new minimum
  if spread < smallest_temp_diff
    smallest_temp_diff = spread
    smallest_temp_day = day
  end
end

puts "Day with the smallest temperature spread is: #{smallest_temp_day} and the spread is: #{smallest_temp_diff}"

# Assuming weather.rb and w_data.dat are in the same folder, run this program in Terminal: ruby weather.rb
