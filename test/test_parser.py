import pytest
import json
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../functions'))
from unity_parser import parse_unity_asset, parse_graph_elements 

# Test the main parse function
def test_parse_unity_asset_file_not_found():
    result = parse_unity_asset("nonexistent_file.asset")
    assert result is None

# Test with an actual asset file 1
def test_parse_unity_asset_with_file1():
    result = parse_unity_asset("example_graphs/example_asset1.asset")
    assert result is not None
    assert "num_nodes" in result
    assert result["num_nodes"] == 11
    assert "edges" in result
    assert len(result["edges"]) == 8
    assert "nodes_with_ID" in result
    assert len(result["nodes_with_ID"]) == 8
    assert "nodes_without_ID" in result
    assert len(result["nodes_without_ID"]) == 3

# Test with an actual asset file 2
def test_parse_unity_asset_with_file2():
    result = parse_unity_asset("example_graphs/example_asset2.asset")
    assert result is not None
    assert "num_nodes" in result
    assert result["num_nodes"] == 5
    assert "edges" in result
    assert len(result["edges"]) == 2
    assert "nodes_with_ID" in result
    assert len(result["nodes_with_ID"]) == 3
    assert "nodes_without_ID" in result
    assert len(result["nodes_without_ID"]) == 2

# Test with an actual asset file representing an emtpy graph
def test_parse_unity_asset_no_edges():
    result = parse_unity_asset("example_graphs/empty_asset.asset")
    assert result is not None
    assert "num_nodes" in result
    assert result["num_nodes"] == 0
    assert "edges" in result
    assert len(result["edges"]) == 0
    assert "nodes_with_ID" in result
    assert len(result["nodes_with_ID"]) == 0
    assert "nodes_without_ID" in result
    assert len(result["nodes_without_ID"]) == 0