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

	def remove_edge!(to)
		@edges.delete_if{|edge|
			edge.to.name == to.name
		}
	end

	def get_next_nodes
		next_nodes = Array.new
		@edges.each{|edge|
			next_nodes << edge.to
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
		print "edge is from #{@from.name} to #{@to.name}: "
		puts "#{@c} #{@f} #{@r}"
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
		@nodes << Node.new(name) unless index
	end

	def add_edge(from, to, c = 0, f = 0)
		from_, to_ = get_node(from), get_node(to)
		if !(from_ && to_)
			add_node(from_.name); add_node(to_.name)
		end
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

	def get_edge(from, to)
		from_, to_ = get_node(from), get_node(to)
		return nil unless (from_ && to_)
		index = @edges.index{|edge|
			edge.from == from_ && edge.to == to_
		}
		return nil unless index
		return @edges[index]
	end

	def node_exist?(name)
		@nodes.index{|item| item.name == name}
	end

	def edge_exist?(from, to)
		from_, to_ = get_node(from), get_node(to)
		return false unless (from_ && to_)
		@edges.find{|edge|
			edge.from == from_ && edge.to == to_
		}
	end

	def increase_stream!(g)
		g.edges.each{|edge|
			if edge.f > 0
				e = get_edge(edge.from,edge.to)
				e.f += edge.f
			end
		}
		return self
	end

	def push_pull!(from, to, flow, pushOrPull)
		from_, to_ = get_node(from), get_node(to)
		return self if from_ == to_
		edges = @edges.find_all{|edge|
			if pushOrPull == :push
				edge.from.name == from_.name && edge.r > 0 
			elsif pushOrPull == :pull
				edge.to.name == from_.name && edge.r > 0
			end
		}
		return self if edges.empty?
		edges.sort{|a,b| a.r <=> b.r}
		while !edges.empty? && flow != 0
			edge = edges.shift
			if edge.r >= flow
				edge.f += flow
				push_pull!(edge.to, to, flow,pushOrPull) if pushOrPull == :push
				push_pull!(edge.from, to, flow,pushOrPull) if pushOrPull == :pull
				flow = 0
				break
			else
				curFlow = edge.r
				flow -= curFlow
				edge.f = edge.c
				push_pull!(edge.to, to, curFlow,pushOrPull) if pushOrPull == :push
				push_pull!(edge.from, to, curFlow,pushOrPull) if pushOrPull == :pull
			end
		end
		return self
	end

	def remove_node!(node)
		@edges.delete_if{|edge|
			edge.from.name == node.name || edge.to.name == node.name
		}
		@nodes.delete_if{|n| node.name == n.name}
		@nodes.each{|n| n.remove_edge!(node)}
		return self
	end
end


