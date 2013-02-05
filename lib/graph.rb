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

	def rm_edge(edge)
		@edges.delete(edge)
	end

	def clear_edges
		@edges.clear
	end

end

class Edge
	attr_accessor :capacity, :used, :from, :to
	attr_reader :stream

	def initialize(from, to, capacity = 0, used = 0)
		@from, @to, @capacity, @used = from, to, capacity, used
		@stream = @capacity - @used
	end

	def to_s
		puts "edge is from #{@from.name} to #{@to.name}"
		puts "edge's capacity is #{@capacity}"
		puts "edge's used is #{@used}"
		puts "edge's stream is #{@stream}"
		puts
	end

	def eql?(o)
		if o.instance_of? Edge
			@from.eql?(o.from) && @to.eql?(o.to) && \
			@stream.eql?(o.stream)
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
			@nodes.eql?(o.nodes) && @edges.eql?(o.edges) 
		elsif 
			false
		end
	end
	alias == eql?

	def to_s
		@nodes.each { |node| node.to_s}
	end

	def add_node(name)
		(@nodes << Node.new(name)) unless node_exist?(name)
	end

	def add_edge(fromname, toname, capacity = 0, used = 0)
		raise "no node" unless (node_exist?(fromname) && \
			node_exist?(toname))

		raise "edge exist" if edge_exist?(fromname, toname)

		from, to = get_node(fromname), get_node(toname)
		edge = Edge.new(from, to, capacity, used)
		@edges << edge
		from.add_edge(edge)
	end

	private

	def get_node(name)
		index = node_exist?(name)
		raise "no node" unless index
		@nodes[index]
	end

	def node_exist?(name)
		@nodes.index{|node| node.name == name}
	end

	def edge_exist?(fromname, toname)
		@edges.index{|edge|
			edge.from.name == fromname && \
			edge.to.name == toname
		}
	end

end


class Graph_Util
	class << self
		def solve_remaining_graph(g)

		end
	end
end