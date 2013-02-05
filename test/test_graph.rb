require 'test/unit'
require 'graph'

class Graph_Algorithms < Test::Unit::TestCase
	# 测试剩余图构建
	def test_remaining_graph
		# 构造图16.1(a)
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',6,2)
		g.add_edge('s','b',5,5)
		g.add_edge('a','c',9,7)
		g.add_edge('b','a',5,5)
		g.add_edge('c','b',9,2)
		g.add_edge('b','d',6,2)
		g.add_edge('c','d',3,3)
		g.add_edge('c','t',2,2)
		g.add_edge('d','t',8,5)
		
		targetG = Graph_Util.solve_remaining_graph(g)

		# 构造图16.1(b)
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

		assert_block do 
			targetG == expectG
		end


	end
end
