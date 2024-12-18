file = 'soccer.dat'

team_with_smallest_diff = nil
smallest_diff = Float::INFINITY

# Constants for header names, if header names change, just update the constants.
TEAM = 'Team'.freeze
GOALS_SCORED_FOR = 'F'.freeze
GOALS_SCORED_AGAINST = 'A'.freeze

# Helper function to detect header line and column indices
def detect_column_indices(lines)
  lines.each do |line|
    columns = line.split
    next unless columns.include?(TEAM) && columns.include?(GOALS_SCORED_FOR) && columns.include?(GOALS_SCORED_AGAINST)

    return {
      team_name: columns.index(TEAM),
      goals_for: columns.index(GOALS_SCORED_FOR),
      goals_against: columns.index(GOALS_SCORED_AGAINST),
    }
  end
  raise "Error: Could not find header line with column names."
end

# Helper method to extract column data by index
# Adjusts index for data rows where the structure may differ
def extract_column(line, index, adjust_offset = 0)
  columns = line.split
  columns[index + adjust_offset] rescue nil
end
  
# Read all lines to detect headers and process data
lines = File.readlines(file)
column_indices = detect_column_indices(lines)

lines.each do |line|
  # Skip lines that don't look like team data
  next unless line =~ /^\s*\d+/

  # Extract relevant data dynamically based on detected column indices
  team_name = extract_column(line, column_indices[:team_name], 1)
  goals_for = extract_column(line, column_indices[:goals_for], 1)&.to_i
  goals_against = extract_column(line, column_indices[:goals_against], 2)&.to_i

  # Skip lines with missing goal data
  next if team_name.nil? || goals_for.nil? || goals_against.nil?

  # Calculate the goal difference
  difference = (goals_for - goals_against).abs

  # Update the smallest difference if we found a new minimum
  if difference < smallest_diff
    smallest_diff = difference
    team_with_smallest_diff = team_name
  end
end

puts "Team with the smallest goal difference is: #{team_with_smallest_diff} and the difference is: #{smallest_diff}"

# Assuming soccer.rb and soccer.dat are in the same folder, run this program in Terminal: ruby soccer.rb
