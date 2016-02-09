object false

child @nodes, root:"nodes", :object_root => false do
  node(:name) { |link| link.name }
  attributes :id
  node(:size) { |node| node.staging ? 10*node.score : node.score }
  node(:url) { |node| timeline_url(node) }
  node(:group) { |node| node.staging ? 1 : 0 }
end

node (:nodes) {[]} if @nodes.empty?

child @links, root:"links", :object_root => false do
  node(:source) { |link| link.timeline_id }
  node(:target) { |link| link.target }
  node(:value) { |link| 1 }
end

node (:links) {[]} if @links.empty?