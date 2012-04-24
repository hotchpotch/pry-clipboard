
$:.unshift File.expand_path '../../lib', __FILE__
require 'pry-clipboard'

def gempath(gemname)
  Gem.loaded_specs.each do |key, spec|
    if key == gemname
      return Pathname.new(spec.full_gem_path)
    end
  end
end

require gempath('pry').join('test/helper.rb').to_s
