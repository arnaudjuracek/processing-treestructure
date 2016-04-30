public class Traveler{
	private Tree TREE;
	private Branch CURRENT_BRANCH;
	private Node CURRENT_NODE;
	private ArrayList<Branch> PATH;
	private int PATH_INDEX = 0;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a traveler on the root of the tree
	Traveler(Tree tree){
		this.TREE = tree;
		this.PATH = this.createPath(this.TREE.getRoot());

		this.CURRENT_NODE = this.TREE.getRoot();
		this.CURRENT_BRANCH = this.TREE.getBranch(0);
	}

	// create a traveler on the given node
	Traveler(Tree tree, Node n){
		this.TREE = tree;
		this.PATH = this.createPath(n);

		this.CURRENT_NODE = n;
		this.CURRENT_BRANCH = n.getParents().get(0);
	}


	// -------------------------------------------------------------------------
	// PATH
	// when instantiated, the Traveler creates a predefined path which will be
	// use when Traveler.next() and Traveler.previous() are called
	public ArrayList<Branch> createPath(Node root){
		ArrayList<Branch> branches = new ArrayList<Branch>();
		Node n = root;
		while(n.isRoot()){
			n = this.NOPATH_next(n);
			branches.add(n.LEAF_OF);
		}

		return branches;
	}

	// -------------------------------------------------------------------------
	// GETTER
	public Tree getTree(){ return this.TREE; }
	public Branch getCurrentBranch(){ return this.CURRENT_BRANCH; }
	public Node getCurrentNode(){ return this.CURRENT_NODE; }
	public ArrayList<Branch> getPath(){ return this.PATH; }



	// -------------------------------------------------------------------------
	// MOVER / NO PATH
	// move one node away from the root of the tree
	public Node NOPATH_next(Node c){
		ArrayList<Node> possibilities = new ArrayList<Node>();
		for(Branch b : c.getParents()){
			if(c.isRootOf(b)){
				// this.CURRENT_NODE = b.getLeaf();
				possibilities.add(b.getLeaf());
			}
		}

		if(possibilities.size()>0) this.CURRENT_NODE = possibilities.get(int(random(possibilities.size())));
		return this.getCurrentNode();
	}

	// move one node toward the root of the tree
	public Node NOPATH_previous(Node c){
		if(c != tree.getRoot()){ // if the current node is the tree root, there is nowhere to go
			for(Branch b : c.getParents()){
				if(c.isLeafOf(b)){
					this.CURRENT_NODE = b.getRoot();
				}
			}
		}
		return this.getCurrentNode();
	}



	// -------------------------------------------------------------------------
	// MOVE / PATH
	// move one node away from the root of the tree, following the predefined path
	public Node next(){
		this.CURRENT_NODE = this.PATH.get(this.PATH_INDEX < this.PATH.size() - 1 ? this.PATH_INDEX++ : this.PATH_INDEX).getLeaf();
		return this.getCurrentNode();
	}

	// move one node toward the root of the tree, following the predefined path
	public Node previous(){
		this.CURRENT_NODE = this.PATH.get(this.PATH_INDEX > 0 ? this.PATH_INDEX-- : this.PATH_INDEX).getRoot();
		return this.getCurrentNode();
	}
}