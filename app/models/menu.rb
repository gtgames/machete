class Menu < Sequel::Model
  # Recursive adjacency list
  plugin :rcte_tree
  plugin :list
end
