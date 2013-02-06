require 'yaml'

class Node
	attr_accessor :name
	attr_reader :edges

	def initialize(name)
		@name = name
		@edges = Array.new
	end

	def eql?(o)
		if o.instance_of? Node
			@name.eql?(o.name) && @edges.eql?(o.edges) 
		elsif 
			false
		end
	end
	alias == eql?

	def to_s
		puts "node #{@name} has these edges:"
		@edges.each {|edge| edge.to_s}
		puts
	end

	def add_edge(edge)
		@edges << edge
	end

	def delete_edge(to)
		@edges.delete_if{|edge|
			edge.to == to
		}
	end

	def get_next_nodes_edge
		next_nodes = Array.new
		@edges.each{|edge|
			next_nodes << [self, edge.to,edge]
		}
		return next_nodes
	end
	
	

end

class Edge
	attr_accessor :from, :to
	attr_reader :c, :f, :r

	def initialize(from, to, c = 0, f = 0)
		@from, @to, @c, @f = from, to, c, f
		@r = @c - @f
	end

	def c=(value)
		@c = value
		@r = @c - @f
	end

	def f=(value)
		@f = value
		@r = @c - @f
	end

	def to_s
		puts "edge is from #{@from.name} to #{@to.name}"
		puts "edge's c is #{@c}"
		puts "edge's f is #{@f}"
		puts "edge's r is #{@r}"
		puts
	end

	def eql?(o)
		if o.instance_of? Edge
			@from.eql?(o.from) && @to.eql?(o.to) && \
			@r.eql?(o.r) && @c.eql?(o.c) && @f.eql?(o.f)
		elsif 
			false
		end
	end
	alias == eql?

end

class Graph
	attr_accessor :nodes, :edges
	
	def initialize
		@nodes = Array.new
		@edges = Array.new
		
	end

	def eql?(o)
		if o.instance_of? Graph
			@nodes.eql?(o.nodes) && \
			@edges.eql?(o.edges) 
		elsif 
			false
		end
	end
	alias == eql?

	def to_s
		@nodes.each { |node| node.to_s}
	end

	def add_node(name)
		index = node_exist?(name)
		raise "node exist" if index
		@nodes << Node.new(name)
	end

	def add_edge(from, to, c = 0, f = 0)
		from_, to_ = get_node(from), get_node(to)
		raise "no node" unless (from_ && to_)
		raise "edge exist" if edge_exist?(from_,to_)
		edge = Edge.new(from_, to_, c, f)
		@edges << edge
		from_.add_edge(edge)
	end

	def get_node(value)
		index = nil
		if value.class == String
			index = @nodes.index{|node|
				node.name == value
			}
		elsif value.instance_of? Node 
			index = @nodes.index{|node|
				node.name == value.name
			}
		else
			raise "Type Error"
		end
		return nil unless index
		@nodes[index]
	end

	def node_exist?(name)
		@nodes.index{|item| item.name == name}
	end

	def edge_exist?(from, to)
		from_, to_ = get_node(from), get_node(to)
		return false unless (from_ && to_)
		@edges.index{|edge|
			edge.from == from_ && edge.to == to_
		}
	end

end

class Graph_Util
	def Graph_Util.solve_remaining_graph(g)
		resG = Graph.new
		g.nodes.each{|node|
			resG.add_node(node.name)
		}
		# 两节点间有双向边难处理！置标记visit
		visit = Hash.new{|hash, key| hash[key] = false}
		g.edges.each{|edge|
			next if visit[[edge.from, edge.to]]
			visit[[edge.from, edge.to]] = true
			# 如果对边存在且还未访问
			if (g.edge_exist?(edge.to, edge.from) && !visit[[edge.to, edge.from]])
				rEdge = g.edges[g.edge_exist?(edge.to,edge.from)]
				visit[[edge.to, edge.from]] = true
				# 如果当前边有流
				if edge.f != 0 && rEdge.f == 0
					if edge.c > edge.f
						resG.add_edge(edge.from, edge.to, edge.c - edge.f)
					end
					resG.add_edge(rEdge.from, rEdge.to, rEdge.c + edge.f)
				# 如果对边有流
				elsif rEdge.f != 0 && edge.f == 0
					if rEdge.c > rEdge.f
						resG.add_edge(rEdge.from, rEdge.to, rEdge.c - rEdge.f)
					end
					resG.add_edge(edge.from, edge.to, edge.c + rEdge.f)
				# 如果都没有流
				else
					resG.add_edge(edge.from, edge.to, edge.c)
					resG.add_edge(rEdge.from, rEdge.to, rEdge.c)
				end
			# 不存在对边
			else
				if edge.f != 0
					if edge.c > edge.f
						resG.add_edge(edge.from, edge.to, edge.c - edge.f)
					end
					resG.add_edge(edge.to, edge.from, edge.f) 
				end
			end
		}
		return resG
	end
end

