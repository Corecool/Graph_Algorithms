require 'graph'

class Graph_Util
	def Graph_Util.dinic(g,s,t)
		data = YAML.dump(g)
		remainingG,streamG = YAML.load(data),YAML.load(data)
		levelG = solve_level_graph(remainingG,s,t)
		while levelG.node_exist?(t)
			bsg = solve_block_stream(levelG,s,t)
			streamG.increase_stream!(bsg)
			remainingG = solve_remaining_graph(\
				remainingG.increase_stream!(bsg),s,t)

			levelG = solve_level_graph(remainingG,s,t)
		end
		return streamG
	end

	def Graph_Util.mpm(g,s,t)
		data = YAML.dump(g)
		remainingG,streamG = YAML.load(data),YAML.load(data)
		levelG = solve_level_graph(remainingG,s,t)
		while levelG.node_exist?(t)
			sNode = levelG.nodes.find{|node| node.name == s}
			tNode = levelG.nodes.find{|node| node.name == t}
			while dfs(levelG,sNode,tNode,[])
				pps = solve_pp_stream(levelG,s,t)
				streamG.increase_stream!(pps)
				remainingG = solve_remaining_graph(\
					remainingG.increase_stream!(pps),s,t)
				levelG = solve_level_graph(remainingG,s,t)
				sNode = levelG.nodes.find{|node| node.name == s}
				tNode = levelG.nodes.find{|node| node.name == t}
			end
			levelG = solve_level_graph(remainingG,s,t)
		end
		return streamG
	end

	def Graph_Util.solve_remaining_graph(g,s,t)
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
				rEdge = g.get_edge(edge.to,edge.from)
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
				else
					resG.add_edge(edge.from, edge.to, edge.c)
				end
			end
		}
		return resG
	end

	def Graph_Util.solve_level_graph(g,s,t)
		resG = Graph.new
		sNode = g.nodes.find{|node|
			node.name == s
		}
		raise "No Start Node" unless sNode
		resG.add_node(sNode.name)
		queue, visit = Array.new, Hash.new{|hash, key| hash[key] = false}
		level = Hash.new{|hash,key| hash[key] = nil}
		level[sNode] = 0
		queue << g.get_node(sNode.name)
		until queue.empty?
			curNode = queue.shift
			next if visit[curNode]
			visit[curNode] = true
			nextNodes = curNode.get_next_nodes
			nextNodes.each{|node|
				queue << node unless visit[node]
				level[node] = level[curNode] + 1 unless level[node]
			}
			curNode.edges.each{|edge|
				if !visit[edge.to] && (level[edge.to] > level[edge.from])
					resG.add_node(edge.to.name)
					resG.add_edge(edge.from,edge.to,edge.c)
				end
			}
		end
		return resG
	end

	def Graph_Util.solve_pp_stream(g,s,t)
		data = YAML.dump(g)
		resG = YAML.load(data)

		sNode = resG.nodes.find{|node|
			node.name == s
		}
		raise "No Start Node" unless sNode
		tNode = resG.nodes.find{|node|
			node.name == t
		}
		raise "No End Node" unless tNode

		minNode,minT = compute_min_node(resG,s,t)
		while minT == 0
			resG.remove_node!(minNode)
			minNode,minT = compute_min_node(resG,s,t)
		end
		resG.push_pull!(minNode,tNode,minT,:push)
		resG.push_pull!(minNode,sNode,minT,:pull)
		return resG
	end

	

	def Graph_Util.solve_block_stream(g,s,t)
		data = YAML.dump(g)
		resG = YAML.load(data)

		sNode = resG.nodes.find{|node|
			node.name == s
		}
		raise "No Start Node" unless sNode
		tNode = resG.nodes.find{|node|
			node.name == t
		}
		raise "No End Node" unless tNode

		tVisit = true
		while tVisit
			tVisit, path = false, Array.new
			tVisit = dfs(resG,sNode,tNode,path)
			if tVisit
				minF = path.min { |a, b| a.c <=> b.c}.c
				path.each{|edge| edge.f += minF} 
			end
		end

		return resG
	end

	def Graph_Util.bimatch(g,x,y)
		data = YAML.dump(g)
		resG = YAML.load(data)

		g.edges.each{|edge|
			resG.remove_edge!(edge.from, edge.to) \
			if y.key?(edge.from.name) && x.key?(edge.to.name)
		}
		resG.add_node('s');resG.add_node('t')
		g.nodes.each{|node|
			resG.add_edge('s',node.name) if x.key? node.name
			resG.add_edge(node.name,'t') if y.key? node.name
		}
		resG.edges.each{|edge| edge.c = 1}
		streamG = dinic(resG,'s','t')
		streamG.remove_node!('s');streamG.remove_node!('t')
		maxMatch = streamG.edges.reduce(0){|sum,edge|
			sum + edge.f
		}
	end 

	private
	def Graph_Util.dfs(graph,sNode,tNode,path)
		return true if sNode == tNode
		sNode.get_next_nodes.each{|node|
			edge = graph.get_edge(sNode, node)
			if edge.r > 0
				path << edge
				return true if dfs(graph,node,tNode,path)
			end
		}
		path.pop
		return false
	end

	def Graph_Util.compute_min_node(g,s,t)
		minNode, minT = nil, nil
		g.nodes.each{|node|
			indegree,outdegree = 0,0
			g.edges.each{|edge|
				outdegree += edge.r if edge.from == node
				indegree += edge.r if edge.to == node
			}
			curT = if node.name == s then outdegree
			elsif node.name == t then indegree
			else
				indegree < outdegree ? indegree : outdegree
			end
			if minNode
				minNode, minT = node, curT if curT < minT
			else
				minNode, minT = node, curT
			end
		}
		return minNode, minT
	end
end