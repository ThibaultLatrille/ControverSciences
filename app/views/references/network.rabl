object false

child @nodes, root:"nodes", :object_root => false do
  node(:name) { |link| link.title_fr != "" ? link.title_fr : link.title }
  attributes :id
  node(:size) { |node| node.star_most + 1 }
  node(:url) { |node| reference_url(node) }
  node(:group) { |node| node.binary_most }
end

node (:nodes) {[]} if @nodes.empty?

child @links, root:"links", :object_root => false do
  node(:source) { |link| link.reference_id }
  node(:target) { |link| link.target }
  node(:value) { |link| 1 }
end

node (:links) {[]} if @links.empty?