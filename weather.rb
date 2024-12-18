file = 'w_data.dat'

smallest_temp_day = nil
smallest_temp_diff = Float::INFINITY

File.foreach(file) do |line|
  next unless line =~ /^\s*\d+/

  columns = line.split
  day = columns[0].to_i
  max_temp = columns[1].to_i
  min_temp = columns[2].to_i

  # Calculate the temperature spread
  spread = (max_temp - min_temp).abs

  # Update the smallest spread if we found a new minimum
  if spread < smallest_temp_diff
    smallest_temp_diff = spread
    smallest_temp_day = day
  end
end

puts "Day with the smallest temperature spread: Day is: #{smallest_temp_day} and the spread is: #{smallest_temp_diff}"

# Assuming weather.rb and w_data.dat are in the same folder, run this program in Terminal: ruby weather.rb