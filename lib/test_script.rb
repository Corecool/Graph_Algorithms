$: << File.dirname(__FILE__) 
require 'graph'

expectG = Graph.new
expectG.add_node('s')
expectG.add_node('t')
('a'..'d').each{|item| expectG.add_node(item)}
expectG.add_edge('s','a',4)
expectG.add_edge('a','s',2)
expectG.add_edge('b','s',5)
expectG.add_edge('a','b',5)
expectG.add_edge('a','c',2)
expectG.add_edge('c','a',7)
expectG.add_edge('c','b',7)
expectG.add_edge('b','c',2)
expectG.add_edge('b','d',4)
expectG.add_edge('d','b',2)
expectG.add_edge('d','c',3)
expectG.add_edge('t','c',2)
expectG.add_edge('t','d',5)
expectG.add_edge('d','t',3)

expectG.to_s