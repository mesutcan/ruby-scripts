file = 'soccer.dat'

team_with_smallest_diff = nil
smallest_diff = Float::INFINITY

File.foreach(file) do |line|
  next unless line =~ /^\s*\d+/

  columns = line.split
  team_name = columns[1]
  goals_for = columns[6].to_i
  goals_against = columns[8].to_i

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