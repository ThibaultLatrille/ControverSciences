object false

child @nodes, root:"nodes", :object_root => false do
  attributes :name
  attributes :id
  node(:group) { |node| node.group }
end

node (:nodes) {[]} if @nodes.empty?

child @links, root:"links", :object_root => false do
  node(:source) { |link| link.timeline_id }
  node(:target) { |link| link.target }
  node(:value) { |link| link.value }
end

node (:links) {[]} if @links.empty?