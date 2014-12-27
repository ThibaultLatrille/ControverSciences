collection @timeline.references

attribute :id
node :title do |ref|
  ref.title_fr
end
node :date do |ref|
  "01 Jan #{ref.year}"
end
node :displaydate do |ref|
  "#{ref.year}"
end
attribute author: 'caption'
attribute f_1_content: 'field1', if: lambda { |m| !m.f_1_content.nil? }
attribute f_2_content: 'field2', if: lambda { |m| !m.f_2_content.nil? }
attribute f_3_content: 'field3', if: lambda { |m| !m.f_3_content.nil? }
attribute f_4_content: 'field4', if: lambda { |m| !m.f_4_content.nil? }
attribute f_5_content: 'field5', if: lambda { |m| !m.f_5_content.nil? }
node :readmoreurl do |ref|
  reference_path(ref.id)
end

node :url do |ref|
  ref.url
end
node :user_name do |ref|
  ref.user_name
end

node :open do |ref|
  ref.open_access
end

node :color do |ref|
  if ref.star_most > 3
      "blue"
  else
      "default"
  end
end

node :expansion do |ref|
  if ref.star_most > 3
    'expanded'
  else
    'collapsed'
  end
end