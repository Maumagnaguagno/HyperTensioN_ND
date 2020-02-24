require_relative '../../../Map_generator/Mapgen'
require_relative '../../../HyperTensioN/examples/experiments/Grid'
if File.exist?(spriter = File.expand_path('../../../../Spriter/', __FILE__))
  require_relative "#{spriter}/Image.rb"
  require_relative "#{spriter}/ImageX.rb"
  back = [255, 255, 255, 255].pack('C4')
  front = [0, 0, 0, 0].pack('C4')
end

width = height = (ARGV.first || 7).to_i # 2 * N + 1
w = (width  << 1) + 1
h = (height << 1) + 1
room_size = 1
start = 'p1_1'
goal = "p#{w - 2}_#{h - 2}"

20.times {|seed|
  srand(seed)
  map = Mapgen.maze_division(width, height, room_size)
  map = Mapgen.wall_to_tile(map)
  mapdata = ["(at agent #{start})"]
  map.each_with_index {|row,y| row.each_with_index {|c,x| mapdata << "(clear p#{x}_#{y})" if c == 0}}
  abort "Problem #{seed} with impossible start #{start}" unless mapdata.include?("(clear #{start})")
  mapdata.delete("(clear #{start})")
  abort "Problem #{seed} with impossible goal #{goal}" unless mapdata.include?("(clear #{goal})")
  mapdata.concat(Grid.generate(w,h).map! {|a,b| "(adjacent #{a} #{b})"})
  IO.binwrite(File.expand_path("../pb#{seed}.ujshop", __FILE__),
    "(defproblem pb#{seed} maze\n  (
    #{mapdata.join("\n    ")}\n  )\n  (
    (forward agent #{goal})\n  )\n)"
  )
  if Image
    pixels = ''
    map.flatten.each {|i| pixels << (i.zero? ? back : front)}
    Image.new(w, h).write(0, 0, pixels, pixels.size).save_png(File.expand_path("../pb#{seed}.png", __FILE__))
  end
  puts seed, map.map! {|row| row.join.tr!('01',' #')}
}