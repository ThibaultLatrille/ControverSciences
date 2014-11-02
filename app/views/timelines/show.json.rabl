collection @timeline.references

attribute :title
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
  reference_url(ref)
end
