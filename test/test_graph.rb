require 'pry'
require 'test/unit'
require 'yaml'
require 'graph'

class Test_Graph_Algorithms < Test::Unit::TestCase
	private

	def compare_graph(expectG,targetG)
		return false if !expectG || !targetG
		return false unless targetG.nodes.length == 
		expectG.nodes.length
		return false unless targetG.edges.length == 
		expectG.edges.length
		expectG.edges.each{|edge|
			return false unless targetG.edges.find{|e|
				edge.from.name == e.from.name &&
				edge.to.name == e.to.name
			}
			e = targetG.edges[targetG.edges.index{|e|
				edge.from.name == e.from.name &&
				edge.to.name == e.to.name
			}]
			return false unless e.c == edge.c &&
			e.f == edge.f && e.r == edge.r
		}
		return true
	end

	def call_method(method,g,s = 's',t = 't')
		data = YAML.dump(g)
		newG = method.call(g,s,t)
		origG = YAML.load(data)
		assert_block do
			g == origG
		end
		return newG
	end


	def remaining_graph_case_0
		# 构造图16.1(a)——输入
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
		
		method = Graph_Util.method(:"solve_remaining_graph")
		targetG = call_method(method,g)
		
		# 构造图16.1(b)——期望输出
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
			compare_graph(expectG,targetG)
		end
	end

	def remaining_graph_case_1
		# 构造图16.3(a),组合16.3(c)(d)——输入
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',16,12)
		g.add_edge('s','b',13,4)
		g.add_edge('a','b',4)
		g.add_edge('a','c',12,12)
		g.add_edge('b','a',10)
		g.add_edge('b','d',14,4)
		g.add_edge('c','b',9)
		g.add_edge('c','t',20,12)
		g.add_edge('d','c',7)
		g.add_edge('d','t',4,4)
		
		method = Graph_Util.method(:"solve_remaining_graph")
		targetG = call_method(method,g)
		
		# 构造图16.3(e)——期望输出
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',4)
		expectG.add_edge('s','b',9)
		expectG.add_edge('a','s',12)
		expectG.add_edge('a','b',4)
		expectG.add_edge('b','s',4)
		expectG.add_edge('b','a',10)
		expectG.add_edge('b','d',10)
		expectG.add_edge('c','a',12)
		expectG.add_edge('c','b',9)
		expectG.add_edge('c','t',8)
		expectG.add_edge('d','b',4)
		expectG.add_edge('d','c',7)
		expectG.add_edge('t','c',12)
		expectG.add_edge('t','d',4)
		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def remaining_graph_case_2
		# 构造图16.3(e),组合16.3(g)——输入
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',4)
		g.add_edge('s','b',9,7)
		g.add_edge('a','s',12)
		g.add_edge('a','b',4)
		g.add_edge('b','s',4)
		g.add_edge('b','a',10)
		g.add_edge('b','d',10,7)
		g.add_edge('c','a',12)
		g.add_edge('c','b',9)
		g.add_edge('c','t',8,7)
		g.add_edge('d','b',4)
		g.add_edge('d','c',7,7)
		g.add_edge('t','c',12)
		g.add_edge('t','d',4)
		
		method = Graph_Util.method(:"solve_remaining_graph")
		targetG = call_method(method,g)
		
		# 构造图16.3(h)——期望输出
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',4)
		expectG.add_edge('s','b',2)
		expectG.add_edge('a','s',12)
		expectG.add_edge('a','b',4)
		expectG.add_edge('b','s',11)
		expectG.add_edge('b','a',10)
		expectG.add_edge('b','d',3)
		expectG.add_edge('c','a',12)
		expectG.add_edge('c','b',9)
		expectG.add_edge('c','d',7)
		expectG.add_edge('c','t',1)
		expectG.add_edge('d','b',11)
		expectG.add_edge('t','c',19)
		expectG.add_edge('t','d',4)
		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def level_graph_case_0
		# 构造图16.3(a)输入图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',16)
		g.add_edge('s','b',13)
		g.add_edge('a','b',4)
		g.add_edge('a','c',12)
		g.add_edge('b','a',10)
		g.add_edge('b','d',14)
		g.add_edge('c','b',9)
		g.add_edge('c','t',20)
		g.add_edge('d','c',7)
		g.add_edge('d','t',4)

		method = Graph_Util.method(:"solve_level_graph")
		targetG = call_method(method,g,'s')

		# 构造图16.3(b) 第一层次图
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',16)
		expectG.add_edge('s','b',13)
		expectG.add_edge('a','c',12)
		expectG.add_edge('b','d',14)
		expectG.add_edge('c','t',20)
		expectG.add_edge('d','t',4)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def level_graph_case_1
		# 构造图16.3(e) 输入图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',4)
		g.add_edge('s','b',9)
		g.add_edge('a','s',12)
		g.add_edge('a','b',4)
		g.add_edge('b','s',4)
		g.add_edge('b','a',10)
		g.add_edge('b','d',10)
		g.add_edge('c','a',12)
		g.add_edge('c','b',9)
		g.add_edge('c','t',8)
		g.add_edge('d','b',4)
		g.add_edge('d','c',7)
		g.add_edge('t','c',12)
		g.add_edge('t','d',4)

		method = Graph_Util.method(:"solve_level_graph")
		targetG = call_method(method,g,'s')

		# 构造图16.3(f) 第二层次图
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',4)
		expectG.add_edge('s','b',9)
		expectG.add_edge('b','d',10)
		expectG.add_edge('c','t',8)
		expectG.add_edge('d','c',7)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def level_graph_case_2
		# 构造图16.3(h) 输入图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',4)
		g.add_edge('s','b',2)
		g.add_edge('a','s',12)
		g.add_edge('a','b',4)
		g.add_edge('b','s',11)
		g.add_edge('b','a',10)
		g.add_edge('b','d',3)
		g.add_edge('c','a',12)
		g.add_edge('c','b',9)
		g.add_edge('c','d',7)
		g.add_edge('c','t',1)
		g.add_edge('d','b',11)
		g.add_edge('t','c',19)
		g.add_edge('t','d',4)

		method = Graph_Util.method(:"solve_level_graph")
		targetG = call_method(method,g,'s')

		# 构造图16.3(i) 第三层次图
		expectG = Graph.new
		expectG.add_node('s')
		('a'..'b').each{|item| expectG.add_node(item)}
		expectG.add_node('d')
		expectG.add_edge('s','a',4)
		expectG.add_edge('s','b',2)
		expectG.add_edge('b','d',3)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def push_pull_stream_case_0
		# 构造图16.4(b) 输入层次图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',13)
		g.add_edge('s','b',4)
		g.add_edge('a','c',9)
		g.add_edge('b','d',8)
		g.add_edge('c','t',7)
		g.add_edge('d','t',9)

		method = Graph_Util.method(:"solve_pp_stream")
		targetG = call_method(method,g)

		# 构造输出流图
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',13)
		expectG.add_edge('s','b',4,4)
		expectG.add_edge('a','c',9)
		expectG.add_edge('b','d',8,4)
		expectG.add_edge('c','t',7)
		expectG.add_edge('d','t',9,4)


		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def push_pull_stream_case_1
		# 构造图16.4(e) 输入层次图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',6)
		g.add_edge('a','b',2)
		g.add_edge('a','c',2)
		g.add_edge('b','d',4)
		g.add_edge('c','d',1)
		g.add_edge('d','t',5)

		method = Graph_Util.method(:"solve_pp_stream")
		targetG = call_method(method,g)

		# 构造输出流图
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',6,1)
		expectG.add_edge('a','b',2)
		expectG.add_edge('a','c',2,1)
		expectG.add_edge('b','d',4)
		expectG.add_edge('c','d',1,1)
		expectG.add_edge('d','t',5,1)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def block_stream_case_0
		# 构造图16.4(b) 输入层次图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',13)
		g.add_edge('s','b',4)
		g.add_edge('a','c',9)
		g.add_edge('b','d',8)
		g.add_edge('c','t',7)
		g.add_edge('d','t',9)

		method = Graph_Util.method(:"solve_block_stream")
		targetG = call_method(method,g)

		# 构造图16.4(c) 阻塞流
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',13,7)
		expectG.add_edge('s','b',4,4)
		expectG.add_edge('a','c',9,7)
		expectG.add_edge('b','d',8,4)
		expectG.add_edge('c','t',7,7)
		expectG.add_edge('d','t',9,4)


		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def block_stream_case_1
		# 构造图16.4(e) 输入层次图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',6)
		g.add_edge('a','b',2)
		g.add_edge('a','c',2)
		g.add_edge('b','d',4)
		g.add_edge('c','d',1)
		g.add_edge('d','t',5)

		method = Graph_Util.method(:"solve_block_stream")
		targetG = call_method(method,g)

		# 构造图16.4(f) 阻塞流
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',6,3)
		expectG.add_edge('a','b',2,2)
		expectG.add_edge('a','c',2,1)
		expectG.add_edge('b','d',4,2)
		expectG.add_edge('c','d',1,1)
		expectG.add_edge('d','t',5,3)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def block_stream_case_2
		# 构造图16.4(h) 输入层次图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',3)
		g.add_edge('a','c',1)
		g.add_edge('b','d',2)
		g.add_edge('c','b',9)
		g.add_edge('d','t',2)

		method = Graph_Util.method(:"solve_block_stream")
		targetG = call_method(method,g)

		# 构造图16.4(i) 阻塞流
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',3,1)
		expectG.add_edge('a','c',1,1)
		expectG.add_edge('b','d',2,1)
		expectG.add_edge('c','b',9,1)
		expectG.add_edge('d','t',2,1)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def dinic_case_0
		# 构造图16.4(a) 输入图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',13)
		g.add_edge('s','b',4)
		g.add_edge('a','b',2)
		g.add_edge('a','c',9)
		g.add_edge('b','a',10)
		g.add_edge('b','d',8)
		g.add_edge('c','b',9)
		g.add_edge('c','d',1)
		g.add_edge('c','t',7)
		g.add_edge('d','t',9)

		method = Graph_Util.method(:dinic)
		targetG = call_method(method,g)

		# 构造图16.4(k) 最大流
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',13,11)
		expectG.add_edge('s','b',4,4)
		expectG.add_edge('a','b',2,2)
		expectG.add_edge('a','c',9,9)
		expectG.add_edge('b','a',10,0)
		expectG.add_edge('b','d',8,7)
		expectG.add_edge('c','b',9,1)
		expectG.add_edge('c','d',1,1)
		expectG.add_edge('c','t',7,7)
		expectG.add_edge('d','t',9,8)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	def mpm_case_0
		# 构造图16.4(a) 输入图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',13)
		g.add_edge('s','b',4)
		g.add_edge('a','b',2)
		g.add_edge('a','c',9)
		g.add_edge('b','a',10)
		g.add_edge('b','d',8)
		g.add_edge('c','b',9)
		g.add_edge('c','d',1)
		g.add_edge('c','t',7)
		g.add_edge('d','t',9)

		method = Graph_Util.method(:mpm)
		targetG = call_method(method,g)

		# 构造图16.4(k) 最大流
		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',13,11)
		expectG.add_edge('s','b',4,4)
		expectG.add_edge('a','b',2,2)
		expectG.add_edge('a','c',9,9)
		expectG.add_edge('b','a',10,0)
		expectG.add_edge('b','d',8,7)
		expectG.add_edge('c','b',9,1)
		expectG.add_edge('c','d',1,1)
		expectG.add_edge('c','t',7,7)
		expectG.add_edge('d','t',9,8)

		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	public

	# 测试剩余图构建
	def test_remaining_graph
		self.private_methods(false).grep(
			/remaining_graph_case_.+/).each{|name|
			self.method(name.to_sym).call
		}
	end

	# 测试层次图构建
	def test_level_graph
		self.private_methods(false).grep(
			/level_graph_case_.+/).each{|name|
			self.method(name.to_sym).call
		}
	end

	# 测试DINIC阻塞流构建
	def test_block_stream
		self.private_methods(false).grep(
			/block_stream_case_.+/).each{|name|
			self.method(name.to_sym).call
		}
	end

	# 测试增加流
	def test_increase_stream
		# 构造图16.4(a) 输入图
		g = Graph.new
		g.add_node('s')
		g.add_node('t')
		('a'..'d').each{|item| g.add_node(item)}
		g.add_edge('s','a',13)
		g.add_edge('s','b',4)
		g.add_edge('a','b',2)
		g.add_edge('a','c',9)
		g.add_edge('b','a',10)
		g.add_edge('b','d',8)
		g.add_edge('c','b',9)
		g.add_edge('c','d',1)
		g.add_edge('c','t',7)
		g.add_edge('d','t',9)

		# 构造图16.4(c) 流图
		streamG = Graph.new
		streamG.add_node('s')
		streamG.add_node('t')
		('a'..'d').each{|item| streamG.add_node(item)}
		streamG.add_edge('s','a',13,7)
		streamG.add_edge('s','b',4,4)
		streamG.add_edge('a','c',9,7)
		streamG.add_edge('b','d',8,4)
		streamG.add_edge('c','t',7,7)
		streamG.add_edge('d','t',9,4)

		g = g.increase_stream!(streamG)
		targetG = g

		expectG = Graph.new
		expectG.add_node('s')
		expectG.add_node('t')
		('a'..'d').each{|item| expectG.add_node(item)}
		expectG.add_edge('s','a',13,7)
		expectG.add_edge('s','b',4,4)
		expectG.add_edge('a','b',2)
		expectG.add_edge('a','c',9,7)
		expectG.add_edge('b','a',10)
		expectG.add_edge('b','d',8,4)
		expectG.add_edge('c','b',9)
		expectG.add_edge('c','d',1)
		expectG.add_edge('c','t',7,7)
		expectG.add_edge('d','t',9,4)
		assert_block do 
			compare_graph(expectG,targetG)
		end
	end

	# 测试MPM流推拉算法
	def test_push_pull_stream
		self.private_methods(false).grep(
			/push_pull_stream_case_.+/).each{|name|
			self.method(name.to_sym).call
		}
	end

	# 测试Dinic
	def test_dinic
		self.private_methods(false).grep(
			/dinic_case_.+/).each{|name|
			self.method(name.to_sym).call
		}
	end

	# 测试MPM
	def test_mpm
		self.private_methods(false).grep(
			/mpm_case_.+/).each{|name|
			self.method(name.to_sym).call
		}
	end
end
