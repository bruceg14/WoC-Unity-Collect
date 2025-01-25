import yaml
import json

#Enter filename
yaml_content = "../filter_method/projects/cloned_github/AJCTuto-VisualScripting/Assets/Graphs/StopElementOnGameOver.asset"

with open(yaml_content, 'r') as file:
    raw_content = file.read()

# Replace Unity-specific tags with a placeholder or remove them
preprocessed_content = raw_content.replace('!u!114 &11400000', '')

with open(yaml_content, 'r') as file:
    try:
        data = yaml.safe_load(preprocessed_content)
    except yaml.YAMLError as e:
        print("Error parsing YAML:", e)

json_string = data['MonoBehaviour']['_data']['_json']
graph_data = json.loads(json_string)

id_count = 0
nodes_with_ID = {}

nodes_without_ID = {}
edges = []


for obj in graph_data['graph']['elements']:
    if obj['$type'] not in ['Unity.VisualScripting.ControlConnection', 'Unity.VisualScripting.ValueConnection']:
        tmp_node = {}
        if "$id" in obj:
            id_count += 1
            nodes_with_ID[obj["$id"]] = obj
        else:
            nodes_without_ID[obj["guid"]] = obj
    else:
        edges.append(obj)

edges = [{"source": edge["sourceUnit"]["$ref"], "destination": edge["destinationUnit"]["$ref"], "type": edge["$type"]} for edge in edges]

two_nodes_subgraph = []
for edge in edges:
    subgraph = {}
    node_from = {}
    node_from["$type"] = nodes_with_ID[edge["source"]]["$type"]
 
    node_to = {}
    node_to["$type"] = nodes_with_ID[edge["destination"]]["$type"]

    subgraph["from"]= node_from
    subgraph["to"]= node_to
    two_nodes_subgraph.append(subgraph)

# Build AST representation
ast = {
    "num_nodes" : len(nodes_with_ID) + len(nodes_without_ID),
    "num_edges" : len(edges),
    "id_count" : id_count,
    "nodes_with_ID": nodes_with_ID,
    "nodes_without_ID" : nodes_without_ID,
    "edges": edges,
    "two_nodes_subgraph": two_nodes_subgraph
}

# Output AST
print("AST here:")
print(json.dumps(ast, indent=4))

