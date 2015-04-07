require 'refile'
require 'refile/type'

# # Monkey Patch to add file extensions to type (derived from content type)
module Refile
  class Type
    attr_reader :name
  end
end