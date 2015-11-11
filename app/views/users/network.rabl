object false

child @nodes, root:"nodes", :object_root => false do
  node(:name) { |link| link.name }
  attributes :id
  node(:size) { |node| node.score }
  node(:url) { |node| user_url(node) }
  node(:group) { |node| '1' }
end

node (:nodes) {[]} if @nodes.empty?

child @links, root:"links", :object_root => false do
  node(:source) { |link| link[0] }
  node(:target) { |link| link[1] }
  node(:value) { |link| 1 }
end

node (:links) {[]} if @links.empty?