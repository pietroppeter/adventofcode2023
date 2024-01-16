import nimib as nb

nb.init()

nb.text(""" ## Day 25

We are given a graph and we are asked to find the 3 edges that partition it
in two (there is some kind of guarantee that this will happen).
The solution is found by multiplying cardinality of the two components.

First we will go through parsing, with the example puzzle:
""")

example = """
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr"""

with nb.code():
    print(example)

nb.text("""
Parsing into graph structure:
""")

with nb.code():
    def parse_line(line):
        two = line.split(":")
        node = two[0]
        targets = two[1].strip().split()
        return node, targets
    
    def parse_puzzle(text):
        return {p[0]: p[1] for p in[parse_line(line) for line in text.strip().split("\n")]}
    
    graph_input = parse_puzzle(example)

    def get_graph(graph_input):
        nodes = set()
        edges = set()
        for k, v in graph_input.items():
            nodes.add(k)
            for h in v:
                edges.add((k, h))
                edges.add((h, k))
                nodes.add(h)
        return nodes, edges
    
    nodes, edges = get_graph(graph_input)
    print(nodes)
    print(len(nodes))
    print(edges)
    print(len(edges))

nb.text("Let's see how many edges per node:")
with nb.code():
    def get_edges(node, edges):
        return [edge for edge in edges if edge[0] == node]
    
    def get_edges_by_node(nodes, edges):
        return {node: len(get_edges(node, edges)) for node in nodes}

    def print_edges_by_node(nodes, edges):
       en = get_edges_by_node(nodes, edges)
       for k, v in sorted(en.items(), key=lambda x: x[1], reverse=True):
           print(f"{k}: {v}")

    print_edges_by_node(nodes, edges)

nb.text("I am using this to visualize the graph in an [online editor](https://csacademy.com/app/graph_editor/).")
with nb.code():
    def to_gephi(edges):
        lines = [f"{e[0]} {e[1]}" for e in edges]
        return "\n".join(lines)

    print(to_gephi(edges))


nb.text("After some thinking and research, I decided to solve this using [NetworkX](https://networkx.org/)")

with nb.code():
    import networkx as nx
    G = nx.Graph()
    G.add_edges_from(edges)
    print(G)

nb.text("Let's see how [minimum_cut](https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.flow.minimum_cut.html) works with this graph:")

with nb.code():
    nx.set_edge_attributes(G, 1, "capacity")
    min_cut, partition = nx.minimum_cut(G, "cmg", "bvb")
    print(min_cut)
    print(partition[0])
    print(partition[1])

nb.text("It works!")
nb.text("Let's see what it does if I set as source and destination same component")
with nb.code():
    min_cut, partition = nx.minimum_cut(G, "frs", "qnr")
    print(min_cut)
    print(partition[0])
    print(partition[1])
nb.text("It gives me a value different from 3")

nb.text("How do I find the removed edges?")
nb.text("...after looking into NetworkX documentation... Aaaah! This should give the answer straight away: [minimum_edge_cut](https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.connectivity.cuts.minimum_edge_cut.html)")
with nb.code():
    cutset = nx.minimum_edge_cut(G)
    print(cutset)
nb.text("Indeed it does, but I will still need the partition to compute the solution.")

nb.text("Now let's write a generic function for the solution")

with nb.code():
    def solution(graph: nx.Graph) -> int:
        cutset = nx.minimum_edge_cut(graph)
        assert len(cutset) == 3
        edge = cutset.pop()
        source = edge[0]
        dest = edge[1]
        min_cut, partition = nx.minimum_cut(graph, source, dest)
        assert min_cut == 3
        assert len(partition) == 2
        return len(partition[0])*len(partition[1])

    print(solution(G))

nb.text("Let's try with the real puzzle")

with nb.code():
    with open("puzzle.txt", 'r') as f:
        puzzle = f.read()
    nodes, edges = get_graph(parse_puzzle(puzzle))
    G = nx.Graph()
    G.add_edges_from(edges)
    nx.set_edge_attributes(G, 1, "capacity")
    print(G)
    print(solution(G))

nb.text("It worked! ⭐")
nb.save()
